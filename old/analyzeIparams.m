close all; clear all; clc
%% LOAD IN TAG DATA

% set path, tag
% change tag and path for different deployments
tag = 'tt14_125a';
path = 'E:\tt14\tt14_125a\';

settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
    'audit',[path 'audit\'])
recdir = d3makefname(tag,'RECDIR');

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);


%% LOOP THROUGH ALL BREATHS AUDITED

% do params and quality already exist?
cd([path 'audit\'])
list = ls('*.mat');
if isempty(strfind(list,strcat(tag,'_PQ'))) >= 1
    % if not, establish Params and Quality
    eParams = [];
    iParams = [];
    tParams = [];
    sParams = [];
    Quality = nan(length(R.cue),1);
else if isempty(strfind(list,strcat(tag,'_PQ'))) == 0
        load(strcat(tag,'_PQ'))
    end
end
if exist('exp') ~= 1
    exp = nan(length(R.cue),2);
    ins = nan(length(R.cue),2);
    srf = nan(length(R.cue),2);
end
if exist('btype') == 0
    btype = zeros(length(R.cue),3);
end

%% analyze eParams 
start=58;
I=find(iParams.Fmax(start:end))+(start-1);
plot(iParams.Fmax(I),'.')
figure
hist(iParams.Fmax(I))

max(iParams.Fmax(I))
min(iParams.Fmax(I))
mean(iParams.Fmax(I))
median(iParams.Fmax(I))

clear I
start=58;
I=find(iParams.Fcent(start:end))+(start-1);
max(iParams.Fcent(I))
min(iParams.Fcent(I))
mean(iParams.Fcent(I))
median(iParams.Fcent(I))

clear I
start=58;
I=find(iParams.time_window(start:end))+(start-1);
max(iParams.time_window(I))
min(iParams.time_window(I))
mean(iParams.time_window(I))
median(iParams.time_window(I))