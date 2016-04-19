function words = loadBinary(path, type)
%LOADBINARY Load data from a file in binary format.
%           Returns an array of words (4 bytes).
%
%           An empty array will be returned if the file is empty,
%           or if an error occurs with the file i/o.
fd = fopen(path);
if fd < 1
    words = [];
    return
end
words = fread(fd, Inf, type);
fclose(fd);
end
