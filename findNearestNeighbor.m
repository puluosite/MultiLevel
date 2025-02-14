function [ m_candi,n_candi] = findNearestNeighbor(center_m, center_n, coordinate )
%FINDNEIGHBOR Summary of this function goes here
%   Detailed explanation goes here
m = size(coordinate, 1);
n = size(coordinate, 2);
dist = 1e20;
m_candi = 0;
n_candi = 0;

for i = 1: m
    for j = 1: n
        if (coordinate(i, j) == 0)
            % current cell is unused
            temp_dist = (i - center_m)^2 + (j - center_n)^2;
            if (temp_dist < dist)
                dist = temp_dist;
                m_candi = i;
                n_candi = j;
            end
        end
    end
end

end

