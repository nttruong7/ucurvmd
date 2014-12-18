function D = upsamp(F, decim)
% Upsampling F in decim
% upsamp can work in any dimension
% decim must be vector equal to dimension of F
%

sz = size(F).*decim;
% max value
ms = prod(sz);
indw = 1:ms;

dim = length(sz);
mask = zeros(ms, dim);

for in = 1:dim
    if in == 1 
        step = decim(in);
        template = [1; zeros(step-1,1)];
    else
        step = decim(in);
        template = kron( [1; zeros(step-1,1)],...
            ones( prod(sz(1:in-1)),1) );  
    end

    kronsz = ones( ms/length(template) ,1);
    maskcol = kron(kronsz, template);
    mask(:,in) = maskcol;
end

maskp = prod(mask, 2);
indwf = indw( find(maskp));

Dc = zeros(prod(sz),1);
Dc(indwf) = F(:);

D = reshape(Dc , sz);

end

