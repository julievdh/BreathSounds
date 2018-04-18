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

for i = 1:length(cues)
[s,afs] = d3wavread([cues(i,1) cues(i,1)+1],recdir, [tag(1:2) tag(6:9)], 'wav' ) ;

% correct sound to be normalized pressure (uPa)
s = normPress(s);
s = s/10^6;             % convert from uPa to Pa

% set x = channel 1
s = s(:,1);

% remove zero offset from recorder
s = s-mean(s);

% fft 
S(:,i) = abs(fft(s)).^2;                       % do FFT, square for power

end 
half = 1:ceil(length(S)/2);                 % get half 

figure(3), clf, hold on                              % plot noise floor from samples
plot(half/max(half),S(half,:)); 

% average across S 
Smean = mean(S');
plot(half/max(half),Smean(half),'k')
Smedian = median(S');
plot(half/max(half),Smedian(half),'r')

templ = fftshift(ifft(Smean));                  % make template from fft 
%templ=templ(round(length(templ)/2-1000)+1:round(length(templ)/2+1000));

%% remove background noise from breath
[bcues,Rbreath] = findaudit(R,'breath');
i = 1;
[s,afs] = d3wavread([bcues(i,1) bcues(i,1)+bcues(i,2)],recdir, [tag(1:2) tag(6:9)], 'wav' ) ;
% correct sound to be normalized pressure (uPa)
s = normPress(s);
s = s/10^6;             % convert from uPa to Pa

% set x = channel 1
s = s(:,1);

% remove zero offset from recorder
s = s-mean(s);

S = abs(fft(s)).^2;                       % do FFT, square
half = 1:ceil(length(S)/2);               % get half 

figure(3), clf, hold on                   % plot breath signal
plot(half/max(half),S(half,:)); 
xlabel('Frequency, Hz'), ylabel('Power')

% window?
% Swin = tukeywin(length(S),0.1);
% test = conv(Swin,sqrt(S));

% zero-pad 
templ(end:length(S)) = 0;

% subtract noise floor from signal
cleaned = S-templ';
cleaned(cleaned <0) = 0;
plot(half/max(half),cleaned(half),'k')
return 
%% 
figure(2); clf, hold on
plot(x), plot(10829:32857,x(10829:32857))

% fft
s = x(10829:32857);                         % subsample of exhalation
S = abs(fft(s));                            % do FFT
templ = fftshift(ifft(S));                            % make template from fft 
templ=templ(round(length(templ)/2-1400)+1:round(length(templ)/2+1400));
half = 1:ceil(length(S)/2);                 % get half 
figure(3), clf                              % plot template
plot(half/max(half),abs(S(half))); 
xlabel('Normalized Frequency'); ylabel('Magnitude')

Sfilt = conv(s,templ,'same');               % filter original signal
figure(2)
plot(10829:32857,Sfilt) % this is not right... 