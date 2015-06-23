function [ result ] = errorCal( p1,p2, error_par )
%ERRORCAL Summary of this function goes here
%   Detailed explanation goes here

%% average error criterion
%     [temp,upper] = max(p1);
%     index = find(0.8*max(p1)<p1&p1<0.9*max(p1));
% 
% 
%     counter = 0;
%     error = 0;
% 
%     for j = 1:length(index)
% 
% %         if(index(j)<upper)
%             counter = counter+1;
%             error = error+abs(p1(index(j))-p2(index(j)))/abs(p1(index(j)));
% %         end
% 
%     end
%     
%     error = error/counter;
%     
%     result = error;

%% corr + max
ind = min(length(p1),length(p2));
corrError = 1 - (corr(p1(1:ind),p2(1:ind)));

maxError = abs((max(p1) - max(p2)))/max(p1);

result = error_par.corr*corrError + error_par.pop*maxError;

end

