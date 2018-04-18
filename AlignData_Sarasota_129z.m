% Load in Tag and Pneumotach data
% Correct offset of times
% Align datasets and find matched cues for each time series

% 13 Aug 2014

close all; clear all;

% Load DQ File Data Structure
load('SarasotaFiles')

%% set file number
i = 7;
%%
% set path, tag
path = strcat('D:/',Sarasota{i,1}(1:4),'/',Sarasota{i,1},'/');
tag = Sarasota{i,1};
settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
    'audit',[path 'audit\'])
recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);

% load respiration data .mat files
cd 'C:\Users\Julie\Documents\MATLAB\BreathSounds\PneumoData'
filename = strcat(Sarasota{i,2},'_resp');
load(filename)

% return to other directory
cd C:\Users\Julie\Documents\MATLAB\MAS500\

% find time in tag record when trial starts
tcue = etime(DEPLOY.TRIAL.STARTTIME, DEPLOY.TAGON.TIME);


%% check and make sure that breaths are at the right time
figure(1); clf
plot(RAWDATA_1(:,1),RAWDATA_1(:,2),'LineWidth',2); hold on
for n = 1:length(R.cue)
    line([R.cue(n)-tcue R.cue(n)-tcue],[0 50],'color','k')
    text(R.cue(n)-tcue,55,num2str(n))
end
xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)

% tcue file A = 209
% tcue = 209;

%% Between files A and B:
etime([2014 5 9 16 13 11],[2014 5 9 16 06 17])
% 414 seconds between starts of files
% 76 s between end and next start

plot(RAWDATA_1(:,1),'k'); hold on

% test to see: RAWDATA_2 should begin 414 s after RAWDATA_1
test = RAWDATA_2(:,1) + 76 + RAWDATA_1(67520,1);
plot(test,'m')

RAWDATA_2(:,1) = test;

RAWDATA_1(67521:67521+76*200,:) = 0;
for i = 67521:67521+(76*200)
RAWDATA_1(i,1) = RAWDATA_1(i-1,1) + (1/200);
end

RAWDATA = vertcat(RAWDATA_1,RAWDATA_2);

plot(RAWDATA(:,1),'k')
%% do the data and cues align?
figure(2); hold on
plot(RAWDATA_1(:,1),RAWDATA_1(:,2),'r')
plot(RAWDATA_2(:,1),RAWDATA_2(:,2),'b')
for n = 1:length(R.cue)
    line([R.cue(n)-tcue R.cue(n)-tcue],[0 50],'color','k')
    text(R.cue(n)-tcue,55,num2str(n))
end

%% Between files B and C
% etime([2014 5 9 16 24 02],[2014 5 9 16 23 23])
% 39 s between end B and start C
% 651 s between start B and start C

figure(1)
test = RAWDATA_3(:,1) + 39 + RAWDATA_2(end,1);
plot(test,'m')

RAWDATA_2(122411:122411+39*200,:) = 0;
for i = 122411:122411+39*200
RAWDATA_2(i,1) = RAWDATA_2(i-1,1) + (1/200);
end

RAWDATA_3(:,1) = test;

%%
plot(vertcat(RAWDATA_1(:,1),RAWDATA_2(:,1),RAWDATA_3(:,1)))

RAWDATA = vertcat(RAWDATA_1,RAWDATA_2,RAWDATA_3);

%% check to see if data and cues align
figure(2); hold on
plot(RAWDATA_1(:,1),RAWDATA_1(:,2),'r')
plot(RAWDATA_2(:,1),RAWDATA_2(:,2),'b')
plot(RAWDATA_3(:,1),RAWDATA_3(:,2),'g')
plot(RAWDATA(:,1),RAWDATA(:,2),'m')
for n = 1:length(R.cue)
    line([R.cue(n)-tcue R.cue(n)-tcue],[0 50],'color','k')
    text(R.cue(n)-tcue,55,num2str(n))
end

%% Between files C and D
% 12 between end C and start D
% 289 between start C and start D

figure(1)
test = RAWDATA_4(:,1) + 12 + RAWDATA_3(end,1);
plot(test,'m')

RAWDATA_3(55401:55401+12*200,:) = 0;
for i = 55401:55401+12*200
RAWDATA_3(i,1) = RAWDATA_3(i-1,1) + (1/200);
end

RAWDATA_4(:,1) = test;

plot(vertcat(RAWDATA_1(:,1),RAWDATA_2(:,1),RAWDATA_3(:,1),RAWDATA_4(:,1)))

RAWDATA = vertcat(RAWDATA_1,RAWDATA_2,RAWDATA_3,RAWDATA_4);

%% check to see if data and cues align
figure(2); hold on
plot(RAWDATA_1(:,1),RAWDATA_1(:,2),'r')
plot(RAWDATA_2(:,1),RAWDATA_2(:,2),'b')
plot(RAWDATA_3(:,1),RAWDATA_3(:,2),'g')
plot(RAWDATA_4(:,1),RAWDATA_4(:,2),'c')
% plot(RAWDATA(:,1),RAWDATA(:,2),'m')
for n = 1:length(R.cue)
    line([R.cue(n)-tcue R.cue(n)-tcue],[0 50],'color','k')
    text(R.cue(n)-tcue,55,num2str(n))
end

%%
SUMMARYDATA = vertcat(SUMMARYDATA_1,SUMMARYDATA_2,SUMMARYDATA_3,SUMMARYDATA_4);

%% create filename for saving
i = 7;
filename = strcat(Sarasota{i,2},'_resp');

% specify directory to save
cd 'C:\Users\Julie\Documents\MATLAB\BreathSounds\PneumoData'

% save file
save(filename,'filename','RAWDATA','SUMMARYDATA')

return


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
    for n = 1:length(pks)
        find(R.cue(:,1) - tcue < RAWDATA(locs(n))+1 & R.cue(:,1) - tcue > RAWDATA(locs(n)) - 1);
        if isempty(ans) == 0
            CUE(n) = ans;
        end
    end
    
    cd 'C:\Users\Julie\Documents\MATLAB\BreathSounds\PneumoData'
    save(filename,'CUE','-append')
end

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
