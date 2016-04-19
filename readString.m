function str = readString(cpustate, address)

[pageIndex, pageOffset] = getPageIndexAndOffset(cpustate, address);

pageData = cpustate.pages{pageIndex}.data;

str = [];
while pageData(pageOffset) ~= 0
    str = [str char(pageData(pageOffset))];
    pageOffset = pageOffset + 1;
end