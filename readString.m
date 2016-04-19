function str = readString(cpustate, address)

[pageIndex, pageOffset] = getPageIndexAndOffset(cpustate, address);

page = cpustate.pages{pageIndex};

str = [];
while page(pageOffset) ~= 0
    str = [str char(page(pageOffset))];
end