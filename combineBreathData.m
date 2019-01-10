% for all files in DQ
load('DQfiles2017')
alleVT = []; alledur = []; allEmaxflow = []; fcount = []; 
alliVT = []; allidur = []; allImaxflow = []; 
for f = [16:25 27]; %[16 18 19 20 21 24 25]; % file 17
% pull in the resp data
%[all_SUMMARYDATA,RESPTIMING] = importRESP(DQ2017{f,2});
filename = strcat(DQ2017{f,2},'_resp');
load([cd '\PneumoData\' filename])
if f == 17
    RESPTIMING = RESPTIMING(1:47,:); 
end

if f == 22
    RESPTIMING = RESPTIMING(1:23,:); 
end

% store it
alleVT = vertcat(alleVT,abs(all_SUMMARYDATA(:,5))); 
alliVT = vertcat(alliVT,abs(all_SUMMARYDATA(:,6))); 
alledur = vertcat(alledur,RESPTIMING(:,6));
allidur = vertcat(allidur,RESPTIMING(:,7));
allEmaxflow = vertcat(allEmaxflow,all_SUMMARYDATA(:,4)); % exhaled flow rate
allImaxflow = vertcat(allImaxflow,abs(all_SUMMARYDATA(:,3))); % inhaled flow rate
fcount = vertcat(fcount,zeros(length(all_SUMMARYDATA),1)+f); 


clear all_SUMMARYDATA RESPTIMING
end

% mesh afterwards
% plot3tomesh(alleVT,alledur,allmaxflow,19);
