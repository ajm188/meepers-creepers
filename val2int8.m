function out = val2int8(in)

out = int32(bitand(in, 255));
if (out >= 128)
    out = out - 256;
end

end