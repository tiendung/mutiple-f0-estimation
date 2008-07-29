function y=FilterBank(f,b,sig)
% y=FilterBank(f,b,sig)
%
% This function filters the waveform x with the array of filters
% specified by the forward and feedback parameters.  Each row
% of the forward and feedback parameters are the parameters
% to the Matlab builtin function "filter". This function is
% used with the conventional implementation of gammatone filterbank.
%
% This file is a part of HUTear- Matlab toolbox for auditory
% modeling. The toolbox is available at 
% http://www.acoustics.hut.fi/software/HUTear/

% Copyrights: Aki Härmä, Helsinki University of Technology, 
% Laboratory of Acoustics and Audio Signal Processing, 
% Espoo, Finland.
% Date: August 20 1999
% Email: Aki.Harma@hut.fi

[rows, cols]=size(f);
y=zeros(length(sig),rows);
for i=1:rows,
 y(:,i)=filter(f(i,:),b(i,:),sig); 
end
