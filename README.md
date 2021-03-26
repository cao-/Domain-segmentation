# Domain-segmentation


This is a MATLAB implementation of the domain segmentation algorithm described in my thesis work, which is available at https://github.com/cao-/Tesi-Magistrale.

The `Test.m` script gives an example of usage for the function `domain_segmentation.m`.

The parameters of this function are

`X` -> the set of data sites

`Z` -> the set of data values

`rf` -> the positive definite radial function to use

`b` -> the global shape parameter for the radial funcion

`k` -> the number of local points to consider

`tol` -> the tolerance for the classification

The test functions `h1`, `h2`, `h3`, `h4`, `h5` are the same used in the thesis.  



The `Reconstruction.m` script, if executed after the `Test.m` script, allows to actually recover the sampled functions by using Support Vector Machines (SVM) and Radial Basis Functions (RBF) interpolation.
The parameters for the SVM can be set inside the function `classificating_function.m`.  
Interpolation is performed globally on each subdomain by the function `interpolate.m`.  This function may be replaced by some partition of unity interpolation method for better performance.


The implementation of the multiclass SVM that is described in the thesis may produce bad results when the discontinuity curves of the function have intersections---a better strategy for multiclass SVM should be implemented.
