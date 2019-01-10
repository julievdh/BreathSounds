function [new_s,fs,n] = cleanbreath_fun(tag,cue,recdir,pad,chan)
% Filter exhalation based on observed frequency distribution of one sample
%
% Inputs:
%       tag = tag code (e.g., 'tt13_269b')
%       cue = breath number in R audit structure (e.g., 'R.cue(1,:)')
%       recdir = record directory
%       pad = just cue of interest (pad == 0) or with +- time on either
%       side for filtering and plotting
%       chan = channel for audio
%
% Outputs:
%       new_s = filtered signal
%       fs = new sampling rate
%       n = raw but downsampled signal
%

% April 2017 jvanderhoop@bios.au.dk

%% load in wav file
if pad == 1
[n,fs] = d3wavread([cue(1,1)-0.2 cue(1,1)+cue(1,2)+0.7],recdir, [tag(1:2) tag(6:9)], 'wav' );
end
if pad == 0
[n,fs] = d3wavread([cue(1,1) cue(1,1)+cue(1,2)],recdir, [tag(1:2) tag(6:9)], 'wav' );
end

if nargin < 5
chan = 1;
end

%% follow from cleanmario.m
chnk = 512; % chunk size

n = n(:,chan);              % set x = channel 1
n = n-mean(n);              % remove zero offset from recorder

% downsample noise
n = resample(n,1,4);
fs = fs/4;    % reduce sampling rate 

% % correct sound to be normalized pressure (uPa)
% s = normPress(s);
% s = s/10^6;             % convert from uPa to Pa


figure(111), clf
subplot(221)
plot(n)
subplot(223)
spectrogram(n,chnk,500,4096,fs,'yaxis'); colorbar off; ylim([0 20])

% estimate noise
N = floor(length(n)/chnk);
hanner=repmat(hanning(chnk),N,1); %big Hann for all that noise
ne = mean(abs(fft(reshape(n(1:N*chnk).*hanner,chnk,N))),2); % mean along 2nd dim
% NE=mean(abs(fft(reshape(noise.*hanner,chunk,N))),2);
half = 1:ceil(length(ne)/2);                 % get half

% figure(2)
% plot(half/max(half),ne(half,:));            % average noise
% xlabel('Frequency'), ylabel('Amplitude')

%% remove background noise from breath
stp = chnk/4;

NL = floor((length(n)-chnk)/stp); % instead of length/chunk its length/step
% step = chunk/4 - has to do with ratio
% between
new_s = n*0;
for j = 1:NL
    R = (j-1)*stp+1:(j-1)*stp+chnk; % range of interest
    F = fft(n(R).*hanning(chnk)); % use hanning window, correct step/chunk relationship
    A = abs(F);
    angl = atan2(imag(F),real(F));
    new_s(R) = new_s(R)+ real(ifft((max([(A-ne*2) A*0],[],2)).*(cos(angl)+1i*sin(angl))))*2/(chnk/stp); % amplitude minus mean noise: estimate of spectrum with noise subtracted
    % new_s + new_s because adding overapped portions
    % max command is to ensure non-negative values
    % can multiply noise*2 to get more pronounced filter
    
    % have to correct for amplitude. Hanning removes half amplitude at
    % tails
end

% figure(1)
subplot(222)
plot(new_s) % plot signal
subplot(224)
% figure(112); clf; set(gcf,'Position',[1970   175   560   420])
spectrogram(new_s,chnk,500,4096,fs,'yaxis'); colorbar off; ylim([0 20])



