close all;
clear all;
clc;
%% constant values
kVerifyMultiLevelColonyWise = 1;
kVerify2MCColonyWise = 2;
kFindParaForTwoColony = 3;
kTwoColonyAveError = 4;
kFindParaForNColony = 5;
kNColonyAveError = 6;
%% choose current job
current_job = 6;
%% panel and shading parameters
%  multi_level = [4, 3, 2, 1];
%  ratios = [0.4, 0.3, 0.2, 0.1];
multi_level = [4,  3.5,3,2.5, 2];
ratios = [0.7, 0.1,0.05,0.05, 0.1;
          0.5, 0.1,0.1,0.1, 0.2;
          0.2, 0.2, 0.2,0.2,0.2];
      
all_m_n = [60, 2;
           30, 4;
           40, 2];

n_ratios = size(ratios, 1);
n_multi_level = size(multi_level, 2);
n_m_n = size(all_m_n, 1);
n_each_case = 100;
n_bypass = 3;
%% solar cell parameters
parameters.IS = 1e-6;
parameters.N = 1.5;
parameters.Rsh = 5000;
parameters.Rs = 0.0079;
parameters.IS_bp = 1e-5;
parameters.N_bp = 1;
%% error calculation parameters
error_par.pop = 0.5;
error_par.corr = 0.5;

%% task: verify multi-level colony wise model correctness
if(current_job == kVerifyMultiLevelColonyWise)
    error = [];
    iter_cnt = 0;
    for i  = 1: n_m_n
        m = all_m_n(i,1);
        n = all_m_n(i,2);
        for j = 1: n_ratios
            this_ratio = ratios(j,:);
            % loop several cases
            for k = 1: n_each_case
                iter_cnt = iter_cnt + 1;
                % gen cloud
                shading_pattern = cloudGen(m, n, multi_level, this_ratio);
%                 shading_pattern1 = [3;1;1;1;1;1;1;1;1;1];
%                 shading_pattern2 = [2;2;2;2;1;1;1;1;1;1];
%                 shading_pattern = [shading_pattern1';shading_pattern2']';
%                 shading_pattern = [3;1;1;1;2;1;1;1;1;1];
                % compare ground truth and colony-wise model
                [v_gt, i_gt] = gtModel(shading_pattern, multi_level, n_bypass, parameters);
                p_gt = v_gt.*i_gt;
                [v_cw, i_cw] = cwModel(shading_pattern, multi_level, n_bypass, parameters);
                p_cw = v_cw.*i_cw;
                temp_error = errorCal(p_gt, p_cw, error_par); 
                error = [error, temp_error];
                all_patterns{iter_cnt} = shading_pattern;
            end           
        end
    end
    save('Task1_error.mat','error');
    save('Task1_patterns.mat','all_patterns');
%% task: verify 2 macro cell multi-level colony wise model     
elseif (current_job == kVerify2MCColonyWise)
    error = [];
    iter_cnt = 0;
    for i  = 1: n_m_n
        m = all_m_n(i,1);
        n = all_m_n(i,2);
        for j = 1: n_ratios
            this_ratio = ratios(j,:);
            for k = 1: n_each_case
                iter_cnt = iter_cnt + 1;
                % gen cloud
                shading_pattern = cloudGen(m, n, multi_level, this_ratio);
                 
                [v_cw, i_cw] = gtModel(shading_pattern, multi_level, n_bypass, parameters);
                p_cw = v_cw.*i_cw;
%                 plot(v_cw, i_cw, 'b');
%                 hold on;
                [v_cw2, i_cw2] = cw2Model(shading_pattern, multi_level, n_bypass, parameters);
                p_cw2 = v_cw2.*i_cw2;
