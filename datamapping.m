function [ outarray, words, data ] = datamapping( sentence, words, data )
%DATAMAPPING Turns input data into a format that can be read by HMM
%   Detailed explanation goes here
sentencearr = strsplit(sentence);
outarray = [];
length(words)
for i=1:length(sentencearr)
    currword = sentencearr(i);
    indexword = find(strcmp([words(:)], currword)); % find word index from sentences
    % handle unseen word test. use 1 for unseen
    if(length(indexword) == 0)
        words = [words; currword];
        indexword = find(strcmp([words(:)], currword));
        % add this as an observation
        newdata = {currword, 'NN'};
        data = [data; newdata];
    end
    
    outarray = [outarray, indexword];
end
length(words)
end

