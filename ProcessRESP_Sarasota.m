% PROCESS RESPIROMETRY DATA
clear all; close all;

load('SarasotaFiles')

for i = 6
%% GOING TO HAVE TO HANDLE FILES WHERE MORE THAN ONE RAW/SUMMARY FILE EXISTS
% all are in multiples of 3
cd 'D:\Pneumotach\AnalyzedData\'
d = dir(strcat(Sarasota{i,2},'*'));

if length(d) <= 3
    
% load respiration data: raw
filename = strcat(Sarasota{i,2},'-RAW_DATA.txt');
RAWDATA = importRAW(filename);

%%
% load respiration data: summary 
filename = strcat(Sarasota{i,2},'-DATA_SUMMARY.txt');
SUMMARYDATA = importSUMMARY(filename);

% create filename for saving
filename = strcat(Sarasota{i,2},'_resp');

% specify directory to save
cd 'C:\Users\Julie\Documents\MATLAB\BreathSounds\PneumoData'

% save file
save(filename,'filename','RAWDATA','SUMMARYDATA')
end

% % if there are more files (A, B, C) that need to be imported and
% % concatenated:
% if length(d) > 3
%     % calculate number of repetitions needed
%     REPEAT = length(d)/3;
%     LETTERS = {'A','B','C','D'};
%     COUNT = 1; 
%     while COUNT <= REPEAT
%     filename = strcat(Sarasota{i,2},'_',LETTERS(COUNT),'-RAW_DATA.txt');
%     eval(['RAWDATA_' num2str(COUNT) ' = importRAW(filename)']);
%     COUNT = COUNT+1;
%     end
% end
end

return

%% FOR WHEN FILES NEED TO BE CONCATENATED

cd 'D:\Pneumotach\AnalyzedData\'
d = dir(strcat(Sarasota{i,2},'*'));
size(d)

%% load respiration data: raw
filename = strcat(Sarasota{i,2},'_A-RAW_DATA.txt');
RAWDATA_1 = importRAW(filename);
% load respiration data: summary
filename = strcat(Sarasota{i,2},'_A-DATA_SUMMARY.txt');
SUMMARYDATA_1 = importSUMMARY(filename);

%%
filename = strcat(Sarasota{i,2},'_B-RAW_DATA.txt');
RAWDATA_2 = importRAW(filename);
% load respiration data: summary
filename = strcat(Sarasota{i,2},'_B-DATA_SUMMARY.txt');
SUMMARYDATA_2 = importSUMMARY(filename);

% % ALIGN TEMPORALLY, CONCATENATE AND CHECK
% RAWDATA_2(:,1) = RAWDATA_2(:,1)+(length(RAWDATA_1)/200);
% 
% SUMMARYDATA = vertcat(SUMMARYDATA_1,SUMMARYDATA_2);
% RAWDATA = vertcat(RAWDATA_1,RAWDATA_2);
% 
% plot(RAWDATA(:,1))

%%
filename = strcat(Sarasota{i,2},'_C-RAW_DATA.txt');
RAWDATA_3 = importRAW(filename);
% load respiration data: summary
filename = strcat(Sarasota{i,2},'_C-DATA_SUMMARY.txt');
SUMMARYDATA_3 = importSUMMARY(filename);

%%
% RAWDATA_3(:,1) = RAWDATA_3(:,1)+(length(RAWDATA)/200);

SUMMARYDATA = vertcat(SUMMARYDATA_1,SUMMARYDATA_2,SUMMARYDATA_3);
RAWDATA = vertcat(RAWDATA_1,RAWDATA_2,RAWDATA_3);

plot(RAWDATA(:,1))

%%
filename = strcat(Sarasota{i,2},'_D-RAW_DATA.txt');
RAWDATA_4 = importRAW(filename);
% load respiration data: summary
filename = strcat(Sarasota{i,2},'_D-DATA_SUMMARY.txt');
SUMMARYDATA_4 = importSUMMARY(filename);

%%
SUMMARYDATA = vertcat(SUMMARYDATA_1,SUMMARYDATA_2,SUMMARYDATA_3,SUMMARYDATA_4);
RAWDATA = vertcat(RAWDATA_1,RAWDATA_2,RAWDATA_3,RAWDATA_4);


%% create filename for saving
filename = strcat(Sarasota{i,2},'_resp');

% specify directory to save
cd 'C:\Users\Julie\Documents\MATLAB\BreathSounds\PneumoData'

% save file
save(filename,'filename','RAWDATA','SUMMARYDATA')