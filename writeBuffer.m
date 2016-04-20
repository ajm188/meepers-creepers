function writeBuffer(cpustate, address, length, data)

[pageIndex, pageOffset] = getPageIndexAndOffset(cpustate, address);

for i = 1:length
    cpustate.pages{pageIndex}.data(pageOffset+(i-1)) = data(i);
end