% load data, work with MATCHED only
load('AllBreaths_noPEAK')

% find Sarasota Only
load('SarasotaFiles')
SARASOTA = find(MATCHED(:,20) == 2);
MATCHED = MATCHED(SARASOTA,:);

% select file 4 as has 28 breaths
i = 4;
ii = find(MATCHED(:,19) == i);
MATCHED = MATCHED(ii,:);

% label MATCHED columns
vlbs = {'e.time window','e.EFD','e.RMS','e.PP','e.Fcent',...
    'i.time window','i.EFD','i.RMS','i.PP','i.Fcent'...
    'ET O_2','ET CO_2','Max Insp Flow','Max Exp Flow','VT','LO_2 consumed'};

% know information about deployment
filename = strcat(Sarasota{i,2},'_resp');
% title(regexprep(tag,'_',' '))

%%
rnd = rand(size(ii),1);
kp = find(round(rnd));
sv = find(round(rnd)~=1);
kMATCHED = MATCHED(kp,:);

%%
etime = kMATCHED(:,1);
eEFD = kMATCHED(:,2);
eRMS = kMATCHED(:,3);
ePP = kMATCHED(:,4);
eFcent = kMATCHED(:,5);
itime = kMATCHED(:,6);
iEFD = kMATCHED(:,7);
iRMS = kMATCHED(:,8);
iPP = kMATCHED(:,9);
iFcent = kMATCHED(:,10);
ETO2 = kMATCHED(:,11);
ETCO2 = kMATCHED(:,12);
MaxInsp = kMATCHED(:,13);
MaxExp = kMATCHED(:,14);
VT = kMATCHED(:,15);
LO2 = kMATCHED(:,16);

%%
ds = dataset(VT,eEFD,eFcent,etime);
mdl = LinearModel.fit(ds,'VT ~ eEFD + eFcent^2 + etime')

% plot residuals
figure(2)
plotResiduals(mdl,'fitted')

% plot cook's distance
figure(3)
plotDiagnostics(mdl,'cookd')

% remove outliers if necessary
[~,outlier] = max(mdl.Diagnostics.CooksDistance);
mdl2 = LinearModel.fit(ds,'VT ~ eEFD + eFcent^2 + etime','Exclude',outlier);
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


%% USE VALUES TO PREDICT OTHER KEPT VALUES (NON-MODELED)
sMATCHED = MATCHED(sv,:);

%%
etime_s = sMATCHED(:,1);
eEFD_s = sMATCHED(:,2);
eRMS_s = sMATCHED(:,3);
ePP_s = sMATCHED(:,4);
eFcent_s = sMATCHED(:,5);
VT_s = sMATCHED(:,15);

[ypred,yci] = predict(mdl2,[eEFD_s eFcent_s etime_s]);

dff = abs(ypred) - abs(VT_s);

% compare predicted vs. measured
figure(5)
subplot(121); hold on
plot(VT,'ro')
plot(mdl2.Fitted,'.')

subplot(122); hold on
plot(VT_s,'ro')
plot(ypred,'.')


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

