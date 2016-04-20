function execProg(name)
% Initialize registers
cpustate.regs = zeros(32, 1, 'int32');
cpustate.reg_hi = 0;
cpustate.reg_lo = 0;
cpustate.sockets = [];

% Load the code page
cpustate.pages{1}.base_address = hex2dec('20000000');
cpustate.pages{1}.data = loadBinary([name '-code.bin'], '*uint8');

% Load the data page
cpustate.pages{2}.base_address = hex2dec('10010000');
cpustate.pages{2}.data = loadBinary([name '-data.bin'], '*uint8');

% Initialize dynamic memory allocation state
cpustate.next_allocation_address = hex2dec('30000000');

% Begin execution at the start of the code page
cpustate.halted = 0;
cpustate.pc = cpustate.pages{1}.base_address;

while ~cpustate.halted
    instr = readMemory(cpustate, cpustate.pc, 4);
    cpustate = execInstr(cpustate, instr);
end
end