function data = writeMemory(cpustate, address, length, data)

[pageIndex, pageOffset] = getPageIndexAndOffset(cpustate, address);

if length >= 1
    cpustate.pages{pageIndex}.data(pageOffset) = uint8(data);
end
if length >= 2
    cpustate.pages{pageIndex}.data(pageOffset+1) = uint8(bitshift(data, -8));
end
if length >= 4
    cpustate.pages{pageIndex}.data(pageOffset+2) = uint8(bitshift(data, -16));
    cpustate.pages{pageIndex}.data(pageOffset+3) = uint8(bitshift(data, -24));
end

end