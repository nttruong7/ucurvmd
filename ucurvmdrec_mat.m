function [x] = ucurvmdrec_mat(c)
% the matrix function of the ucurvmdrec subroutine
% this function can be turned to handle to provide for optimization solver
% for this function to run, there must be two global variables param_udct 
% and udctwin.
global param_udct udctwin;
coeff = vec2ucurv_r(c, param_udct.mark);
xx = ucurvmdrec(coeff, param_udct, udctwin);
x = xx(:);


