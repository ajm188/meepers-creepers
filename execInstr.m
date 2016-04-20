% NOTE(Cam): Because Matlab uses 1-index arrays, I'm fixing up
% the register indices by adding 1 as they're unpacked. This means
% the numbers will be off by one when compared raw with the instruction
% set documentation. The regidx2name() function will properly handle
% these modified indices.

function cpustate = execInstr(cpustate, instr)
dumpRegs(cpustate.regs);
dumpOpcode(instr);

% Unpack I and J forms now since they don't conflict with each other.
% We'll use the correct unpacked form when executing.
[rs, rt, immediate] = unpackI(instr);
address = unpackJ(instr);

% TODO(Cam): Fix signedness and overflow/underflow behavior of arithmetic
% instructions. Fix arithmetic shift behavior.
switch (opCode(instr))
    case hex2dec('0')
        % R-type instruction. Have to switch on funct
        [rs, rt, rd, shamt, funct] = unpackR(instr);
        switch (funct)
            case hex2dec('20')
                % add
                cpustate.regs(rd) = cpustate.regs(rs) + cpustate.regs(rt);
            case hex2dec('21')
                % addu
                cpustate.regs(rd) = cpustate.regs(rs) + cpustate.regs(rt);
            case hex2dec('22')
                % sub
                cpustate.regs(rd) = cpustate.regs(rs) - cpustate.regs(rt);
            case hex2dec('23')
                % subu
                cpustate.regs(rd) = cpustate.regs(rs) - cpustate.regs(rt);
            case hex2dec('18')
                % mult
                product = cpustate.regs(rs) * cpustate.regs(rt);
                cpustate.reg_lo = int32(product);
                cpustate.reg_hi = int32(bitshift(product, -32));
            case hex2dec('19')
                % multu
                product = cpustate.regs(rs) * cpustate.regs(rt);
                cpustate.reg_lo = uint32(product);
                cpustate.reg_hi = uint32(bitshift(product, -32));
            case hex2dec('1A')
                % div
                cpustate.reg_lo = cpustate.regs(rs) / cpustate.regs(rt);
                cpustate.reg_hi = mod(cpustate.regs(rs), cpustate.regs(rt));
            case hex2dec('1B')
                % divu
                cpustate.reg_lo = cpustate.regs(rs) / cpustate.regs(rt);
                cpustate.reg_hi = mod(cpustate.regs(rs), cpustate.regs(rt));
            case hex2dec('10')
                % mfhi
                cpustate.regs(rd) = cpustate.reg_hi;
            case hex2dec('12')
                % mflo
                cpustate.regs(rd) = cpustate.reg_lo;
            case hex2dec('24')
                % and
                cpustate.regs(rd) = bitand(cpustate.regs(rs), cpustate.regs(rt), 'int32');
            case hex2dec('25')
                % or
                cpustate.regs(rd) = bitor(cpustate.regs(rs), cpustate.regs(rt), 'int32');
            case hex2dec('26')
                % xor
                cpustate.regs(rd) = bitxor(cpustate.regs(rs), cpustate.regs(rt), 'int32');
            case hex2dec('27')
                % nor
                cpustate.regs(rd) = bitcmp(bitor(cpustate.regs(rs), cpustate.regs(rt), 'int32'), 'int32');
            case hex2dec('2A')
                % slt
                cpustate.regs(rd) = (cpustate.regs(rs) < cpustate.regs(rt));
            case hex2dec('2B')
                % sltu
                cpustate.regs(rd) = (cpustate.regs(rs) < cpustate.regs(rt));
            case hex2dec('0')
                % sll
                cpustate.regs(rd) = bitshift(cpustate.regs(rt), shamt);
            case hex2dec('2')
                % srl
                cpustate.regs(rd) = bitshift(cpustate.regs(rt), -shamt);
            case hex2dec('3')
                % sra
                cpustate.regs(rd) = bitshift(cpustate.regs(rt), -shamt);
            case hex2dec('4')
                % sllv
                cpustate.regs(rd) = bitshift(cpustate.regs(rt), cpustate.regs(rs));
            case hex2dec('6')
                % srlv
                cpustate.regs(rd) = bitshift(cpustate.regs(rt), -cpustate.regs(rs));
            case hex2dec('7')
                % srav
                cpustate.regs(rd) = bitshift(cpustate.regs(rt), -cpustate.regs(rs));
            case hex2dec('8')
                % jr
            case hex2dec('C')
                % syscall
                cpustate = dispatchSyscall(cpustate);
            otherwise
                % Illegal instruction - halt core
                disp(instr);
                cpustate.halted = 1;
        end
    case hex2dec('8')
        % addi
        cpustate.regs(rt) = cpustate.regs(rs) + immediate;
    case hex2dec('9')
        % addiu
        cpustate.regs(rt) = cpustate.regs(rs) + immediate;
    case hex2dec('23')
        % lw
        cpustate.regs(rt) = readMemory(cpustate, cpustate.regs(rs) + immediate, 4);
    case hex2dec('21')
        % lh
        cpustate.regs(rt) = readMemory(cpustate, cpustate.regs(rs) + immediate, 2);
    case hex2dec('25')
        % lhu
        cpustate.regs(rt) = readMemory(cpustate, cpustate.regs(rs) + immediate, 2);
    case hex2dec('20')
        % lb
        cpustate.regs(rt) = readMemory(cpustate, cpustate.regs(rs) + immediate, 1);
    case hex2dec('24')
        % lbu
        cpustate.regs(rt) = readMemory(cpustate, cpustate.regs(rs) + immediate, 1);
    case hex2dec('2B')
        % sw
        writeMemory(cpustate, cpustate.regs(rs) + immediate, 4, cpustate.regs(rt));
    case hex2dec('29')
        % sh
        writeMemory(cpustate, cpustate.regs(rs) + immediate, 2, cpustate.regs(rt));
    case hex2dec('28')
        % sb
        writeMemory(cpustate, cpustate.regs(rs) + immediate, 1, cpustate.regs(rt));
    case hex2dec('F')
        % lui
        cpustate.regs(rt) = bitshift(immediate, 16);
    case hex2dec('C')
        % andi
        cpustate.regs(rt) = bitand(cpustate.regs(rs), immediate);
    case hex2dec('D')
        % ori
        cpustate.regs(rt) = bitor(cpustate.regs(rs), immediate);
    case hex2dec('A')
        % slti
        cpustate.regs(rt) = (cpustate.regs(rs) < immediate);
    case hex2dec('4')
        % beq
    case hex2dec('5')
        % bne
    case hex2dec('2')
        % j
    case hex2dec('3')
        % jal
    otherwise
        % Illegal instruction - halt core
        disp(instr);
        cpustate.halted = 1;
