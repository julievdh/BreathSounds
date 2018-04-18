% close all; clear all; clc

% Load exhalation parameters, matched breaths, without file 164
load('eMatched')

% Load Sarasota metadata
load('DQFiles')

% Build data matrix
MATCHED = [etimewindow eEFD eRMS ePP eFcent ETO2 ETCO2 MaxInspFlow MaxExpFlow VT LO2consumed];
vlbs = {'e.time window','e.EFD','e.RMS','e.PP','e.Fcent',...
    'ET O_2','ET CO_2','Max Insp Flow','Max Exp Flow','VT','LO_2 consumed'};

DQO = find(Location == 1);
SARASOTA = find(Location == 2);

% select file
i = 1;
ii = find(Animal(DQO) == i);
jj = find(State(DQO(ii)) == 1);

% DQ{i,2}
% BEFORE ONLY
MATCHED_before = MATCHED(DQO(ii(jj)),:);
% 
% % know information about deployment
% filename = strcat(Sarasota{i,2},'_resp');
% % title(regexprep(tag,'_',' '))



%%
etime = MATCHED_before(:,1);
eEFD = MATCHED_before(:,2);
eRMS = MATCHED_before(:,3);
ePP = MATCHED_before(:,4);
eFcent = MATCHED_before(:,5);
% itime = kMATCHED(:,6);
% iEFD = kMATCHED(:,7);
% iRMS = kMATCHED(:,8);
% iPP = kMATCHED(:,9);
% iFcent = kMATCHED(:,10);
ETO2 = MATCHED_before(:,6);
ETCO2 = MATCHED_before(:,7);
MaxInsp = MATCHED_before(:,8);
MaxExp = MATCHED_before(:,9);
VT = MATCHED_before(:,10);
LO2 = MATCHED_before(:,11);

%%
ds = dataset(LO2, eFcent, etime);
mdl = LinearModel.fit(ds,'LO2 ~ eFcent*etime')

% plot residuals
figure(2)
plotResiduals(mdl,'fitted')

% plot cook's distance
figure(3)
plotDiagnostics(mdl,'cookd')

% remove outliers if necessary
[~,outlier] = max(mdl.Diagnostics.CooksDistance);
mdl2 = LinearModel.fit(ds,'LO2 ~ eFcent*etime','Exclude',outlier);
disp(mdl2)

% plot the new model
plot(mdl2)

% plot new Cooks Distance
figure(3)
subplot(121)
plotDiagnostics(mdl,'cookd')
subplot(122)
plotDiagnostics(mdl2,'cookd')

% plot new residuals vs. fitted values
figure(2)
subplot(121)
plotResiduals(mdl,'fitted')
subplot(122)
plotResiduals(mdl2,'fitted')

%% CHOOSE MODEL:
best_mdl = mdl;

[ypred,yci] = predict(best_mdl,[eFcent etime]);
figure(4); clf
subplot(211); hold on
errorbar(etime.*eFcent,ypred,yci(:,1),yci(:,2),'k.')
plot(etime.*eFcent,LO2,'ro')

subplot(212)
hist(abs(LO2 - ypred)./LO2)
text(0.1,3,num2str(median(abs(LO2 - ypred)./LO2)))



% plot 
figure(10); hold on
errorbar(etime.*eFcent,ypred,yci(:,1),yci(:,2),'k.')
plot(etime.*eFcent,LO2,'ro')
xlabel('95% Duration (s) x F_c_e_n_t (Hz)'); ylabel('L O_2 per breath')
adjustfigurefont
box on


%% PREDICT AFTER EXERCISE

kk = find(State(DQO(ii)) == 2);
LO2_after = MATCHED(DQO(kk),11);
eFcent_after = MATCHED(DQO(kk),5);
etime_after = MATCHED(DQO(kk),1);
% RESTRICT TO BE WITHIN WHAT WE FIT BEFORE
within_eFcent = find(eFcent_after < max(eFcent));
within_etime = find(etime_after < max(etime));
int = intersect(within_eFcent,within_etime);

[ypred_after,yci_after] = predict(best_mdl,[eFcent_after(int) etime_after(int)]);
figure(5); clf; hold on
errorbar(etime_after(int).*eFcent_after(int),ypred_after,yci_after(:,1),yci_after(:,2),'k.')
plot(etime_after(int).*eFcent_after(int),LO2_after(int),'ro')

return

mean(LO2_after(int) - abs(ypred_after))
xlabel('95% Duration (s) x F_c_e_n_t (Hz)'); ylabel('L O_2 per breath')
adjustfigurefont
box on

figure(8)
plot(LO2_after(int),ypred_after,'bo','MarkerFaceColor','b')
hold on
plot([0 1.8],[0 1.8],'k')
plot(LO2,ypred,'ro','MarkerFaceColor','r')
xlim([0 max(LO2)+0.1*max(LO2)]); ylim([0 max(LO2)+0.1*max(LO2)])
xlabel('Measured O_2 per breath (L)'); ylabel('Predicted O_2 per breath (L)')
%%
figure(11); hold on
plot(LO2_after(int),LO2_after(int)-ypred_after,'bo','MarkerFaceColor','b')
plot([0 2],[mean(LO2_after(int)-ypred_after) mean(LO2_after(int)-ypred_after)],'b')
plot([0 2],[mean(LO2_after(int)-ypred_after)+std(LO2_after(int)-ypred_after)...
    mean(LO2_after(int)-ypred_after)+std(LO2_after(int)-ypred_after)],'b--')
plot([0 2],[mean(LO2_after(int)-ypred_after)-std(LO2_after(int)-ypred_after)...
    mean(LO2_after(int)-ypred_after)-std(LO2_after(int)-ypred_after)],'b--')

plot(LO2,LO2-ypred,'ro','MarkerFaceColor','r')
plot([0 2],[mean(LO2-ypred) mean(LO2-ypred)],'r')
plot([0 2],[mean(LO2-ypred)+std(LO2-ypred) mean(LO2-ypred)+std(LO2-ypred)],'r--')
plot([0 2],[mean(LO2-ypred)-std(LO2-ypred) mean(LO2-ypred)-std(LO2-ypred)],'r--')

xlabel('Measured LO_2'); ylabel('Difference in LO_2')


return

%% BECAUSE WHAT MODEL FITS POST BETTER?
ds = dataset(LO2, eFcent, etime);
mdl_after = LinearModel.fit(ds,'LO2 ~ eFcent*etime')

% remove outliers if necessary
[~,outlier] = max(mdl.Diagnostics.CooksDistance);
mdl2_after = LinearModel.fit(ds,'LO2 ~ eFcent*etime','Exclude',outlier)

% plot the new model
figure
subplot(121)
plot(mdl_after)
subplot(122)
plot(mdl2_after)


%% FIND BREATHS FROM SAME INDIVIDUAL, SAME STATE, SAME LOCATION

SARASOTA = find(BREATHONLY(:,15) == 2);
BREATHONLY = BREATHONLY(SARASOTA,:);

ii = find(BREATHONLY(:,13) == i);
BREATHONLY = BREATHONLY(ii,:);

% FIND SAME PARAMETERS FOR BREATHS ONLY
etime_BO = BREATHONLY(:,1);
eEFD_BO = BREATHONLY(:,2);
eRMS_BO = BREATHONLY(:,3);
ePP_BO = BREATHONLY(:,4);
eFcent_BO = BREATHONLY(:,5);

% PREDICT
[ypred,yci] = predict(mdl2,[eEFD_BO eFcent_BO etime_BO]);

