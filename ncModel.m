function [ voltage, current  ] = ncModel( pattern, levels, n_bypass, par, fixed_par )
%NCMODEL Summary of this function goes here
%   Detailed explanation goes here

%% extract model parameters from inputs
m = size(pattern, 1);
n = size(pattern, 2);
n_levels = size(levels, 2);
IS = fixed_par.IS;
N = fixed_par.N;
Rsh = fixed_par.Rsh;
Rs = fixed_par.Rs;
IS_bp = fixed_par.IS_bp;
N_bp = fixed_par.N_bp;

%% parameters need to be curve-fitted
% assume we only have 3 bypass diode at this point
assert( n_bypass == 3);
assert( size(par,1) == (n_bypass - 1) );
alpha1 = par(1,1);
beta1 = par(1,2);
gamma1 = par(1,3);
alpha2 = par(2,1);
beta2 = par(2,2);
gamma2 = par(2,3);

%% Step 1. calculate the max/min current for each colony
% Step 1.1 Collect Info for Each Colony
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
 % Step 1.2 get the max/min current
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

for i = 1: row_colony
    for j = 1: col_colony
        counter = colony(i,j).cell_counter;
        max_current = -1;
        min_current = -1;
        n_max = 0;
        n_min = 0;
        is_max = false;
        for k = 1: size(counter, 1)
            if (counter(k) ~= 0)
                if (is_max == false)
                    max_current = levels(k);
                    n_max = counter(k);
                    is_max = true;
                else
                    min_current = levels(k);
                    n_min = counter(k);
                end
            end
        end
        colony(i,j).max_current = max_current;
        colony(i,j).n_max = n_max;
        if (n_min ~= 0)
            colony(i,j).min_current = min_current;
            colony(i,j).n_min = n_min;
        else
            colony(i,j).min_current = max_current;
            colony(i,j).n_min = n_min;
        end
    end
end
%% Step 2. Generate current for each Super cell
all_min_currents = [];
for j = 1: col_colony
    chain_currents = [];
    for i = 1: row_colony
        t_min = colony(i,j).min_current;
        chain_currents = [chain_currents, t_min];        
    end
    chain_currents = sort(chain_currents);
    all_min_currents = [all_min_currents; chain_currents];   
end

super_cell_currents = zeros(1, n_bypass);
for i = 1: n_bypass
    super_cell_currents(i) = sum(all_min_currents(:,i)); 
end
super_cell_currents = fliplr(super_cell_currents);

%% Step 3. Generate Cell Shading Ratio and Colony Shading Ratio
cell_cnt = zeros(1, n_bypass);
colony_cnt = zeros(1, n_bypass);

assert(n_bypass == 3);
for j = 1: n % col
    i_high = all_min_currents(j,3);
    i_mid = all_min_currents(j,2);
    i_low = all_min_currents(j,1);
    for i = 1: m % row
        this_cell_current = levels(pattern(i,j));
        if (this_cell_current >= i_high)
            cell_cnt(1) = cell_cnt(1) + 1;
        elseif (this_cell_current < i_high && this_cell_current >= i_mid)
            cell_cnt(2) = cell_cnt(2) + 1;
        else
            cell_cnt(3) = cell_cnt(3) + 1;
        end
    end
end

for j = 1: col_colony % col
    i_high = all_min_currents(j,3);
    i_mid = all_min_currents(j,2);
    i_low = all_min_currents(j,1);
    for i = 1: row_colony % row
        this_colony_current = colony(i,j).min_current;
        if (this_colony_current >= i_high)
            colony_cnt(1) = colony_cnt(1) + 1;
        elseif (this_colony_current < i_high && this_colony_current >= i_mid)
            colony_cnt(2) = colony_cnt(2) + 1;
        else
            colony_cnt(3) = colony_cnt(3) + 1;
        end
    end
end

cell_ratio = cell_cnt/(m*n);
assert(sum(cell_cnt) == m*n);
colony_ratio = colony_cnt/(col_colony*row_colony);
assert(sum(colony_cnt) == col_colony*row_colony);

ratio1 = colony_ratio(1)*alpha1 + cell_ratio(1)*beta1 + gamma1;
ratio2 = colony_ratio(2)*alpha1 + cell_ratio(2)*beta1 + gamma2;
ratio3 = 1 - ratio1 - ratio2;
if (ratio3 < 0.01)
    disp(ratio1);
    disp(ratio2);
    disp(colony_ratio(1));
    disp(cell_ratio(1));
    disp(colony_ratio(2));
    disp(cell_ratio(2));
    save('error_pattern','pattern');
