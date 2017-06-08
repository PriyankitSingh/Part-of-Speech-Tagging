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

sentence = 'i think indian food is great .';
% test data mapping
%[outarray, words, data] = datamapping(sentence, words, data);

% get the observation matrix
obsmat = getobsmat(data, states, words);

%[prior] = getprior(data, states);
[prior] = getprior(pr, states);
prior2 = mk_stochastic(prior);

% viterbi for most likely path
display('displaying most likely state sequence')
%B = multinomial_prob(outarray, obsmat);
%[path] = viterbi_path(prior2, transmat, B);
%posseq = pathtostates(path, states, sentence)
[abcd] = testmodel('posdata_test.txt', prior2, transmat, obsmat);

display('starting training the data');
% train the model using all the data. Goes to -inf 
datalength = size(data(:,1))
trainarray = [];
counter = 0;

for i=1:datalength
    currword = data(i,1);
    currpos = data(i, 2);
    %display(data(i,:));
    wordindex = find(strcmp([words(:)], currword(1,1)));
    posindex = find(strcmp([states(:)], currpos(1,1)));
    
    if(strcmp(currword, '.')) % train model at the end of the sentence
        %trainarray(i) = wordindex;
        trainarray = [trainarray, wordindex];
        
        display('calling the em method');
        % training and other shit goes here. Fixing adj_trans works the
        % first time
        [LL, prior2, transmat, obsmat] = dhmm_em(trainarray, prior2, transmat, obsmat, ...
            'max_iter', 5, 'adj_prior', 0, 'adj_trans', 1, 'adj_obs', 0);
        % use model to compute log likelihood
        loglik = dhmm_logprob(trainarray, prior2, transmat, obsmat)
        
        counter = counter +1;
        if(counter == 1)
            break;
        end
        trainarray = [];
        continue;
    end
    %trainarray(i) = wordindex;
    trainarray = [trainarray, wordindex];
end

%[LL, prior2, transmat2, obsmat2] = dhmm_em(countmat, prior, transmat, obsmat, 'max_iter', 5);


