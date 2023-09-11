% Example file that processes a 2-color CGM interferogram into
% - 1 OPD image,
% - 1 fluo image and
% - 1 intensity image.

addpath(genpath(pwd))
addpath(genpath('../CGMprocess'))  % add the main repo. https://github.com/baffou/CGMprocess
clear

%% experimental parameters
Gamma = 39e-6;  % period of the cross-grating (grexel size) [m]
d = 0.5e-3;     % grating-camera distance [m]
p = 6.5e-6;     % camera pixel size (dexel size) [m]
Z = 1;          % zoom of the relay lens (if any)

%% import the images
Itf = readmatrix('../CGMprocess/data/NPs/interferogram.txt');
Ref = readmatrix('../CGMprocess/data/NPs/interferogram_ref.txt');

[OPD, T, DWx, DWy] = CGMprocess(Itf, Ref,'Gamma',Gamma,'distance',d,'dxSize',p,'zoom',Z);




%% Plot the results
figure
ax1=subplot(2,2,1);
imagesc(Itf)
set(gca,'DataAspectRatio',[1,1,1])
colorbar
title('interferogram')
ax2=subplot(2,2,2);
imagesc(OPD)
set(gca,'DataAspectRatio',[1,1,1])
colorbar
clim([-4 1]*1e-9)
title('OPD')
ax3=subplot(2,2,3);
imagesc(DWx)
set(gca,'DataAspectRatio',[1,1,1])
colorbar
colormap(gca,'Gray')
title('OPD gradient along x')
ax4=subplot(2,2,4);
imagesc(DWy)
set(gca,'DataAspectRatio',[1,1,1])
colorbar
colormap(gca,'Gray')
title('OPD gradient along y')
linkaxes([ax1,ax2,ax3,ax4])
zoom on











