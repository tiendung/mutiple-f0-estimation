function bw=ERB(fc)
%
%   bw=ERB(fc)
%
% Equivalent Rectangular Bandwidth (Moore&Glasberg, 1990)
% as a function of center frequency. 
%
% This file is a part of HUTear- Matlab toolbox for auditory
% modeling. The toolbox is available at 
% http://www.acoustics.hut.fi/software/HUTear/

% Copyrights: Aki Härmä, Helsinki University of Technology, 
% Laboratory of Acoustics and Audio Signal Processing, 
% Espoo, Finland.
% Date: August 20 1999
% Email: Aki.Harma@hut.fi

fc=fc(:);

% Bandwidths have not been measured below 100 Hz.
% Here, bandwidth is assumed to be constant below that.
%  
l=find(fc<100);
fc(l)=ones(length(l),1)*100;

bw=24.7+0.108*fc;

