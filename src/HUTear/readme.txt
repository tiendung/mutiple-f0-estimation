HUTear files:
AudMod.m
ERB.m
FilterBank.m
Gammatone.m
MakeERBFiltersB.m

We must use Klapuri2005 FWC method in order to get the correct F0 result. 
Because, other FWC methods in HUTear scale low frequency magnitudes to much, 
it will make the favor of low F0 (in this case must set minF0 >= 400 
to come over the bias low frequency magnitude part)

Sample code in MATLAB to use HUTear for Klapuri2005

[waveIn, fs] = wavread('filename');
model = Klaprui2005Profile(fs);
[au, model] = AudMod(waveIn, model);
