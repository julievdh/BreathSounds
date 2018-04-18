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

%% analyze sParams
start=58;
I=find(sParams.Fmax(start:end))+(start-1);
plot(sParams.Fmax(I),'.')
figure
hist(sParams.Fmax(I))

max(sParams.Fmax(I))
min(sParams.Fmax(I))
mean(sParams.Fmax(I))
median(sParams.Fmax(I))

clear I
start=58;
I=find(sParams.Fcent(start:end))+(start-1);
max(sParams.Fcent(I))
min(sParams.Fcent(I))
mean(sParams.Fcent(I))
median(sParams.Fcent(I))

clear I
start=58;
I=find(sParams.time_window(start:end))+(start-1);
max(sParams.time_window(I))
min(sParams.time_window(I))
mean(sParams.time_window(I))
median(sParams.time_window(I))