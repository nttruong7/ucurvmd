classdef opUdct < opSpot
    %OPCURVELET  Two-dimensional curvelet operator.
    %
    %   opCurvelet(M,N,NBSCALES,NBANGLES,TTYPE) creates a two-dimensional
    %   curvelet operator for M by N matrices. The curvelet transform is
    %   computed using the Curvelab code.
    %
    %   The remaining three parameters are optional; NBSCALES gives the
    %   number of scales and is set to max(1,ceil(log2(min(M,N)) - 3)) by
    %   default, as suggested by Curvelab. NBANGLES gives the number of
    %   angles at the second coarsest level which must be a multiple of
    %   four with a minimum of 8. By default NBANGLES is set to 16. TTYPE
    %   determines the type of transformation and is set to 'WRAP' by
    %   default.
    %
    %   See also CURVELAB
    
    %   Copyright 2009, Gilles Hennenfent, Ewout van den Berg and Michael P. Friedlander
    %   See the file COPYING.txt for full copyright information.
    %   Use the command 'spot.gpl' to locate this file.
    
    %   http://www.cs.ubc.ca/labs/scl/spot
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Properties
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (SetAccess = private)
        funHandle = []; % Multiplication function
        % param_int = {};
        % udctwin = {};
        % mark;
    end % Properties
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Methods
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function op = opUdct(param_udct)
            
            finest  = 1;
            is_real = 1;
            
            % [udctwin, param_udct] = udctmdwin(param_udct);
            % param_int = param_udct;
            
            % parms = {m,n,cn,hdr,finest,nbscales,nbangles,is_real,ttype};
            fun   = @(x,mode) opUdct_intrnl(x,mode);
            
            % Construct operator
            op = op@opSpot('Udct', param_udct.len_r, param_udct.len);
            op.cflag     = ~is_real;
            op.funHandle = fun;
        end % Constructor
        
    end % Methods
    
    
    methods ( Access = protected )
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Multiply
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function y = multiply(op,x,mode)
            y = op.funHandle(x,mode);
        end % Multiply
        
    end % Methods
    
end % Classdef


%=======================================================================


function y = opUdct_intrnl(x,mode)

if mode == 1
    % Analysis mode
    % coeff = udctmddec_mat(resize(x,param_int.size) , param_int, udctwin);
    % [y, mark] = udct2vec_r(coeff);
    y = udctmddec_mat(x);
else
    % Synthesis mode
    [y] = udctmdrec_mat(x);
    
end
end
