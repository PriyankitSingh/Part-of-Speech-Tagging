function [ outarray ] = datamapping( sentence, words )
%DATAMAPPING Turns input data into a format that can be read by HMM
%   Returns the sentence as an array. Unseen words are returned as 1 (.)

outarray = [];
global noun;

for i=1:size(sentence, 1)
    currword = sentence(i, 1);
    if(length(sentence) == 1)
        %display('empty word');
        continue;
    end
    
    indexword = find(strcmp([words(:)], currword)); % find word index from sentences
    
    % handle unseen word test. use NN for unseen (assume is first noun)
    if(length(indexword) == 0)
        indexword = find(strcmp([words(:)], noun));
    end
    
    outarray = [outarray, indexword];
end
end

