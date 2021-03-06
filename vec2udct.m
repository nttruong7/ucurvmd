function y = vec2udct(yind, mark)
% VEC2udct   Convert the output of the UDCT into a vector form
%
%       vec2udct(yind, mark)
%
% Input:
%   y:  an output of the UDCT
%
% Output:
%   yind :  1-D vector that contains all UDCT coefficients
%   mark :  starting point of each change in band in yind
%
% See also:	udct2vec

% take out the directional subband complex amplitude value
tmp = yind(1:mark(1,1));

y{1}{1} = reshape(tmp, mark(1,2), mark(1,3));
% band index

for min = 2:size(mark,1) % for each consider band
	%	mark(min-1,1)+1
	%	mark(min,1)
	%	yind(mark(min,1))
	tmp = yind(mark(min-1,1)+1:mark(min,1));

        y{mark(min,4)}{mark(min,5)}{mark(min,6)} = reshape(tmp,mark(min,2),mark(min,3));
        
end

