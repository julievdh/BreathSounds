% Descriptive Table
% Take descriptive statistics for parameters in different locations and put
% in table

load('AllBreaths_noPEAK')

DQO = find(BREATHONLY(:,15) == 1);
SARASOTA = find(BREATHONLY(:,15) == 2);

before = find(BREATHONLY(:,12) == 1);
after = find(BREATHONLY(:,12) == 2);

DQO_median = median(BREATHONLY(before,5));

% for all parameters
for j = 1:10
    % and all dolphin quest files
for i = 1:17
    % find breaths for a given file, at dolphin quest, before swim
    ind = find(BREATHONLY(:,13) == i & BREATHONLY(:,15) == 1 & BREATHONLY(:,12) == 1);
    DQO_md_before(i,j) = median(BREATHONLY(ind,j));
    % hist(BREATHONLY(ind,j))
end

for i = 1:17
    % find breaths for a given file, at dolphin quest, after swim
    ind = find(BREATHONLY(:,13) == i & BREATHONLY(:,15) == 1 & BREATHONLY(:,12) == 2);
    DQO_md_after(i,j) = median(BREATHONLY(ind,j));
    % hist(BREATHONLY(ind,5))
end
end


% figure(1); clf
% hist(BREATHONLY(DQO,5)); hold on
% plot([mean(BREATHONLY(before,5)) mean(BREATHONLY(before,5))],[0 120],'g--')
% plot([median(DQO_md_before) median(DQO_md_before)],[0 120],'y')
% plot([DQO_median DQO_median],[0 120],'r')
% plot([mean(DQO_md_before) mean(DQO_md_before)],[0 120],'c')
% 
% figure(2); clf
% hist(BREATHONLY(DQO,5)); hold on
% plot([mean(BREATHONLY(after,5)) mean(BREATHONLY(after,5))],[0 120],'g--')
% plot([median(DQO_md_after) median(DQO_md_after)],[0 120],'y')
% plot([DQO_median DQO_median],[0 120],'r')
% plot([mean(DQO_md_after) mean(DQO_md_after)],[0 120],'c')

% set up stats tables
% COLUMNS = PARAMETERS == 10
% ROWS = CONDITION
MEAN_TABLE(1,:) = mean(DQO_md_before);
MEAN_TABLE(2,:) = mean(DQO_md_after);

STD_TABLE(1,:) = std(DQO_md_before);
STD_TABLE(2,:) = std(DQO_md_after);

%% SARASOTA
SAR_median = median(BREATHONLY(SARASOTA,5));

% for all parameters
for j = 1:10
    % and all Sarasota files
for i = 1:15
    % find breaths for a given file, in Sarasota, on deck
    ind = find(BREATHONLY(:,13) == i & BREATHONLY(:,15) == 2 & BREATHONLY(:,12) == 3);
    SAR_md_deck(i,j) = nanmedian(BREATHONLY(ind,j));
    % hist(BREATHONLY(ind,j))
end

for i = 1:15
    % find breaths for a given file, in Sarasota, in water
    ind = find(BREATHONLY(:,13) == i & BREATHONLY(:,15) == 2 & BREATHONLY(:,12) == 4);
    SAR_md_water(i,j) = nanmedian(BREATHONLY(ind,j));
    % hist(BREATHONLY(ind,5))
end

for i = 1:15
    % find breaths for a given file, in Sarasota, swimming
    ind = find(BREATHONLY(:,13) == i & BREATHONLY(:,15) == 2 & BREATHONLY(:,12) == 5);
    SAR_md_swim(i,j) = nanmedian(BREATHONLY(ind,j));
    % hist(BREATHONLY(ind,5))
end
end

% set up stats tables
% COLUMNS = PARAMETERS == 10
% ROWS = CONDITION
MEAN_TABLE(3,:) = nanmean(SAR_md_deck);
MEAN_TABLE(4,:) = nanmean(SAR_md_water);
MEAN_TABLE(5,:) = nanmean(SAR_md_swim);

STD_TABLE(3,:) = nanstd(SAR_md_deck);
STD_TABLE(4,:) = nanstd(SAR_md_water);
STD_TABLE(5,:) = nanstd(SAR_md_swim);


% figure
% hist(BREATHONLY(SARASOTA,5)); hold on
% 
% plot([nanmean(BREATHONLY(SARASOTA,5)) nanmean(BREATHONLY(SARASOTA,5))],[0 120],'g--')
% plot([nanmedian(SAR_md) nanmedian(SAR_md)],[0 120],'y')
% plot([SAR_median SAR_median],[0 120],'r')
% plot([nanmean(SAR_md) nanmean(SAR_md)],[0 120],'c')