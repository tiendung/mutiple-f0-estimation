function bin = Freq2Bin(f, fs, K)
bin = floor(f*K/fs) + 1;