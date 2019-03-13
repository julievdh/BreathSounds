% Load in Tag and Pneumotach data
% Correct offset of times
% Align datasets and find matched cues for each time series

% 13 Aug 2014

close all; 
% set file number
if exist('f','var'),
    keep f
else 
f = 4;
end

% Load DQ File Data Structure
load('DQFiles')



% set path, tag
% hdd = driveletter('DQ');
% path = strcat(hdd,':/',DQ{i,1}(1:4),'/',DQ{i,1},'/');
tag = DQ{f,1};
% settagpath('audio',path(1:3));
% settagpath('cal','C:\tag\cal');
% settagpath('prh',[path 'prh\'],'raw',[path 'raw\'],...
%     'audit',[path 'audit\'])
recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);

% load respiration data .mat files
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
filename = strcat(DQ{f,2},'_resp');
load(filename)
%%
% concatenate to bring all respiratory data together for deployment
all_RAWDATA = vertcat(pre_RAWDATA,post_RAWDATA);
all_SUMMARYDATA = vertcat(pre_SUMMARYDATA,post_SUMMARYDATA);

% return to other directory
cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\

return 

%% IF tcue DOESN'T ALREADY EXIST FROM IMPORTED FILE: recalculate
if exist('tcue') ~= 1
% find time in tag record when trial starts
tcue = etime(DEPLOY.TRIAL.STARTTIME, DEPLOY.TAGON.TIME);
end 
%% check and make sure that breaths are at the right time
figure(12); clf
plot(all_RAWDATA(:,1),all_RAWDATA(:,2),'LineWidth',2); hold on
for n = 1:length(R.cue)
    line([R.cue(n)-tcue R.cue(n)-tcue],[0 50],'color','k')
    text(R.cue(n)-tcue,55,num2str(n))
end
xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)

% find peaks in flow rate signal
[pks,locs] = findpeaks(all_RAWDATA(:,2),'minpeakheight',4,'minpeakdistance',300);
% plot detected peaks
plot(all_RAWDATA(locs,1),pks,'ko')


%% observe offset and correct
if exist('CUE') ~= 1
    
    disp('Select cue then matching breath')
    
    ginput(2)
    offset = floor(ans(2,1) - ans(1,1));
    tcue = tcue-offset;
    %%
    figure(12)
    plot(all_RAWDATA(:,1),all_RAWDATA(:,2),'LineWidth',2); hold on
    for n = 1:length(R.cue)
        line([R.cue(n)-tcue R.cue(n)-tcue],[0 50],'color','r')
        text(R.cue(n)-tcue,51,num2str(n))
    end
    xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)
    xlim([0 max(R.cue(:,1))-tcue])
    
    
    %% determine breaths where have CUE and PNEUMO
    
    % check to see if detected peaks are same length as summary data
    disp('Did we find the same peaks?')
    disp(isequal(length(pks),length(all_SUMMARYDATA)))
    
    [CUE,mind] = nearest(R.cue(:,1)-tcue,all_RAWDATA(locs,1),5);
    
    save([cd '\PneumoData\' filename],'CUE','tcue','-append')
end


%% cut
for i = 1:length(locs)
    figure(2); hold on
    cuts(i).flow = all_RAWDATA(locs(i)-150:locs(i)+250,:);
    plot(cuts(i).flow(:,2))
end

xlabel('Time (sec)'); ylabel('Flow Rate (L/sec')

save([cd '\PneumoData\' filename],'cuts','-append')



return

%% PLOT
CUE_S = find(CUE);
CUE_R = CUE(find(CUE));
figure(3); hold on
plot(R.cue(CUE_R,1)-tcue,all_SUMMARYDATA(CUE_S,:),'.')
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

figure(2)
plot(-all_SUMMARYDATA(CUE_S,4),eParams.Fmax(CUE_R),'mo')

return

figure(3)
plot(R.cue(CUE_R,1)-tcue,eParams.Fcent(CUE_R)/1000,'g.')
legend('End Tidal O_2','End Tidal CO_2','Max Insp Flow','Max Exp Flow','Tidal Volume','Centroid Frequency','Location','WestOutside')


% PLOT SUMMARY DATA
figure(4)
[H,AX,BigAx,P]=plotmatrix(all_SUMMARYDATA);
set(get(BigAx,'title'),'string',regexprep(tag,'_',' '))
set(get(BigAx,'xlabel'),'string',{'End Tidal O_2       End Tidal CO_2      Max Insp Flow Rate       Max Exp Flow Rate       Tidal Volume'})

% PLOT COMBINED
figure(6)
subplot(221)
title(regexprep(tag,'_',' '))
plot(eParams.Fcent(CUE_R)/1000,all_SUMMARYDATA(CUE_S,:),'.')
xlabel('Centroid Frequency (kHz)')
subplot(222)
plot(eParams.RMS(CUE_R)/1000,all_SUMMARYDATA(CUE_S,:),'.')
xlabel('RMS Amplitude');
subplot(223)
plot(eParams.EFD(CUE_R)/1000,all_SUMMARYDATA(CUE_S,:),'.')
xlabel('Energy Flux Density')
subplot(224)
plot(eParams.pp(CUE_R)/1000,all_SUMMARYDATA(CUE_S,:),'.')
xlabel('Peak to Peak Amplitude')

% PLOT WHAT WE EXPECT TO CORRELATE
% FCENT and FLOW RATES
figure(7)
subplot(131)
plot(eParams.Fcent(CUE_R)/1000,all_SUMMARYDATA(CUE_S,4),'.')
hold on
plot(iParams.Fcent(CUE_R)/1000,all_SUMMARYDATA(CUE_S,3),'g.')
xlabel('Centroid Frequency (kHz)')
ylabel('Flow Rate')
legend('Expiration','Inspiration','Location','Best')
subplot(132)
plot(eParams.EFD(CUE_R)/1000,all_SUMMARYDATA(CUE_S,4),'.')
hold on
plot(iParams.EFD(CUE_R)/1000,all_SUMMARYDATA(CUE_S,3),'g.')
xlabel('Energy Flux Density')
ylabel('Flow Rate')
legend('Expiration','Inspiration','Location','Best')

subplot(133)
plot(eParams.pp(CUE_R)/1000,all_SUMMARYDATA(CUE_S,4),'o')
hold on
plot(iParams.pp(CUE_R)/1000,all_SUMMARYDATA(CUE_S,3),'go')
plot(eParams.RMS(CUE_R)/1000,all_SUMMARYDATA(CUE_S,4),'b.')
plot(iParams.RMS(CUE_R)/1000,all_SUMMARYDATA(CUE_S,3),'g.')
xlabel('Centroid Frequency (kHz)')
ylabel('Flow Rate')
legend('PP Expiration','PP Inspiration','RMS Expiration','RMS Inspiration','Location','Best')

% EFD AND VT
figure(8)
subplot(121)
plot(eParams.time_window(CUE_R)/1000,all_SUMMARYDATA(CUE_S,5),'.')
hold on
plot(iParams.time_window(CUE_R)/1000,all_SUMMARYDATA(CUE_S,5),'g.')
xlabel('95% Energy Duration (s)')
ylabel('Tidal Volume (L)')
legend('Expiration','Inspiration','Location','Best')


subplot(122)
plot(eParams.EFD(CUE_R)/1000,all_SUMMARYDATA(CUE_S,5),'.')
hold on
plot(iParams.EFD(CUE_R)/1000,all_SUMMARYDATA(CUE_S,5),'g.')
xlabel('Energy Flux Density')
ylabel('Tidal Volume (L)')
legend('Expiration','Inspiration','Location','Best')


%%
figure(10)
plotmatrix(horzcat(eParams.RMS(CUE_R)',eParams.pp(CUE_R)',eParams.EFD(CUE_R)',eParams.Fcent(CUE_R)',all_SUMMARYDATA(CUE_S,:)))
title(strcat(regexprep(tag,'_',' '),'  Expiration'))

figure(11)
plotmatrix(horzcat(iParams.RMS(CUE_R)',iParams.pp(CUE_R)',iParams.EFD(CUE_R)',iParams.Fcent(CUE_R)',all_SUMMARYDATA(CUE_S,:)))
title(strcat(regexprep(tag,'_',' '),'  Inspiration'))
