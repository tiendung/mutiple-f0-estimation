function X = HarmonicSpecShape(amp, d, windowSpec)
% function X = HarmonicSpec(amp, d, windowSpec)
% -------------------------------------------------------------------------
% DESCRIPTION
% -------------------------------------------------------------------------
% Estimate the shape of surround bin spectrum magnitude of harmonic
% INPUT
% amp: amplitude of harmonic
% d: number of surround bins
% windowSpec: magnitude spectrum of the window
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006/10/06
% -------------------------------------------------------------------------
    X = [flipud(windowSpec(1:d+1)); windowSpec(2:d+1)];
    maxAmp = max(X);
    X = X.*(amp/maxAmp);
end