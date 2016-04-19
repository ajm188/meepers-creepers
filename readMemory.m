function data = readMemory(cpustate, address, length)

[pageIndex, pageOffset] = getPageIndexAndOffset(cpustate, address);

pageData = cpustate.pages{pageIndex}.data;

if length >= 1
    data = uint8(pageData(pageOffset));
end
if length >= 2
    data = uint16(uint16(data) + bitshift(uint16(pageData(pageOffset+1)), 8));
end
if length >= 4
    data = uint32(uint32(data) + bitshift(uint32(pageData(pageOffset+2)), 16) + ...
        bitshift(uint32(pageData(pageOffset+3)), 24));
end

end