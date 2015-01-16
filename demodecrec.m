
close all; clear all;
fprintf(['%% ', repmat('-',1,78), '\n']);
fprintf('%%  Demo forward inverse UDCT transform in 2 dimensions      \n');
fprintf(['%% ', repmat('-',1,78), '\n']);
param_udct.dim = 2;
param_udct.size = [256 256];
param_udct.len = prod( param_udct.size );
param_udct.cfg = [3 3;6 6;12 6];
param_udct.res = size(param_udct.cfg,1);
param_udct.alpha = 0.15;
param_udct.r = pi*[1/3 2/3 2/3 4/3];
param_udct.decim = [param_udct.cfg/3]*2;
param_udct.winthresh = 10^(-5);

[udctwin, param_udct] = udctmdwin(param_udct)

% im = rand(param_udct.size);
im = mkZonePlate(param_udct.size);

coeff = udctmddec(im, param_udct, udctwin)

showudct(coeff);

im2 = udctmdrec(coeff, param_udct, udctwin);

max(abs(im(:)-im2(:)))
% snr(im,im2)

fprintf(['%% ', repmat('-',1,78), '\n']);
fprintf('%%  Continue with UDCT forward/inverse in 3 dimensions ?     \n');
fprintf(['%% ', repmat('-',1,78), '\n']);

pause;

%%
close all; clear all;

fprintf(['%% ', repmat('-',1,78), '\n']);
fprintf('%%  Demo forward inverse UDCT transform in 3 dimensions      \n');
fprintf(['%% ', repmat('-',1,78), '\n']);

param_udct.dim = 3;
param_udct.size = 4*[32 32 32];
param_udct.len = prod( param_udct.size );
param_udct.cfg = [3 3 3;6 6 6];
param_udct.res = size(param_udct.cfg,1);
param_udct.alpha = 0.15;
param_udct.r = pi*[1/3 2/3 2/3 4/3];
param_udct.decim = [param_udct.cfg/3]*2;
param_udct.winthresh = 10^(-5);


[udctwin, param_udct] = udctmdwin(param_udct);

im = rand(param_udct.size);

coeff = udctmddec(im, param_udct, udctwin)

im2 = udctmdrec(coeff, param_udct, udctwin);

max(abs(im(:)-im2(:)))

fprintf(['%% ', repmat('-',1,78), '\n']);
fprintf('%%  Continue with UDCT forward/inverse in 4 dimensions ?     \n');
fprintf(['%% ', repmat('-',1,78), '\n']);

pause;
%%
close all; clear all;

fprintf(['%% ', repmat('-',1,78), '\n']);
fprintf('%%  Demo forward inverse UDCT transform in 4 dimensions      \n');
fprintf(['%% ', repmat('-',1,78), '\n']);

param_udct.dim = 4;
param_udct.size = [32 32 32 32];
param_udct.len = prod( param_udct.size );
param_udct.cfg = [3 3 3 3;6 6 6 6];
param_udct.res = size(param_udct.cfg,1);
param_udct.alpha = 0.15;
param_udct.r = pi*[1/3 2/3 2/3 4/3];
param_udct.decim = [param_udct.cfg/3]*2;
param_udct.winthresh = 10^(-5);

[udctwin, param_udct] = udctmdwin(param_udct);

im = rand(param_udct.size);

coeff = udctmddec(im, param_udct, udctwin)

im2 = udctmdrec(coeff, param_udct, udctwin);

max(abs(im(:)-im2(:)))

fprintf(['%% ', repmat('-',1,78), '\n']);
fprintf('%%  Continue with UDCT forward/inverse in 5 dimensions ?     \n');
fprintf(['%% ', repmat('-',1,78), '\n']);

pause;
%%
close all; clear all;
fprintf(['%% ', repmat('-',1,78), '\n']);
fprintf('%%  Demo forward inverse UDCT transform in 5 dimensions      \n');
fprintf('%%  Its going to take some times ...                         \n');
fprintf(['%% ', repmat('-',1,78), '\n']);

param_udct.dim = 5;
param_udct.size = [32 32 32 32];
param_udct.len = prod( param_udct.size );
param_udct.cfg = [3 3 3 3 3];
param_udct.res = size(param_udct.cfg,1);
param_udct.alpha = 0.15;
param_udct.r = pi*[1/3 2/3 2/3 4/3];
param_udct.decim = [param_udct.cfg/3]*2;
param_udct.winthresh = 10^(-5);


[udctwin, param_udct] = udctmdwin(param_udct);

im = rand(param_udct.size);

coeff = udctmddec(im, param_udct, udctwin)

im2 = udctmdrec(coeff, param_udct, udctwin);

max(abs(im(:)-im2(:)))

fprintf(['%% ', repmat('-',1,78), '\n']);
fprintf('%%  Normally 6 dimension is not possible in PC               \n');
fprintf(['%% ', repmat('-',1,78), '\n']);

