function [ lines ] = filelines( filename )
%FILELINES Finds the number of lines in the file. No empty lines counted
%   counts the number of lines in a file
fid = fopen(filename);
lines = 0;

while feof(fid) == 0
    line = fgetl(fid);
    if(strcmp(line, '')) % handle empty line
        continue
    end
    lines = lines + 1;
end
fclose(fid);
end

