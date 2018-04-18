% Load in Tag and Pneumotach data
% Correct offset of times
% Align datasets and find matched cues for each time series

% 13 Aug 2014


close all; 

close all; 
% set file number
if exist('f','var'),
    keep f
else 
f = 16; % set file number
end

% Load DQ File Data Structure
load('DQFiles2017')

% set path, tag
% hdd = driveletter('DQ');
% path = strcat(hdd,':/',DQ{i,1}(1:4),'/',DQ{i,1},'/');
tag = DQ2017{f,1};
recdir = d3makefname(tag,'RECDIR');


filename = strcat(DQ2017{f,2},'_resp');
load([cd '\PneumoData\' filename])

% load calibration and deployment info, tag audit
% load respiration data
% cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
% filename = strcat(DQ2017{f,2},'-RAW_DATA.txt');
% RAW_DATA = importRAWDATA(filename);
% RAW_DATA(:,1) = RAW_DATA(:,1) - RAW_DATA(1,1); % start it at zero
% filename = strcat(DQ2017{f,2},'-DATA_SUMMARY.txt');
% all_SUMMARYDATA = importDATASUMMARY(filename);
% filename = strcat(DQ2017{f,2},'-RESP_TIMING.txt');
% RESPTIMING = importRESPTIMING(filename);

% load audit data
R = loadaudit(tag);
[~,breath] = findaudit(R,'breath');

return 
% return to other directory
% cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\

%% IF tcue DOESN'T ALREADY EXIST FROM IMPORTED FILE: recalculate
if exist('tcue') ~= 1
    % find time in tag record when trial starts
    [CAL,DEPLOY] = d3loadcal(tag);
    tcue = etime(DEPLOY.TRIAL.STARTTIME, DEPLOY.TAGON.TIME);
end

%% check and make sure that breaths are at the right time
PneumCueTimeline

% find peaks in flow rate signal
[pks,locs] = findpeaks(RAW_DATA(:,3),'minpeakheight',8,'minpeakdistance',300);
% plot detected peaks
plot(RAW_DATA(locs,1),pks,'ko')


%% observe offset and correct
if exist('CUE') ~= 1
    % xlim([5 R.cue(8)-tcue]) % for zoom purposes
    
    disp('Select cue then matching breath')
    
    ginput(2)
    offset = floor(ans(2,1) - ans(1,1));
    tcue = tcue-offset;
    
    figure(11)
    plot(RAW_DATA(:,1),RAW_DATA(:,3),'LineWidth',2); hold on
    for n = 1:length(R.cue)
        line([R.cue(n)-tcue R.cue(n)-tcue],[0 50],'color','r')
        text(R.cue(n)-tcue,55,num2str(n))
    end
    xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)
    xlim([0 max(R.cue(:,1))-tcue])
    
    % want to check exhales?
    [~,exh] = findaudit(R,'exh');
    for n = 1:length(exh.cue)
        line([exh.cue(n)-tcue exh.cue(n)-tcue],[0 50],'color','g')
        text(exh.cue(n)-tcue,45,num2str(n),'color','g')
    end
    %% determine breaths where have CUE and PNEUMO
        
    % check to see if detected peaks are same length as summary data
    disp('Did we find the same peaks?')
    disp(isequal(length(pks),length(all_SUMMARYDATA)))
    
    % find BREATHS and CUES at same time
    clear CUE
    %     for n = 1:length(pks)
    %         find(breath.cue(:,1) - tcue < RAW_DATA(locs(n))+1 & breath.cue(:,1) - tcue > RAW_DATA(locs(n)) - 1);
    %         if isempty(ans) == 0
    %             CUE(n) = ans;
    %         end
    %     end
    % instead, use this and check:
    [ECUE,mind] = nearest(exh.cue(:,1)-tcue,RAW_DATA(locs,1),5);
    [CUE,mind] = nearest(breath.cue(:,1)-tcue,RAW_DATA(locs,1),5);
    
    filename = strcat(DQ2017{f,2},'_resp');
    save([cd '\PneumoData\' filename],'CUE','ECUE','tcue','all_SUMMARYDATA','RAW_DATA','RESPTIMING')
    
    
    end
%% cut
    figure(2); clf, hold on
for i = 1:length(locs)
    cuts(i).flow = -RAW_DATA(locs(i)-700:locs(i)+300,:);
    plot(cuts(i).flow(:,3))
end

xlabel('Time (sec)'); ylabel('Flow Rate (L/sec')
save(filename,'cuts','-append')
   
    
    return

    % of if locs all off:
    for i = 1:length(RESPTIMING)
cuts(i).flow = (-RAW_DATA(RESPTIMING(i,1)-200:RESPTIMING(i,4)+200,:));
plot(cuts(i).flow(:,3))

end

%% PLOT
CUE_S = find(CUE);
CUE_R = CUE(find(CUE));
figure(3); clf, hold on
plot(R.cue(CUE_R,1)-tcue,all_SUMMARYDATA(CUE_S,1:6),'.','markersize',10)
legend('End Tidal O_2','End Tidal CO_2','Max Insp Flow','Max Exp Flow','Tidal Volume E','Tidal Volume I','Location','WestOutside')
title(regexprep(tag,'_',' '))
xlabel('Time (s)')
adjustfigurefont



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
