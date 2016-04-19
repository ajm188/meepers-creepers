function execInstr(instr)

switch (opCode(instr))
    case 0
        % R-type instruction. Have to switch on funct
        switch (funct(instr))
            case hex2dec('20')
                % add
                disp('add');
            case hex2dec('21')
                % addu
            case hex2dec('22')
                % sub
            case hex2dec('23')
                % subu
            case hex2dec('18')
                % mult
            case hex2dec('19')
                % multu
            case hex2dec('1A')
                % div
            case hex2dec('1B')
                % divu
            case hex2dec('10')
                % mfhi
            case hex2dec('12')
                % mflo
            case hex2dec('24')
                % and
            case hex2dec('25')
                % or
            case hex2dec('26')
                % xor
            case hex2dec('27')
                % nor
            case hex2dec('2A')
                % slt
            case hex2dec('2B')
                % sltu
            case hex2dec('0') % Unnecessary, but consistent.
                % sll
            case hex2dec('2')
                % srl
            case hex2dec('3')
                % sra
            case hex2dec('4')
                % sllv
            case hex2dec('6')
                % srlv
            case hex2dec('7')
                % srav
            case hex2dec('8')
                % jr
            case hex2dec('C')
                % syscall
                disp('syscall');
            otherwise
                disp(funct(instr));
                % error. wtf happened?
                return;
        end
    case 8
        % addi
    case 9
        % addiu
        disp('addiu');
    case hex2dec('23')
        % lw
    case hex2dec('21')
        % lh
    case hex2dec('25')
        % lhu
    case hex2dec('20')
        % lb
    case hex2dec('24')
        % lbu
    case hex2dec('2B')
        % sw
    case hex2dec('29')
        % sh
    case hex2dec('28')
        % sb
    case hex2dec('F')
        % lui
    case hex2dec('C')
        % andi
    case hex2dec('D')
        % ori
    case hex2dec('A')
        % slti
    case hex2dec('4')
        % beq
    case hex2dec('5')
        % bne
    case hex2dec('2')
        % j
    case hex2dec('3')
        % jal
    otherwise
        % error. wtf happened?
        return;
end
end

function ft = funct(instr)
%FUNCT Return the funct of an instruction. This is the last six bits.
%      Instr MUST be an R-TYPE instruction. R-instructions are the only
%      instructions with a funct.
ft = bin2int(bitget(instr, 6:-1:1));
end

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

function op = opCode(instr)
%OPCODE Return the op code of an instruction.
%       The op code is the first six bits.
op = bin2int(bitget(instr, 32:-1:27));
end
