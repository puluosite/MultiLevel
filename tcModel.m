function [voltage, current ] = tcModel(pattern, levels, n_bypass, par, fixed_par)

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
alpha = par(1);
beta = par(2);
gamma = par(3);

%% Step 1. calculate the max/min current for each colony
% Step 1.1 Collect Info for Each Colony
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
        % old
%         colony(i,j).min_current = min_current;
%         colony(i,j).n_min = n_min;
        % new, let min = max when homogenous
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
% Conclusion: For 2 bypass diodes
% in each chain, find smallest and second smallest currents
% super cell 1: sum of all second smallest currents
% super cell 2: sum of all smallest currents
assert(n_bypass == 2);
% old
max_min = [];
% Iph1 = 0;
% Iph2 = 0;
% if (n_bypass == 2) 
%     for j = 1: col_colony
%         chain_currents = [];
%         for i = 1: row_colony
%             t_max = colony(i,j).max_current;
%             t_n_max = colony(i,j).n_max;
%             t_min = colony(i,j).min_current;
%             t_n_min = colony(i,j).n_min;
%             assert(t_n_max ~= 0);
%             % insert t_max
%             chain_currents = [chain_currents, t_max];
%             if (t_n_min ~= 0)
%                 chain_currents = [chain_currents, t_min];
%             end            
%         end
%         new_c_c = sort(unique(chain_currents));
%         if (size(new_c_c, 2) == 1)
%             max_min = [max_min; new_c_c(1), new_c_c(1);];
%         elseif (size(new_c_c, 2) > 1)
%             max_min = [max_min; new_c_c(2), new_c_c(1);];
%         else
%             assert(0);
%         end       
%     end
% end
% 
% Iph1 = sum(max_min(:,1));
% Iph2 = sum(max_min(:,2));

% new
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

Iph1 = super_cell_currents(1);
Iph2 = super_cell_currents(2);
max_min = all_min_currents;


%% Step 3. Generate Cell Shading Ratio and Colony Shading Ratio
% Step 3.1 Cell Shading Ratio
cell_cnt = 0;
for j = 1: n % col
    %old
    %i_max = max_min(j, 1);
    %new
    i_max = max_min(j, 2);
    for i = 1: m % row
        this_cell_current = levels(pattern(i,j));
        if (this_cell_current < i_max)
            cell_cnt = cell_cnt + 1;
        end
    end
end
cell_ratio = cell_cnt/(m*n);
% Step 3.2 Colony Shading Ratio
colony_cnt = 0;
for j = 1: col_colony
    %old
    %i_max = max_min(j, 1);
    %new
    i_max = max_min(j, 2);
    for i = 1: row_colony
        if (colony(i,j).n_min ~= 0)
            this_colony_min_current = colony(i,j).min_current;
        else
            this_colony_min_current = colony(i,j).max_current;
        end
        if (this_colony_min_current < i_max)
            colony_cnt = colony_cnt + 1;
        end
    end
end
colony_ratio = colony_cnt/(col_colony*row_colony);

ratio = alpha*colony_ratio + beta*cell_ratio + gamma;
% Super cell 1 parameters
Rs_1 = Rs*m/n*(1 - ratio); 
Rsh1 = Rsh*m/n*(1 - ratio); 
N1 = N*m*(1 - ratio);
IS1 = IS*n*(1 - ratio); 
N1_INV = N_bp*n_bypass*(1 - ratio); 
IS1_INV = IS_bp*n*(1 - ratio); 

% Super cell 2 parameters
Rs_2 = Rs*m/n*ratio; 
Rsh2 = Rsh*m/n*ratio; 
N2 = N*m*ratio;
IS2 = IS*n*ratio; 
N2_INV = N_bp*n_bypass*ratio; 
IS2_INV = IS_bp*n*ratio; 

%% generate spice file
% assert(0);
in_file = fopen('tcModel.sp','w');

% Super Cell 1
fprintf(in_file,'** Super Cell 1 Max Current\n\n');
fprintf(in_file,' I1 0 P_1 DC %f\n',Iph1);
fprintf(in_file,' D1 P_1 0 diode1\n D1_inv 0 M diode2\n Rsh_1 P_1 0 %e\n',Rsh1);
fprintf(in_file,' Rs_1 P_1 M %e\n',Rs_1);
fprintf(in_file,'.MODEL diode1 D IS=%e N=%e\n',IS1,N1);
fprintf(in_file,'.MODEL diode2 D IS=%e N=%e\n\n\n',IS1_INV,N1_INV);

% Super Cell 2
fprintf(in_file,'**  Super Cell 2 Min Current\n\n');
fprintf(in_file,' I2 M P_2 DC %f\n',Iph2);
fprintf(in_file,' D2 P_2 M diode3\n D2_inv M out diode4\n Rsh_2 M P_2 %e\n',Rsh2);
fprintf(in_file,' Rs_2 P_2 out %e\n',Rs_2);
fprintf(in_file,'.MODEL diode3 D IS=%e N=%e\n',IS2,N2);
fprintf(in_file,'.MODEL diode4 D IS=%e N=%e\n\n\n',IS2_INV,N2_INV);

sim_v = 30;
if (m > 30)
    sim_v = 60;
end

fprintf(in_file,'\n\n Vds out 0\n');
fprintf(in_file,'.DC Vds 0 %f 0.005\n',sim_v);
fprintf(in_file,'.PRINT V(out) I(Vds)\n');
fprintf(in_file,'.end\n');

fclose(in_file);

%% simulate unlumped model
%run hspice to run the simulation
dos(['"C:\synopsys\Hspice_C-2009.03-SP1\BIN\hspice.exe" -i tcModel.sp']);

%run python to analyse the .lis file for matlab analysis
system('tcModel.py');

%matlab plot I-V curve and P-V curve
data = xlsread('output_tcModel.csv');

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