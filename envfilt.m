function [E,E2,E2_s,fs] = envfilt(signal,afs)


%% plot filtered signal
figure(2), clf, hold on
plot(signal)
% fill zeros with NaNs 
signal(find(signal == 0)) = NaN;

% get envelope
E = hilbenv(signal);

% plot envelope
% plot(E)

%% smooth envelope
% Filter based on bandwidth of pneumotach data: -10dB cutoff is ~3 Hz
B2 = fir1(100,3/afs,'stop'); % LPF 

x = zeros(1,1000);
x(50) = 1; % have created an impulse here 
Y2 = fft(conv(x,B2));
half = 1:ceil(length(Y2)/2);
% figure(3)
% plot(half/max(half),abs(Y2(half)));

% plot smoothed
E2 = conv(E,B2);
figure(2), clf, hold on
plot((1:length(E))/afs,E)
plot((1:length(E2))/afs,E2,'k')
xlabel('Time (sec)')

% interpolate NaN sections
X = naninterp(E2);
X(find(X<0)) = 0; % zero out any negative values at the beginning
X(find(X>max(E2))) = NaN; % interpolation should never exceed max envelope
plot((1:length(X))/afs,X)
%% downsample to same sampling frequency as pneumotach = 200 Hz 

E2_s = resample(X,1,300);
fs = afs/300;    % reduce sampling rate 
plot((1:length(E2_s))/fs,E2_s,'LineWidth',1.5)
