function num = bin2int(bin)
%BIN2INT Convert a binary number, represented as an array of bits,
%        to an integer.

num = sum(2.^(length(bin)-find(bin ~= 0)));
end
