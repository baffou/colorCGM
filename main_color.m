% Example file that processes a 2-color CGM interferogram into
% - 1 OPD image,
% - 1 fluo image and
% - 1 intensity image.

addpath(genpath(pwd))
addpath(genpath('../CGMprocess'))  % add the main repo. https://github.com/baffou/CGMprocess
clear

%% experimental parameters
Gamma = 39e-6;  % period of the cross-grating (grexel size) [m]
d = 0.91e-3;     % grating-camera distance [m]
p = 5.5e-6;     % camera pixel size (dexel size) [m]
Z = 1.1931;          % zoom of the relay lens (if any)

%% import the images
Itf = double(imread('data/ITFcolor_COS7.tiff'));
Ref = double(imread('data/REFcolor_COS7.tiff'));

ItfG0 = colorInterpolation(Itf,'g');
ItfR0 = colorInterpolation(Itf,'r');
RefG0 = colorInterpolation(Ref,'g');
RefR0 = colorInterpolation(Ref,'r');

[ItfR, ItfG] = crosstalkCorrection(ItfR0,ItfG0);
[RefR, RefG] = crosstalkCorrection(RefR0,RefG0);

[OPD, ~, ~, ~, crops] = CGMprocess(ItfR, RefR,'Gamma',Gamma, ...
                                'distance',d,'dxSize',p,'zoom',Z, ...
                                 'method','accurate');
[~, T] = CGMprocess(ItfG, RefG,'Gamma',Gamma, ...
                                'distance',d,'dxSize',p,'zoom',Z, ...
                                 'method','accurate','crops',crops,'Tnormalisation','subtraction');

%% Plot the results

figure
ax1 = subplot(1,2,1);
imagesc(T)
set(gca,'DataAspectRatio',[1,1,1])
colorbar
title('fluorescence')
ax2 = subplot(1,2,2);
imagesc(OPD)
set(gca,'DataAspectRatio',[1,1,1])
colorbar
%clim([-4 1]*1e-9)
title('OPD')
linkaxes([ax1,ax2])
zoom on
















