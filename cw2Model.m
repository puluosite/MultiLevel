function [ voltage, current ] = cw2Model( pattern, levels, n_bypass, parameters )
%%  This is the also Colony-Wise Model
%   However, each colony has only 2 macro cells
%   One has the largest current, the other has the smallest current
%   We have a threshold to determine which cell belongs to which macro cell


%% parameters and settings
% here we first consider #bypass diodes = 2 or 3 to simplify the model
assert(n_bypass == 2 || n_bypass == 3);
m = size(pattern, 1);
n = size(pattern, 2);
assert(mod(m, 2) == 0);
n_levels = size(levels, 2);
IS1 = parameters.IS;
N = parameters.N;
Rsh = parameters.Rsh;
Rs = parameters.Rs;
IS_bp = parameters.IS_bp;
N_bp = parameters.N_bp;

% write to spice simulation file
in_file = fopen('cw2Model.sp','w');

% subcircuit of one cell ubshaded!!!
fprintf(in_file,'** %d cascaded, %d paralleled cells\n\n\n',m, n);

%% Step 1. analyse each colony to see how many cells for each level
if (n_bypass == 2)
    range = [1, m/2 , m];
    for j = 1: n
        counter_upper = zeros(n_levels,1);
        counter_down = zeros(n_levels,1);
        for i =1: m
            if (i <= m/2 )
                % upper BP 
                counter_upper(pattern(i,j)) = counter_upper(pattern(i,j)) + 1;
            else
                % down BP
                counter_down(pattern(i,j)) = counter_down(pattern(i,j)) + 1;
            end             
        end
        % record to the corresponding colony
        colony(1,j).cell_counter = counter_upper;
        colony(2,j).cell_counter = counter_down;
     end
elseif (n_bypass == 3)
    range = [1, floor(m/3) , floor(m*2/3), m];
    for j = 1: n
        counter_upper = zeros(n_levels,1);
        counter_mid = zeros(n_levels,1);
        counter_down = zeros(n_levels,1);
        for i =1: m
            if (i <= range(2) )
                % upper BP 
                counter_upper(pattern(i,j)) = counter_upper(pattern(i,j)) + 1;
            elseif(i > range(2) && i <= range(3) )
                % mid BP
                counter_mid(pattern(i,j)) = counter_mid(pattern(i,j)) + 1;
            else
                % down BP
                counter_down(pattern(i,j)) = counter_down(pattern(i,j)) + 1;
            end             
        end
        % record to the corresponding colony
        colony(1,j).cell_counter = counter_upper;
        colony(2,j).cell_counter = counter_mid;
        colony(3,j).cell_counter = counter_down;
     end
else
    assert(0);
end

%% Step 2. Lump the cell_counter to size 2
% check levels in a decreasing Iph fasion
%assert( sum (fliplr(sort(levels)) == levels) == size(levels,2) );
assert( isequal(fliplr(sort(levels)), levels) );

row_colony = size(colony, 1);
col_colony = size(colony, 2);

for i = 1: row_colony
    for j = 1: col_colony
        counter = colony(i,j).cell_counter;
        new_counter = lumpCellCounter(counter, levels);
        colony(i,j).cell_counter = new_counter;
    end
end


%% Step 3. insert the colony into spice file
% topology
%       1   1   1   1
%bp1    11  12  13  14
%bp2    21  22  23  24
%bp3      0   0   0   0
% inside each colony
%   1
%   11_1
%   11_2
%   11_n-1
%   11

