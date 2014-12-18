function im = ucurv_lev_image(y, gap, gridI)
% DFBIMAGE    Produce an image from the result subbands of DFB
%
%	im = dfbimage(y, [gap, gridI])
%
% Input:
%	y:	output from DFBDEC
%	gap:	gap (in pixels) between subbands
%	gridI:	intensity of the grid that fills in the gap
%
% Output:
%	im:	an image with all DFB subbands
%
% The subband images are positioned as follows 
% (for the cases of 4 and 8 subbands):
%
%     0   1              0   1
%              and       2   3  and 
%     2   3            4 5 6 7

% Gap between subbands
if ~exist('gap', 'var')
    gap = 0;    
end


% Intensity of the grid (default is white)
if ~exist('gridI', 'var')
    gridI = 0;
    for r = 1:2
        l = length(y{r});
        
        for k = 1:l
            m = max(abs(y{r}{k}(:)));
            % m = Inf;
            
            if m > gridI
                gridI = m;
            end
        end
    end
    
    % gridI = gridI * 1.1;		% add extra 10% of intensity
end

% Add grid seperation if required
if gap > 0
    for r = 1:2
        l = length(y{r});
        
        for k = 1:l
            y{r}{k}(1:gap,:) = gridI;
            y{r}{k}(:,1:gap) = gridI;
        end
    end
end

With = 3;

% Assume that the first subband has "horizontal" shape
[m, n] = size(y{1}{1});

% The image
im1 = zeros(m, length(y{1})*n);

% First half of subband images ("horizontal" ones)
for k = 1:length(y{1})
        im1(1:m,(k-1)*n+1:k*n) = [y{1}{k}];
end

% Second half of subband images ("vertical" ones)

% The size of each of those subband        
% The image 2
[p, q] = size(y{2}{1});
im2 = im1*0.;
npc = length(y{2})/3;
for k = 1:length(y{2})
    cl = floor((k-1)/npc)+1;
    ro = k - (cl-1)*npc;
    im2((ro-1)*p+1:ro*p, (cl-1)*q+1:cl*q) = y{2}{k};
end

im = [im1;im2];
im(end,:) = gridI;
% Finally, grid line in bottom and left
% if gap > 0
%     im(end-gap+1:end, :) = gridI;
%     im(:, end-gap+1:end) = gridI;
% end
