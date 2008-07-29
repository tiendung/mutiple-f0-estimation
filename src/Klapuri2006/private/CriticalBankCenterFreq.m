function [cbFreq] = CriticalBankCenterFreq( b)
cbFreq = 229*(10^((b+1)/21.4) - 1);
