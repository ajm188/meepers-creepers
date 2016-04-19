function execProg(words)
cpustate.regs = zeros(32, 1, 'int32');
cpustate.reg_hi = 0;
cpustate.reg_lo = 0;
cpustate.pc = 1;
cpustate.halted = 0;

while ~cpustate.halted
    instr = words(cpustate.pc);
    cpustate = execInstr(cpustate, instr);
    if cpustate.pc > length(words)
        cpustate.halted = 1;
    end
end
end