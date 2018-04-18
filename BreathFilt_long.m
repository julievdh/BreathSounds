function [x_d,xfilt] = BreathFilt_long(i,R,recdir,tag,pad)

% Import wav file for a breath based on tag cues from audit, filter audio
%
% Inputs:
%       i = breath number, to correspond with cue number
%       R = tagaudit array of cues [cue duration]
%       recdir = record directory
%       tag = tag code (e.g., 'tt13_269b')
%
% Outputs:
%       x = original signal
%       xfilt = filtered signal (fourth-order low pass Hamming-window FIR
%       filter)
%
% Julie van der Hoop jvanderhoop@whoi.edu
% 27 March 2014



% % load wav file
tcue1 = R.cue(i,1);     % start time cue of interest
tdur1 = R.cue(i,2);     % end time cue of interest + pad
if pad == 1
[x,afs] = d3wavread([tcue1 tcue1+tdur1+0.1],recdir, [tag(1:2) tag(6:9)], 'wav' ) ;
end
if pad == 0
[x,afs] = d3wavread([tcue1 tcue1+tdur1],recdir, [tag(1:2) tag(6:9)], 'wav' ) ;
end


% correct sound to be normalized pressure (uPa)
x = normPress(x);
x = x/10^6;             % convert from uPa to Pa

% set x = channel 1
x = x(:,1);

% remove zero offset from recorder
x = x-mean(x);

% set values
BL = 1024;      % FFT block size

% downsample by factor of 4 
x_d = resample(x,1,4);
afs = 240000/4;    % reduce sampling rate 

% make spectrogram
[B F T P] = spectrogram(x_d,hamming(BL),floor(BL/1.3),BL,afs,'yaxis');

    figure(1); clf; set(gcf,'Position',[780   175   560   420])
    imagesc(T,F/1000,10*log10(abs(P)))
    axis xy
    xlabel('Time');
    ylabel('Frequency (kHz)');
%% based on this, build a low-pass filter

B2 = fir1(4,0.16,'low'); % lowpass filter with cutoff
                         % frequencies of interest are < 0.16*fs/2

% Plot impulse response of filter
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
