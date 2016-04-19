function execProg(words)
cpustate.regs = zeros(32, 1, 'int32');

for i = 1:length(words)
    instr = words(i);
    cpustate = execInstr(cpustate, instr);
end
end