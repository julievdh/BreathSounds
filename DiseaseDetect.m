% Detector to find high respiratory effort: breaths that are either on
% deck, or belong to diseased individuals

% Built 11 Oct 2014
% PROBLEMS: 
%       - does not use training set and test set
%       - does not use all proper, final diagnostics from Cynthia Smith
%       - should use better classification system: linear discriminant
%       analysis or PCA

close all; clear all; clc

disp('DO NOT USE THIS CODE')
disp('THIS IS AN OLD SCRIPT AND A DETECTOR THAT IS IMPROPERLY CONSTRUCTED')
disp('Dont worry Julie, it was your first time')

warning off

load('AllBreaths_noPEAK')
SAR = find(BREATHONLY(:,15) == 2);
BREATHONLY = BREATHONLY(SAR,:);

% Calculate EFD/Fcent Ratio
RATIO = BREATHONLY(:,2)./BREATHONLY(:,5);

% plot all points
figure(1); clf; hold on
% plot(RATIO,BREATHONLY(:,1),'bo')
xlabel('EFD/F_c_e_n_t'); ylabel('95% Energy Duration')
adjustfigurefont


% Overall:
% True Instances: have lung disease or are on deck
Ti = find(BREATHONLY(:,12) == 3 | BREATHONLY(:,11) == 242 | BREATHONLY(:,11) == 241);
% False instances: do not have lung disease, are not on deck
Fi = find(BREATHONLY(:,11) ~= 242 & BREATHONLY(:,11) ~= 241 & BREATHONLY(:,12) ~= 3);

%Detect with specified threshold
clear th
th(:,1) = [0.001; 0.001; 0.01; 0.01; 0.05; 0.05; 0.1; 0.1; 0.11; 0.11; 0.13; 0.13; 0.15; 0.15; 0.17; 0.17; 0.19; 0.19; 0.21; 0.21; 0.23];
th(:,2) = [0.001; 0.1; 0.1; 0.2; 0.2; 0.35; 0.35; 0.4; 0.4; 0.45; 0.45; 0.55; 0.55; 0.65; 0.65; 0.75; 0.75; 0.85; 0.85; 0.95; 0.95];
for i = 1:length(th)
DTECT = find(RATIO > th(i,1) & BREATHONLY(:,1) > th(i,2));
noDTECT = find(RATIO <=th(i,1) | BREATHONLY(:,1) <= th(i,2));

plot(RATIO(DTECT),BREATHONLY(DTECT,1),'ro')
plot(RATIO(noDTECT),BREATHONLY(noDTECT,1),'ko')
plot(RATIO(Ti),BREATHONLY(Ti,1),'r.')

legend('Detected','Not Detected','Diseased'); warning off

% True Positives: Diseased, detected
TP = length(intersect(DTECT,Ti));

% True Negatives: Not diseased, not detected
TN = length(intersect(noDTECT,Fi));

% False Positives: Not disease, but detected
FP = length(intersect(DTECT,Fi));

% False Negatives: Is diseased, is not detected
FN = length(intersect(noDTECT,Ti));

% CHECK SUMS
if isequal(length(Ti),TP+FN) < 1 
    disp('SUMS ARE NOT EQUAL - ERROR IN DETECTION CALCS')
else
    if isequal(length(Fi),FP+TN) < 1
disp('SUMS ARE NOT EQUAL - ERROR IN DETECTION CALCS')
    end
end

ACC(i) = (TP + TN)/(TP+FP+TN+FN);

% Calculate Sensitivity and Specificity
Sens(i) = TP/(TP + FN);
Spec(i) = TN/(FP + TN);
end


figure(2); hold on
plot(1-Spec,Sens,'o-','color','k','MarkerFaceColor','k')
plot([0 1],[0 1],'k')
xlabel('1-Specificity'); ylabel('Sensitivity')
% Calculate AUC
AUC = trapz(1-Spec,Sens); 
% Calculate Youden Index
J = max(Sens+Spec);
yOPT = find(Sens+Spec == J); 

plot(1-Spec(yOPT),Sens(yOPT),'bo')

% Calculate Distance Cutoff Point
d = sqrt((1-Sens).^2 + (1-Spec).^2);
dOPT = find(d == min(d));

plot(1-Spec(dOPT),Sens(dOPT),'ko','MarkerFaceColor','w')

box on
adjustfigurefont


