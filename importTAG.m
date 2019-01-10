function [TAG] = importTAG(tag,directory,prh)
% if prh = 1, then load prh file too
path = strcat(directory,':/',tag(1:4),'/',tag,'/');

[R]=loadR(tag, path);
if prh == 1
    loadprh(tag)
end
%% Load params
cd([path 'audit\'])
TAG = load(strcat(tag,'_PQ.mat'));
% ZeroBreaths % may no longer work on struct, but also may not be needed 
TAG = orderfields(TAG);

% add to structure
TAG.name = tag;

TAG.R = R;
TAG.p = p;
TAG.A = A;
TAG.fs = fs;