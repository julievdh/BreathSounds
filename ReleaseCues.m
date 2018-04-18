% PLOT RELEASE CUES TO CHECK 

%% LOAD IN TAG DATA

% set path, tag
% change tag and path for different deployments
tag = 'tt14_125b';
path = 'E:\tt14\tt14_125b\';

settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
    'audit',[path 'audit\'])
recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);

loadprh(tag)

%% GENERATE PLOT

% set time vector
t = (1:length(p))/fs;

figure(1); hold on
plot(t,-p)
xlabel('Time (s)'); ylabel('Depth (m)')
title(regexprep(tag,'_',' '))
adjustfigurefont

%% GET CUES AND PLOT

tstartcue = floor(etime(DEPLOY.TRIAL.STARTTIME,DEPLOY.TAGON.TIME));
plot([tstartcue tstartcue],[-2 2],'r')
tendcue = floor(etime(DEPLOY.TRIAL.ENDTIME,DEPLOY.TAGON.TIME));
plot([tendcue tendcue],[-2 2],'r')
trelease = floor(etime(DEPLOY.TAGON.RELEASE,DEPLOY.TAGON.TIME));
plot([trelease trelease],[-2 2],'r')

%% ADD SAM'S AUDIT WITH HER CUES
plot(R.cue(1:57,1),zeros(length(1:57),1),'r.')
plot(R.cue(58:end,1),zeros(length(R.cue(58:end,1)),1),'g.')

%% FIND RELEASE CUES WITH ALGORITHM INSTEAD
ii = find(R.cue(:,1) < trelease); 
plot(R.cue(ii,1),zeros(length(ii)),'ro')
plot(R.cue(ii(end)+1:end,1),zeros(length(R.cue(ii(end)+1:end,1)),1),'go')