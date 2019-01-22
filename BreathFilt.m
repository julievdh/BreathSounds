function [x_d,xfilt,afs,tcue1,tdur1] = BreathFilt(i,R,recdir,tag,pad)

% Import wav file for a breath based on tag cues from audit, filter audio
%
% Inputs:
%       i = breath number, to correspond with cue number
%       R = tagaudit array of cues [time duration]
%       recdir = record directory
%       tag = tag code (e.g., 'tt13_269b')
%
% Outputs:
%       x = original signal
%       xfilt = filtered signal (fourth-order low pass Hamming-window FIR
%       filter)
%       afs = audio sampling frequency (Hz)
%       tcue1 = time cue start (s)
%       tdur1 = cue duration (s)
%
% Julie van der Hoop jvanderhoop@whoi.edu
% 27 March 2014



% load wav file
tcue1 = R.cue(i,1);     % start time cue of interest
if strcmp(tag,'tt14_125a') && i < 303
 tcue1 = R.cue(i,1)+0.65;     % special adjustment for some of tt125a 
end
if strcmp(tag,'tt14_125a') && i > 565 
 tcue1 = tcue1+0.3;     % special adjustment for some of tt125a 
end
tdur1 = R.cue(i,2);     % end time cue of interest + pad
if strcmp(tag,'tt14_125a') && i > 515
 tdur1 = tdur1+0.3;     % special adjustment for some of tt125a 
end

if pad == 1
    [x,afs] = d3wavread([tcue1-0.4 tcue1+tdur1+0.6],recdir, [tag(1:2) tag(6:9)], 'wav' ) ;
end
if pad == 0
    [x,afs] = d3wavread([tcue1 tcue1+tdur1],recdir, [tag(1:2) tag(6:9)], 'wav' ) ;
end


% correct sound to be normalized pressure (uPa)
x = normPress(x);
x = x/10^6;             % convert from uPa to Pa

% set x = channel 2 (because tag 119 hydrophone 1 bad)
x = x(:,2);

% remove zero offset from recorder
x = x-mean(x);
if pad == 1
    xf = cleanup_d3_hum(x(0.4*afs:(0.4+tdur1)*afs),afs); % remove hum in D3
%if rms(xf) < rms(x(0.4*afs:(0.4+tdur1)*afs))
    x(0.4*afs:(0.4+tdur1)*afs) = xf;
%end
end

if pad == 0
    xf = cleanup_d3_hum(x,afs);
    if rms(xf(1:(tdur1)*afs)) < rms(x(1:(tdur1)*afs)) % use this approach only if it reduces RMS during time of interest
        x = xf ;
    end
end



%% set values
BL = 1024;      % FFT block size

% downsample by factor of 4
x_d = resample(x,1,2);
afs = afs/2;    % reduce sampling rate

% make spectrogram
[B F T P] = spectrogram(x_d,hamming(BL),floor(BL/1.3),BL,afs,'yaxis');

figure(1); clf; % set(gcf,'Position',[1970   175   560   420])
imagesc(T,F/1000,10*log10(abs(P)))
axis xy
xlabel('Time');
ylabel('Frequency (kHz)'); ylim([0 20])
%% based on this, build a low-pass filter

B2 = fir1(4,0.16,'low'); % lowpass filter with cutoff
% frequencies of interest are < 0.16*fs/2

% % Plot impulse response of filter
% kk = zeros(1,1000);
% kk(50) = 1;                  % create an impulse
% Y2 = fft(conv(kk,B2));
% half = 1:ceil(length(Y2)/2);
% figure(2)
% plot(half/max(half),abs(Y2(half)));
% xlabel('Normalized Frequency'); ylabel('Magnitude')

% convolve filter and signal
xfilt = conv(x_d,B2,'same');

end
