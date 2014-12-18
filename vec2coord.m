function coord = vec2coord(vec, sz)
% convert a integer vector of 1d position to coordinate in an matrix of
% size sz
len = length(vec);
dim = length(sz);
coord = zeros(len, dim);

coord(1:len, 1) = 1 + mod(vec-1, sz(1));
for in = 2:dim
    lv = prod(sz(1:in));
    tmp = 1+mod(vec-1,lv);
    lv = prod(sz(1:in-1));
    coord(1:len, in) = fix((tmp-1)/lv) + 1;
end

end
