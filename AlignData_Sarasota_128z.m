% Already need to have loaded individual data files 
% Use ProcessRESP_Sarasota.m

figure(2); clf; hold on
plot(RAWDATA_1(:,1),RAWDATA_1(:,2),'m')

% RAWDATA file starts at 2014 5 8 14 44 03
% first number = 120 (RAWDATA_1 starts at 120 s into file)
% mark beginning of file A
plot([120 120],[-20 60],'y')

% mark end of file A
A_end = etime([2014 5 8 15 00 26],[2014 5 8 14 44 03]);
plot([A_end A_end],[-20 60],'k')

% A END IS ACTUALLY 675.6 IN TO DATA DUE TO PROBLEM WITH CO2 ANALYZER
A_end = 675.61;
plot([A_end A_end],[-20 60],'r')

% mark beginning of file B
B_start = etime([2014 5 8 15 01 31],[2014 5 8 14 44 03]);
plot([B_start B_start],[-20 60],'b')

% mark end of file B
B_end = etime([2014 5 8 15 06 34],[2014 5 8 14 44 03]);
plot([B_end B_end],[-20 60],'c')

% mark beginning of file C
C_start = etime([2014 5 8 15 07 06],[2014 5 8 14 44 03]);
plot([C_start C_start],[-20 60],'g')

% mark end of file C
C_end = etime([2014 5 8 15 13 25],[2014 5 8 14 44 03]);
plot([C_end C_end],[-20 60],'m')

legend('DATA','A start','A end','A end','B start','B end','C start','C end')
%% BETWEEN A END AND B START:
% Find difference between start of B and end of A, and consider that file
% _B starts at 20
padAB = B_start - A_end + 20;

% add the pad
RAWDATA_1(111123:111123+padAB*200,:) = 0;
for i = 111123:111123+(padAB*200)
RAWDATA_1(i,1) = RAWDATA_1(i-1,1) + (1/200);
end

plot(RAWDATA_1(:,1),RAWDATA_1(:,2),'m')

test = RAWDATA_2(:,1) + padAB - 20 + RAWDATA_1(111123,1);

RAWDATA_2(:,1) = test;
plot(RAWDATA_2(:,1),RAWDATA_2(:,2),'g')

RAWDATA = vertcat(RAWDATA_1,RAWDATA_2);

plot(RAWDATA(:,1),RAWDATA(:,2),'b')

%% BETWEEN B END AND C START:

% B_end is actually earlier (data trucated)
B_end = 1283;

padBC = C_start - B_end + 30;

% add the pad
RAWDATA_2(43112:43112+padBC*200,:) = 0;
for i = 43112:43112+(padBC*200)
RAWDATA_2(i,1) = RAWDATA_2(i-1,1) + (1/200);
end

plot(RAWDATA_2(:,1),RAWDATA_2(:,2),'g')

test = RAWDATA_3(:,1) + padBC - 30 + RAWDATA_2(43112,1);

RAWDATA_3(:,1) = test;

RAWDATA_TEST = vertcat(RAWDATA_1,RAWDATA_2,RAWDATA_3);

plot(RAWDATA_TEST(:,1),RAWDATA_TEST(:,2),'r')

%% CONCATENATE AND SAVE
% concatenate summary and raw files together
SUMMARYDATA = vertcat(SUMMARYDATA_1,SUMMARYDATA_2,SUMMARYDATA_3);
RAWDATA = RAWDATA_TEST;

% create filename for saving
i = 5;
filename = strcat(Sarasota{i,2},'_resp');

% specify directory to save
cd 'C:\Users\Julie\Documents\MATLAB\BreathSounds\PneumoData'

% save file
save(filename,'filename','RAWDATA','SUMMARYDATA')

