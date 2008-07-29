function [forward,feedback,cf,ERBwidth] = MakeERBFiltersB(fs,numChannels,cf,b)
% [forward,feedback,cf,ERBwidth]=MakeERBFiltersB(fs,numChannels,cf,b)
% computes the filter coefficients for a bank of Gammatone filters.  These
% filters were defined by Patterson and Holdworth for simulating 
% the cochlea.  The results are returned as arrays of filter
% coefficients.  Each row of the filter arrays (forward and feedback)
% can be passed to the MatLab "filter" function, or you can do all
% the filtering at once with the ERBFilterBank() function.
%
% The filter bank contains "numChannels" channels that extend from
% half the sampling rate (fs) to "lowFreq".
%
% Original by Malcolm Slaney
%
% Modified by Toshio Irino on 17 Jul 97
% Changed Name : MakeERBFilters.m -> MakeERBFilersB.m
% Changed Input: lowFreq -> cf  (to allow direct input of cf)
% Added Input  : b
% Added Output : cf, ERBwidth
% debug for length(numChannels) on 18 Nov. 97
% 
% This function was adopted to the HUTear with permission from 
% Malcolm Slaney and Toshio Irino. 
%
% This file is a part of HUTear- Matlab toolbox for auditory
% modeling. The toolbox is available at 
% http://www.acoustics.hut.fi/software/HUTear/

% Copyrights: Aki Härmä, Helsinki University of Technology, 
% Laboratory of Acoustics and Audio Signal Processing, 
% Espoo, Finland.
% Date: August 20 1999
% Email: Aki.Harma@hut.fi

T=1/fs;
% Change the following parameters if you wish to use a different
% ERB scale.
% EarQ = 9.26449;               %  Glasberg and Moore Parameters
EarQ = 1/0.107939;
minBW = 24.7;
order = 1;

if nargin < 4, b = 1.019; end; % default by Patterson and Holdworth 
if length(cf) == 1, 
  lowFreq = cf;  
  if length(numChannels) == 0, help MakeERBFiltersB
                               disp('Error: Define numChannels.');
  end;
else 
  lowFreq = []; 
end;

% All of the following expressions are derived in Apple TR #35, "An
% Efficient Implementation of the Patterson-Holdsworth Cochlear
% Filter Bank."

if length(lowFreq) > 0, % If lowFreq is defined.
  cf = -(EarQ*minBW)+exp((1:numChannels)'*(-log(fs/2 + EarQ*minBW) + ...
                         log(lowFreq + EarQ*minBW))/numChannels) ...
                          *(fs/2 + EarQ*minBW);
else           % If cf vector is given. numChannel and lowFreq are ignored.
  cf = cf(:);
end;

ERBwidth = ((cf/EarQ).^order + minBW^order).^(1/order);
B=b*2*pi*ERBwidth;
gain = abs((-2*exp(4*i*cf*pi*T)*T + ...
            2*exp(-(B*T) + 2*i*cf*pi*T).*T.* ...
	    (cos(2*cf*pi*T) - sqrt(3 - 2^(3/2))* ...
	    sin(2*cf*pi*T))) .* ...
           (-2*exp(4*i*cf*pi*T)*T + ...
             2*exp(-(B*T) + 2*i*cf*pi*T).*T.* ...
              (cos(2*cf*pi*T) + sqrt(3 - 2^(3/2)) * ...
               sin(2*cf*pi*T))).* ...
           (-2*exp(4*i*cf*pi*T)*T + ...
             2*exp(-(B*T) + 2*i*cf*pi*T).*T.* ...
              (cos(2*cf*pi*T) - ...
               sqrt(3 + 2^(3/2))*sin(2*cf*pi*T))) .* ...
           (-2*exp(4*i*cf*pi*T)*T+2*exp(-(B*T) + 2*i*cf*pi*T).*T.* ...
           (cos(2*cf*pi*T) + sqrt(3 + 2^(3/2))*sin(2*cf*pi*T))) ./ ...
          (-2 ./ exp(2*B*T) - 2*exp(4*i*cf*pi*T) +  ...
           2*(1 + exp(4*i*cf*pi*T))./exp(B*T)).^4);
feedback=zeros(length(cf),9);
forward=zeros(length(cf),5);
forward(:,1) = T^4 ./ gain;
forward(:,2) = -4*T^4*cos(2*cf*pi*T)./exp(B*T)./gain;
forward(:,3) = 6*T^4*cos(4*cf*pi*T)./exp(2*B*T)./gain;
forward(:,4) = -4*T^4*cos(6*cf*pi*T)./exp(3*B*T)./gain;
forward(:,5) = T^4*cos(8*cf*pi*T)./exp(4*B*T)./gain;
feedback(:,1) = ones(length(cf),1);
feedback(:,2) = -8*cos(2*cf*pi*T)./exp(B*T);
feedback(:,3) = 4*(4 + 3*cos(4*cf*pi*T))./exp(2*B*T);
feedback(:,4) = -8*(6*cos(2*cf*pi*T) + cos(6*cf*pi*T))./exp(3*B*T);
feedback(:,5) = 2*(18 + 16*cos(4*cf*pi*T) + cos(8*cf*pi*T))./exp(4*B*T);
feedback(:,6) = -8*(6*cos(2*cf*pi*T) + cos(6*cf*pi*T))./exp(5*B*T);
feedback(:,7) = 4*(4 + 3*cos(4*cf*pi*T))./exp(6*B*T);
feedback(:,8) = -8*cos(2*cf*pi*T)./exp(7*B*T);
feedback(:,9) = exp(-8*B*T);