% Criterion Plot
figure(3); clf
subplot(121); hold on; box on
plot(th(:,1),Spec,'b',th(:,1),Sens,'r')
plot(th(dOPT,1),Sens(dOPT),'ro')
plot(th(yOPT,1),Sens(yOPT),'bo')
xlabel('EFD/Fcent Threshold'); h = ylabel({'Specificity'; 'Sensitivity'});
subplot(122); hold on; box on
plot(th(:,2),Spec,'b',th(:,2),Sens,'r')
plot(th(dOPT,2),Sens(dOPT),'ro')
plot(th(yOPT,2),Sens(yOPT),'bo')
xlabel('95% Energy Duration Threshold')

return

%% FOR INHALATIONS?

% Calculate EFD/Fcent Ratio INHALATIONS
RATIO = BREATHONLY(:,7)./BREATHONLY(:,10);

clear th
th(:,1) = [0.001; 0.001; 0.01; 0.01; 0.05; 0.05; 0.1; 0.1; 0.11; 0.11; 0.12; 125; 0.125; 0.12; 0.13; 0.13; 0.15; 0.15; 0.17; 0.17; 0.19; 0.19; 0.21];
th(:,2) = [0.001; 0.1; 0.1; 0.2; 0.2; 0.3; 0.3; 0.35; 0.35; 0.4; 0.4; 0.41; 0.41; 0.43; 0.43; 0.45; 0.45; 0.5; 0.5; 0.55; 0.55; 0.65; 0.65];
for i = 1:length(th)
DTECT = find(RATIO > th(i,1) & BREATHONLY(:,6) > th(i,2));
noDTECT = find(RATIO <=th(i,1) | BREATHONLY(:,6) <= th(i,2));

plot(RATIO(DTECT),BREATHONLY(DTECT,6),'ro')
plot(RATIO(noDTECT),BREATHONLY(noDTECT,6),'ko')
plot(RATIO(Ti),BREATHONLY(Ti,6),'r.')

legend('Detected','Not Detected','Diseased'); warning off

% True Positives: Diseased, detected
TP = length(intersect(DTECT,Ti));

% True Negatives: Not diseased, not detected
TN = length(intersect(noDTECT,Fi));

% False Positives: Not disease, but detected
FP = length(intersect(DTECT,Fi));

% False Negatives: Is diseased, is not detected
FN = length(intersect(noDTECT,Ti));

% CHECK SUMS
if isequal(length(Ti),TP+FN) < 1 
    disp('SUMS ARE NOT EQUAL - ERROR IN DETECTION CALCS')
else
    if isequal(length(Fi),FP+TN) < 1
disp('SUMS ARE NOT EQUAL - ERROR IN DETECTION CALCS')
    end
end

ACC(i) = (TP + TN)/(TP+FP+TN+FN);

% Calculate Sensitivity and Specificity
Sens(i) = TP/(TP + FN);
Spec(i) = TN/(FP + TN);
end


figure(2); hold on
plot(1-Spec,Sens,'o--','color','k','MarkerFaceColor','k')
plot([0 1],[0 1],'k')
xlabel('1-Specificity'); ylabel('Sensitivity')
% Calculate AUC
AUC = trapz(1-Spec,Sens); 
% Calculate Youden Index
J = max(Sens+Spec);
yOPT = find(Sens+Spec == J); 

plot(1-Spec(yOPT),Sens(yOPT),'bo')

% Calculate Distance Cutoff Point
d = sqrt((1-Sens).^2 + (1-Spec).^2);
dOPT = find(d == min(d));

plot(1-Spec(dOPT),Sens(dOPT),'ko','MarkerFaceColor','w')

box on
adjustfigurefont


% Criterion Plot
figure(6); clf
subplot(121); hold on; box on
plot(th(:,1),Spec,'b',th(:,1),Sens,'r')
plot(th(dOPT,1),Sens(dOPT),'ro')
plot(th(yOPT,1),Sens(yOPT),'bo')
xlabel('EFD/Fcent Threshold'); h = ylabel({'Specificity'; 'Sensitivity'});
subplot(122); hold on; box on
plot(th(:,2),Spec,'b',th(:,2),Sens,'r')
plot(th(dOPT,2),Sens(dOPT),'ro')
plot(th(yOPT,2),Sens(yOPT),'bo')
xlabel('95% Energy Duration Threshold')