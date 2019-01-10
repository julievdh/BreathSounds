clear
clf
[s,sr]=audioread('sh40_mario_its_me.wav');
chunk=512;  %imperically derived
stp=chunk/4; %also an arbitrary guess 
strt=37.5*sr;    %found by ogling the spectrogram
N=floor(strt/chunk); %this is the number of noise chunks;
subs=s(strt+1:end); %the bit to be cleaned up
noise=[s(1:N*chunk);s(chunk/2+1:(N-1)*chunk+chunk/2)];
    %for hanning later.
N=length(noise)/chunk; %new N
hanner=repmat(hanning(chunk),N,1); %big Hann for all that noise

%-----------was für's Auge--------------
subplot(2,2,1)
plot(s(strt:end))
subplot(2,2,3)
spectrogram(s(strt:end),512,500,4096,sr,'yaxis');colorbar off
caxis([-100 0]+max(caxis))
myx=caxis;  %saving the axis for comparison later
%----------------------------------------------

NE=mean(abs(fft(reshape(noise.*hanner,chunk,N))),2);
        %noise estimate
        
ns=subs*0; %preallocate
for j=1:floor(length(subs)/stp)-chunk/stp+1
    range=((j-1)*stp+1:(j-1)*stp+chunk)'; %the samples for this round of the loop
    SS=fft(subs(range).*hanning(chunk));  %complex spectrum
    
    angl=atan2(imag(SS),real(SS));  %phase angle
    amp=abs(SS);    %amplitude
    NS=(cos(angl)+1i*sin(angl)).*max([(amp-NE*4) amp*0;],[],2);
        %the signal minus noise estimate with phase conserved
        %The factor of the noise estimate is highly dependent on SNR
    ns(range)=ns(range)+real(ifft(NS))*2*stp/chunk; %added to the new estimate
        %The factor 2 is from the Hann window. The /(chunk/stp) compensates
        %approximately for the overlap
end
%-----------more für's Auge--------------
subplot(2,2,2)
plot(ns)
subplot(2,2,4)
spectrogram(ns,512,500,4096,sr,'yaxis');colorbar off
caxis(myx)
%----------------------------------------------

