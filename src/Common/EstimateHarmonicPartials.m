function UD = EstimateHarmonicPartials(U, ha, config)
% calculate harmonic partial spectrum for substraction step
% Klapuri PhD Thesis, page 62

haNum = length(ha);
halfK = length(U);
UD = zeros(size(U));
d = config.surroundHarmonicBins;
for j = 1 : haNum
    pos = ha(j).pos;
    X = HarmonicSpecShape(ha(j).amp, d, config.windowSpec);
    low = max(1, pos-d);
    up = min(halfK, pos+d);
    UD(low:up) = X(low-pos+d+1 : up-pos+d+1);
end
