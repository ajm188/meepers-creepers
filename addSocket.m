function [cpustate, fd] = addSocket(cpustate, socket)
fd = length(cpustate.sockets) + 1;
cpustate.sockets(fd) = socket;
end
