function data = readBuffer(cpustate, address, length)

[pageIndex, pageOffset] = getPageIndexAndOffset(cpustate, address);

pageData = cpustate.pages{pageIndex}.data;

data = pageData(pageOffset:pageOffset+length-1);