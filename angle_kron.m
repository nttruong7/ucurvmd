function  ang_md = angle_kron(angle_fun, nper, param_udct)
% , nper, param_udct

krsz = [1, 1, 1];

krsz(1) = prod(param_udct.size( 1:(nper(1)-1) ));
krsz(2) = prod(param_udct.size( (nper(1)+1):(nper(2)-1) ));
krsz(3) = prod(param_udct.size( (nper(2)+1): param_udct.dim ));
    
tmp = angle_fun;

tmp1 = kron(ones(krsz(2),1), tmp);

tmp2 = kron( ones(krsz(3),1) , tmp1(:));

tmp3 = kron(tmp2, ones(krsz(1),1 ));

ang_md = reshape(tmp3, param_udct.size);
    
end

