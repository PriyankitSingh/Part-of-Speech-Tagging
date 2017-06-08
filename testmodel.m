function [ confusion ] = testmodel( filename, prior, transmat, obsmat, words )
%TESTMODEL Tests the model against an input file.
%   Test the model against a file input

linenum = filelines(filename);
sentence = {}; 
outfile = fopen( 'results.txt', 'wt' );
fid = fopen(filename);

numstates = length(prior);
numstates = numstates(1);
confusion = zeros(numstates, numstates);

sentence = {};
postrue = {};
index = 1;

line = fgetl(fid);
while ischar(line) % read through test file.
    str = strsplit(line, '\t');
    
    if(strcmp(line, '')) % handle empty line
        %display('empty line');
        line = fgetl(fid);
        continue
    end
    
    if(strcmp(str(1,1), '.') && strcmp(str(1,2), '.')) % last word of sentence
        sentence(index, 1) = str(1,1);
        sentence(index, 2) = str(1,2);
        % test the sentence against the model and update the confusion matrix.
        pos = predictpos(sentence, prior, transmat, obsmat, words);
        writetofile(outfile, pos);
        
        sentence = {};
        index = 1;
        line = fgetl(fid);
        continue;
        %break
    end
    sentence(index, 1) = str(1,1);
    sentence(index, 2) = str(1,2);
    index = index + 1;
    line = fgetl(fid);
end
fclose(fid);
fclose(outfile);
end
