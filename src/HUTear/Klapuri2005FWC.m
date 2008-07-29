function B = Klapuri2005FWC(rA, model)
% B = Klapuri2005FWC(rA, model)
% -------------------------------------------------------------------------
% Do Full Wave Compression (FWC) for narrow bank by simply scaling in
% Klapuri, "A Perceptually motivated Multiple-F0 Estimation Method", 2005
% -------------------------------------------------------------------------
% INPUT
%   rA: channel signals after rectification
%   model: auditory model (need number of channels .nch information)
% OUTPUT
%   B: channel signals after FWC
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006-10-08

c = 0.33 - 1;
    B = zeros(size(rA));
    for i = 1 : model.cochlea.gt.nch
        s = std(rA(:, i));
        s = s^c;
        B(:, i) = rA(:, i)*s;
    end
end