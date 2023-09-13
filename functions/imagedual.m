function mixedImage = imagedual(OPD, Fluo, opt)
arguments
    OPD
    Fluo
    opt.minOPD  (1,1) double = -20
    opt.maxOPD  (1,1) double = 200
    opt.minFluo (1,1) double = 0
    opt.maxFluo (1,1) double = max(Fluo(:))
    opt.sigmaHP = 40   % HP filter for the OPD image
end


% OPD: OPD image
% fluo: fluorescence image

if sum(size(OPD)~=size(Fluo)) % if the two images do not have the same size
    error('the two inputs must have the same size')
end


if abs(opt.minOPD) > 1e-2 % value entered in nm instead of m
    opt.minOPD = opt.minOPD*1e-9;
end
if abs(opt.maxOPD) > 1e-2 % value entered in nm instead of m
    opt.maxOPD = opt.maxOPD*1e-9;
end


%Filtre HP
%OPD = applyLimitsToImage(OPD,[opt.minOPD opt.maxOPD]); % Threshold to make the filter more efficient
imOPD_hp = OPD - imgaussfilt(OPD,opt.sigmaHP);
%Rescaling
hp_clim = [opt.minOPD opt.maxOPD];
imOPD_hp = applyLimitsToImage(imOPD_hp,hp_clim); % Enhances the contrast

%Rescaling
fluo_clim = [opt.minFluo opt.maxFluo];
Fluo = applyLimitsToImage(Fluo,fluo_clim);

% Create the RGB mixed image
colormapOPD = (gray(256));
colormapFLUO = zeros(256,3);
colormapFLUO(:,2) = linspace(0,1,256);

RGB_composite = composite_inversed(imOPD_hp,Fluo, colormapOPD, colormapFLUO);

if nargout
    mixedImage = RGB_composite;
else

    figure,
    image(RGB_composite)
    axis image

end

    function im = applyLimitsToImage(im,lim)
        % leveling of the image with min and max values
        idx = im < lim(1);
        im(idx) = lim(1);
        idx = im > lim(2);
        im(idx) = lim(2);
    end

    function RGB_composite = composite_inversed(IM1, IM2, LUT1, LUT2)
        RGB_composite = uint8(zeros([size(IM1), 3]));
        IM1 = uint8(255*normalisationImage(IM1));
        IM2 = uint8(255*normalisationImage(IM2));
        
        RGB1 = uint8(LUT1(IM1+1,:) * 255);
        RGB2 = uint8(LUT2(IM2+1,:) * 255);

        color1 = 255 - (reshape(RGB1(:,1),size(IM1)) + reshape(RGB2(:,1),size(IM2)));
        color2 = 255 - (reshape(RGB1(:,2),size(IM1)) + reshape(RGB2(:,2),size(IM2)));
        
        RGB_composite(:,:,1) = color2;
        RGB_composite(:,:,2) = color1;
        RGB_composite(:,:,3) = color2;


    end

    function imn = normalisationImage(im)
        % makes the values of the image range from 0 to 1.
        im0 = im-min(im(:));
        imn = im0/max(im0(:));
    end

end