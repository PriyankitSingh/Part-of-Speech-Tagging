function [  ] = writetofile( fid, pos )
%WRITETOFILE Summary of this function goes here
%   Detailed explanation goes here

length = size(pos, 1);
formatSpec = '%s\t%s\n';

for i=1:length
    fprintf(fid, formatSpec, pos{i, :});
end
fprintf(fid, '\n');
end

