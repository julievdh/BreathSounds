% figure out time delay between tt133z and pneumotach files trial 4 and 6
close all; clear all; clc
%% Load Data
% load tag file and calibration information
tag = 'tt15_133z';
path = 'D:\tt15\tt15_133z\';
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
figure(1); clf; hold on
t = (1:length(p))/fs;
plot(t,A(:,1))
xlabel('Time (s) since tag on')

% % plot time of day from tag deployment
% % figure(2); clf; hold on
% % for i = 1:length(t)
% % tvec(i) = addtodate(datenum(DEPLOY.TAGON.TIME),t(i)/60,'min');
% % end
% % 
% % plot(tvec,A(:,1))

%% load respirometry files
Trial04 = load('E:\2015_Pneumotach\Sarasota2015-Trial04-F133-13May2015-OnDeck');
Trial04.FilteredFlow = Trial04.data(Trial04.datastart(9,2):Trial04.dataend(9,2));

Trial06 = load('E:\2015_Pneumotach\Sarasota2015-Trial06-F133-13May2015-OnDeck');
Trial06.FilteredFlow = Trial06.data(Trial06.datastart(9):Trial06.dataend(9));

%%
% find time in tag record when trial starts
% block time from labchart matlab converted to UTC
tcue4 = etime(datevec(addtodate(Trial04.blocktimes(2),4,'hour')), DEPLOY.TAGON.TIME);
tcue6 = etime(datevec(addtodate(Trial06.blocktimes,4,'hour')), DEPLOY.TAGON.TIME);

%% Plot flow and dtag audit at the same time
figure(2); clf; hold on
pneumo_t = (1:length(Trial04.FilteredFlow))/400;
plot(pneumo_t,Trial04.FilteredFlow)
xlabel('Time (s)'); ylabel('Flow rate (L/s)')

% plot all audit marks
for n = 1:length(R.cue)
line([R.cue(n)-tcue4 R.cue(n)-tcue4],[0 1],'color','k')
end

% TO AUTOMATE: DO A SEARCH THROUGH R.STYPE AND FIND PNEUMOTACH IN STRINGS
% USE THOSE CUES HERE
line([R.cue(3)-tcue4 R.cue(3)-tcue4],[0 1],'color','g') % pneumotach on
line([R.cue(122)-tcue4 R.cue(122)-tcue4],[0 1],'color','r') % pneumotach off
line([R.cue(171)-tcue4 R.cue(171)-tcue4],[0 1],'color','g') % pneumotach ofn

% time difference between two trials (Trial06 and Trial04)
tcue_diff = etime(datevec(addtodate(Trial06.blocktimes,4,'hour')),datevec(addtodate(Trial04.blocktimes(2),4,'hour')));

% plot Trial06 with later delay
pneumo_t = (1:length(Trial06.FilteredFlow))/400;
plot(pneumo_t+tcue_diff,Trial06.FilteredFlow)

%% WANT TO SAVE TCUES SOMEWHERE FOR FUTURE REFERENCE
%% USE THE LABCHART TIMESTAMPS INSTEAD OF THE MANUAL ENTRY IN DEPLOY STRUCTURE 
