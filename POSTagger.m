% Input data from file
filename = 'posdata_train.txt';
linenum = filelines(filename);
data = cell(linenum, 2);

fid = fopen(filename);
totalWords = 0;

line = fgetl(fid);
first = 1; % 1 is true
pr = []; % collect the first words of sentences
numIterations = 100;
counter = 0;
index = 1;
display('starting to read data');
nnfound = 0;
global noun;

while ischar(line)
    if(counter == numIterations)
       %break 
    end
    totalWords = totalWords+1;
    %display(line)
    str = strsplit(line, '\t');
    %display(str);
    
    if(strcmp(line, '')) % handle empty line
        line = fgetl(fid);
        first = 1;
        counter = counter + 1;
        continue
    end
    
    if(nnfound == 0 && strcmp(str(1,2), 'NN'))
        noun = str(1,1);
        nnfound = 1;
    end
    
    if(first == 1) % add first words to a different array
        pr = [pr;str];
        first = 0;
    end
    
    if(strcmp(str(1,1), '.') && strcmp(str(1,2), '.'))
        %break
    end
    data(index, 1) = str(1,1);
    data(index, 2) = str(1,2);
    index = index + 1;
    line = fgetl(fid);
end
fclose(fid);
display('data read finished');

display('starting training the data');

% find the number of states and calculate observ probability
global states;
states = unique(data(:, 2));
states2 = transpose(states);
return;

transmat = createtransmat(data, states);
transmat = mk_stochastic(transmat); % transition matrix

% number of output states = size(observ)
observ = zeros(size(states)); % number of times each state is observed
for i=1:length(states)
    observ(i) = sum(strcmp(data(:, 2), states(i)));
end
observ = mk_stochastic(observ); 

% number of output symbols = size(words)
[words, countmat] = countwords(data); 

% test data mapping
%[outarray, words, data] = datamapping(sentence, words, data);

% get the observation matrix
obsmat = getobsmat(data, states, words);
obsmat = mk_stochastic(obsmat);

%[prior] = getprior(data, states);
[prior] = getprior(pr, states);
prior = mk_stochastic(prior);

display('model created, starting tests on the model');
[abcd] = testmodel('posdata_test.txt', prior, transmat, obsmat, words);

display('collecting stats from tests');
confusion = getstats('posdata_test.txt', states);
csvwrite('confusion.dat',confusion);

%[LL, prior2, transmat2, obsmat2] = dhmm_em(countmat, prior, transmat, obsmat, 'max_iter', 5);


