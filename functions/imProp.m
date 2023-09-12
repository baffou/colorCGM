function [T, Ph]=imProp(field,pxSize,lambda,zFocus, n)
% function that propagates a scalar E field over a distance z
arguments
    field
    pxSize    % pixel size [m]
    lambda    % wavelength
    zFocus         % defocus

    n = 1 % refractive index of the propagation medium
end

[Ny,Nx]=size(field);
Ffield=fftshift(fft2(field));

%L=2*pi/(2*G.N*G.pxSize);

[xx,yy]=meshgrid(-Nx/2:Nx/2-1,-Ny/2:Ny/2-1);

kx=xx*2*pi/(Nx*pxSize);
ky=yy*2*pi/(Ny*pxSize);

k0=2*n*pi/lambda;
kz=real(sqrt(k0^2-kx.^2-ky.^2));
        % real part, otherwise, if one spans over kx values that exceed k0,
        % it yields complex values of kz. When defocusing in one direction,
        % it is not a problem because it gives evanescent waves, but when
        % defocusing in the other direction, it yields divergences,
        % even if the image Fimage has no information in this frequency range.

Prop=exp(1i*kz*zFocus);
Ffieldz=Ffield.*Prop;
field2=ifft2(ifftshift(Ffieldz));
T = abs(field2).^2;
Ph = Unwrap_TIE_DCT_Iter(angle(field2));
