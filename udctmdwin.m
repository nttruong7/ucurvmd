function [udctwin, param_udct] = udctmdwin(param_udct)
%
% UDCTMDWIN :  Calculate curvelet windows functions for UDCT transform
%
%       [udctwin, param_udct] = udctmdwin(param_udct)
%
% Input:
%	param_udct:	A structure to contain all information about current
%               curvelet transform configuration
%
% Output:
%   udctwin:    Calculated curvelet windows for current UDCT transform.
%               Matrix data stored in sparse form. 
%	param_udct:	Updated param_udct structure
%   
% See also:     UDCTMDDEC, UDCTMDREC, README.TXT
%
% =====================================================================
% udctMDWIN code
% =====================================================================

% create the 1d grid along each dimension
% then use the grid to estimate smooth windows for lowpass highpass
% function
for ind = 1: param_udct.dim
    Sgrid{ind} = -1.5*pi:pi/(param_udct.size(ind)/2):(0.5*pi-pi/(param_udct.size(ind)/2));
    f1d{param_udct.res,ind} = fun_meyer(abs(Sgrid{ind}), [-2,-1, param_udct.r(1:2)] );
    if (param_udct.res == 1)
        f1d{param_udct.res,ind} = f1d{param_udct.res,ind} + fun_meyer(abs(Sgrid{ind}+2*pi), [-2,-1, param_udct.r(1:2)] );
    end
    f1d{param_udct.res+1,ind} = fun_meyer(abs(Sgrid{ind}), [-2,-1, param_udct.r(3:4)] );
    for in = param_udct.res-1:-1:1
        f1d{in,ind} = fun_meyer(abs(Sgrid{ind}), [-2,-1, param_udct.r(1:2)/(2^(param_udct.res-in))] );
    end
end

for in = param_udct.res:-1:1
    fltmp = 1;
    fhtmp = 1;
    
    for ind = param_udct.dim:-1:1
        fltmp = kron(fltmp(:), f1d{in,ind}(:));
        fhtmp = kron(fhtmp(:), f1d{in+1,ind}(:));
    end
    
    FL = reshape(fltmp, param_udct.size);
    FH = reshape(fhtmp, param_udct.size);
    FP = FH-FL;
    FP(FP<0) = 0;
    F2d{in+1} = FP;
end
F2d{1} = FL;
clear FL FH FP

Winlow = circshift(sqrt(F2d{1}), param_udct.size/4);
% convert to sparse format
udctwin{1}{1} = [find(Winlow>param_udct.winthresh), ...
    Winlow(find(Winlow>param_udct.winthresh))];
param_udct.ind{1}{1} = 0;

% every combination of 2 dimension out of 1:dim
mperms = nchoosek(1:param_udct.dim, 2);
% the mesh for 2-d angle function
for ind = 1:size(mperms,1)
    [ M{ind,1},M{ind,2}] = adapt_grid(Sgrid{mperms(ind,1)},Sgrid{mperms(ind,2)});
end

% gather angle function for each pyramid
clear Mang Mang_in Mdir;

for res = 1:param_udct.res
    % for each resolution
    for ind = 1: param_udct.dim
        % for each pyramid in resolution res
        cnt = 1;
        % cnt is number of angle funtion rquired for each pyramid
        % now loop throgh mperms
        Mdir{res}(ind,:) = [1:ind-1, ind+1:param_udct.dim];
        % Mdir is dimension of need to calculate angle function on each
        % hyperpyramid
        
        for np = 1:size(mperms,1)
            for ndir = 1:2
                if mperms(np, ndir) == ind
                    
                    Mang{res}{ind,cnt} = angle_fun(M{np,ndir}, ndir, ...
                        param_udct.cfg(res, mperms(np, 3-ndir) ), param_udct.alpha);
                    Mang_in{res}{ind,cnt} = mperms(np,1:2);
                    cnt = cnt +1;
                end
            end
        end
    end
end

