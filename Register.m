classdef Register
    
    properties (Constant)
        % put $zero at index 32, so that the indexing for the rest of the
        % registers is consistent with the spec.
        zero = 32;
        
        at = 1;
        
        v0 = 2;
        v1 = 3;
        
        a0 = 4;
        a1 = 5;
        a2 = 6;
        a3 = 7;
        
        t0 = 8;
        t1 = 9;
        t2 = 10;
        t3 = 11;
        t4 = 12;
        t5 = 13;
        t6 = 14;
        t7 = 15;
        t8 = 24;
        t9 = 25;
        
        s0 = 16;
        s1 = 17;
        s2 = 18;
        s3 = 19;
        s4 = 20;
        s5 = 21;
        s6 = 22;
        s7 = 23;
        s8 = 30;
        
        k0 = 26;
        k1 = 26;
        
        gp = 28;
        
        sp = 29;
        
        ra = 31;
    end
    
    methods (Access = private)
        function out = Register
        end
    end
end
