% create 2-D grid function-------------------------------------------------
function [M2, M1] = adapt_grid(S1, S2)

[x1, x2] = meshgrid(S2,S1);

% scale the grid approximate the tan theta function ------------------
% creat two scale grid for mostly horizontal and vertical direction
% firt grid
t1 = zeros(size(x1));
ind = and(x1~=0, abs(x2) <= abs(x1));
t1(ind) = -x2(ind)./x1(ind);

t2 = zeros(size(x1));
ind = and(x2~=0, abs(x1) < abs(x2));
t2(ind) = x1(ind)./x2(ind);
t3 = t2;
t3(t2<0) = t2(t2<0)+2;
t3(t2>0) = t2(t2>0)-2;

M1 = t1+t3;
M1(x1>=0) = -2;

% second grid
t1 = zeros(size(x1));
ind = and(x2~=0, abs(x1) <= abs(x2));
t1(ind) = -x1(ind)./x2(ind);

t2 = zeros(size(x1));
ind = and(x1~=0, abs(x2) < abs(x1));
t2(ind) = x2(ind)./x1(ind);
t3 = t2;
t3(t2<0) = t2(t2<0)+2;
t3(t2>0) = t2(t2>0)-2;

M2 = t1+t3;
M2(x2>=0) = -2;
clear t1 t2 t3;

end

