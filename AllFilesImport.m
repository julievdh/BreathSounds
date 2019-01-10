function [S,D] = AllFilesImport(files);

% Loads in audited tag data for Breath Sounds Project
% stores calculated parameters: eParams, iParams, etc, Quality, audit cues
% also now p, t vectors

% OLD VERSION OF SAM'S NOW SAVED AS ALLFILESIMPORT_SAM
% AUG 13 2014

%% SARASOTA
if files == 1
load('SarasotaFiles')

for i = 1:size(Sarasota,1)
tag = Sarasota{i,1};
S(i) = importTAG(tag,'E',1);
end
end

if exist('S') == 0
    S = []; % make an empty array if sarasota files are being skipped
end

%% DQ
if files == 2
load('DQFiles')

for i = 1:size(DQ,1)
tag = DQ{i,1};
D(i) = importTAG(tag,'D',1);
end
end

if exist('D') == 0
    D = []; % make an empty array if DQ files are being skipped
end

