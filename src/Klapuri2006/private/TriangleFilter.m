function Hb = TriangleFilter(first, center, last, halfK)
% Hb = TriangleFilter(first, center, last, halfK)
% -------------------------------------------------------------------------
% DESCRIPTION
% -------------------------------------------------------------------------
% create triangle filter in frequency domain
% INPUT
%   first: first bin (lower left tip of triangle)
%   center: center bin
%   last: last bin  (lower right)
%   halfK: half number of samples in a frame
% -------------------------------------------------------------------------
% written by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006/10/09
% -------------------------------------------------------------------------
Hb = zeros(1, halfK);
Hb(first:center) = linspace(0, 1, center - first + 1);
Hb(center:last) = fliplr(linspace(0, 1, last - center + 1));