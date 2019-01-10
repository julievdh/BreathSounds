% Load in Tag and Pneumotach data
% Correct offset of times
% Align datasets and find matched cues for each time series

% Created: 13 Aug 2014 % Updated: 19 June 2017

close all; clear ; % clc

% Load DQ File Data Structure
load('DQFiles2017')

% set file number
f = 10;

% set path, tag
% hdd = driveletter('DQ');
% path = strcat(hdd,':/',DQ{i,1}(1:4),'/',DQ{i,1},'/');
tag = DQ2017{f,1};
recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);

% load respiration data .mat files
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\ChestBand'
filename = strcat(DQ2017{f,2});
load(filename)
% parse
for i = 1:size(titles,1)
    v = genvarname(titles(i,:));
    eval(strcat(v, ' = data(datastart(', num2str(i), '):dataend(', num2str(i), '));'));
end
flowt = (1:length(FilteredFlow))/tickrate; % time in seconds for flow 

% return to other directory
cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\

%% IF tcue DOESN'T ALREADY EXIST FROM IMPORTED FILE: recalculate
if exist('tcue') ~= 1
% find time in tag record when trial starts
tcue = etime(datevec(addtodate(blocktimes,10,'h')), DEPLOY.TAGON.TIME);
end 
%% check and make sure that breaths are at the right time
figure(1); clf
plot(flowt,FilteredFlow,'LineWidth',2); hold on
% find pneumotach cues
[~,pneum] = findaudit(R,'pneum');
for n = 1:length(pneum.cue(:,1))
    line([pneum.cue(n,1)-tcue pneum.cue(n,1)-tcue],[0 50],'color','g')
end
% plot all breaths
[~,breath] = findaudit(R,'breath');
for n = 1:length(breath.cue)
    line([breath.cue(n,1)-tcue breath.cue(n,1)-tcue],[0 50],'color','k')
    text(breath.cue(n,1)-tcue,50,num2str(n))
end
xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)

%% find peaks in flow rate signal
% because EXP = Negative now, have to detect troughs, so flip
[pks,locs] = findpeaks(-FilteredFlow,flowt,'minpeakheight',15,'minpeakdistance',2);
% plot detected peaks
plot(locs,-pks,'ko')


%% observe offset and correct
if exist('CUE') ~= 1
    xlim([5 R.cue(8)-tcue]) % for zoom purposes
    
    disp('Select cue then matching breath')
    %%
    ginput(2)
    offset = floor(ans(2,1) - ans(1,1));
    tcue = tcue-offset;
    
    figure(1)
    plot(flowt,FilteredFlow,'LineWidth',2,'color','k'); hold on
    for n = 1:length(breath.cue)
        line([breath.cue(n,1)-tcue breath.cue(n,1)-tcue],[0 50],'color','r')
        text(breath.cue(n,1)-tcue,50,num2str(n))
    end
    xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)
    xlim([0 max(R.cue(:,1))-tcue])
    
    
   %% determine breaths where have CUE and PNEUMO
    
   % check to see if detected peaks are same length as summary data
   % disp('Did we find the same peaks?')
   % disp(isequal(length(pks),length(all_SUMMARYDATA)))
    
    % find BREATHS and CUES at same time: this used to be easier when all
    % breaths were pneumotach and sound. Now have to use NEAREST 
    clear CUE
    [CUE,mind] = nearest(breath.cue(:,1)-tcue,locs',1);
    
    cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\ChestBand'
    save(filename,'CUE','tcue','-append')
end

%% PLOT
CUE_S = find(CUE); 
CUE_R = CUE(find(CUE)); % sound cues
% figure(3); hold on
% plot(R.cue(CUE_R,1)-tcue,all_SUMMARYDATA(CUE_S,:),'.')
% legend('End Tidal O_2','End Tidal CO_2','Max Insp Flow','Max Exp Flow','Tidal Volume','Location','WestOutside')
% title(regexprep(tag,'_',' '))
% xlabel('Time (s)')
% adjustfigurefont

return

%% cut
for i = 1:length(locs)
    figure(2); hold on
    cuts(i).flow = FilteredFlow(locs(i)*tickrate-100:locs(i)*tickrate+200);
    plot(cuts(i).flow)
end

xlabel('Time (sec)'); ylabel('Flow Rate (L/sec')

% % plot only those that are sequential
% inc = diff(CUE_R) > 1;
% i1 = find(inc >= 1);
% if isempty(i1) == 0
%     seqbr1 = CUE_S(1:i1(1)); % first set
%     for i= 1:length(seqbr1)
%         plot(cuts(seqbr1(i)).flow(:,2),'r')
%     end
%
%     seqbr2 = CUE_S(i1(end)+1:end); % second set
%     for i= 1:length(seqbr2)
%         plot(cuts(seqbr2(i)).flow(:,2),'k')
%     end
% end

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
