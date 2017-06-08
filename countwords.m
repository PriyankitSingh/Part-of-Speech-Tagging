function [ words, countmat ] = countwords( data )
%COUNTOBS counts the number of times each word occurs in data
%   Detailed explanation goes here

% count the number of unique words first
words = unique(data(:, 1));
wordcount = length(words);
countmat = zeros(wordcount, 1);

% find the number of occurances of each word
for i=1:wordcount
    countmat(i) = sum(strcmp(data(:, 1), words(i)));
end

end

