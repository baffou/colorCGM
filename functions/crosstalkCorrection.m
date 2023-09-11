function [imR, imG] = crosstalkCorrection(imR0, imG0)

betag = 0.204;
betar = 0.457;

imR = (1+betar)*imR0 -     betag*imG0;
imG =   - betar*imR0+ (1+betag)*imG0;

end