% plotfortalk

% make spectrogram from 4 to 20 min 
% load tag
path = 'E:\tt13\tt13_281a\';
settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
    'audit',[path 'audit\'])
tag = 'tt13_281a';
recdir = d3makefname(tag,'RECDIR'); % get audio path
R = loadaudit(tag);

%% this might break matlab

% load wav file
tcue1 = 240;     % start time cue of interest: 4 min in
tcue2 = R.cue(end,1);     % end time cue of interest: 20 min

[x,afs] = d3wavread([tcue1 tcue2],recdir, [tag(1:2) tag(6:9)], 'wav' ) ;

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
afs = afs/4;    % reduce sampling rate 

%% make spectrogram
[B F T P] = spectrogram(x_d,hamming(BL),floor(BL/1.3),BL,afs,'yaxis');

    figure(1); clf; set(gcf,'Position',[780   175   560   420])
    imagesc(T,F/1000,10*log10(abs(P)))
    axis xy
    xlabel('Time');
    ylabel('Frequency (kHz)');
    
    % fix axes for presentation
    set(gcf,'position',[311 352 1014 281],'paperpositionmode','auto')
    set(gca,'xtick',60:60:1200,'xticklabels',5:25)
    set(gca,'xlim',[0 960])
    adjustfigurefont
    
    %% save
    cd  \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\AnalysisFigures
print -dpng tt13_281a_sound