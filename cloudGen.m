function [ coordinate ] = cloudGen(m, n, multi_level, ratio)
%CLOUDGEN Summary of this function goes here
% this version still has odd points in the coordinate
% e.g 11114111
% because the sequence of find neighbor, we can further elinimate
% this by filter out this kind of odd points
% way to do that is check the neighor, if make sure there gradient is less
% than 1, otherwise, change the value

% check if data is valid
assert(size(multi_level, 2) == size(ratio, 2));
assert(size(multi_level, 1) == size(ratio, 1));
assert(int16(sum(ratio)) == 1);
for i = 1: size(multi_level, 2)
    assert(ratio(i) ~= 0);
end

% initialize coordinate matrix
coordinate = zeros(m,n);

% init level data
n_levels = size(multi_level, 2);
irr_flags = [];
for i = 1: n_levels
    irr_flags = [irr_flags, i];
end

n_each_level_cells = [];
for i = 1: (n_levels - 1)
    n_this_level = floor(m*n*ratio(i));
    n_each_level_cells = [n_each_level_cells, n_this_level];
end
n_except_last_ratio = sum(n_each_level_cells);
remain_cells = m*n - n_except_last_ratio;
n_each_level_cells = [n_each_level_cells, remain_cells];

%x coor set and y coor set

mSet = [];
nSet = [];

% pick center point for each level
for i= 1: n_levels
    m_exist = [1];
    n_exist = [1];
    m_coor = 0;
    n_coor = 0;
    while((size(m_exist,2) ~= 0) && (size(n_exist,2) ~= 0)) 
        m_coor= randi(m,1);
        n_coor = randi(n,1);    
        m_exist = find(mSet == m_coor);
        n_exist = find(nSet == n_coor);
    end
    
    mSet = [mSet, m_coor];
    nSet = [nSet, n_coor];

    % mark the center of each level by its flag
    coordinate(m_coor, n_coor) = irr_flags(i);

end

% expand from the center to fill the shading pattern
for i = 1: n_levels
    n_fill = n_each_level_cells(i) - 1;
    this_flag = irr_flags(i);
    center_m = mSet(i);
    center_n = nSet(i);
    for j = 1: n_fill
        [m_candi, n_candi] = findNearestNeighbor(center_m, center_n, coordinate);
        coordinate(m_candi, n_candi) = this_flag;
    end
end

% %start generating random shading pattern with fixed ratio
% for i = 2:num_shaded
%     
%     %find the neighbour of existing points
%     [xCandi,yCandi] = findNeighbor(m,n,xSet,ySet);
%     
%     %pick one from the candidates
%     tempPick = randi(length(xCandi),1);
%     
%     tempX = xCandi(tempPick);
%     tempY = yCandi(tempPick);
%     
%     % add the picked coor to xSet and ySet, also need to add them to
%     % coordinate
%     
%     xSet = [xSet,tempX];
%     ySet = [ySet,tempY];
%     
%     coordinate(tempX,tempY) = 1;
% 
% 
% end
end

