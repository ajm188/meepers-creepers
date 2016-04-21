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
        cpustate = writeString(cpustate, cpustate.regs(Register.a0), ...
            cpustate.regs(Register.a1), data);
    case 9
        % sbrk (memory allocation)
        pageindex = length(cpustate.pages)+1;
        cpustate.pages{pageindex}.name = 'Dynamic Allocation (sbrk)';
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
        a = fopen(filename, mode);
        cpustate.regs(Register.v0) = a;
    case 14
        % read
        readdata = fread(double(cpustate.regs(Register.a0)), cpustate.regs(Register.a2));
        cpustate = writeBuffer(cpustate, cpustate.regs(Register.a1), length(readdata), readdata);
        cpustate.regs(Register.v0) = length(readdata);
    case 15
        % write
        fwrite(double(cpustate.regs(Register.a0)), ...
            readBuffer(cpustate, cpustate.regs(Register.a1), cpustate.regs(Register.a2)));
        cpustate.regs(Register.v0) = cpustate.regs(Register.a2);
    case 16
        % close
        fclose(double(cpustate.regs(Register.a0)));
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
        socket = cpustate.sockets{fd};
        if maxLen > 0
            bytes = readBuffer(cpustate, buffAddr, maxLen);
            try
                socket.getOutputStream().write(bytes);
                cpustate.regs(Register.v1) = length(bytes);
            catch
                cpustate.regs(Register.v1) = -1;
            end
        else
            cpustate.regs(Register.v1) = 0;
        end
    case 102
        % sock_read
        % socket fd in $a0
        % buffer address in $a1
        % max-len in $a2
        % bytes read or -1 in $v1
        fd = cpustate.regs(Register.a0);
        buffAddr = cpustate.regs(Register.a1);
        maxLen = cpustate.regs(Register.a2);
        socket = cpustate.sockets{fd};
        buff = [];
        while length(buff) < maxLen && socket.getInputStream().available() > 0
            buff = [buff socket.getInputStream().read()];
        end
        cpustate = writeBuffer(cpustate, buffAddr, length(buff), buff);
        cpustate.regs(Register.v1) = length(buff);
    case 103
        % sock_close
        % socket fd in $a0
        fd = cpustate.regs(Register.a0);
        socket = cpustate.sockets{fd};
        socket.close();
    case 110
        % ssock_open
        % put socket fd in $v1
        import java.net.ServerSocket;
        import java.net.InetSocketAddress;
        port = cpustate.regs(Register.a0);
        sock = ServerSocket();
        sock.setReuseAddress(1);
        sock.bind(InetSocketAddress(port));
        [cpustate, fd] = addSocket(cpustate, sock);
        cpustate.regs(Register.v1) = fd;
    case 112
        % ssock_accept
        % server socket fd in $a0
        % put client socket fd in $v1
        fd = cpustate.regs(Register.a0);
        server = cpustate.sockets{fd};
        client = server.accept;
        [cpustate, client_fd] = addSocket(cpustate, client);
        cpustate.regs(Register.v1) = client_fd;
    case 120
        % sock_close_all
        % close all open server sockets
        for i = 1:length(cpustate.sockets)
            cpustate.sockets{i}.close();
        end
        cpustate.sockets = {};
    otherwise
        fprintf('Invalid syscall index: %d\n', cpustate.regs(Register.v0));
end
end
