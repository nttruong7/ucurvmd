function [x] = udctmdrec_mat(c)
% the matrix function of the udctmdrec subroutine
% this function can be turned to handle to provide for optimization solver
% for this function to run, there must be two global variables param_udct 
% and udctwin.
global param_udct udctwin;
coeff = vec2udct_r(c, param_udct.mark);
xx = udctmdrec(coeff, param_udct, udctwin);
x = xx(:);


