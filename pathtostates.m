function [ pos ] = pathtostates( path, states, sentence )
%PATHTOSTATES Summary of this function goes here
%   Detailed explanation goes here

pos = cell(length(path), 2);

for i=1:length(path)
    path(i) = lower(path(i));
    index = path(i);
    postag = states(index);
    pos(i, 1) = sentence(i, 1);
    % handle unseen words. assume noun for now
    if(strcmp(postag, '.') && ~(strcmp(sentence(i, 1), '.')) )
        pos(i, 2) = {'NN'};
        continue;
    end
    if(length(postag) == 0)
        pos(i, 2) = 'NN';
        continue;
    end
    pos(i,2) = postag;
end

end