assert(ratio3 >= 0.01);
end

% Super cell 1 parameters
Iph1 = super_cell_currents(1);
Rs_1 = Rs*m/n*ratio1; 
Rsh1 = Rsh*m/n*ratio1; 
N1 = N*m*ratio1;
IS1 = IS*n*ratio1; 
N1_INV = N_bp*n_bypass*ratio1; 
IS1_INV = IS_bp*n*ratio1; 

% Super cell 2 parameters
Iph2 = super_cell_currents(2);
Rs_2 = Rs*m/n*ratio2; 
Rsh2 = Rsh*m/n*ratio2; 
N2 = N*m*ratio2;
IS2 = IS*n*ratio2; 
N2_INV = N_bp*n_bypass*ratio2; 
IS2_INV = IS_bp*n*ratio2; 

% Super cell 3 parameters
Iph3 = super_cell_currents(3);
Rs_3 = Rs*m/n*ratio3; 
Rsh3 = Rsh*m/n*ratio3; 
N3 = N*m*ratio3;
IS3 = IS*n*ratio3; 
N3_INV = N_bp*n_bypass*ratio3; 
IS3_INV = IS_bp*n*ratio3; 


%% Step 4. generate SP file
in_file = fopen('ncModel.sp','w');

% Super Cell 1
if (ratio1 ~= 0)
    fprintf(in_file,'** Super Cell 1 Max Current\n\n');
    fprintf(in_file,' I1 0 1_1 DC %f\n',Iph1);
    fprintf(in_file,' D1 1_1 0 diode1\n D1_inv 0 1 diode2\n Rsh_1 1_1 0 %e\n',Rsh1);
    fprintf(in_file,' Rs_1 1_1 1 %e\n',Rs_1);
    fprintf(in_file,'.MODEL diode1 D IS=%e N=%e\n',IS1,N1);
    fprintf(in_file,'.MODEL diode2 D IS=%e N=%e\n\n\n',IS1_INV,N1_INV);
else
    fprintf(in_file,'Rshort1 0 1 1e-30\n\n');
end

% Super Cell 2
if (ratio2 ~= 0)
    fprintf(in_file,'** Super Cell 2 Mid Current\n\n');
    fprintf(in_file,' I2 1 2_1 DC %f\n',Iph2);
    fprintf(in_file,' D2 2_1 1 diode3\n D2_inv 1 2 diode4\n Rsh_2 2_1 1 %e\n',Rsh2);
    fprintf(in_file,' Rs_2 2_1 2 %e\n',Rs_2);
    fprintf(in_file,'.MODEL diode3 D IS=%e N=%e\n',IS2,N2);
    fprintf(in_file,'.MODEL diode4 D IS=%e N=%e\n\n\n',IS2_INV,N2_INV);
else
    fprintf(in_file,'Rshort2 1 2 1e-30\n\n');
end

% Super Cell 3
if (ratio3 ~= 0)
    fprintf(in_file,'** Super Cell 3 Min Current\n\n');
    fprintf(in_file,' I3 2 3_1 DC %f\n',Iph3);
    fprintf(in_file,' D3 3_1 2 diode5\n D3_inv 2 3 diode6\n Rsh_3 3_1 2 %e\n',Rsh3);
    fprintf(in_file,' Rs_3 3_1 3 %e\n',Rs_3);
    fprintf(in_file,'.MODEL diode5 D IS=%e N=%e\n',IS3,N3);
    fprintf(in_file,'.MODEL diode6 D IS=%e N=%e\n\n\n',IS3_INV,N3_INV);
else
    fprintf(in_file,'Rshort3 2 3 1e-30\n\n');
end

sim_v = 30;
if (m > 30)
    sim_v = 60;
end

fprintf(in_file,'\n\n Vds 3 0\n');
fprintf(in_file,'.DC Vds 0 %f 0.005\n',sim_v);
fprintf(in_file,'.PRINT V(out) I(Vds)\n');
fprintf(in_file,'.end\n');

fclose(in_file);

%% simulate unlumped model
%run hspice to run the simulation
dos(['"C:\synopsys\Hspice_C-2009.03-SP1\BIN\hspice.exe" -i ncModel.sp']);

%run python to analyse the .lis file for matlab analysis
system('ncModel.py');

%matlab plot I-V curve and P-V curve
data = xlsread('output_ncModel.csv');

voltage = data(:,1);
current = data(:,2);


test = 1;

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

mid_point = (levels(1) + levels(end))/2;
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

