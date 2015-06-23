function [ cost, g ] = TCCostFunction( par, patterns, multi_level,n_bypass, fixed_par, p_gts, error_par )
%TCCOSTFUNCTION Summary of this function goes here
%   Detailed explanation goes here
%   caculate the cost and gradient for the two-colony model

cost = 0;
n_gt = size(patterns, 2);

for i = 1: n_gt
    pattern = patterns{i};
    p_gt = p_gts{i};
    levels = multi_level;
    [temp_v, temp_i] = tcModel(pattern, levels, n_bypass, par, fixed_par);
    temp_p = temp_v.*temp_i;
    cost = cost + errorCal(p_gt, temp_p, error_par);
end

cost = cost/n_gt;

if (nargout > 1)
    % now need to return the gradient for each parameter
    % empty here, just return a zero vector the same size as par
    g = zeros(size(par) );
    return;
end

return;

end

