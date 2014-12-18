function vec = coord2vec(coord, sz)
% convert a integer vector of 1d position to coordinate in an matrix of
% size sz
dim = length(sz);
vec = coord(:, 1);
for in = 2:dim
    lv = prod(sz(1:in-1));    
    vec =  vec + (coord(:, in)-1)*lv;
end
    
    