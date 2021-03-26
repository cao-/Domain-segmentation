%-------------------------------------------------------------------------%
%
% Input:  kernel: RBF type
%
% Output:  phi:    RBF
%
% Last update: 10/3/20
%
%-------------------------------------------------------------------------%
function [phi] = RBFtype(kernel)

switch lower(kernel)
    case 'gauss'
        phi = @(e, r) exp(-(e*r).^2);
    case 'imq'
        phi = @(e, r) 1./sqrt(1+(e*r).^2);
    case 'mq'
        phi = @(e, r) sqrt(1+(e*r).^2);
    case 'mat_c6'
        phi = @(e, r) exp(-(e*r)).*(15+15*e*r+6*(e*r).^2+(e*r).^3);  
    case 'mat_c4'
        phi = @(e, r) exp(-(e*r)).*(3+3*e*r+(e*r).^2);
    case 'mat_c2'
        phi = @(ep, r) exp(-(ep*r)).*(1+(ep*r));
    case 'mat_c0'
        phi = @(ep, r) exp(-(ep*r));
    case 'wen_c6'
        phi = @(ep, r) (max(1-(ep*r),0).^8).*(32*(ep*r).^3+...
            25*(ep*r).^2+8*ep*r+1);
    case 'wen_c4'
        phi = @(ep, r) (max(1-(ep*r),0).^6).*(35*(ep*r).^2+...
            18*(ep*r)+3)/3;
    case 'wen_c2'
        phi = @(ep, r) (max(1-(ep*r),0).^4).*(4*(ep*r)+1);
    case 'wen_c0'
        phi = @(ep, r) max(1-(ep*r),0).^2;
    otherwise
        error('Kernel not found: check the input string')
end
end