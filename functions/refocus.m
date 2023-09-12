function [Tout, OPDout] = refocus(T, OPD, zFocus, pxSize, lambda, n)
% numerical propagation over the distance z
arguments
    T % Intensity image
    OPD % OPD image
    zFocus % defocus [m]
    pxSize % pixel size at the sample plane [m]
    lambda % wavelength [m]
    n % refractive index of the propagation medium
end

field = sqrt(T).*exp(1i*2*pi/lambda*OPD);
[Tout, Phout] = imProp(field,pxSize,lambda,zFocus,n);
OPDout = Phout*lambda/(2*pi);

end