% Mang is 1-d angle function for each hyper pyramid (row) and each angle
% dimension (column)
for res = 1:param_udct.res
    % for each resolution
    for in1 = 1: param_udct.dim
        % for each hyperpyramid
        ang_in = 1;
        for in2 = 1: param_udct.dim-1
            ln = length(Mang{res}{in1,in2});
            tmp2 = [1:ln].';
            
            if in2==1
                ang_in = tmp2;
            else
                ln2 = ln*length(ang_in);
                tmp3 = kron(ang_in, ones(ln,1) );
                tmp4 = kron(ones(size(ang_in,1),1), tmp2);
                ang_in = [tmp3, tmp4];
            end
        end
        lent = size(ang_in,1);
        ang_inmax = param_udct.cfg(res, Mdir{res}(in1,:));
        % lent is the smallest number of windows need to calculated on each
        % pyramid
        % ang_inmax is M-1 vector contain number of angle function per each
        % dimension of the hyperpyramid
        
        ang_ind = 0;
        ind = 1;
        for in3 = 1:lent
            % for each calculated windows function, estimated all the other
            % flipped window functions
            afun = ones(param_udct.size);
            afunin = 1;
            for in4 = 1:param_udct.dim-1
                afun2 = angle_kron( Mang{res}{in1,in4}{ang_in(in3,in4)}, ...
                    Mang_in{res}{in1,in4}, param_udct);
                afun = afun.*afun2;
            end
            clear ang_in2 aafun;
            afun = afun.*F2d{res+1};
            afun = sqrt(circshift(afun, param_udct.size/4) );
            % first windows function
            
            aafun{afunin} = afun;
            % index of current angle
            ang_in2 = ang_in(in3, :);
            
            % all possible flip along different dimension
            for in5 = param_udct.dim-1:-1:1
                lentmp = size(ang_in2,1);
                for in6 = 1:lentmp;
                    if (2*ang_in2(in6,in5) <= ang_inmax(in5))
                        ang_in2tmp = ang_in2(in6, :);
                        ang_in2tmp(1,in5) = ang_inmax(in5)+1-ang_in2(in6,in5);
                        ang_in2 = [ang_in2; ang_in2tmp];
                        aafun{end + 1} = fftflip(aafun{in6}, Mdir{res}(in1,in5) );
                    end
                end
            end
            %    Mwin{tmp(in3,:)} = afun;
            % subband(ang)
            
            if ang_ind == 0
                ang_ind = ang_in2;
                subband{in1} = aafun;
                for in7 = 1:size(ang_ind,1)
                    % convert to sparse format
                    udctwin{res+1}{in1}{in7} = [find(aafun{in7}>param_udct.winthresh), ...
                        aafun{in7}(find(aafun{in7}>param_udct.winthresh))];
                end
            else
                %
                inold = size(ang_ind,1);
                ang_ind = [ang_ind; ang_in2];
                innew = size(ang_ind,1);
                subband{in1}(inold+1:innew) = aafun;
                %
                for in7 = inold+1:innew
                    % convert to sparse format
                    in8 = in7 - inold;
                    udctwin{res+1}{in1}{in7} = [find(aafun{in8}>param_udct.winthresh), ...
                        aafun{in8}(find(aafun{in8}>param_udct.winthresh))];
                    
                end
                param_udct.ind{res+1}{in1} = ang_ind;
            end
        end
    end
end


% sumw = Winlow.^2;
% for dir = 1: param_udct.dim
%     for ang = 1:length(subband{dir})
%         tmpw = subband{dir}{ang};
%         sumw = sumw + tmpw.^2;
%         tmpw = fftflip(tmpw, dir);
%         sumw = sumw + tmpw.^2;
%     end
% end

sumw2 = zeros(param_udct.size);
sumw2(udctwin{1}{1}(:,1)) = udctwin{1}{1}(:,2).^2;
for res = 1:param_udct.res
    for dir = 1: param_udct.dim
        for ang = 1:length(udctwin{res+1}{dir})
            tmpw = zeros(param_udct.size);
            tmpw(udctwin{res+1}{dir}{ang}(:,1)) = udctwin{res+1}{dir}{ang}(:,2).^2;
            sumw2 = sumw2 + tmpw;
            tmpw = fftflip(tmpw, dir);
            sumw2 = sumw2 + tmpw;
        end
    end
end

sumw2 = sqrt(sumw2);
udctwin{1}{1}(:,2) = udctwin{1}{1}(:,2)./sumw2(udctwin{1}{1}(:,1));
for res = 1:param_udct.res
    for dir = 1: param_udct.dim
        for ang = 1:length(udctwin{res+1}{dir})
            udctwin{res+1}{dir}{ang}(:,2) = udctwin{res+1}{dir}{ang}(:,2)./ ...
                sumw2(udctwin{res+1}{dir}{ang}(:,1));
        end
    end
end
%
% sumw = sqrt(sumw);
% Winlow = Winlow./sumw;
% for dir = 1: param_udct.dim
%     for ang = 1:length(subband{dir})
%         subband{dir}{ang} = subband{dir}{ang}./sumw;
%     end
% end
% decim = 2 * ones(param_udct.dim, param_udct.dim);

% decimation ratio for each band
for res = 1:param_udct.res
    param_udct.dec{res} = 2^(param_udct.res-res+1)*ones(param_udct.dim, param_udct.dim);
    for ind = 1: param_udct.dim
        param_udct.dec{res}(ind, Mdir{res}(ind,:)) = 2^(param_udct.res-res)* ...
            2*param_udct.cfg(res,Mdir{res}(ind,:))/3;
    end
end

param_udct.len_r = param_udct.len/2^((param_udct.res-1)*param_udct.dim);
for res = 1:param_udct.res
    for ind = 1: param_udct.dim
        param_udct.len_r = param_udct.len_r + ...
            length(udctwin{res+1}{ind})*2*param_udct.len/prod(param_udct.dec{res}(ind,:));
    end
end


% sort the window 
for res = 2:param_udct.res+1
    for pyr = 1:param_udct.dim
        % take out the angle index list
        list = param_udct.ind{res}{pyr};
        % map it to a number
        mult = 1;
        nlist = zeros(size(list,1), 1);
        for d = size(list,2):-1:1
            for b = 1:size(list,1)
                nlist(b) = nlist(b) + mult*list(b,d);
            end
            mult = mult*100;
        end
        [b, ix] = sort(nlist);
        for b = 1:size(list,1)
            newind(b,:) = list(ix(b),:);
            newwin{b} = udctwin{res}{pyr}{ix(b)};
        end
        param_udct.ind{res}{pyr} = newind;
        udctwin{res}{pyr} = newwin;
    end
end
