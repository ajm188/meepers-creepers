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
        data = input('', 's');
        writeString(cpustate, cpustate.regs(Register.a0), ...
            cpustate.regs(Register.a1), data);
    case 9
        % sbrk (memory allocation)
        pageindex = length(cpustate.pages)+1;
        cpustate.pages{pageindex}.base_address = cpustate.next_allocation_address;
        cpustate.pages{pageindex}.data = zeros(cpustate.regs(Register.a0), 1, 'uint8');
        cpustate.next_allocation_address = cpustate.next_allocation_address + cpustate.regs(Register.a0);
        cpustate.regs(Register.v0) = cpustate.pages{pageindex}.base_address;
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
        filename = readString(cpustate, cpustate.regs(Register.a0));
        if cpustate.regs(Register.a1) == 0
            mode = 'r';
        else
            mode = 'w';
        end
        cpustate.regs(Register.v0) = fopen(filename, mode);
    case 14
        % read
        readdata = fread(cpustate.regs(Register.a0), cpustate.regs(Register.a2));
        writeBuffer(cpustate, cpustate.regs(Register.a1), length(readdata), readdata);
        cpustate.regs(Register.v0) = length(readdata);
    case 15
        % write
        fwrite(cpustate.regs(Register.a0), ...
            readBuffer(cpustate.regs(Register.a1), cpustate.regs(Register.a2)));
        cpustate.regs(Register.v0) = cpustate.regs(Register.a2);
    case 16
        % close
        fclose(cpustate.regs(Register.a0));
        cpustate.regs(Register.v0) = 0;
    case 17
        % exit2
        exit(cpustate.regs(Register.a0));
    case 101
        % sock_write
        % socket fd in $a0
        % buffer address in $a1
        % max-len in $a2
        % bytes written or -1 in $v1
        fd = cpustate.regs(Register.a0);
        buffAddr = cpustate.regs(Register.a1);
        maxLen = cpustate.regs(Register.a2);
        socket = cpustate.sockets(fd);
        bytes = readBuffer(cpustate, buffAddr, maxLen);
        socket.getOutputStream().write(bytes);
        cpustate.regs(Register.v1) = length(bytes);
    case 102
        % sock_read
        % socket fd in $a0
        % buffer address in $a1
        % max-len in $a2
        % bytes read or -1 in $v1
        fd = cpustate.regs(Register.a0);
        buffAddr = cpustate.regs(Register.a1);
        maxLen = cpustate.regs(Register.a2);
        socket = cpustate.sockets(fd);
        buff = zeros(1, maxLen, 'uint8');
        bytesRead = socket.getInputStream().read(buff);
        writeBuffer(cpustate, buffAddr, bytesRead, buff);
        cpustate.regs(Register.v1) = bytesRead;
    case 103
        % sock_close
        % socket fd in $a0
        fd = cpustate.regs(Register.a0);
        socket = cpustate.sockets(fd);
        socket.close();
    case 110
        % ssock_open
        % put socket fd in $v1
        import java.net.ServerSocket;
        port = cpustate.regs(Register.a0);
        sock = ServerSocket(port);
        [cpustate, fd] = addSocket(cpustate, sock);
        cpustate.regs(Register.v1) = fd;
    case 112
        % ssock_accept
        % server socket fd in $a0
        % put client socket fd in $v1
        fd = cpustate.regs(Register.a0);
        server = cpustate.sockets(fd);
        client = server.accept;
        [cpustate, client_fd] = addSocket(client, fd);
        cpustate.regs(Register.v1) = client_fd;
    case 120
        % sock_close_all
        % close all open server sockets
        for i = 1:length(cpustate.sockets)
            cpustate.sockets(i).close();
        end
        cpustate.sockets = [];
    otherwise
        fprintf('Invalid syscall index: %d\n', cpustate.regs(Register.v0));
end
end