%                 plot(v_cw2, i_cw2, 'r');
%                 hold on;
                temp_error = errorCal(p_cw, p_cw2, error_par); 
                error = [error, temp_error];
                all_patterns{iter_cnt} = shading_pattern;
                print_info = ['Iteration: ',num2str(iter_cnt),'    Error: ',num2str(error(iter_cnt))];
                %disp('iteration: %d; error %e\n',iter_cnt, error);
                disp(print_info);
                
                ind = min(length(p_cw),length(p_cw2));
                corr_error = 1 - (corr(p_cw(1:ind),p_cw2(1:ind)));
                pop = abs((max(p_cw) - max(p_cw2)))/max(p_cw);
                valid_error{iter_cnt}.pattern = shading_pattern;
                valid_error{iter_cnt}.p_gt = p_cw;
                valid_error{iter_cnt}.p_cw = p_cw2;
                valid_error{iter_cnt}.corr = corr_error;
                valid_error{iter_cnt}.pop = pop;
                
            end           
        end
    end
    save('cwModel_error.mat','valid_error');
    save('Task2_error.mat','error');
    save('Task2_patterns.mat','all_patterns');
%% Task 3. Find parameters for  Two-Colony Model
elseif (current_job == kFindParaForTwoColony)
    %for i  = 1: n_m_n
    for i  = 1: 1
        m = all_m_n(i,1);
        n = all_m_n(i,2);
        for j = 1: n_ratios
            % Step 1. try to find opt parameters under each shading ratio
            this_ratio = ratios(j,:);
            % generate 10 ground truth data from gtModel
            for k = 1: 10
                shading_pattern = cloudGen(m, n, multi_level, this_ratio);
                [v_gt, i_gt] = gtModel(shading_pattern, multi_level, n_bypass, parameters);
                p_gt = v_gt.*i_gt;
                patterns{k} = shading_pattern;
                p_gts{k} = p_gt;
            end
            %
            initial_par = [0.5; 0.4; 0.1;];
            options = optimset('Display', 'iter', 'LargeScale', 'off', 'GradObj', 'off', 'MaxIter', 100);
            [par, cost, exitflag, output] = ...
                fminunc(@(t)(TCCostFunction(t, patterns, multi_level, n_bypass, parameters, p_gts, error_par)), initial_par, options);
            parameter{j}.par = par;
            parameter{j}.cost = cost;
            parameter{j}.exitflag = exitflag;
            parameter{j}.output = output;
        end
    end
    save('tcfmin.mat','parameter');
    % use fminunc or fmincon for optimization
    
%     %  Set options for fminunc
% options = optimset('GradObj', 'off', 'MaxIter', 400);
% 
% %  Run fminunc to obtain the optimal theta
% %  This function will return theta and the cost 
% [theta, cost] = ...
% 	fminunc(@(t)(TCCostFunction(t, X, y)), initial_theta, options);

%% calculate the average error of the Two-colony Model
elseif (current_job == kTwoColonyAveError)
    n_bypass = 2;
    par = [0.75, 0.22, 0.06];
    iter_cnt = 0;
    for i  = 1: 2
        m = all_m_n(i,1);
        n = all_m_n(i,2);
        for j = 1: n_ratios
            this_ratio = ratios(j,:);
            for k = 1: n_each_case
                iter_cnt = iter_cnt + 1;
                % gen cloud
                shading_pattern = cloudGen(m, n, multi_level, this_ratio);
                 
                [v_cw, i_cw] = cwModel(shading_pattern, multi_level, n_bypass, parameters);
                p_cw = v_cw.*i_cw;
                
                [v_tc, i_tc ] = tcModel(shading_pattern, multi_level, n_bypass, par, parameters);
                p_tc = v_tc.*i_tc;

                ind = min(length(p_cw),length(p_tc));
                corr_error = 1 - (corr(p_cw(1:ind),p_tc(1:ind)));
                pop = abs((max(p_cw) - max(p_tc)))/max(p_cw);
                
                valid_error{iter_cnt}.pattern = shading_pattern;
                valid_error{iter_cnt}.p_cw = p_cw;
                valid_error{iter_cnt}.p_tc = p_tc;
                valid_error{iter_cnt}.corr = corr_error;
                valid_error{iter_cnt}.pop = pop;
                
                
                print_info = ['Iteration: ',num2str(iter_cnt),'    Corr: ',num2str(corr_error), '    Pop: ', num2str(pop)];
                disp(print_info);
                
            end           
        end
    end
    
    save('tcModel_error.mat','valid_error');
    
    pop_error = 0;
    corr_error = 0;
    for i  = 1:900
        pop_error = pop_error + valid_error{i}.pop;
        corr_error = corr_error + valid_error{i}.corr;
    end
    pop_error = pop_error/900;
    corr_error = corr_error/900;
    
