function displayIm = showudct(y, percentile)
% SHOWPDFB   Show PDFB coefficients. 
%
%       showpdfb(y, [scaleMode, displayMode, ...
%                    lowratio, highratio, coefMode, subbandgap])
%
% Input:
%	y:	a cell vector of length n+1, one for each layer of 
%		subband images from DFB, y{1} is the lowpass image
%
%   scaleMode: 
%       scale mode (a string or number):
%           If it is a number, it denotes the number of most significant 
%           coefficients to be displayed.  Its default value is 'auto2'.
%           'auto1' ---   All the layers use one scale. It reflects the real 
%                         values of the coefficients.
%                         However, the visibility will be very poor.
%           'auto2' ---   Lowpass uses the first scale. All the highpass use 
%                         the second scale.
%           'auto3' ---   Lowpass uses the first scale. 
%                         All the wavelet highpass use the second scale.
%                         All the contourlet highpass use the third scale.
%   displayMode: 
%       display mode (a string): 
%           'matlab' --- display in Matlab environment. 
%                        It uses the background color for the marginal
%                        image.
%           'others' --- display in other environment or for print.
%                        It used the white color the marginal image. 
%                        It is the default value.
%   lowratio:
%       display ratio for the lowpass filter (default value is 2).
%       It ranges from 1.2 to 4.0.
%   highratio:
%       display ratio for the highpass filter (default value is 6).
%       It ranges from 1.5 to 10.
%  coefMode: 
%       coefficients mode (a string): 
%           'real' ----  Highpass filters use the real coefficients. 
%           'abs' ------ Highpass filters use the absolute coefficients. 
%                        It is the default value
%   subbandgap:	
%       gap (in pixels) between subbands. It ranges from 1 to 4.
%
% Output:
%	displayIm: matrix for the display image.
%   
% See also:     PDFBDEC, DFBIMAGE, COMPUTESCALE

% History:
%   09/17/2003  Creation.
%   09/18/2003  Add two display mode, denoted by 'displayMode'.
%               Add two coefficients mode, denoted by 'coeffMode'.
%   10/03/2003  Add the option for the lowpass wavelet decomposition.
%   10/04/2003  Add a function computescale in computescales.m. 
%               This function will call it.
%               Add two scal modes, denoted by 'scaleMode'. 
%               It can also display the most significant coefficients.
%   10/05/2003  Add 'axis image' to control resizing.
%               Use the two-fold searching method to find the 
%               background color index.

%   Truong
%  03/10/2004  Adding code to handle nuDFB

% Gap between subbands
if exist('percentile', 'var')
    [yind, mark] = udct2vec(y);
    n = ceil(length(yind)*percentile/100);
    ytmp = sort(abs(yind),'descend');
    thr = ytmp(n);
    ytmp = yind*0;
    ytmp(abs(yind) > thr) = 1;
    y = vec2udct(ytmp,mark);
end

% Input structure analysis. 
nLayers = length(y); %number of PDFB layers
% Compute the number of wavelets layers.
% We assume that the wavelets layers are first several consecutive layers.
% The number of the subbands of each layer is 3.
% 

% Merge all layers to corresponding display layers.
% Prepare the cellLayers, including the boundary.
% Need to polish with real boudary later!
% Now we add the boundary, but erase the images!!
% First handle the lowpass filter
% White line around subbands

z = cell(1, nLayers);
z{1} = y{1};
nWidth = size(y{1}{1},2);
nHeight = size(y{1}{1},1);

% All the contourlet layers
for i = 2 : nLayers
    z{i} = udct_lev_image(y{i},1);
    nWidth = nWidth + size(z{i}, 2);
    nHeight = max(nHeight, size(z{i}, 1));
end

% Prepare for the display
colormap(gray);
cmap = get(gcf,'Colormap');
cColorInx = size(cmap,1);

dBgColor = get( gcf, 'Color' ) ;

% Search the color index by 2-fold searching method.
% This method is only useful for the gray color!
nSmall = 1 ;
nBig = cColorInx ;
while nBig > nSmall + 1
    nBgColor = floor ((nSmall + nBig) / 2) ;
    if dBgColor(1) < cmap (nBgColor, 1)
        nBig = nBgColor ;
    else
        nSmall = nBgColor ;
    end
end;
if abs( dBgColor(1) - cmap (nBig, 1) ) > abs ( dBgColor(1) - cmap( nSmall, 1) )
    nBgColor = nSmall ;
else
    nBgColor = nBig ;
end

displayIm = zeros( nHeight, nWidth);

z{1} = y{1}{1};
z{1}(end,:) = z{2}(end,1);
nPos = 0; mPos = 0;

for i = 1 : nLayers
    [h, w] = size( z{i} );
    displayIm( nPos+1: nPos+h, mPos+1: mPos+w) = abs(z{i})./max(abs(z{i}(:)));
    mPos = mPos+w;
end

% for i = 1 : nLayers
%     [h, w] = size( z{i} );
%     displayIm( nPos+1: nPos+h, mPos+1: mPos+w) = abs(z{i})./max(abs(z{i}(:)));
%     mPos = mPos+w;
% end

hh = imagesc( displayIm );
% title('decompostion image');
axis image off;