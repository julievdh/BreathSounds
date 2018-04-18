% Filter exhalation based on observed frequency distribution of one sample

% Julie van der Hoop // March 2017

close all; clear all;

%% LOAD IN DATA
% load('tt13_284a_b43')
% % set path, tag
% change tag and path for different deployments
tag = 'tt13_284a';
path = 'D:\tt13\tt13_284a\';

settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
    'audit',[path 'audit\'])
recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);
%% Find noise floor
% have audited periods of silence in this tag audit
[cues,Rsub] = findaudit(R,'silence');

for i = 1
    [s,fs] = d3wavread([cues(i,1) cues(i,1)+1],recdir, [tag(1:2) tag(6:9)], 'wav' ) ;
    
    % % correct sound to be normalized pressure (uPa)
    % s = normPress(s);
    % s = s/10^6;               % convert from uPa to Pa
    
    s = s(:,1);                 % set x = channel 1
    s = s-mean(s);              % remove zero offset from recorder
end

%% follow from cleanmario.m
chnk = 512; % chunk size

n = s; % noise
[subs,fs] = d3wavread([R.cue(24,1) R.cue(24,1)+R.cue(24,2)],recdir, [tag(1:2) tag(6:9)], 'wav' ) ; % signal of interest

% % correct sound to be normalized pressure (uPa)
% s = normPress(s);
% s = s/10^6;             % convert from uPa to Pa

subs = subs(:,1);           % set x = channel 1
subs = subs-mean(subs);     % remove zero offset from recorder

figure(1), clf
subplot(221)
plot(subs)
subplot(223)
spectrogram(subs,chnk,500,4096,fs,'yaxis'); colorbar off; ylim([0 20])

% estimate noise
N = floor(length(n)/chnk);
hanner=repmat(hanning(chnk),N,1); %big Hann for all that noise
ne = mean(abs(fft(reshape(n(1:N*chnk).*hanner,chnk,N))),2); % mean along 2nd dim
% NE=mean(abs(fft(reshape(noise.*hanner,chunk,N))),2);
half = 1:ceil(length(ne)/2);                 % get half

figure(2) 
plot(half/max(half),ne(half,:));            % average noise 
xlabel('Frequency'), ylabel('Amplitude') 

%% remove background noise from breath
stp = chnk/4;

NL = floor((length(subs)-chnk)/stp); % instead of length/chunk its length/step
                                % step = chunk/4 - has to do with ratio
                                % between
new_s = subs*0;
for j = 1:NL 
    R = (j-1)*stp+1:(j-1)*stp+chnk; % range of interest
    F = fft(subs(R).*hanning(chnk)); % use hanning window, correct step/chunk relationship
    A = abs(F);
    angl = atan2(imag(F),real(F));
    new_s(R) = new_s(R)+ real(ifft((max([(A-ne*2) A*0],[],2)).*(cos(angl)+1i*sin(angl))))*2/(chnk/stp); % amplitude minus mean noise: estimate of spectrum with noise subtracted
    % new_s + new_s because adding overapped portions
    % max command is to ensure non-negative values
    % can multiply noise*2 to get more pronounced filter 
    
    % have to correct for amplitude. Hanning removes half amplitude at
    % tails
end

figure(1)
subplot(222)
plot(new_s) % plot signal
subplot(224)
spectrogram(new_s,chnk,500,4096,fs,'yaxis'); colorbar off; ylim([0 20])