elseif( current_job == kFindParaForNColony )
    diary('FindNCParLog.txt');
    n_bypass = 3;
    for i  = 1: 1
        m = all_m_n(i,1);
        n = all_m_n(i,2);
        %for j = 1: n_ratios
        for j = 1: n_ratios
            % Step 1. try to find opt parameters under each shading ratio
            this_ratio = ratios(j,:);
            % generate 10 ground truth data from gtModel
            for k = 1: 20
                shading_pattern = cloudGen(m, n, multi_level, this_ratio);
                [v_gt, i_gt] = cw2Model(shading_pattern, multi_level, n_bypass, parameters);
                p_gt = v_gt.*i_gt;
                patterns{k} = shading_pattern;
                p_gts{k} = p_gt;
            end
            %
%             initial_par = [0.4 0.2 0.1
%                            0.4 0.2 0.1];
%             options = optimset('Display', 'iter', 'FinDiffRelStep',0.03, 'LargeScale', 'off', 'GradObj', 'off', 'MaxIter', 100);
%             %cost = NCCostFunction(initial_par, patterns, multi_level, n_bypass, parameters, p_gts, error_par);
%             [par, cost, exitflag, output] = ...
%                 fminunc(@(t)(NCCostFunction(t, patterns, multi_level, n_bypass, parameters, p_gts, error_par)), initial_par, options);
%             parameter{1}.par = par;
%             parameter{1}.cost = cost;
%             parameter{1}.exitflag = exitflag;
%             parameter{1}.output = output;
            
            initial_par = [0.3 0.2 0.05
                           0.3 0.2 0.05];
            options = optimset('Display', 'iter', 'FinDiffRelStep',0.03, 'LargeScale', 'off', 'GradObj', 'off', 'MaxIter', 100);
            %cost = NCCostFunction(initial_par, patterns, multi_level, n_bypass, parameters, p_gts, error_par);
            [par, cost, exitflag, output] = ...
                fminunc(@(t)(NCCostFunction(t, patterns, multi_level, n_bypass, parameters, p_gts, error_par)), initial_par, options);
            parameter{1}.par = par;
            parameter{1}.cost = cost;
            parameter{1}.exitflag = exitflag;
            parameter{1}.output = output;
        end
    end
    save('ncfmin.mat','parameter');
    diary off;

    
elseif ( current_job == kNColonyAveError )
    n_bypass = 3;
    %par = [ 0.388,0.186,0.082;
    %        0.4,0.2,0.085 ];
    par{1} = [0.413146973579157,0.172728122364881,0.0387096979008728;
            0.400000000000000,0.200000000000000,0.142240765841547];
        
    par{2} = [0.390133059520529,0.188556914620134,0.0850149376117549;
            0.400000000000000,0.200000000000000,0.0877302163234540];
    par{3} =    [0.373905323353778,0.169171209886551,0.0607890111040313;
            0.400000000000000,0.200000000000000,0.0728989980195029];
    iter_cnt = 0;
    for i  = 3: n_m_n
        m = all_m_n(i,1);
        n = all_m_n(i,2);
        for j = 1: n_ratios
            this_ratio = ratios(j,:);
            for k = 1: n_each_case
                iter_cnt = iter_cnt + 1;
                % gen cloud
                shading_pattern = cloudGen(m, n, multi_level, this_ratio);
                 
                [v_cw, i_cw] = cwModel(shading_pattern, multi_level, n_bypass, parameters);
                p_cw = v_cw.*i_cw;
                
                [v_tc, i_tc ] = ncModel(shading_pattern, multi_level, n_bypass, par{i}, parameters);
                p_tc = v_tc.*i_tc;

                ind = min(length(p_cw),length(p_tc));
                corr_error = 1 - (corr(p_cw(1:ind),p_tc(1:ind)));
                pop = abs((max(p_cw) - max(p_tc)))/max(p_cw);
                
                valid_error{iter_cnt}.pattern = shading_pattern;
                valid_error{iter_cnt}.p_cw = p_cw;
                valid_error{iter_cnt}.p_tc = p_tc;
                valid_error{iter_cnt}.corr = corr_error;
                valid_error{iter_cnt}.pop = pop;
                
                
                print_info = ['Iteration: ',num2str(iter_cnt),'    Corr: ',num2str(corr_error), '    Pop: ', num2str(pop)];
                disp(print_info);
                
            end           
        end
    end
    
    save('ncModel_error.mat','valid_error');
    
    pop_error = 0;
    corr_error = 0;
    for i  = 1:900
        pop_error = pop_error + valid_error{i}.pop;
        corr_error = corr_error + valid_error{i}.corr;
    end
    pop_error = pop_error/900;
    corr_error = corr_error/900;
