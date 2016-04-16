function type = instrType(instr)
%INSTRTYPE Returns the type of instruction, as defined by the enum in
%          InstructionType.

% I-TYPE opcodes are 4, 5, 8-A, C, D, F, 20, 21, 23-25, 28, 2B in hex
i_type_opcodes = [4:5, 8:10, 12:13, 15, 32:33, 35:37, 40, 43];
j_type_opcodes = [2 3];

op = opCode(instr);
if op == 0
    type = InstructionType.R;
elseif ~isempty(find(i_type_opcodes == op, 1))
    type = InstructionType.I;
elseif ~isempty(find(j_type_opcodes == op, 1))
    type = InstructionType.J;
else
    type = InstructionType.UNKNOWN;
end
end
