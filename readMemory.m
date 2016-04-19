function data = readMemory(cpustate, address, length)

[pageIndex, pageOffset] = getPageIndexAndOffset(cpustate, address);

page = cpustate.pages{pageIndex};

if length >= 1
    data = uint8(page(pageOffset));
end
if length >= 2
    data = uint16(data + bitshift(page(pageOffset+1), 8));
end
if length >= 4
    data = uint32(data + bitshift(page(pageOffset+2), 16) + ...
        bitshift(page(pageOffset+3), 24));
end

end