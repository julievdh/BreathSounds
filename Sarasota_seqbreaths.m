% Load in Tag and Pneumotach data
% Correct offset of times
% Align datasets and find matched cues for each time series

% 13 Aug 2014

close all; clear all;

% Load DQ File Data Structure
load('SarasotaFiles')

% set file number
i = 13;

% set path, tag
path = strcat('F:/',Sarasota{i,1}(1:4),'/',Sarasota{i,1},'/');
tag = Sarasota{i,1};
settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
    'audit',[path 'audit\'])
recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);

% load respiration data .mat files
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
filename = strcat(Sarasota{i,2},'_resp');
load(filename)

% return to other directory
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\'

if exist('tcue') ~= 1
    % find time in tag record when trial starts
    tcue = etime(DEPLOY.TRIAL.STARTTIME, DEPLOY.TAGON.TIME);
end

%% check and make sure that breaths are at the right time
figure(1); clf
plot(RAWDATA(:,1),RAWDATA(:,2),'LineWidth',2); hold on
for n = 1:length(R.cue)
    line([R.cue(n)-tcue R.cue(n)-tcue],[0 50],'color','k')
    text(R.cue(n)-tcue,50,num2str(n))
end
xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)

%% PLOT
CUE_S = find(CUE);
CUE_R = CUE(find(CUE));
% figure(3); hold on
% % plot(R.cue(CUE_R,1)-tcue,SUMMARYDATA(CUE_S,:),'.')
% legend('End Tidal O_2','End Tidal CO_2','Max Insp Flow','Max Exp Flow','Tidal Volume','Location','WestOutside')
% title(regexprep(tag,'_',' '))
% xlabel('Time (s)')
% adjustfigurefont

%% CUT FLOW RATE DATA

[pks,locs] = findpeaks(RAWDATA(:,2),'minpeakheight',0.75,'minpeakdistance',300);

% check to see if detected peaks are same length as summary data
disp('Did we find the same peaks?')
disp(isequal(length(pks),length(SUMMARYDATA)))

% plot detected peaks
plot(RAWDATA(locs,1),pks,'ko')

%% which cues are NOT in CUE_R?
pneum = ismember(CUE_R(1):CUE_R(end),CUE_R); % 1 is on, 0 is off
for n = 1:length(CUE_R)
    if pneum(n) == 0
        line([R.cue(n)-tcue R.cue(n)-tcue],[0 50],'color','r')
        text(R.cue(n)-tcue,50,num2str(n))
    end
end

%% filter breaths?
[xfilt,fs] = cleanbreath_fun(tag,R.cue(1,:),recdir);
envelope
figure
plot(averageenv)

return

%% load envelope
load(strcat('FlowEnvelope_',tag));
figure(19); hold on
for i = 1:length(env)
    if pneum(i) == 1
        plot(env{i,1},'r')
    else if pneum(i) == 0
            plot(env{i,1},'b')
        end
    end
end

return

%% cut
for i = 1:length(locs)
    figure(2); hold on
    cuts(i).flow = RAWDATA(locs(i)-100:locs(i)+200,:);
    plot(cuts(i).flow(:,2))
end

xlabel('Time (sec)'); ylabel('Flow Rate (L/sec')

% plot only those that are sequential
inc = diff(CUE_R) > 1;
i1 = find(inc >= 1);
if isempty(i1) == 0
    seqbr1 = CUE_S(1:i1(1)); % first set
    for i= 1:length(seqbr1)
        plot(cuts(seqbr1(i)).flow(:,2),'r')
    end
    
    seqbr2 = CUE_S(i1(end)+1:end); % second set
    for i= 1:length(seqbr2)
        plot(cuts(seqbr2(i)).flow(:,2),'k')
    end
end

