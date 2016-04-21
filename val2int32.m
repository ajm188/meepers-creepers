function out = val2int32(in)

out = int64(bitand(in, 4294967295));
if (out >= 2147483647)
    out = out - 4294967296;
end

end