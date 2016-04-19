function [index offset] = getPageIndexAndOffset(cpustate, address)

index = -1;
offset = 0;

for i = 1:length(cpustate.pages)
    % Check that the address starts above this page's base address
    if address >= cpustate.pages{i}.base_address
        base_addr = cpustate.pages{i}.base_address;
        % Check that this address ends within the page's base address
        if address - base_addr < length(cpustate.pages{i}.data)
            index = i;
            
            % Correct for Matlab's use of 1-indexed arrays
            offset = (address - base_addr) + 1;
            break;
        end
    end
end