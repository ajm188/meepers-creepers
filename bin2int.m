function num = bin2int(bin)
%BIN2INT Convert a binary number, represented as an array of bits,
%        to an integer.

% just raise each bit to a power of two (in decreasing order) and sum
% it up.
num = sum(double(bin).*(2.^((length(bin)-1):-1:0)));
end
