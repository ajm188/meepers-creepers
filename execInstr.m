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
