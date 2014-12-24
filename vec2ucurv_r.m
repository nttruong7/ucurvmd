function y = vec2ucurv_r(yind, mark)
% VEC2UCURV   Convert a real vector back to UDCT coefficents
%
%       y = vec2ucurv_r(yind, mark)
%
% Input:
%   y:  an output of the UDCT
%
% Output:
%   yind :  1-D vector that contains all UDCT coefficients
%   mark :  starting point of each change in band in yind
%
% See also:	ucurv2vec

% take out the directional subband complex amplitude value
tmp = yind(1:mark(1,1));

y{1}{1} = reshape(tmp, mark(1,2), mark(1,3));
% band index

for min = 2:size(mark,1) % for each consider band
    %	mark(min-1,1)+1
    %	mark(min,1)
    %	yind(mark(min,1))
    tmpr = yind(mark(min-1,1)+1:mark(min,1));
    tmp = tmpr(1:2:end) + sqrt(-1)*tmpr(2:2:end);
    
    y{mark(min,4)}{mark(min,5)}{mark(min,6)} = reshape(tmp,mark(min,2),mark(min,3));
    
end

