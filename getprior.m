function [ prior ] = getprior( data, states )
%GETPRIOR Calculates the prior distribution from data
%   Detailed explanation goes here

numsentences = length(data);
prior = zeros(size(states, 1), 1);

for i=1:size(states)
    prior(i) = sum(strcmp(data(:, 2), states(i)));
end

end

