% Loop together all breaths in a deployment to calculate breath sound
% parameters
% Calls upon BreathFilt and BreathParams

% Julie van der Hoop // April 2014 
% Last Updated: 14 June 2014

close all; clear all;

%% LOAD IN TAG DATA

% set path, tag
% change tag and path for different deployments
tag = 'tt13_269b';
path = 'D:\tt13\tt13_269b\';

settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
    'audit',[path 'audit\'])
recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);


%% LOOP THROUGH ALL BREATHS AUDITED

% establish Params
Params = [];

% loop through all breaths (= length of R.cue)
for i = 1:length(R.cue); % 1:length(R.cue);
    
    % downsample and filter single breath
    [x,xfilt] = BreathFilt(i,R,recdir,tag,1);
    
    % Obtain parameters for this one breath
    [Params] = BreathParams(xfilt,i,Params,R);
   
end

% USEFUL:
% p = audioplayer(xfilt, 60000);
% play(p)

