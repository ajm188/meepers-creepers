function execProg(words)
registers = zeros(32, 1, 'int32');

for i = 1:length(words)
    instr = words(i);
    execInstr(instr);
end
end