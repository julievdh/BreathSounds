function o=crmsbw(varargin)

if nargin==1 %nargin=#input parameters?
   s=varargin{1};
   sr=1;    %use default value for sr
elseif nargin==2
   s=varargin{1};
   sr=varargin{2};
else
   error('not enough input!')
end;

if size(s,1)<size(s,2) %if necessary, 
   s=s';            %then make it a column vector
end;

if mod(length(s),2) %if necessary
    s=[s;0]; %then make length even
end;

L=length(s); %length of s in samples
S=abs(fft(s)).^2/L*2; %spectral power

f=[0:L/2-1]/L*sr; %frequency axes - note that it's a row vector
S=S(1:L/2); %we only need half the spectrum (positive frequencies)
E=sum(S); %signal energy

rms=f*S/E; %mean frequency (controid)

o=sqrt(((f-rms).^2*S/E)); %variance around mean frequency