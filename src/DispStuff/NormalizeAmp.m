function y = NormalizeAmp(x, maxAmp)
y = Amp2Log(x);
if exist('maxAmp','var')
    tmp = maxAmp/max(y);
    y = y.*tmp;
end
