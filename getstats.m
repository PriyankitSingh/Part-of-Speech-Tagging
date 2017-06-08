function [ confusion ] = getstats( inputfilename, states )
%GETSTATS Gets the confusion matrix and accuracy of the model
%   Detailed explanation goes here

numstates = length(states);
numstates = numstates(1);
confusion = zeros(numstates, numstates);

trainf = fopen(inputfilename, 'r');
resultf = fopen('results.txt', 'r');

tline = fgetl(trainf);
rline = fgetl(resultf);

while ischar(tline) % read through test file.
    trainstr = strsplit(tline, '\t');
    resstr = strsplit(rline, '\t');
    
    if(strcmp(trainstr, '')) % handle empty line
        tline = fgetl(trainf);
        rline = fgetl(resultf);
        continue
    end
    % get the pos tags
    trainpos = trainstr(1,2);
    respos = resstr(1,2);
    
    % look for index of pos tags
    trainposindex = find(strcmp([states(:)], trainpos));
    resposindex = find(strcmp([states(:)], respos));
    
    confusion(trainposindex, resposindex) = confusion(trainposindex, resposindex) + 1;
    tline = fgetl(trainf);
    rline = fgetl(resultf);
end

fclose(trainf);
fclose(resultf);
end

