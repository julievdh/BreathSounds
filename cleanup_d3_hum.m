function		y = cleanup_d3_hum(x,fs)

%		y = cleanup_d3_hum(x,fs)
%		This is a quick hack to reduce sensor sampling interference
%		in a Dtag-3 audio recording. The sequence length (seqlen) parameter
%		in the function depends on the sensor sequence being run on the tag
%		and so may need to be changed for recordings from tags with different
%		sensors or sensor sampling rates.
%
%		markjohnson@st-andrews.ac.uk

seqlen = 9600 ;
[X,z] = buffer(x,round(seqlen*fs/240e3),0,'nodelay');
xp = sum(X.^2) ; 
T = mean(X(:,xp<median(xp)*1.5),2) ;
y = x-[repmat(T,size(X,2),1);T(1:length(z))] ;

