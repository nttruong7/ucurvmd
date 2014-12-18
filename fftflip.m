% flip M-D matrix function ------------------------------------------------
function Fc = fftflip(F, dir)

Fc = F;
dim = ndims(F);

shiftvec = zeros(1, dim);
shiftvec(dir) = 1;

Fc = flipdim(F, dir);
Fc = circshift(Fc,shiftvec);


% for in = 1: length(para)
%     flipvec = zeros(1,dim);
%     flipvec(para(in)) = 1;
%     Fc = circshift(flipdim(Fc, para(in)), flipvec);
% end

end