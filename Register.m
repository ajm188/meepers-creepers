classdef Register

    % See the note in execInstr for why we add 1 to each index.
    properties (Constant)
        zero = 0 + 1;
        
        at = 1 + 1;
        
        v0 = 2 + 1;
        v1 = 3 + 1;
        
        a0 = 4 + 1;
        a1 = 5 + 1;
        a2 = 6 + 1;
        a3 = 7 + 1;
        
        t0 = 8 + 1;
        t1 = 9 + 1;
        t2 = 10 + 1;
        t3 = 11 + 1;
        t4 = 12 + 1;
        t5 = 13 + 1;
        t6 = 14 + 1;
        t7 = 15 + 1;
        t8 = 24 + 1;
        t9 = 25 + 1;
        
        s0 = 16 + 1;
        s1 = 17 + 1;
        s2 = 18 + 1;
        s3 = 19 + 1;
        s4 = 20 + 1;
        s5 = 21 + 1;
        s6 = 22 + 1;
        s7 = 23 + 1;
        s8 = 30 + 1;
        
        k0 = 26 + 1;
        k1 = 27 + 1;
        
        gp = 28 + 1;
        
        sp = 29 + 1;
        
        ra = 31 + 1;
    end
    
    methods (Access = private)
        function out = Register
        end
    end
end
