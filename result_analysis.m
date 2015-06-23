clear all;
clc;
close all;

kPlot3Models = 1;
kAnalyzeCWModel = 2;
kAnalyzeNCModel = 3;
kRuntimeComp = 4;

current_job = 3;

multi_level = [4,  3, 2];
n_bypass = 3;
parameters.IS = 1e-6;
parameters.N = 1.5;
parameters.Rsh = 5000;
parameters.Rs = 0.0079;
parameters.IS_bp = 1e-5;
parameters.N_bp = 1;

%% Task 1. Plot A Typical 3 Model curves
if (current_job == kPlot3Models)
    % pvExample.fig
    cw_results = load('ncModel_error.mat');
    
    pop_error = [];
    corr_error = [];
    error = [];

    for i  = 1:900
        pop_error = [pop_error,  cw_results.valid_error{i}.pop];
        corr_error = [corr_error, cw_results.valid_error{i}.corr];

    end
    
    sort_corr_error = sort(corr_error);
    sort_pop_error = sort(pop_error);
    
    index_t = find(corr_error==sort_corr_error(5))
    %index_t = find(pop_error==sort_pop_error(30))
    index = index_t(1);

    shading_pattern = cw_results.valid_error{index}.pattern;
    m = size(shading_pattern, 1)
    n = size(shading_pattern, 2)
    [v_gt, i_gt] = gtModel(shading_pattern, multi_level, n_bypass, parameters);
    p_gt = v_gt.*i_gt;
    [v_cw2, i_cw2] = cw2Model(shading_pattern, multi_level, n_bypass, parameters);
    p_cw2 = v_cw2.*i_cw2;
    
    par{1} = [0.413146973579157,0.172728122364881,0.0387096979008728;
            0.400000000000000,0.200000000000000,0.142240765841547];
        
    par{2} = [0.390133059520529,0.188556914620134,0.0850149376117549;
            0.400000000000000,0.200000000000000,0.0877302163234540];
    par{3} =    [0.373905323353778,0.169171209886551,0.0607890111040313;
            0.400000000000000,0.200000000000000,0.0728989980195029];
        
        
    concrete_par = [];
    if (index <= 300)
        concrete_par = par{1};
    elseif (index <= 600)
        concrete_par = par{2};
    else
        concrete_par = par{3};
    end
    
    [v_nc, i_nc] = ncModel(shading_pattern, multi_level, n_bypass, concrete_par, parameters);
    p_nc = v_nc.*i_nc;

    figure(3)
    plot(v_gt, p_gt, 'r');
    hold on;
    plot(v_cw2, p_cw2, 'b');
    hold on;
    plot(v_nc, p_nc, 'g');
    hold on;
    
    

%% Task 2. Plot CW-Model Error
elseif (current_job == kAnalyzeCWModel)
    %cwHist.fig
cw_results = load('cwModel_error.mat');
pop_error = [];
corr_error = [];
big_error = [];

for i  = 1:900
    pop_error = [pop_error,  cw_results.valid_error{i}.pop];
    corr_error = [corr_error, cw_results.valid_error{i}.corr];
    if ( cw_results.valid_error{i}.pop > 0.25)
        big_error = [big_error, i];
    end
end

ave_pop_error = mean(pop_error);
ave_corr_error = 1- mean(corr_error);
figure(1)
figa = subplot(1,2,1);
hist(pop_error,50);
title('(a)');
hold on;
figb = subplot(1,2,2);
hist(1-corr_error,50);
title('(b)');
hold on;

figure(2)
figa = subplot(2,3,1);
hist(pop_error(1:300),50);
hold on;
figb = subplot(2,3,2);
hist(pop_error(301:600),50);
hold on;
figc = subplot(2,3,3);
hist(pop_error(601:900),50);
hold on;
hold on;
figa = subplot(2,3,4);
hist(1-corr_error(1:300),50);
hold on;
figb = subplot(2,3,5);
hist(1-corr_error(301:600),50);
hold on;
figc = subplot(2,3,6);
hist(1-corr_error(601:900),50);
hold on;

