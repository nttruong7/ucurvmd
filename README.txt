UCURV toolbox version 2.0 

Implementation of the Uniform Discrete Curvelet Transform for any dimension.
The toolbox can run curvelet transform in 2,3,4,5 and more dimension, as long
as the data can be held in MATLAB memory. There are three main subroutines,
ucurvmdwin calculates all the curvelet windows for a particular transform
parameters, ucurvmddec and ucurvmdre do the decomposition (forward transform)
and reconstruction (inverse transform). 

Demo
====

Files in the toolbox
====================
* Key files : Key subroutine for using UDCT

udctmdrec.m      
udctmddec.m       
udctmdwin.m

* Utilities for using UDCT : For using UDCT effectively

README.txt    
opUdct.m
vec2udct.m
udct2vec.m    
udct2vec_r.m          
vec2udct_r.m
showudct.m    
demodecrec.m  

* Internal utilities for UDCT : for use by the above two categories, should not be used elsewhere

adapt_grid.m  
coord2vec.m   
vec2coord.m
fun_meyer.m    
udctmddec_mat.m  
downsamp.m    
upsamp.m
angle_fun.m   
angle_kron.m  
udct_lev_image.m  
udctmdrec_mat.m  
fftflip.m                  

* External utilities : for use without UDCT

mkZonePlate.m 
mkR.m           
snr.m         

References
==========
Truong T. Nguyen and Hervé Chauris, ``The Uniform Discrete Curvelet Transform  ," IEEE Trans. Signal Processing


