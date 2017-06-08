function [ prediction ] = predictpos( sentence, prior, transmat, obsmat, words )
%PREDICTPOS uses the model to do POS tagging in a sentence
%   INPUT: sentence in form <word, POS>. This function will remove the POS

% convert sentence to an array of numbers
sentencearray = datamapping(sentence, words);
sentencearray = transpose(sentencearray)

% viterbi for most likely path
B = multinomial_prob(sentencearray, obsmat);
[path] = viterbi_path(prior, transmat, B);
%prediction = pathtostates(path, states, sentence)
prediction = path;
%prediction = sentencearray;
end

