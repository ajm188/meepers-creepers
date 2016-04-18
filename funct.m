function ft = funct(instr)
%FUNCT Return the funct of an instruction. This is the last six bits.
%      Instr MUST be an R-TYPE instruction. R-instructions are the only
%      instructions with a funct.
ft = bin2int(bitget(instr, 6:-1:1));
end
