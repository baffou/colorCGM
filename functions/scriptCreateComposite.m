function imagedual(OPD,fluo)% Les deux images sources qui servent à construire la composite
imOPD = QLSI.OPD;
imFLUO = QLSI_FLUO.T;

%Filtre HP
sigmaHP = 40;
imOPD = applyLimitsToImage(imOPD,[-40 120]*1e-9); % Treshold pour rendre le filtre plus efficace
imOPD_hp = imOPD - imgaussfilt(imOPD,sigmaHP);
%Rescaling
hp_clim = [-3 12]*1e-9; 
imOPD_hp = applyLimitsToImage(imOPD_hp,hp_clim); % Globalement correspond à réhaussé le contraste, exactement pareil que sur ImageJ
    
%Rescaling
fluo_clim = [0 18.5];
imFLUO = applyLimitsToImage(imFLUO,fluo_clim);

% Create the RGB composite
colormapOPD = (gray(256));
colormapFLUO = zeros(256,3);
colormapFLUO(:,2) = linspace(0,1,256);

RGB_composite = composite_inversed(imOPD_hp,imFLUO, colormapOPD, colormapFLUO);

figure,
imagebm(RGB_composite)

function im = applyLimitsToImage(im,lim)
    idx = im < lim(1);
    im(idx) = lim(1);
    idx = im > lim(2);
    im(idx) = lim(2);
end

function RGB_composite = composite_inversed(IM1, IM2, LUT1, LUT2)
RGB_composite = uint8(zeros(size(IM1,1), size(IM1,2), 3));
IM1 = uint8(255*normalisationImage(IM1));
IM2 = uint8(255*normalisationImage(IM2));
for x = 1:size(RGB_composite,1)
    for y = 1:size(RGB_composite,2)
            RGB1 = uint8(LUT1(IM1(x,y)+1,:) * 255);
            RGB2 = uint8(LUT2(IM2(x,y)+1,:) * 255);

            color = 255 - (RGB1 + RGB2);
            color = [color(2) color(1) color(2)];

            RGB_composite(x,y,:) = color;
    end
end


end

end