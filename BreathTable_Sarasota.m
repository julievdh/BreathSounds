% CREATE MASTER DATA TABLES

% plot to check
figure(99)
plot(RAWDATA(:,1),RAWDATA(:,2),'LineWidth',2); hold on
plot(R.cue(CUE_R,1)-tcue,-SUMMARYDATA(CUE_S,3),'k.')

% eParams
BREATHONLY(:,1) = eParams.time_window';
BREATHONLY(:,2) = eParams.EFD';
BREATHONLY(:,3) = eParams.RMS';
BREATHONLY(:,4) = eParams.pp';
BREATHONLY(:,5) = eParams.Fcent';
BREATHONLY(:,6) = eParams.Fmax';

% iParams
BREATHONLY(:,7) = iParams.time_window';
BREATHONLY(:,8) = iParams.EFD';
BREATHONLY(:,9) = iParams.RMS';
BREATHONLY(:,10) = iParams.pp';
BREATHONLY(:,11) = iParams.Fcent';
BREATHONLY(:,12) = iParams.Fmax';


% if isempty('sParams') == 0
% % sParams
% BREATHONLY(:,13) = sParams.time_window';
% BREATHONLY(:,14) = sParams.EFD';
% BREATHONLY(:,15) = sParams.RMS';
% BREATHONLY(:,16) = sParams.pp';
% BREATHONLY(:,17) = sParams.Fcent';
% BREATHONLY(:,18) = sParams.Fmax';
% end

%% ALL BREATHS MATCHED 

% eParams
BREATHMATCHED(:,1) = eParams.time_window(CUE_R)';
BREATHMATCHED(:,2) = eParams.EFD(CUE_R)';
BREATHMATCHED(:,3) = eParams.RMS(CUE_R)';
BREATHMATCHED(:,4) = eParams.pp(CUE_R)';
BREATHMATCHED(:,5) = eParams.Fcent(CUE_R)';
BREATHMATCHED(:,6) = eParams.Fmax(CUE_R)';

% iParams
BREATHMATCHED(:,7) = iParams.time_window(CUE_R)';
BREATHMATCHED(:,8) = iParams.EFD(CUE_R)';
BREATHMATCHED(:,9) = iParams.RMS(CUE_R)';
BREATHMATCHED(:,10) = iParams.pp(CUE_R)';
BREATHMATCHED(:,11) = iParams.Fcent(CUE_R)';
BREATHMATCHED(:,12) = iParams.Fmax(CUE_R)';

% Pneumo data
BREATHMATCHED(:,13:17) = SUMMARYDATA(CUE_S,:);

return

%% S PARAMS IF POSSIBLE

sParams.time_window(~sParams.time_window) = NaN;
sParams.start(~sParams.start) = NaN;
sParams.stop(~sParams.stop) = NaN;
sParams.RMS(~sParams.RMS) = NaN;
sParams.EFD(~sParams.EFD) = NaN;
sParams.pp(~sParams.pp) = NaN;
sParams.Fcent(~sParams.Fcent) = NaN;
sParams.Fmax(~sParams.Fmax) = NaN;

SURF(:,1) = sParams.time_window(~isnan(sParams.time_window))';
SURF(:,2) = sParams.EFD(~isnan(sParams.EFD))';
SURF(:,3) = sParams.RMS(~isnan(sParams.RMS))';
SURF(:,4) = sParams.pp(~isnan(sParams.pp))';
SURF(:,5) = sParams.Fcent(~isnan(sParams.Fcent))';
SURF(:,6) = sParams.Fmax(~isnan(sParams.Fcent))';