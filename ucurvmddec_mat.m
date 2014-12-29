function [c] = ucurvmddec_mat(x)
% the matrix function of the ucurvmddec subroutine
% this function can be turned to handle to provide for optimization solver
% for this function to run, there must be two global variables param_udct 
% and udctwin.
global param_udct udctwin;
xx = reshape(x,param_udct.size);
coeff = ucurvmddec(xx, param_udct, udctwin);
[c, mark] = ucurv2vec_r(coeff);
param_udct.mark = mark;

