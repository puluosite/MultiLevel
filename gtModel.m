function [ voltage, current ] = gtModel(pattern, levels, n_bypass, parameters )

%GROUNDTRUTH Summary of this function goes here
%   Detailed explanation goes here
% parameters
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
in_file = fopen('gtModel.sp','w');

% subcircuit of one cell ubshaded!!!
fprintf(in_file,'** %d cascaded, %d paralleled cells\n\n\n',m, n);

% write each case
for i = 1:n_levels
    this_current = levels(i);
    fprintf(in_file,'** subcircuit:%eA,unshaded\n',this_current);
    fprintf(in_file,'.SUBCKT CELL%d P M \n I1 M Y DC %e\n D1 Y M diode1\n Rsh Y M %e\n',i, this_current, Rsh);
    fprintf(in_file,' Rs Y P %e\n.MODEL diode1 D IS=%e N=%e\n.ENDS\n\n\n',Rs, IS1, N);
end

% number of paralleled cells
NumCascadedCells = m;
NumParaArrays = n;

for i = 1:NumParaArrays
    for j=1:NumCascadedCells
        % j is row number and i is col number
        % determine which cell to use
        this_cell = pattern(j,i);
        if(j==1)           
            fprintf(in_file,' XU1%d 1 %d%d CELL%d\n',i,j,i, this_cell);
        elseif(j==NumCascadedCells)
            fprintf(in_file,' XU%d%d %d%d 0 CELL%d\n',j,i,(j-1),i, this_cell);  
        else
            fprintf(in_file,' XU%d%d %d%d %d%d CELL%d\n',j,i,(j-1),i,j,i, this_cell);
        end   
    end
    % add bypass diode
    if (n_bypass == 2)
        mid_point = m/2;
        fprintf(in_file,'\n D_Bypass1%d 0 %d%d  diode_b%d\n',i,mid_point,i,i);
        fprintf(in_file,'\n D_Bypass2%d %d%d 1  diode_b%d\n',i,mid_point, i,i);

        fprintf(in_file,'.MODEL diode_b%d D IS=%e N=%e\n',i,IS_bp, N_bp);
    elseif (n_bypass == 3)
        mid_point1 = floor(m*2/3);
        mid_point2 = floor(m/3);
        fprintf(in_file,'\n D_Bypass1%d 0 %d%d  diode_b%d\n',i,mid_point1,i,i);
        fprintf(in_file,'\n D_Bypass2%d %d%d %d%d  diode_b%d\n',i,mid_point1,i,mid_point2,i,i);
        fprintf(in_file,'\n D_Bypass3%d %d%d 1  diode_b%d\n',i,mid_point2, i,i);

        fprintf(in_file,'.MODEL diode_b%d D IS=%e N=%e\n',i,IS_bp, N_bp);
    else
        assert(0);
    end
        
end

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
dos(['"C:\synopsys\Hspice_C-2009.03-SP1\BIN\hspice.exe" -i gtModel.sp']);

%run python to analyse the .lis file for matlab analysis
system('gtModel.py');

%matlab plot I-V curve and P-V curve
data = xlsread('output_gtModel.csv');
voltage = data(:,1);
current = data(:,2);

end

