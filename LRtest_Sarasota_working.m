close all; clear all; clc

% Load exhalation parameters, matched breaths, without file 164
load('eMatched')

% Load Sarasota metadata
load('SarasotaFiles')

% Build data matrix
MATCHED = [etimewindow eEFD eRMS ePP eFcent ETO2 ETCO2 MaxInspFlow MaxExpFlow VT LO2consumed];
vlbs = {'e.time window','e.EFD','e.RMS','e.PP','e.Fcent',...
    'ET O_2','ET CO_2','Max Insp Flow','Max Exp Flow','VT','LO_2 consumed'};

DQO = find(Location == 1);
SARASOTA = find(Location == 2);

% select file
i = 11;
ii = find(file_i(SARASOTA) == i);

% FOR FILE 4: WATER THEN DECK
% jj = find(State(SARASOTA(ii)) == 3);
% MATCHED = MATCHED(SARASOTA(ii(jj)),:);

% Sarasota{i,2}

MATCHED = MATCHED(SARASOTA(ii),:);
% 
% % know information about deployment
% filename = strcat(Sarasota{i,2},'_resp');
% % title(regexprep(tag,'_',' '))



%%
etime = MATCHED(:,1);
eEFD = MATCHED(:,2);
eRMS = MATCHED(:,3);
ePP = MATCHED(:,4);
eFcent = MATCHED(:,5);
% itime = kMATCHED(:,6);
% iEFD = kMATCHED(:,7);
% iRMS = kMATCHED(:,8);
% iPP = kMATCHED(:,9);
% iFcent = kMATCHED(:,10);
ETO2 = MATCHED(:,6);
ETCO2 = MATCHED(:,7);
MaxInsp = MATCHED(:,8);
MaxExp = MATCHED(:,9);
VT = MATCHED(:,10);
LO2 = MATCHED(:,11);

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
best_mdl = mdl2;

[ypred,yci] = predict(best_mdl,[eFcent etime]);
figure(4); clf
subplot(211); hold on
plot(etime,ypred,'b.')
plot(etime,LO2,'ro')

subplot(212)
hist(abs(LO2 - ypred)./LO2)
text(0.1,3,num2str(median(abs(LO2 - ypred)./LO2)))

figure(10); hold on
errorbar(etime.*eFcent,ypred,yci(:,1),yci(:,2),'k.')
plot(etime.*eFcent,LO2,'ro')
xlabel('95% Duration (s) x F_c_e_n_t (Hz)'); ylabel('L O_2 per breath')
adjustfigurefont
box on

figure(11); clf; hold on
plot(LO2,ypred,'ko','MarkerFaceColor','k')
xlabel('Measured O_2 per breath (L)'); ylabel('Predicted O_2 per breath (L)')
plot([0 max(LO2)+0.1*max(LO2)],[0 max(LO2)+0.1*max(LO2)],'k')
xlim([0 max(LO2)+0.1*max(LO2)]); ylim([0 max(LO2)+0.1*max(LO2)])
box on
adjustfigurefont

figure(12); hold on
plot(LO2,LO2-ypred,'ko','MarkerFaceColor','k')
plot([0 2],[mean(LO2-ypred) mean(LO2-ypred)],'k')
plot([0 2],[mean(LO2-ypred)+std(LO2-ypred) mean(LO2-ypred)+std(LO2-ypred)],'k--')
plot([0 2],[mean(LO2-ypred)-std(LO2-ypred) mean(LO2-ypred)-std(LO2-ypred)],'k--')

xlabel('Measured LO_2'); ylabel('Difference in LO_2')
adjustfigurefont

return


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

