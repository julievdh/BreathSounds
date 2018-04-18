function o=rmsbw(varargin)

if nargin==1
   s1=varargin{1};
   sr=1;
elseif nargin==2
   s1=varargin{1};
   sr=varargin{2};
else
   error('not enough or too much input!')
end;

gs=size(s1);
if gs(1)<gs(2)
   s1=s1';
end;
if mod(length(s1),2)
    s1(length(s1)+1)=0;
end;

L=size(s1,1);
S=abs(fft(s1));

f=[0:L/2-1]/L*sr;
E=S(1:L/2,:)'*S(1:L/2,:);
for j=1:size(s1,2)
o(j)=f*S(1:L/2,j).^2/E(j);
end