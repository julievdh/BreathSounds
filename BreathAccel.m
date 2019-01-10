% can we use accelerometers to learn more about individual breaths?
warning off; close all; clear all

% load tag
% path = 'D:\tt14\tt14_125a\';
path = 'D:\tt13\tt13_268c\';
settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
    'audit',[path 'audit\'])
tag = 'tt13_268c';
recdir = d3makefname(tag,'RECDIR'); % get audio path

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);
loadprh(tag);

%% plot spectrogram
% choose breath
for i = 30% :length(R.cue);
    
    [x,xfilt] = BreathFilt(i,R,recdir,tag,1);
    
    % plot spectrogram
    BL = 1024; afs = 240000/4;    % reduced sampling rate
    [B F T P] = spectrogram(xfilt,hamming(BL),floor(BL/1.3),BL,afs,'yaxis');
    figure(2); clf
    set(gcf,'position',[2857 -170 560 779])
    subplot(5,1,[1 2])
    imagesc(T,F/1000,10*log10(abs(P)))
    axis xy
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    % plot waveform
    subplot(5,1,3); hold on
    plot((1:length(xfilt))/afs,xfilt)
    plot((1:length(xfilt))/afs,abs(hilbert(xfilt)))
    xlim([0 length(xfilt)/afs]); ylim([-0.3 0.3])
    xlabel('Time (s)'); ylabel('Sound Pressure (Pa)')
    
    % plot accelerometers and depth
    subplot(5,1,4); hold on
    stcue = R.cue(i);
    endcue = R.cue(i,1)+R.cue(i,2);
    t = (1:length(A))/fs;
    plotyy(t(stcue*fs:endcue*fs),A(stcue*fs:endcue*fs,:),t(stcue*fs:endcue*fs),p(stcue*fs:endcue*fs,:))
    % plot(t(stcue*fs:endcue*fs),p(stcue*fs:endcue*fs,:),'k')
    % m = msa(A(stcue*fs:endcue*fs,:));
    % plot(t(stcue*fs:endcue*fs),m,'k')
    xlabel('Time (s)'); ylabel('A')
    
    % calculate and plot kurtosis
    winwidth = 1000;  % Sliding window width
    step = 500;  % Slide for each iteration
    [kurtwin,i2] = BreathKurt(xfilt,winwidth,step);
    subplot(5,1,5); hold on
    plot(step:step:i2-2,kurtwin,'.')
    ylabel('kurtosis')
    
    pause
end

%% is there a characteristic signal for all?
figure(3); clf;
for i = 1:length(R.cue)
    stcue = R.cue(i);
    endcue = R.cue(i,1)+R.cue(i,2);
    subplot(4,1,[1 2]); hold on
    plot(A(stcue*fs:endcue*fs,:))
    ylabel('A')
    subplot(413); hold on
    % calculate MSA and jerk
    m = msa(A(stcue*fs:endcue*fs,:));
    j = njerk(A(stcue*fs:endcue*fs,:),fs);
    % plot
    plot(m,'r')
    ylabel('MSA')
    subplot(414); hold on
    plot(j,'k')
    ylabel('jerk'); xlabel('Samples')
end