if (size(big_error,1) > 0)
    error_index = big_error(1);
    shading_pattern = cw_results.valid_error{error_index}.pattern;
    m = size(shading_pattern, 1);
    n = size(shading_pattern, 2);
    [v_gt, i_gt] = gtModel(shading_pattern, multi_level, n_bypass, parameters);
    p_gt = v_gt.*i_gt;
    [v_cw2, i_cw2] = cw2Model(shading_pattern, multi_level, n_bypass, parameters);
    p_cw2 = v_cw2.*i_cw2;

    figure(3)
    plot(v_gt, p_gt, 'r');
    hold on;
    plot(v_cw2, p_cw2, 'b');
    hold on;

end
%% Task 3. Plot NC-Model Error
elseif (current_job == kAnalyzeNCModel)
    %ncHist.fig
    n_bypass = 3
    
cw_results = load('ncModel_error.mat');
pop_error = [];
corr_error = [];
big_error = [];
small_corr = []

for i  = 1:900
    pop_error = [pop_error,  cw_results.valid_error{i}.pop];
    corr_error = [corr_error, cw_results.valid_error{i}.corr];
    if ( cw_results.valid_error{i}.pop > 0.25)
        big_error = [big_error, i];
    end
    if ( cw_results.valid_error{i}.corr < 0.9)
        small_corr = [small_corr, i];
    end
end

ave_pop_error = mean(pop_error);
ave_corr_error = 1- mean(corr_error);
figure(1)
figa = subplot(1,2,1);
hist(pop_error,50);
title('(a)');
hold on;
figb = subplot(1,2,2);
hist(1-corr_error(1:300),50);
h1 = findobj(gca,'Type','patch');
h1.FaceColor = [0,0.5,1];
title('(b)');
hold on;
h2 = hist(1-corr_error(301:600),50);
%h1.FaceColor = [0.5,0,0.5];

figure(2)
figa = subplot(2,3,1);
hist(pop_error(1:300),50);
hold on;
figb = subplot(2,3,2);
hist(pop_error(301:600),50);
hold on;
figc = subplot(2,3,3);
hist(pop_error(601:900),50);
hold on;
figa = subplot(2,3,4);
hist(1-corr_error(1:300),50);
hold on;
figb = subplot(2,3,5);
hist(1-corr_error(301:600),50);
hold on;
figc = subplot(2,3,6);
hist(1-corr_error(601:900),50);
hold on;



if (size(small_corr, 1) > 0)
    par{1} = [0.413146973579157,0.172728122364881,0.0387096979008728;
            0.400000000000000,0.200000000000000,0.142240765841547];
        
    par{2} = [0.390133059520529,0.188556914620134,0.0850149376117549;
            0.400000000000000,0.200000000000000,0.0877302163234540];
    par{3} =    [0.373905323353778,0.169171209886551,0.0607890111040313;
            0.400000000000000,0.200000000000000,0.0728989980195029];
        
    for i = 1: 5
        error_index = small_corr(i+5);
        concrete_par = [];
        if (error_index <= 300)
            concrete_par = par{1};
        elseif (error_index <= 600)
            concrete_par = par{2};
        else
            concrete_par = par{3};
        end
        shading_pattern = cw_results.valid_error{error_index}.pattern;
        m = size(shading_pattern, 1);
        n = size(shading_pattern, 2);
        [v_gt, i_gt] = cwModel(shading_pattern, multi_level, n_bypass, parameters);
        p_gt = v_gt.*i_gt;
        [v_cw2, i_cw2] = ncModel(shading_pattern, multi_level, n_bypass, concrete_par, parameters);
        p_cw2 = v_cw2.*i_cw2;

        figure(3)
        plot(v_gt, p_gt, 'r');
        hold on;
        plot(v_cw2, p_cw2, 'b');
        hold on;
    end
    
    
end

sort_corr = sort(corr_error);
ave_sort_corr = [];
for i = 1:size(sort_corr,2)
    temp = mean(sort_corr(1:i));
    ave_sort_corr = [ave_sort_corr, temp];
end
figure(4)
%hist(ave_sort_corr, 50);
stem(ave_sort_corr);

%% Task 4. Runtime Compare
elseif (current_job == kRuntimeComp)
    m = 30;
    n = 2;
    n_bypass = 3;
    ratio = [0.7, 0.2, 0.1];
    shading_pattern = cloudGen(m, n, multi_level, ratio);
    
    [v_gt, i_gt] = gtModel(shading_pattern, multi_level, n_bypass, parameters);
    p_gt = v_gt.*i_gt;
    [v_cw2, i_cw2] = cw2Model(shading_pattern, multi_level, n_bypass, parameters);
    p_cw2 = v_cw2.*i_cw2;
    
    par = [0.413146973579157,0.172728122364881,0.0387096979008728;
            0.400000000000000,0.200000000000000,0.142240765841547];

    [v_nc, i_nc] = ncModel(shading_pattern, multi_level, n_bypass, par, parameters);
    p_nc = v_nc.*i_nc;
    
