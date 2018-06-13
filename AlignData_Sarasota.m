% Load in Tag and Pneumotach data
% Correct offset of times
% Align datasets and find matched cues for each time series

% 13 Aug 2014

close all; clear;

% Load Sarasota File Data Structure
load('SarasotaFiles')

% set file number
f = 14;

% set path, tag
path = strcat('D:/',Sarasota{f,1}(1:4),'/',Sarasota{f,1},'/');
tag = Sarasota{f,1};
recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);

% load respiration data .mat files
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
filename = strcat(Sarasota{f,2},'_resp');
load(filename)

% return to other directory
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\'
%% IF tcue DOESN'T ALREADY EXIST FROM IMPORTED FILE: recalculate
if exist('tcue') ~= 1
    % find time in tag record when trial starts
    [CAL,DEPLOY] = d3loadcal(tag);
    tcue = etime(DEPLOY.TRIAL.STARTTIME, DEPLOY.TAGON.TIME);
% find time in tag record when trial starts
if isfield(DEPLOY,'TRIAL') == 0
    disp('Enter trial information and save DEPLOY')
    return 
    TRIAL.PNEUMOFILE = Sarasota{f,2};
    TRIAL.STARTTIME = [2014 5 8 16 10 08]; % time start respirometry
    d3savecal(tag,'TRIAL',TRIAL);
end
tcue = etime(DEPLOY.TRIAL.STARTTIME, DEPLOY.TAGON.TIME);
end

% find only breath cues
[~,breath] = findaudit(R,'breath');

%% check and make sure that breaths are at the right time
figure(1); clf
plot(RAWDATA(:,1),RAWDATA(:,2),'LineWidth',2); hold on
for n = 1:length(breath.cue)
    line([breath.cue(n)-tcue breath.cue(n)-tcue],[0 50],'color','k')
    text(breath.cue(n)-tcue,55,num2str(n))
end
xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)

%% observe offset and correct
if exist('CUE') ~= 1
    xlim([50 R.cue(3)-tcue]) % for zoom purposes
    %%
    
    disp('Select cue then matching breath')
    
    ginput(2)
    offset = floor(ans(2,1) - ans(1,1));
    tcue = tcue-offset;
    
    figure(1)
    plot(RAWDATA(:,1),RAWDATA(:,2),'LineWidth',2); hold on
    for n = 1:length(R.cue)
        line([R.cue(n)-tcue R.cue(n)-tcue],[0 50],'color','r')
        text(R.cue(n)-tcue,55,num2str(n))
    end
    xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)
    xlim([0 max(R.cue(:,1))-tcue])
    
    
    %% determine breaths where have CUE and PNEUMO
    % find peaks in flow rate signal
    [pks,locs] = findpeaks(RAWDATA(:,2),'minpeakheight',1,'minpeakdistance',300);
    
    % check to see if detected peaks are same length as summary data
    disp('Did we find the same peaks?')
    disp(isequal(length(pks),length(SUMMARYDATA)))
    
    % plot detected peaks
    plot(RAWDATA(locs,1),pks,'ko')
    
    % find BREATHS and CUES at same time
    clear CUE
    [CUE,mind] = nearest(breath.cue(:,1)-tcue,RAWDATA(locs,1),1);
    
    cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
    filename = strcat(Sarasota{f,2},'_resp');
    save(filename,'CUE','tcue','-append')
end
return 
%% 

for i = 1:length(locs)
    figure(2); hold on
    cuts(i).flow = RAWDATA(locs(i)-100:locs(i)+200,:);
    plot(cuts(i).flow(:,2))
end
save(filename,'cuts','-append')
%% PLOT
CUE_S = find(CUE); 
CUE_R = CUE(find(CUE));
figure(3); hold on
plot(R.cue(CUE_R,1)-tcue,SUMMARYDATA(CUE_S,:),'.')
legend('End Tidal O_2','End Tidal CO_2','Max Insp Flow','Max Exp Flow','Tidal Volume','Location','WestOutside')
title(regexprep(tag,'_',' '))
xlabel('Time (s)')
adjustfigurefont

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