end
cpustate.pc = cpustate.pc + 4;
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

function [rs, rt, rd, shamt, funct] = unpackR(instr)
% Extracts parameters from an R-type instruction
% These instructions contain 3 registers, a constant offset, and a function
% code
rs = bin2int(bitget(instr, 26:-1:22)) + 1;
rt = bin2int(bitget(instr, 21:-1:17)) + 1;
rd = bin2int(bitget(instr, 16:-1:12)) + 1;
shamt = bin2int(bitget(instr, 11:-1:7));
funct = bin2int(bitget(instr, 6:-1:1));
end

function [rs, rt, immediate] = unpackI(instr)
% Extracts parameters from an I-type instruction
% These instructions contain 2 registers and an immediate value
rs = bin2int(bitget(instr, 26:-1:22)) + 1;
rt = bin2int(bitget(instr, 21:-1:17)) + 1;
immediate = bin2int(bitget(instr, 16:-1:1));
end

function address = unpackJ(instr)
% Extracts parameters from an J-type instruction
% These instructions contain a jump target only.
address = bin2int(bitget(instr, 26:-1:1));
end

% TODO(Cam): We should move this into another file if we can
function dumpOpcode(instr)

% Unpack I and J forms now since they don't conflict with each other.
% We'll use the correct unpacked form when executing.
[rs, rt, immediate] = unpackI(instr);
address = unpackJ(instr);
switch (opCode(instr))
    case hex2dec('0')
        % R-type instruction. Have to switch on funct
        [rs, rt, rd, shamt, funct] = unpackR(instr);
        switch (funct)
            case hex2dec('20')
                fprintf('add');
            case hex2dec('21')
                fprintf('addu');
            case hex2dec('22')
                fprintf('sub');
            case hex2dec('23')
                fprintf('subu');
            case hex2dec('18')
                fprintf('mult');
            case hex2dec('19')
                fprintf('multu');
            case hex2dec('1A')
                fprintf('div');
            case hex2dec('1B')
                fprintf('divu');
            case hex2dec('10')
                fprintf('mfhi');
            case hex2dec('12')
                fprintf('mflo');
            case hex2dec('24')
                fprintf('and');
            case hex2dec('25')
                fprintf('or');
            case hex2dec('26')
                fprintf('xor');
            case hex2dec('27')
                fprintf('nor');
            case hex2dec('2A')
                fprintf('slt');
            case hex2dec('2B')
                fprintf('sltu');
            case hex2dec('0')
                fprintf('sll');
            case hex2dec('2')
                fprintf('srl');
            case hex2dec('3')
                fprintf('sra');
            case hex2dec('4')
                fprintf('sllv');
            case hex2dec('6')
                fprintf('srlv');
            case hex2dec('7')
                fprintf('srav');
            case hex2dec('8')
                fprintf('jr');
            case hex2dec('C')
                disp('syscall');
                return;
            otherwise
                disp(funct(instr));
                % error. wtf happened?
                return;
        end
        fprintf(' $%s $%s $%s %d\n', regidx2name(rd), regidx2name(rs), ...
            regidx2name(rt), shamt);
        return;
    case hex2dec('8')
        fprintf('addi');
    case hex2dec('9')
        fprintf('addiu');
    case hex2dec('23')
        fprintf('lw');
    case hex2dec('21')
        fprintf('lh');
    case hex2dec('25')
        fprintf('lhu');
    case hex2dec('20')
        fprintf('lb');
    case hex2dec('24')
        fprintf('lbu');
    case hex2dec('2B')
        fprintf('sw');
    case hex2dec('29')
        fprintf('sh');
    case hex2dec('28')
        fprintf('sb');
    case hex2dec('F')
        fprintf('lui');
    case hex2dec('C')
        fprintf('andi');
    case hex2dec('D')
        fprintf('ori');
    case hex2dec('A')
        fprintf('slti');
    case hex2dec('4')
        fprintf('beq $%s $%s %04x\n', regidx2name(rs), regidx2name(rt), immediate);
    case hex2dec('5')
        fprintf('bne $%s $%s %04x\n', regidx2name(rs), regidx2name(rt), immediate);
    otherwise
        switch (opCode(instr))
            case hex2dec('2')
                fprintf('j');
            case hex2dec('3')
                fprintf('jal');
            otherwise
                % error. wtf happened?
                disp(instr);
                return;
        end
        fprintf(' %08x\n', address);
        return;
end
fprintf(' $%s %d($%s)\n', regidx2name(rt), immediate, regidx2name(rs));
end

% Converts a register index (as present in an opcode) into a human-readable
% register name
function name = regidx2name(regidx)
names = {'zero', 'at', 'v0', 'v1', 'a0', 'a1', 'a2', 'a3', 't0', 't1', 't2', 't3', ...
    't4', 't5', 't6', 't7', 's0', 's1', 's2', 's3', 's4', 's5', 's6', 's7', ...
    't8', 't9', 'k0', 'k1', 'gp', 'sp', 's8', 'ra'};
name = names{regidx};
end

% Dumps register values
function dumpRegs(regs)
for i = 1:length(regs)
    % Only print registers that have a value
    if regs(i)
        fprintf('$%s = 0x%08x = %d\n', regidx2name(i), regs(i), regs(i));
    end
end
end