return
%% LOAD BREATH PARAMS
cd([path 'audit\'])
load(strcat(tag,'_PQ'));
ZeroBreaths % NaN-out Zeros in breath params

%% PLOT (for example)
figure(1)
plot(R.cue(CUE_R,1)-tcue,eParams.EFD(CUE_R),'m.')
plot(R.cue(CUE_R,1)-tcue,iParams.EFD(CUE_R),'mo')
title(regexprep(tag,'_',' '))

return

figure(3)
plot(R.cue(CUE_R,1)-tcue,eParams.Fcent(CUE_R)/1000,'g.')
legend('End Tidal O_2','End Tidal CO_2','Max Insp Flow','Max Exp Flow','Tidal Volume','Centroid Frequency','Location','WestOutside')


% PLOT SUMMARY DATA
figure(4)
[H,AX,BigAx,P]=plotmatrix(SUMMARYDATA);
set(get(BigAx,'title'),'string',regexprep(tag,'_',' '))
set(get(BigAx,'xlabel'),'string',{'End Tidal O_2       End Tidal CO_2      Max Insp Flow Rate       Max Exp Flow Rate       Tidal Volume'})

% PLOT COMBINED
figure(6)
subplot(221)
title(regexprep(tag,'_',' '))
plot(eParams.Fcent(CUE_R)/1000,SUMMARYDATA(CUE_S,:),'.')
xlabel('Centroid Frequency (kHz)')
subplot(222)
plot(eParams.RMS(CUE_R)/1000,SUMMARYDATA(CUE_S,:),'.')
xlabel('RMS Amplitude');
subplot(223)
plot(eParams.EFD(CUE_R)/1000,SUMMARYDATA(CUE_S,:),'.')
xlabel('Energy Flux Density')
subplot(224)
plot(eParams.pp(CUE_R)/1000,SUMMARYDATA(CUE_S,:),'.')
xlabel('Peak to Peak Amplitude')

% PLOT WHAT WE EXPECT TO CORRELATE
% FCENT and FLOW RATES
figure(7)
subplot(131)
plot(eParams.Fcent(CUE_R)/1000,SUMMARYDATA(CUE_S,4),'.')
hold on
plot(iParams.Fcent(CUE_R)/1000,SUMMARYDATA(CUE_S,3),'g.')
xlabel('Centroid Frequency (kHz)')
ylabel('Flow Rate')
legend('Expiration','Inspiration','Location','Best')
subplot(132)
plot(eParams.EFD(CUE_R)/1000,SUMMARYDATA(CUE_S,4),'.')
hold on
plot(iParams.EFD(CUE_R)/1000,SUMMARYDATA(CUE_S,3),'g.')
xlabel('Energy Flux Density')
ylabel('Flow Rate')
legend('Expiration','Inspiration','Location','Best')

subplot(133)
plot(eParams.pp(CUE_R)/1000,SUMMARYDATA(CUE_S,4),'o')
hold on
plot(iParams.pp(CUE_R)/1000,SUMMARYDATA(CUE_S,3),'go')
plot(eParams.RMS(CUE_R)/1000,SUMMARYDATA(CUE_S,4),'b.')
plot(iParams.RMS(CUE_R)/1000,SUMMARYDATA(CUE_S,3),'g.')
xlabel('Centroid Frequency (kHz)')
ylabel('Flow Rate')
legend('PP Expiration','PP Inspiration','RMS Expiration','RMS Inspiration','Location','Best')

% EFD AND VT
figure(8)
subplot(121)
plot(eParams.time_window(CUE_R)/1000,SUMMARYDATA(CUE_S,5),'.')
hold on
plot(iParams.time_window(CUE_R)/1000,SUMMARYDATA(CUE_S,5),'g.')
xlabel('95% Energy Duration (s)')
ylabel('Tidal Volume (L)')
legend('Expiration','Inspiration','Location','Best')


subplot(122)
plot(eParams.EFD(CUE_R)/1000,SUMMARYDATA(CUE_S,5),'.')
hold on
plot(iParams.EFD(CUE_R)/1000,SUMMARYDATA(CUE_S,5),'g.')
xlabel('Energy Flux Density')
ylabel('Tidal Volume (L)')
legend('Expiration','Inspiration','Location','Best')


%%
figure(10)
plotmatrix(horzcat(eParams.RMS(CUE_R)',eParams.pp(CUE_R)',eParams.EFD(CUE_R)',eParams.Fcent(CUE_R)',SUMMARYDATA(CUE_S,:)))
title(strcat(regexprep(tag,'_',' '),'  Expiration'))

figure(11)
plotmatrix(horzcat(iParams.RMS(CUE_R)',iParams.pp(CUE_R)',iParams.EFD(CUE_R)',iParams.Fcent(CUE_R)',SUMMARYDATA(CUE_S,:)))
title(strcat(regexprep(tag,'_',' '),'  Inspiration'))
