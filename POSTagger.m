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
states = unique(data(:, 2));

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

% viterbi for most likely path
display('displaying most likely state sequence')
%B = multinomial_prob(outarray, obsmat);
%[path] = viterbi_path(prior2, transmat, B);
%posseq = pathtostates(path, states, sentence)
[abcd] = testmodel('posdata_test.txt', prior, transmat, obsmat, words);



%[LL, prior2, transmat2, obsmat2] = dhmm_em(countmat, prior, transmat, obsmat, 'max_iter', 5);


