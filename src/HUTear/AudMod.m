function [C, model]=AudMod(Sig,model)
%
% A=AudMod(sig,model)
%
% A generic auditory model 
%
% This file is a part of HUTear- Matlab toolbox for auditory
% modeling. The toolbox is available at 
% http://www.acoustics.hut.fi/software/HUTear/

% Copyrights: Aki Härmä, Helsinki University of Technology, 
% Laboratory of Acoustics and Audio Signal Processing, 
% Espoo, Finland.
% Date: August 20 1999
% Email: Aki.Harma@hut.fi

% -------------------------------------------------------------------------
% modified by Nguyen Tien Dung, g0505497@nus.edu.sg, 2006-10-08
% -------------------------------------------------------------------------
%1) return model variable to get full setting of Auditory Model
%2) change FWC and HWR order (FWC first, HWR second)
%3) support Full Wave Compression (FWC) for narrow bank  by simply scaling
% Klapuri, "A Perceptually motivated Multiple-F0 Estimation Method", 2005

if ~isstruct(model), eval(model); end

A=[];B=[];C=[];D=[];

% All signals are processed as column vectors
if min(size(Sig))==1, sig=Sig(:); else sig=Sig; end

%%%%%%%%%%%%%%% Outer and middle ear filtering %%%%%%%%%%%%%%%%%%%%%%%
if isfield(model,'outmid'),
   if isfield(model.outmid,'file'), eval(['load ' model.outmid.file]);
     if exist('lam'), sig=wfilter(a,b,sig,lam);else
       sig=filter(a,b,sig);
     end     
   end
   if isfield(model.outmid,'function'),
	sig=feval(model.outmid.function,sig);
   end
end
 
%%%%%%%%%%%%%% Cochlear filtering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(model,'cochlea'),
	%%%%%% Design and use a gammatone filterbank %%%%%%
  if isfield(model.cochlea,'gt'), 
	[A,model.cochlea.centfreqs]=Gammatone(sig,model); 
  end

  if isfield(model.cochlea,'fb'), % A pre-designed filterbank 
    if isfield(model.cochlea.fb,'file'), %Coeff. from a file
	eval(['load ' model.cochlea.fb.file]);  
	if exist('CentFreqs')~=0,model.cochlea.centfreqs=CentFreqs;end
	    if isreal(b)==1, % Real or complex-valued implementation
	  	  A=FilterBank(f,b,sig);
			  else
	          A=cgtbank(f,b,sig);
	    end	      
    else 				% coeff. from structure
	if isreal(model.cochlea.fb.b)==1,% Real or complex-valued impl.
	  	  A=FilterBank(model.cochlea.fb.f,model.cochlea.fb.b,sig);
			  else
	          A=cgtbank(model.cochlea.fb.f,model.cochlea.fb.b,sig);
	end
    end;
  end   
  if isfield(model.cochlea,'function'), % Another function
    A=feval(model.cochlea.function,sig);
  end    


% Irino's asymmetrical compensation filterbank
  if isfield(model.cochlea,'asymmcomp'),  
     [A,D]=ACfiltering(A,model.cochlea.centfreqs,model.fs);
  end
else % No Cochlea
	A=sig;
end

%%%%%%%%%%%%% Mechanical to Neural %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(model,'haircell'),
	%%%% Rectify-Compress-Filter path %%%%

    % Compression
    switch model.haircell.rcf.c,
      case 'Klapuri2005',
	B=Klapuri2005FWC(A, model);
      case 1,
	B=A;
      otherwise,	    
 	B=A.^model.haircell.rcf.c;
      end

   if isfield(model.haircell,'rcf'),
      % Rectification
    switch model.haircell.rcf.r,
      case 'full',
	B=abs(B);
      case 'half',
	B=max(B,0);
      otherwise,
	B=B;
    end

    % Smoothing
    switch model.haircell.rcf.f,
      case '1kHz',
	bb=exp(-1/(0.001*model.fs));
	B=filter(1-bb,[1 -bb],B);
      case 'tw20',
	bb=exp(-1/(0.02*model.fs));
	B=filter(1-bb,[1 -bb],B);
      otherwise,
	B=B;
      end
  end 
	%%%%%%%%%%%% Meddis's inner haircell model (ihc) %%%%%%
  if isfield(model.haircell,'ihc'),
	if isfield(model.haircell.ihc,'params'),
		B=Meddis_network91M(A,model.fs,model.haircell.ihc.params);
	else
		B=Meddis_network91M(A,model.fs); % Use default params
	end

	%%%%% Meddis's model for neural refractoriness %%%%%
	if isfield(model.haircell.ihc,'refractory'),
		 B=AN_refractory91(B,model.fs);
	end
  end

  if isfield(model.haircell,'function');% An user definable function
		B=feval(model.haircell.function,A);
  end

%%%%%%%%%% Threshold outputs (to get rid of zeros, etc.) %%%%%%%%%%%%
if isfield(model.haircell,'threshold'), 
	B=max(B,model.haircell.threshold);
      end;
else B=A;
end

%%%%%%%%%%%% Neural Adaptation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(model,'neural'),	
	switch model.neural.function,
	  case 'Meddis91',
	    C=AN_refractory91(B,model.fs);
	  case 'Plack98',
	    C=TempWin98(B,model.fs);
	  case 'Dau96',
	    C=Dau_network96(B,model.neural.Dau.thr);
	  case 'Karjalainen96',
	    [Slow,Fast]=Karja_network96(B,model.fs);
	    if isfield(model.neural.Karjalainen,'slow'), C=Slow; 
		else C=Fast;end
	  otherwise, 
	C=feval(model.neural.function,B);
	end
else
	C=B;
end

%%%%%%%%%%% Post-processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isfield(model,'pp'),
	if isfield(model.pp,'mapping'),
		switch model.pp.mapping,
			case 'decibel',
				C=max(20*log10(C),0);			
			otherwise,
				C=feval(model.pp.mapping,C);
			end
	end
end

