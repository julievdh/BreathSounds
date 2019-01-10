function ns = fftsyringe(s,afs)
% fft filter for syringe sound

f1 = 300; 
f2 = 500;

range = round(f1/afs*length(s)):round(f2/afs*length(s)); 

S = fft(s); 
S(range) = (1-tukeywin(length(range),0.1)).*S(range); % set to zero
S(length(s)/2:end) = 0; % set second half to zero

ns = 2*real(ifft(S)); 