if (n_bypass == 2)
for j = 1:n
    % insert column by column
    % first bp
    fprintf(in_file,'**First Colony Starts\n');
    points = cell(n_levels+1,1);
    points{1} = '1';
    for k = 1: n_levels-1
        temp_val = int2str(k);
        temp_str = strcat('1',int2str(j));
        temp_str = strcat(temp_str,'_');
        temp_str = strcat(temp_str,temp_val);
        points{k+1} = temp_str;
    end
    points{n_levels+1} = strcat('1',int2str(j));
    
    for i = 1: size(points,1)-1
        start_point = points{i};
        end_point = points{i+1};
        this_current = levels(i);
        this_cnt = colony(1,j).cell_counter(i);
        if (this_cnt == 0)
            fprintf(in_file,'**it does not exit, short!\n');
            fprintf(in_file,'R%s%s %s %s 1e-30\n\n',start_point,end_point,start_point,end_point);
        else
            %this_rsh = Rsh;*this_cnt;
            this_rsh = Rsh;
            this_rs = Rs*this_cnt;
            this_n = N*this_cnt;
            this_is = IS1;
            fprintf(in_file,'I%s%s %s %s_0 DC %e\n',start_point,end_point,end_point,start_point,this_current);
            fprintf(in_file,'D%s%s %s_0 %s diode%s%s\n',start_point,end_point,start_point,end_point,start_point,end_point);
            fprintf(in_file,'Rs%s%s %s %s_0 %e\n',start_point,end_point,start_point,start_point,this_rs);
        	fprintf(in_file,'Rsh%s%s %s_0 %s %e\n',start_point,end_point,start_point,end_point,this_rsh);
            fprintf(in_file,'.MODEL diode%s%s D IS=%e N=%e\n\n',start_point,end_point,this_is,this_n);
        end
    end
    
    %insert bp
    start_point = points{n_levels+1};
    end_point = points{1};
    fprintf(in_file,'.MODEL diode_bp%s%s D IS=%e N=%e\n',start_point,end_point,IS_bp,N_bp);
    fprintf(in_file,'D_Bypass%s%s %s %s diode_bp%s%s\n\n',start_point,end_point,start_point,end_point,start_point,end_point);

    % second bp
    fprintf(in_file,'**Second Colony Starts\n');
    points = cell(n_levels+1,1);
    points{1} = strcat('1',int2str(j));
    for k = 1: n_levels-1
        temp_val = int2str(k);
        temp_str = strcat('2',int2str(j));
        temp_str = strcat(temp_str,'_');
        temp_str = strcat(temp_str,temp_val);
        points{k+1} = temp_str;
    end
    points{n_levels+1} = '0';
    
    for i = 1: size(points,1)-1
        start_point = points{i};
        end_point = points{i+1};
        this_current = levels(i);
        this_cnt = colony(2,j).cell_counter(i);
        if (this_cnt == 0)
            fprintf(in_file,'**it does not exit, short!\n');
            fprintf(in_file,'R%s%s %s %s 1e-30\n\n',start_point,end_point,start_point,end_point);
        else
            %this_rsh = Rsh;*this_cnt;
            this_rsh = Rsh;
            this_rs = Rs*this_cnt;
            this_n = N*this_cnt;
            this_is = IS1;
            fprintf(in_file,'I%s%s %s %s_0 DC %e\n',start_point,end_point,end_point,start_point,this_current);
            fprintf(in_file,'D%s%s %s_0 %s diode%s%s\n',start_point,end_point,start_point,end_point,start_point,end_point);
            fprintf(in_file,'Rs%s%s %s %s_0 %e\n',start_point,end_point,start_point,start_point,this_rs);
        	fprintf(in_file,'Rsh%s%s %s_0 %s %e\n',start_point,end_point,start_point,end_point,this_rsh);
            fprintf(in_file,'.MODEL diode%s%s D IS=%e N=%e\n\n',start_point,end_point,this_is,this_n);
        end
    end
    
    %insert bp
    start_point = points{n_levels+1};
    end_point = points{1};
    fprintf(in_file,'.MODEL diode_bp%s%s D IS=%e N=%e\n',start_point,end_point,IS_bp,N_bp);
    fprintf(in_file,'D_Bypass%s%s %s %s diode_bp%s%s\n\n',start_point,end_point,start_point,end_point,start_point,end_point);
  
end

end % end of n_bypass == 2


