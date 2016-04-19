function execProg(name)
cpustate.regs = zeros(32, 1, 'int32');
cpustate.reg_hi = 0;
cpustate.reg_lo = 0;
cpustate.pc = 0;
cpustate.pages{0}.base_address = hex2int('0x20000000');
cpustate.pages{0}.data = loadBinary([name '-code.bin'], '*uint8');
cpustate.pages{1}.base_address = hex2int('0x10010000');
cpustate.pages{1}.data = loadBinary([name '-data.bin'], '*uint8');
for i = 1:length(words)
    instr = words(i);
    cpustate = execInstr(cpustate, instr);
end
end