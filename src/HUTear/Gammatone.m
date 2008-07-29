function [A,CentFreqs]=Gammatone(sig,model)
% [A,CentFreqs]=Gammatone(sig,model)
%
% A generic function for gammatone design and filtering
%
% This file is a part of HUTear- Matlab toolbox for auditory
% modeling. The toolbox is available at 
% http://www.acoustics.hut.fi/software/HUTear/

% Copyrights: Aki Härmä, Helsinki University of Technology, 
% Laboratory of Acoustics and Audio Signal Processing, 
% Espoo, Finland.
% Date: August 20 1999
% Email: Aki.Harma@hut.fi

gt=model.cochlea.gt;
fs=model.fs;
ds=model.ds;

% Design a gammatone filterbank and filtering
if isfield(gt,'design'),
	  switch gt.design,
  case 'gammachirp',% Use Irino's package
    A=GC_filtering(sig,fs,model.gt.nch,gt.frange);
	CentFreqs=[];
  case 'gammatone', % Use Slaney's package
    [f, b, CentFreqs]=MakeERBFiltersB(fs,gt.nch,min(gt.frange)); % Design GTFs
    A=FilterBank(f,b,sig);
  case 'agammatone4',% Use complex-valued 4th order gammatones
    [f, b, CentFreqs]=Make_cgtbank(gt.nch,fs,min(gt.frange),4);
     A=cgtbank(f,b,sig);
  case 'agammatone6',% Use complex-valued 6th order gammatones
    [f, b, CentFreqs]=Make_cgtbank(gt.nch,fs,min(gt.frange),6); 
     A=cgtbank(f,b,sig);
  otherwise, disp('Gammatone filterbank was incorrectly specified!')  
  end
end
