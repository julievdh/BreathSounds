% Count Breaths in BREATHONLY/MATCHED/SURFACE 

% load data: no peak frequency, ONLY breaths where we have both E and I
load('AllBreaths_noPEAK')

%% BREATHONLY

kolohe = find(BREATHONLY(:,11) == 1);
liko = find(BREATHONLY(:,11) == 2);
lono = find(BREATHONLY(:,11) == 3);
nainoa = find(BREATHONLY(:,11) == 4);

before = find(BREATHONLY(:,12) == 1);
after = find(BREATHONLY(:,12) == 2);
deck = find(BREATHONLY(:,12) == 3);
water = find(BREATHONLY(:,12) == 4);
swim = find(BREATHONLY(:,12) == 5);

BOAT = find(BREATHONLY(:,13) > 14 & BREATHONLY(:,13) < 17);
NOBOAT = find(BREATHONLY(:,13) < 15 | BREATHONLY(:,13) > 16);

SARASOTA = find(BREATHONLY(:,15) == 2);
DQO = find(BREATHONLY(:,15) == 1);

% how many files per individual?
nKO = size(unique(BREATHONLY(kolohe,13)),1);
nLI = size(unique(BREATHONLY(liko,13)),1);
nLO = size(unique(BREATHONLY(lono,13)),1);
nNA = size(unique(BREATHONLY(nainoa,13)),1);

% how many files per location
nDQ = size(unique(BREATHONLY(DQO,13)),1);
nSAR = size(unique(BREATHONLY(SARASOTA,13)),1);

% how many BREATHS per condition
nbBEFORE = size(BREATHONLY(before,13),1);
nbAFTER = size(BREATHONLY(after,13),1);
nbDECK = size(BREATHONLY(deck,13),1);
nbWATER = size(BREATHONLY(water,13),1);
nbSWIM = size(BREATHONLY(swim,13),1);

% how many BREATHS per individual?
nbKO = size(BREATHONLY(kolohe,13),1);
nbLI = size(BREATHONLY(liko,13),1);
nbLO = size(BREATHONLY(lono,13),1);
nbNA = size(BREATHONLY(nainoa,13),1);

% how many BREATHS per location?
nbDQ = size(BREATHONLY(DQO,13),1);
nbSAR = size(BREATHONLY(SARASOTA,13),1);

%% MATCHED

kolohe = find(MATCHED(:,16) == 1);
liko = find(MATCHED(:,16) == 2);
lono = find(MATCHED(:,16) == 3);
nainoa = find(MATCHED(:,16) == 4);

before = find(MATCHED(:,17) == 1);
after = find(MATCHED(:,17) == 2);
deck = find(MATCHED(:,17) == 3);
water = find(MATCHED(:,17) == 4);
swim = find(MATCHED(:,17) == 5);

BOAT = find(MATCHED(:,18) > 14 & MATCHED(:,18) < 17);
NOBOAT = find(MATCHED(:,18) < 15 | MATCHED(:,18) > 16);

SARASOTA = find(MATCHED(:,19) == 2);
DQO = find(MATCHED(:,19) == 1);

% how many files per individual?
nKO = size(unique(MATCHED(kolohe,18)),1);
nLI = size(unique(MATCHED(liko,18)),1);
nLO = size(unique(MATCHED(lono,18)),1);
nNA = size(unique(MATCHED(nainoa,18)),1);

% how many files per location
nDQ = size(unique(MATCHED(DQO,18)),1);
nSAR = size(unique(MATCHED(SARASOTA,18)),1);

% how many BREATHS per condition
nbBEFORE = size(MATCHED(before,18),1);
nbAFTER = size(MATCHED(after,18),1);
nbDECK = size(MATCHED(deck,18),1);
nbWATER = size(MATCHED(water,18),1);
nbSWIM = size(MATCHED(swim,18),1);

% how many BREATHS per individual?
nbKO = size(MATCHED(kolohe,18),1);
nbLI = size(MATCHED(liko,18),1);
nbLO = size(MATCHED(lono,18),1);
nbNA = size(MATCHED(nainoa,18),1);

% how many BREATHS per location?
nbDQ = size(MATCHED(DQO,18),1);
nbSAR = size(MATCHED(SARASOTA,18),1);

%% SURFACE

kolohe = find(SURFACE(:,6) == 1);
liko = find(SURFACE(:,6) == 2);
lono = find(SURFACE(:,6) == 3);
nainoa = find(SURFACE(:,6) == 4);

before = find(SURFACE(:,7) == 1);
after = find(SURFACE(:,7) == 2);
deck = find(SURFACE(:,7) == 3);
water = find(SURFACE(:,7) == 4);
swim = find(SURFACE(:,7) == 5);

BOAT = find(SURFACE(:,8) > 14 & SURFACE(:,8) < 17);
NOBOAT = find(SURFACE(:,8) < 15 | SURFACE(:,8) > 16);

SARASOTA = find(SURFACE(:,9) == 2);
DQO = find(SURFACE(:,9) == 1);

% how many files per individual?
nKO = size(unique(SURFACE(kolohe,8)),1);
nLI = size(unique(SURFACE(liko,8)),1);
nLO = size(unique(SURFACE(lono,8)),1);
nNA = size(unique(SURFACE(nainoa,8)),1);

% how many files per location
nDQ = size(unique(SURFACE(DQO,8)),1);
nSAR = size(unique(SURFACE(SARASOTA,8)),1);

% how many BREATHS per individual?
nbKO = size(SURFACE(kolohe,8),1);
nbLI = size(SURFACE(liko,8),1);
nbLO = size(SURFACE(lono,8),1);
nbNA = size(SURFACE(nainoa,8),1);

% how many BREATHS per location?
nbDQ = size(SURFACE(DQO,8),1);
nbSAR = size(SURFACE(SARASOTA,8),1);