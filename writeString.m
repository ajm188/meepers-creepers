function cpustate = writeString(cpustate, address, length, string)

[pageIndex, pageOffset] = getPageIndexAndOffset(cpustate, address);

for i = 1:length
    cpustate.pages{pageIndex}.data(pageOffset+(i-1)) = string(i);
end
cpustate.pages{pageIndex}.data(pageOffset+length) = 0;