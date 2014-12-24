function im2 = ucurvmdrec(coeff, param_udct, udctwin)

% =====================================================================
% UCURVMDREC code
% =====================================================================
imf = zeros(param_udct.size);

for res = 1:param_udct.res
    for dir = 1: param_udct.dim
        for ang = 1:1:length(udctwin{res+1}{dir})
            cband = upsamp(coeff{res+1}{dir}{ang}, param_udct.dec{res}(dir,:));
            cband = cband./sqrt(2*prod(param_udct.dec{res}(dir,:)));
            cband = prod(param_udct.dec{res}(dir,:))*fftn(cband);
            imf(udctwin{res+1}{dir}{ang}(:,1)) = imf(udctwin{res+1}{dir}{ang}(:,1)) ...
                + cband(udctwin{res+1}{dir}{ang}(:,1)).*udctwin{res+1}{dir}{ang}(:,2);
        end
    end
end

imfl = zeros(param_udct.size);
decimlow = 2^(param_udct.res-1)*ones(1,param_udct.dim);
cband = upsamp(coeff{1}{1}, decimlow );
cband = prod(decimlow)*fftn(cband);
imfl(udctwin{1}{1}(:,1)) = cband(udctwin{1}{1}(:,1)).* ...
    udctwin{1}{1}(:,2);


imf = 2*imf + imfl;

im2 = real(ifftn(imf));