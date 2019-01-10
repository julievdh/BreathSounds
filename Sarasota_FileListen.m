close all; clear all; clc
%% Load Data
% load tag file and calibration information
tag = 'tt15_134a';
path = 'D:\tt15\tt15_134a\';
settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
    'audit',[path 'audit\'])

% load calibration and deployment information
[CAL,DEPLOY] = d3loadcal(tag);

% load audit
R = loadaudit(tag);
% Run audit
R = d3tagaudit(tag,1,R);