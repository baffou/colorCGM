function mixedImage = imagedual(OPD, Fluo, opt)
arguments
    OPD
    Fluo
    opt.minOPD  (1,1) double = -20
    opt.maxOPD  (1,1) double = 200
    opt.minFluo (1,1) double = 0
    opt.maxFluo (1,1) double = max(Fluo(:))
    opt.sigmaHP = 40   % HP filter for the OPD image
    opt.invLUT_OPD = false % invert the first lut
    opt.invLUT_Fluo = false % invert the second lut
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
colormapFLUO(:,2) = linspace(0,1,256)*0.5;

RGB_composite = composite_inversed(imOPD_hp,Fluo, colormapOPD, colormapFLUO, ...
    'min1',opt.minOPD,'max1', opt.maxOPD, ...
    'min2',opt.minFluo,'max2', opt.maxFluo, ...
    'inv1',opt.invLUT_OPD, ...
    'inv2',opt.invLUT_Fluo);

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



end

function RGB_composite = composite_inversed(IM1, IM2, LUT1, LUT2,opt)
    arguments
        IM1
        IM2
        LUT1
        LUT2
        opt.min1
        opt.max1
        opt.min2
        opt.max2
        opt.inv1 = false % invert the first lut
        opt.inv2 = false % invert the second lut
    end
    if opt.inv1
        LUT1 = flipud(LUT1);
    end
    if opt.inv2
        LUT2 = flipud(LUT2);
    end
    
    RGB_composite = uint8(zeros([size(IM1), 3]));
    IM1 = uint8(255*normalisationImage(IM1,min=opt.min1,max=opt.max1));
    IM2 = uint8(255*normalisationImage(IM2,min=opt.min2,max=opt.max2));
    
    RGB1 = uint8(LUT1(IM1+1,:) * 255);
    RGB2 = uint8(LUT2(IM2+1,:) * 255);

    color1 = 255 - (reshape(RGB1(:,1),size(IM1)) + reshape(RGB2(:,1),size(IM2)));
    color2 = 255 - (reshape(RGB1(:,2),size(IM1)) + reshape(RGB2(:,2),size(IM2)));
    
    RGB_composite(:,:,1) = color2;
    RGB_composite(:,:,2) = color1;
    RGB_composite(:,:,3) = color2;


end

function imn = normalisationImage(im,opt)
    arguments
        im
        opt.min = min(im(:))
        opt.max = max(im(:))
    end
    % makes the values of the image range from 0 to 1.
    imn = (im-opt.min)/opt.max;
end

