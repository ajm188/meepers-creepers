function execProg(words)
cpustate.regs = zeros(32, 1, 'int32');
cpustate.reg_hi = 0;
cpustate.reg_lo = 0;

for i = 1:length(words)
    instr = words(i);
    cpustate = execInstr(cpustate, instr);
end
end