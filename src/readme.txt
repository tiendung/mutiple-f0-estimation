This folder contains source codes of two state-of-the-art methods for multipitch estimation.


[Klapuri2005] Klapuri, A., "A Perceptually motivated Multiple-F0 Estimation Method", in Proc. IEEE Workshop on Applications of Signal Processing to Audio and Acoustics", New Paltz, New York, Oct. 2005. 
[Klapuri2006] Klapuri, A., "Multiple Fundamental Frequency Estimation by Summing Harmonic Amplitudes", 7th International Conference on Music Information Retrieval, Victoria, Canada, Oct. 2006. 

Since there are a lot of common points between these two methods, they are combined into a single framework.



How to run?
Use the command:  Klapuri200x(fileName, numberOfF0);

Example:
Klapuri2006('../database/DSV_RandomMix/2/bcla@Ab2_aflu@A4.wav', 2)
Klapuri2006('../database/DSV_RandomMix/1/EbClar_mf_C5.wav', 1)
Klapuri2005('../database/DSV_RandomMix/4/clar@C6_cell@D2_bsoo@A4_vila@A5.wav', 4)
Klapuri2006('../database/DSV_RandomMix/4/clar@C6_cell@D2_bsoo@A4_vila@A5.wav', 4)