else
tc_results = load('wcModel_error_n_2.mat');
%tc_results = load('tcModel_errorIphSmallDiff.mat');
tc_results = load('ncModel_error.mat');



pop_error = [];
corr_error = [];
big_error = [];
for i  = 1:900
    pop_error = [pop_error,  tc_results.valid_error{i}.pop];
    corr_error = [corr_error, tc_results.valid_error{i}.corr];
    if ( tc_results.valid_error{i}.pop > 0.4)
        big_error = [big_error, i];
    end
end
ave_pop_error = mean(pop_error);
ave_corr_error = 1- mean(corr_error);
figure(1)
figa = subplot(2,2,1);
hist(pop_error,50);
hold on;
figb = subplot(2,2,2);
hist(1-corr_error,50);
hold on;

tc_results = load('wcModel_error_n_3.mat');
%tc_results = load('ncModel_error.mat');

pop_error = [];
corr_error = [];
big_error = [];
for i  = 1:900
    pop_error = [pop_error,  tc_results.valid_error{i}.pop];
    corr_error = [corr_error, tc_results.valid_error{i}.corr];
    if ( tc_results.valid_error{i}.pop > 0.4)
        big_error = [big_error, i];
    end
end
ave_pop_error = mean(pop_error);
ave_corr_error = 1- mean(corr_error);
figc = subplot(2,2,3);
hist(pop_error,50);
hold on;
figd = subplot(2,2,4);
hist(1-corr_error,50);
hold on;

title(figa,'(a)');
title(figb,'(b)');
title(figc,'(c)');
title(figd,'(d)');

%% analyze cases

multi_level = [4,  2, 1];
ratios = [0.7, 0.2, 0.1;
          0.5, 0.3, 0.2;
          0.2, 0.3, 0.5;];
      
all_m_n = [30, 2;
           20, 4;
           20, 2];
n_bypass = 2;
% solar cell parameters
parameters.IS = 1e-6;
parameters.N = 1.5;
parameters.Rsh = 5000;
parameters.Rs = 0.0079;
parameters.IS_bp = 1e-5;
parameters.N_bp = 1;

% shading_pattern = tc_results.valid_error{10}.pattern;
% [v_cw2, i_cw2] = gtModel(shading_pattern, multi_level, n_bypass, parameters);
% p_cw2 = v_cw2.*i_cw2;
% figure(3)
% plot(v_cw2, i_cw2, 'r');
% hold on;
% 
% par = [0.75, 0.22, 0.06];
% par = [0.95, 0.12, 0.06];
% 
% [v_tc, i_tc ] = tcModel(shading_pattern, multi_level, n_bypass, par, parameters);
% p_tc = v_tc.*i_tc;
% figure(3)
% plot(v_tc, i_tc, 'b');


%% runtime analysis
m = 30;
n = 2;
multi_level = [4, 3,  2, 1];
this_ratio = [0.4, 0.3, 0.2, 0.1];
par = [0.4, 0.2, 0.1; 0.4, 0.2, 0.1;];

n_bypass = 2;
shading_pattern = cloudGen(m, n, multi_level, this_ratio);
[v_cw2, i_cw2] = gtModel(shading_pattern, multi_level, n_bypass, parameters);
[v_cw2, i_cw2] = cw2Model(shading_pattern, multi_level, n_bypass, parameters);
[v_tc, i_tc ] = tcModel(shading_pattern, multi_level, n_bypass, par, parameters);

n_bypass = 3;
shading_pattern = cloudGen(m, n, multi_level, this_ratio);
[v_cw2, i_cw2] = gtModel(shading_pattern, multi_level, n_bypass, parameters);
[v_cw2, i_cw2] = cw2Model(shading_pattern, multi_level, n_bypass, parameters);
[v_tc, i_tc ] = ncModel(shading_pattern, multi_level, n_bypass, par, parameters);


t = [1143	252	164
2106	441 	153
1449	297	149
1116	351	243
2196	613	225
1656	432	231];

end