if (n_bypass == 3)
for j = 1:n
    % first bp
    fprintf(in_file,'**First Colony Starts\n');
    points = cell(n_levels+1,1);
    points{1} = '1';
    for k = 1: n_levels-1
        temp_val = int2str(k);
        temp_str = strcat('1',int2str(j));
        temp_str = strcat(temp_str,'_');
        temp_str = strcat(temp_str,temp_val);
        points{k+1} = temp_str;
    end
    points{n_levels+1} = strcat('1',int2str(j));
    
    for i = 1: size(points,1)-1
        start_point = points{i};
        end_point = points{i+1};
        this_current = levels(i);
        this_cnt = colony(1,j).cell_counter(i);
        if (this_cnt == 0)
            fprintf(in_file,'**it does not exit, short!\n');
            fprintf(in_file,'R%s%s %s %s 1e-30\n\n',start_point,end_point,start_point,end_point);
        else
            %this_rsh = Rsh;*this_cnt;
            this_rsh = Rsh;
            this_rs = Rs*this_cnt;
            this_n = N*this_cnt;
            this_is = IS1;
            fprintf(in_file,'I%s%s %s %s_0 DC %e\n',start_point,end_point,end_point,start_point,this_current);
            fprintf(in_file,'D%s%s %s_0 %s diode%s%s\n',start_point,end_point,start_point,end_point,start_point,end_point);
            fprintf(in_file,'Rs%s%s %s %s_0 %e\n',start_point,end_point,start_point,start_point,this_rs);
        	fprintf(in_file,'Rsh%s%s %s_0 %s %e\n',start_point,end_point,start_point,end_point,this_rsh);
            fprintf(in_file,'.MODEL diode%s%s D IS=%e N=%e\n\n',start_point,end_point,this_is,this_n);
        end
    end
    
    %insert bp
    start_point = points{n_levels+1};
    end_point = points{1};
    fprintf(in_file,'.MODEL diode_bp%s%s D IS=%e N=%e\n',start_point,end_point,IS_bp,N_bp);
    fprintf(in_file,'D_Bypass%s%s %s %s diode_bp%s%s\n\n',start_point,end_point,start_point,end_point,start_point,end_point);

    % second bp
    fprintf(in_file,'**Second Colony Starts\n');
    points = cell(n_levels+1,1);
    points{1} = strcat('1',int2str(j));
    for k = 1: n_levels-1
        temp_val = int2str(k);
        temp_str = strcat('2',int2str(j));
        temp_str = strcat(temp_str,'_');
        temp_str = strcat(temp_str,temp_val);
        points{k+1} = temp_str;
    end
    points{n_levels+1} = strcat('2',int2str(j)); 
    
    for i = 1: size(points,1)-1
        start_point = points{i};
        end_point = points{i+1};
        this_current = levels(i);
        this_cnt = colony(2,j).cell_counter(i);
        if (this_cnt == 0)
            fprintf(in_file,'**it does not exit, short!\n');
            fprintf(in_file,'R%s%s %s %s 1e-30\n\n',start_point,end_point,start_point,end_point);
        else
            %this_rsh = Rsh;*this_cnt;
            this_rsh = Rsh;
            this_rs = Rs*this_cnt;
            this_n = N*this_cnt;
            this_is = IS1;
            fprintf(in_file,'I%s%s %s %s_0 DC %e\n',start_point,end_point,end_point,start_point,this_current);
            fprintf(in_file,'D%s%s %s_0 %s diode%s%s\n',start_point,end_point,start_point,end_point,start_point,end_point);
            fprintf(in_file,'Rs%s%s %s %s_0 %e\n',start_point,end_point,start_point,start_point,this_rs);
        	fprintf(in_file,'Rsh%s%s %s_0 %s %e\n',start_point,end_point,start_point,end_point,this_rsh);
            fprintf(in_file,'.MODEL diode%s%s D IS=%e N=%e\n\n',start_point,end_point,this_is,this_n);
        end
    end
    
    %insert bp
    start_point = points{n_levels+1};
    end_point = points{1};
    fprintf(in_file,'.MODEL diode_bp%s%s D IS=%e N=%e\n',start_point,end_point,IS_bp,N_bp);
    fprintf(in_file,'D_Bypass%s%s %s %s diode_bp%s%s\n\n',start_point,end_point,start_point,end_point,start_point,end_point);    

    
    % third bp
    fprintf(in_file,'**Third Colony Starts\n');
    points = cell(n_levels+1,1);
    points{1} = strcat('2',int2str(j));
    for k = 1: n_levels-1
        temp_val = int2str(k);
        temp_str = strcat('3',int2str(j));
        temp_str = strcat(temp_str,'_');
        temp_str = strcat(temp_str,temp_val);
        points{k+1} = temp_str;
    end
    points{n_levels+1} = '0';
    
    for i = 1: size(points,1)-1
        start_point = points{i};
        end_point = points{i+1};
        this_current = levels(i);
        this_cnt = colony(3,j).cell_counter(i);
        if (this_cnt == 0)
            fprintf(in_file,'**it does not exit, short!\n');
            fprintf(in_file,'R%s%s %s %s 1e-30\n\n',start_point,end_point,start_point,end_point);
        else
            %this_rsh = Rsh;*this_cnt;
            this_rsh = Rsh;
            this_rs = Rs*this_cnt;
            this_n = N*this_cnt;
            this_is = IS1;
            fprintf(in_file,'I%s%s %s %s_0 DC %e\n',start_point,end_point,end_point,start_point,this_current);
            fprintf(in_file,'D%s%s %s_0 %s diode%s%s\n',start_point,end_point,start_point,end_point,start_point,end_point);
            fprintf(in_file,'Rs%s%s %s %s_0 %e\n',start_point,end_point,start_point,start_point,this_rs);
        	fprintf(in_file,'Rsh%s%s %s_0 %s %e\n',start_point,end_point,start_point,end_point,this_rsh);
            fprintf(in_file,'.MODEL diode%s%s D IS=%e N=%e\n\n',start_point,end_point,this_is,this_n);
        end
    end
    
    %insert bp
    start_point = points{n_levels+1};
    end_point = points{1};
    fprintf(in_file,'.MODEL diode_bp%s%s D IS=%e N=%e\n',start_point,end_point,IS_bp,N_bp);
    fprintf(in_file,'D_Bypass%s%s %s %s diode_bp%s%s\n\n',start_point,end_point,start_point,end_point,start_point,end_point);    

