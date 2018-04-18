%% LOAD IN TAG DATA

close all; clear all; 

% set path, tag
% change tag and path for different deployments
tag = 'tt13_283a';
path = 'E:\tt13\tt13_283a\';

settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
    'audit',[path 'audit\'])
recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);

%% PLOT ACCELEROMETER BEFORE TRIAL START

tstarttrial = floor(etime(DEPLOY.TRIAL.STARTTIME,DEPLOY.TAGON.TIME));
tendtrial = floor(etime(DEPLOY.TRIAL.ENDTIME,DEPLOY.TAGON.TIME));

loadprh(tag)
plot(A); hold on
line([tstarttrial*fs tstarttrial*fs],[-2.5 2.5],'color','k')
%plot(A(1:tstarttrial,:))

for i = 1:length(R.cue)
plot(R.cue(i)*20,2,'k.')
end

line([tendtrial*fs tendtrial*fs],[-2.5 2.5],'color','k')
