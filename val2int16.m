function out = val2int16(in)

out = int32(bitand(in, 65535));
if (out >= 32768)
    out = out - 65536;
end

end