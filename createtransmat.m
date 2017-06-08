function [ transmat ] = createtransmat( data, states )
%CREATETRANSMAT Creates a transformation matrix.
%   INPUTS
% data: cell array in form <word, POS>
% numstates: number of states (POS tags) in the HMM

transmat = mk_stochastic(zeros(length(states), length(states)));
wordcount = size(data, 1);
prev = data(1,2);
isfirst = 1; % ignore the first words because they are prior

for i=2:wordcount
    curr = data(i, 2);
    if(isfirst == 1) % ignore the first words because they are prior
        isfirst = 0;
        prev = curr;
        continue;
    end
    
    if(strcmp(curr, '.'))
        isfirst = 1; % next is first when . is encountered
    end
    previndex = find(strcmp([states(:)], prev));
    currIndex = find(strcmp([states(:)], curr));
    transmat(previndex, currIndex) = transmat(previndex, currIndex) + 1;
    prev = curr;
end

end