end

end % end of n_bypass == 3


sim_v = 30;
if (m > 30)
    sim_v = 60;
end

fprintf(in_file,'\n\n Vds 1 0\n');
fprintf(in_file,'.DC Vds 0 %f 0.005\n',sim_v);
% fprintf(in_file,'.PRINT V(1) I(Vds) V(91) V(81) V(71) V(61) V(51) V(41)\n');
fprintf(in_file,'.PRINT V(1) I(Vds)\n');

% fprintf(in_file,'.PRINT V(1) I(XU11.Rs)\n');
fprintf(in_file,'.end\n');
 
fclose(in_file);

%% simulate unlumped model
%run hspice to run the simulation
dos(['"C:\synopsys\Hspice_C-2009.03-SP1\BIN\hspice.exe" -i cw2Model.sp']);

%run python to analyse the .lis file for matlab analysis
system('cw2Model.py');

%matlab plot I-V curve and P-V curve
data = xlsread('output_cw2Model.csv');
voltage = data(:,1);
current = data(:,2);
end

function [new_counter] = lumpCellCounter(counter, levels)
assert( isequal(size(counter'),size(levels)) );
% if counter has only 1 or 2 non-zero positions, just return
cnt_non_zero = 0;
for i = 1: size(counter, 1)
    if (counter(i) ~= 0)
        cnt_non_zero = cnt_non_zero + 1;
    end
end
if (cnt_non_zero == 1 || cnt_non_zero == 2) 
    new_counter = counter;
    return;
end

%mid_point = (levels(1) + levels(end))/2;
new_counter = zeros(size(counter));
% find the start
index_start = 0;
for i = 1: size(counter, 1)
    if (counter(i) ~= 0)
        index_start = i;
        break;
    end
end

% find the end
index_end = 0;
for i = size(counter, 1): -1 : 1
    if (counter(i) ~= 0)
        index_end = i;
        break;
    end
end

mid_point = (levels(index_start) + levels(index_end))/2;

% loop between start and end to assign to new_counter
% new counter has value only at index_start and index_end
assert(index_end >= index_start);
for i = index_start: index_end
    if (levels(i) >= mid_point)
        new_counter(index_start) = new_counter(index_start) + counter(i);
    else
        new_counter(index_end) = new_counter(index_end) + counter(i);
    end
end

return;

end