clc
% figure out time delay between tt135z and pneumotach files trial 4 and 6
close all; clear all; clc

%% load tag file and calibration information
tag = 'tt15_135z';
path = 'E:\tt15\tt15_135z\';
settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
    'audit',[path 'audit\'])

% load calibration and deployment information
[CAL,DEPLOY] = d3loadcal(tag);

% load prh
loadprh(tag)

% load audit
R = loadaudit(tag);

%% plot tag deployment
% figure(1); clf; hold on
% t = (1:length(p))/fs;
% plot(t,A(:,1))
% xlabel('Time (s) since tag on')

% % plot time of day from tag deployment
% % figure(2); clf; hold on
% % for i = 1:length(t)
% % tvec(i) = addtodate(datenum(DEPLOY.TAGON.TIME),t(i)/60,'min');
% % end
% % 
% % plot(tvec,A(:,1))

%% load respirometry file
load('E:\2015_Pneumotach\Sarasota2015-Trial12-F193-15May2015-InWater,BeforeOnDeck')
FilteredFlow = data(datastart(9,2):dataend(9,2));

%%
% find time in tag record when trial starts
tcue = etime(DEPLOY.TRIAL.STARTTIME, DEPLOY.TAGON.TIME);

%% plot
figure(2); clf; hold on
pneumo_t = (1:length(FilteredFlow))/400;
plot(pneumo_t,FilteredFlow)
xlabel('Time (s)'); ylabel('Flow rate (L/s)')

for n = 1:length(R.cue)
line([R.cue(n)-tcue R.cue(n)-tcue],[0 1],'color','k')
end

% TO AUTOMATE: DO A SEARCH THROUGH R.STYPE AND FIND PNEUMOTACH IN STRINGS
% USE THOSE CUES HERE
line([R.cue(2)-tcue R.cue(2)-tcue],[0 1],'color','g') % pneumotach on
line([R.cue(23)-tcue R.cue(23)-tcue],[0 1],'color','r') % pneumotach off

%% observe offset and correct
if exist('CUE') ~= 1
    set(gcf,'position',[520 380 1080 420])
    
    disp('Select cue then matching breath')
    
    ginput(2)
    offset = floor(ans(2,1) - ans(1,1));
    tcue = tcue-offset;
    
    figure(1)
    plot(pneumo_t,FilteredFlow,'LineWidth',2); hold on
    for n = 1:length(R.cue)
        line([R.cue(n)-tcue R.cue(n)-tcue],[0 1],'color','r')
        text(R.cue(n)-tcue,1.5,num2str(n))
    end
    xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)
    xlim([0 max(R.cue(:,1))-tcue])
    
    
    %% determine breaths where have CUE and PNEUMO
    % find peaks in flow rate signal
    [pks,locs] = findpeaks(FilteredFlow,'minpeakheight',0.3,'minpeakdistance',300);
    
    % check to see if detected peaks are same length as summary data
%     disp('Did we find the same peaks?')
%     disp(isequal(length(pks),length(SUMMARYDATA)))
%     
    % plot detected peaks
    plot(pneumo_t(locs),pks,'ko')
    
    % find BREATHS and CUES at same time
    clear CUE
    for n = 1:length(pks)
        find(R.cue(:,1) - tcue < pneumo_t(locs(n))+2 & R.cue(:,1) - tcue > pneumo_t(locs(n)) - 2);
        if isempty(ans) == 0
            CUE(n) = ans;
        end
    end
    
   % FIGURE OUT WHEN PNEUMOTACH IS OFF AND DONT INCLUDE ANY RESP DATA FROM
   % AFTER THAT
   
    
    cd 'C:\Users\Julie\Documents\MATLAB\BreathSounds\PneumoData'
    save(filename,'CUE','-append')
end

% SAVE CUE AND OFFSET OR SOMETHING LIKE THAT
% TURN THIS INTO A FUNCTION THAT ALIGNS 2015 DATA
