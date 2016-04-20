function cpustate = writeMemory(cpustate, address, length, data)

[pageIndex, pageOffset] = getPageIndexAndOffset(cpustate, address);

if length >= 1
    cpustate.pages{pageIndex}.data(pageOffset) = bitand(data, 255);
end
if length >= 2
    cpustate.pages{pageIndex}.data(pageOffset+1) = bitand(bitshift(data, -8), 255);
end
if length >= 4
    cpustate.pages{pageIndex}.data(pageOffset+2) = bitand(bitshift(data, -16), 255);
    cpustate.pages{pageIndex}.data(pageOffset+3) = bitand(bitshift(data, -24), 255);
end

end