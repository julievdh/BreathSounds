% Already need to have loaded individual data files 
% Use ProcessRESP_Sarasota.m

figure(2); clf; hold on
plot(RAWDATA_1(:,1),RAWDATA_1(:,2),'m')

% RAWDATA file starts at 2014 5 8 14 44 03
% first number = 120 (RAWDATA_1 starts at 120 s into file)
% mark beginning of file A
A_start = etime([2014 5 8 18 08 24],[2014 5 8 18 07 28]);
plot([A_start A_start],[-20 60],'y')

% mark end of file A
A_end = etime([2014 5 8 18 09 31],[2014 5 8 18 07 28]);
plot([A_end A_end],[-20 60],'k')

% A end is actually a bit sooner:
A_end = 118;
plot([A_end A_end],[-20 60],'k')

% mark beginning of file B
B_start = etime([2014 5 8 18 09 58],[2014 5 8 18 07 28]);
plot([B_start B_start],[-20 60],'b')

% mark end of file B
B_end = etime([2014 5 8 18 19 27],[2014 5 8 18 07 28]);
plot([B_end B_end],[-20 60],'c')


legend('DATA','A start','A end','A end','B start','B end')
%% BETWEEN A END AND B START:
% Find difference between start of B and end of A, and consider that file
% _B starts at 20
padAB = B_start - A_end;

% add the pad
RAWDATA_1(12321:12321+padAB*200,:) = 0;
for i = 12321:12321+(padAB*200)
RAWDATA_1(i,1) = RAWDATA_1(i-1,1) + (1/200);
end

plot(RAWDATA_1(:,1),RAWDATA_1(:,2),'k')

test = RAWDATA_2(:,1) + padAB + RAWDATA_1(12321,1);

RAWDATA_2(:,1) = test;
plot(RAWDATA_2(:,1),RAWDATA_2(:,2),'g')

RAWDATA = vertcat(RAWDATA_1,RAWDATA_2);

plot(RAWDATA(:,1),RAWDATA(:,2),'b')

%% CONCATENATE AND SAVE
% concatenate summary and raw files together
SUMMARYDATA = vertcat(SUMMARYDATA_1,SUMMARYDATA_2);

% create filename for saving
i = 6;
filename = strcat(Sarasota{i,2},'_resp');

% specify directory to save
cd 'C:\Users\Julie\Documents\MATLAB\BreathSounds\PneumoData'

% save file
save(filename,'filename','RAWDATA','SUMMARYDATA')

