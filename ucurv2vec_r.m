function [yind, mark] = ucurv2vec_r(y)
% UCURV2VEC_R   Convert the output of the UDCT into a real vector form
%
%       [yind, mark] = ucurv2vec_r(y)
%
% Input:
%   y:  an output of the UDCT
%
% Output:
%   yind :  1-D vector that contains all UDCT coefficients
%   mark :  starting point of each change in band in yind
%
% See also:	UCURV2VEC

% take out the directional subband complex amplitude value
tmp = y{1}{1};
yind = real(tmp(:)); % low pass always real 
% band index
min = 1;
mark(min, 1) = prod(size(tmp));
mark(min,2) = size(tmp,1);
mark(min,3) = size(tmp,2);
mark(min,4) = 1;
mark(min,5) = 1;
mark(min,6) = 1;

for in = 2:length(y) % for each consider resolution
    for dim = 1:length(y{in})
        for d = 1:length(y{in}{dim})
            min = min+1;
            tmp = y{in}{dim}{d};
            len = length(tmp(:));
            clear tmpr;
            tmpr(1:2:2*len) = real(tmp(:));
            tmpr(2:2:2*len) = imag(tmp(:));
            
            % first column is the ending point of the subband
            mark(min,1) = mark(min-1,1)+2*len;
            % second column is the row size of the subband
            mark(min,2) = size(tmp,1);
            % third column is the column size of the subband
            mark(min,3) = size(tmp,2);
            % fourth column resolution the subband
            mark(min,4) = in;
            % fifth column pyramid the subband
            mark(min,5) = dim;
            % six column direction the subband
            mark(min,6) = d;
            
            % [inc, inr] = meshgrid(1:Stmp(2), 1:Stmp(1));
            
            %
            % tmp3 = [(tmp(:));
            
            yind = [yind; tmpr(:)];
        end
    end
end
