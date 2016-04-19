function cpustate = dispatchSyscall(cpustate)

% The syscall code is loaded into $v0
switch (cpustate.regs(Register.v0))
    case 1
        % print_int
        fprintf('%d', cpustate.regs(Register.a0));
    case 2
        % print_float
        disp('print_float is unsupported');
    case 3
        % print_double
        disp('print_double is unsupported');
    case 4
        % print_string
        fprintf('%s', readString(cpustate, cpustate.regs(Register.a0)));
    case 5
        % read_int
        cpustate.regs(Register.v0) = input('');
    case 6
        % read_float
        disp('read_float is unsupported');
    case 7
        % read_double
        disp('read_double is unsupported');
    case 8
        % read_string
        fprintf('UNIMPLEMENTED: print_string\n');
    case 9
        % sbrk (memory allocation)
        fprintf('UNIMPLEMENTED: sbrk(%d)\n', cpustate.regs(Register.a0));
    case 10
        % exit
        exit(0);
    case 11
        % print_character
        fprintf('%c', cpustate.regs(Register.a0));
    case 12
        % read_character
        in = input('', 's');
        if ~isempty(in)
            cpustate.regs(Register.v0) = in(0);
        end
    case 13
        % open
    case 14
        % read
    case 15
        % write
    case 16
        % close
    case 17
        % exit2
        exit(cpustate.regs(Register.a0));
    otherwise
        fprintf('Invalid syscall index: %d\n', cpustate.regs(Register.v0));
end
end