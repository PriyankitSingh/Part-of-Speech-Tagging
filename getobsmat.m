function [ obsmat ] = getobsmat( data, states, words )
%GETOBSMAT Summary of this function goes here
%   Detailed explanation goes here
numwords = size(words);
numstates = size(states);

obsmat = zeros(numstates(1), numwords(1));

for i=1:size(data, 1)
    currWord = data(i, 1);
    currPOS = data(i,2);
    indexWord = find(strcmp([words(:)], currWord));
    indexPOS = find(strcmp([states(:)], currPOS));
    
    obsmat(indexPOS, indexWord) = obsmat(indexPOS, indexWord)+1;
end

end