%% for debuging
else
    shading_pattern = [5,4,4,1,     4,3,3,1,    2,2,2,2;];
    shading_pattern = shading_pattern';
    multi_level = [5, 4, 3,  2, 1];
    multi_level = [4, 3,  2, 1];
%     shading_pattern = [4,4,4,4,     3,3,3,3,    3,1,1,1;
%                        3,1,1,1,     1,1,1,1,    1,1,1,1;];
   shading_pattern = [4,4,4,1,     3,3,3,1,    1,1,1,2;];
   shading_pattern = [4,4,4,1,     3,3,3,1,    3,3,3,2;];
   shading_pattern = [4,4,4,4,     3,3,3,1,    1,1,1,3;];
%    shading_pattern = [4,4,4,1,     1,1,1,2,    1,1,1,1;];
%     shading_pattern = [4,4,4,1,     3,3,3,2,    1,1,1,1;
%                        4,4,4,1,     1,1,1,2,    1,1,1,1;];

%% debug for NC model
%     n_bypass = 3;
%     shading_pattern = [1,1,1,4,     1,1,1,3,    1,1,1,2;
%                        1,1,1,3,     1,1,1,2,    1,1,1,4;];
%     shading_pattern = shading_pattern';
%     m = 36;
%     n = 2;
%     multi_level = [4, 3,  2, 1];
%     this_ratio = [0.4, 0.3, 0.2, 0.1];
%     n_bypass = 3;
%     %shading_pattern = cloudGen(m, n, multi_level, this_ratio);
%     [v_cw2, i_cw2] = gtModel(shading_pattern, multi_level, n_bypass, parameters);
%     p_cw2 = v_cw2.*i_cw2;
%     plot(v_cw2, i_cw2, 'r');
%     hold on;
%     par = [0.4, 0.2, 0.1; 0.4, 0.2, 0.1;];
%     [v_tc, i_tc ] = ncModel(shading_pattern, multi_level, n_bypass, par, parameters);
%     p_tc = v_tc.*i_tc;
%     plot(v_tc, i_tc, 'b');
%      error = errorCal(p_cw2, p_tc, error_par);
%      disp(error);
% %     hold on;    

%% debug for tcModel
    n_bypass = 2;
    shading_pattern = [1,1,1,4,     1,1,1,3
                       1,1,1,1,     1,1,1,2];
    shading_pattern = shading_pattern';
    m = 36;
    n = 2;
    multi_level = [4, 3,  2, 1];
    this_ratio = [0.4, 0.3, 0.2, 0.1];
    n_bypass = 2;
    shading_pattern = cloudGen(m, n, multi_level, this_ratio);
    [v_cw2, i_cw2] = gtModel(shading_pattern, multi_level, n_bypass, parameters);
    p_cw2 = v_cw2.*i_cw2;
    plot(v_cw2, i_cw2, 'r');
    hold on;
    par = [0.4, 0.2, 0.1; 0.4, 0.2, 0.1;];
    [v_tc, i_tc ] = tcModel(shading_pattern, multi_level, n_bypass, par, parameters);
    p_tc = v_tc.*i_tc;
    plot(v_tc, i_tc, 'b');
     error = errorCal(p_cw2, p_tc, error_par);
     disp(error);
    
end




