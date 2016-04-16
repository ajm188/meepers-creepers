classdef (Sealed) InstructionType
    %INSTRUCTIONTYPE Defines an enum for instruction types.
    
    properties (Constant)
        UNKNOWN = -1;
        
        R = 0;
        I = 1;
        J = 2;
    end
    
    methods (Access = private) % private to prevent instantiation
        function types = InstructionType
            % Usage: InstructionType.R, InstructionType.I, ...
        end
    end
    
end

