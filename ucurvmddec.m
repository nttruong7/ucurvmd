function coeff = ucurvmddec(im, param_udct, udctwin)

imf = fftn(im);


fband = 0*imf;
fband(udctwin{1}{1}(:,1)) = imf(udctwin{1}{1}(:,1)).* ...
    udctwin{1}{1}(:,2);
cband = ifftn(fband);
coeff{1}{1} = downsamp(cband,2^(param_udct.res-1)*ones(1,param_udct.dim ));

fvec = imf(udctwin{1}{1}(:,1)).*udctwin{1}{1}(:,2);
% convert the window sparse vector to sparse coordinate
dvec = vec2coord(udctwin{1}{1}(:,1), param_udct.size);
% down sample the sparse coordinate
szdown = param_udct.size ./ (2^(param_udct.res-1)*ones(1,param_udct.dim ));
dcorddown = mod(dvec-1,kron(szdown,ones(size(dvec,1),1))) + 1;
dvecdown = coord2vec(dcorddown, szdown);
fband = zeros(szdown);
fband(dvecdown) = fvec;
cband = ifftn(fband);


for res = 1:param_udct.res
    for dir = 1: param_udct.dim
        for ang = 1:1:length(udctwin{res+1}{dir})
            fband = 0*imf;
            fband(udctwin{res+1}{dir}{ang}(:,1)) = imf(udctwin{res+1}{dir}{ang}(:,1)).* ...
                udctwin{res+1}{dir}{ang}(:,2);
            % fband = imf.*subband{dir}{ang};
            cband = ifftn(fband);
            coeff{res+1}{dir}{ang} = downsamp(cband,param_udct.dec{res}(dir,:));
            coeff{res+1}{dir}{ang} = sqrt(2*prod(param_udct.dec{res}(dir,:))) * coeff{res+1}{dir}{ang};
        end
    end
end