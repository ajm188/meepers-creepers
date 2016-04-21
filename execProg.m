function execProg(name)
% Initialize registers
cpustate.regs = zeros(32, 1, 'int32');
cpustate.reg_hi = 0;
cpustate.reg_lo = 0;
cpustate.sockets = {};

% Initialize breakpoints
cpustate.breakpoints = [];
%cpustate.breakpoints(1) = hex2dec('40057c');
%cpustate.breakpoints(2) = hex2dec('400594');
%cpustate.breakpoints(3) = hex2dec('400584');

% Load the code page
cpustate.pages{1}.name = 'Code Segment';
cpustate.pages{1}.base_address = hex2dec('00400000');
cpustate.pages{1}.data = loadBinary([name '-code.bin'], '*uint8');

% Load the data page
cpustate.pages{2}.name = 'Data Segment';
cpustate.pages{2}.base_address = hex2dec('10010000');
cpustate.pages{2}.data = loadBinary([name '-data.bin'], '*uint8');
cpustate.pages{2}.data(10000000) = 0;

% Allocate a page for stack
cpustate.pages{3}.name = 'Stack';
cpustate.pages{3}.base_address = hex2dec('40000000');
cpustate.pages{3}.data = zeros(256 * 1024, 1, 'uint8');

% Initialize dynamic memory allocation state
cpustate.next_allocation_address = hex2dec('30000000');

% Begin execution at the start of the code page
cpustate.halted = 0;
cpustate.pc = cpustate.pages{1}.base_address;
cpustate.regs(Register.sp) = cpustate.pages{3}.base_address;

% Initialize callstack tracker
cpustate.callframes = [];
cpustate.loops = 0;
cpustate.dmpdelay = Inf;

while ~cpustate.halted
    instr = readMemory(cpustate, cpustate.pc, 4);
    for i = 1:length(cpustate.breakpoints)
        if cpustate.breakpoints(i) == cpustate.pc
            break;
        end
    end
    cpustate.loops = cpustate.loops + 1;
    
    cpustate = execInstr(cpustate, instr);
    
    if cpustate.loops >= cpustate.dmpdelay
        dumpPageArray(cpustate);
        dumpCalls(cpustate);
    end
end
end

function dumpPageArray(cpustate)

fprintf('Name\t\t\tBase\t\tLimit\t\tLength\n');
for i = 1:length(cpustate.pages)
    page = cpustate.pages{i};
    fprintf('%s\t0x%08x\t0x%08x\t%d\n', ...
        page.name, ...
        page.base_address, ...
        page.base_address+length(page.data), ...
        length(page.data));
end
end

function dumpCalls(cpustate)

for i = length(cpustate.callframes):-1:1
    fprintf('0x%08x\n', cpustate.callframes(i));
end
end