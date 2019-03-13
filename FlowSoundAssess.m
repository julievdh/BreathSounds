% FlowSoundAssess
% make this the same for all DQ and DQ2017 and Sarasota by putting it here

% rename variables for consistency
if exist('SUMMARYDATA','var')
    all_SUMMARYDATA = SUMMARYDATA; clear SUMMARYDATA
end
if exist('RAWDATA','var')
    RAW_DATA = RAWDATA; clear RAWDATA
end
if exist('all_RAWDATA','var')
    RAW_DATA = all_RAWDATA; clear all_RAWDATA
end


%% Apply median filter to sound, make min zero
for i = 1:length(allstore)
    allstore(i).sounde = medfilt1(allstore(i).sounde,4);
    allstore(i).soundi = medfilt1(allstore(i).soundi,4);
   % allstore(i).soundi = allstore(i).soundi-min(allstore(i).soundi);
   % allstore(i).sounde = allstore(i).sounde-min(allstore(i).sounde);
end
%% Fit relationship between flow and sound
% use 25% of data
[a,b] = FSfit(extractfield(allstore,'sounde'),extractfield(allstore,'flowe'),0.25);
[ai,bi] = FSfit(extractfield(allstore,'soundi'),-extractfield(allstore,'flowi'),0.25);
% alternatively here can use FSfitlog and then below, FSapplylog 

%% Apply relationship to aligned breaths
ffs = 1/diff(RAW_DATA(1:2,1)); % flow sampling rate
[~,afs] = d3wavread([1 2],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
dr = round(afs/ffs); % decimation rate
% initialize some things
VTest = NaN(2,length(CUE_R)); VTesti = NaN(2,length(CUE_R)); % initialize VT estimate from sound
VTe2 = NaN(1,length(CUE_R)); VTi2 = NaN(1,length(CUE_R)); % initialize VT calculation from fow
Sint1 = NaN(1,length(CUE_R)); Sint2 = NaN(1,length(CUE_R));
if f == 22
    VTest = NaN(2,23); VTesti = NaN(2,23); % because of tag move
end
%%
figure(19), clf, hold on
for n = 1:length(CUE_R)
    if aligned(n) == 1,
        % Estimate flow from sound, compute error
        %[allstore(n).Feste,allstore(n).errore] = FSapply(allstore(n).sounde,allstore(n).flowe,a,b); % exhales
        [allstore(n).Festi,allstore(n).errori] = FSapply(allstore(n).soundi,-allstore(n).flowi,ai,bi); % inhales
        % [allstore(n).Festi,allstore(n).errori] = FSapplylog(allstore(n).soundi,-allstore(n).flowi,ai2); % inhales
        
        
       % gde = ~isnan(allstore(n).Feste); % find any NaNs
        gdi = ~isnan(allstore(n).Festi); % find any NaNs
        
        % estimate exh and inh tidal volume from flow
        %VTest(1,n) = trapz(allstore(n).Feste(gde))/(afs/dr);
        VTesti(1,n) = trapz(allstore(n).Festi(gdi))/(afs/dr);
        
        % calculate VT from flow instead -- as a check
        %VTe2(:,n) = trapz(allstore(n).flowe(gde))/(afs/dr);
        VTi2(:,n) = trapz(allstore(n).flowi(gdi))/(afs/dr);
        
        
        % keep mean flow rates 
        %allstore(n).mnflowE = mean(allstore(n).flowe(gde));
        allstore(n).mnflowI = mean(allstore(n).flowi(gdi));
        
        % plot measured and estimated flows
        %plot(allstore(n).idxe,allstore(n).flowe)
        plot(allstore(n).idxi,allstore(n).flowi)
        %plot(allstore(n).idxe,allstore(n).Feste,'.')
        plot(allstore(n).idxi,-allstore(n).Festi,'.')
        
    end
end
figure(333), hold on
plot(VTesti(1,:)--VTi2)
VTrmse = rmse(VTesti(1,:),-VTi2);

xlabel('Time (sec) UNITS WRONG'), ylabel('Flow Rate (L/s)')
print([cd '/AnalysisFigures/' tag '_Flowmeas-est.png'],'-dpng')

%%
figure(29), clf
subplot(3,1,1:2), hold on
plot([0 20],[0 20],'k')
VTesti(VTesti < 0.5) = NaN; VTesti(VTesti > 25) = NaN;
% VTest(VTest < 0.5) = NaN; VTest(VTest > 25) = NaN;

% VTe = VTe2;
VTi = abs(VTi2); % this is computed from flow
VTi(VTi < 0.5) = NaN;
title([regexprep(tag,'_','    ') ' VTmeas-est.png'])
% plot(VTest(1,:),VTe,'^')
plot(VTesti(1,:),VTi,'v')

ylabel('Measured VT'), xlabel('Estimated VT')
subplot(3,1,3), hold on
pon = CUE_R(~isnan(CUE_R)); % all of the breaths where have pneumotach on
% plot(breath.cue(pon)/60,VTe(~isnan(CUE_R)),'k.','markersize',10)
plot(breath.cue(pon)/60,VTi(~isnan(CUE_R)),'k.','markersize',10)


% ylim([0 12]), % set(gca,'ytick',0:2:12)
xlim([breath.cue(pon(1))/60-1 breath.cue(pon(end))/60+1])
%plot(breath.cue(pon)/60,VTest(1,~isnan(CUE_R)),'^')
%plot(breath.cue(pon)/60,VTest(2,~isnan(CUE_R)),'^')
plot(breath.cue(pon)/60,VTesti(1,~isnan(CUE_R)),'v','color',[230 159 0]/255)
%plot(breath.cue(pon)/60,VTesti(2,~isnan(CUE_R)),'v')
xlabel('Time (min)'), ylabel('Tidal Volume (L)')

print([cd '/AnalysisFigures/' tag '_VTmeas-est.png'],'-dpng')
savefig([cd '\AnalysisFigures\' tag '_VTmeas-est'])

% how much are the tidal volumes off?
% nanmean(nanmean(VTe(VTest > 0) - VTest(VTest > 0))./VTe(VTest > 0))
% [min(nanmean(VTe(VTest > 0) - VTest(VTest > 0))./VTe(VTest > 0))
%     max(nanmean(VTe(VTest > 0) - VTest(VTest > 0))./VTe(VTest > 0))]
% rmse_VTe = sqrt(sum((VTe(VTest > 0)-VTest(VTest > 0)).^2)/numel(VTe(VTest > 0)));
% rmse_VTi = sqrt(sum((VTi(VTesti > 0.5)-VTesti(VTesti > 0.5)).^2)/numel(VTi(VTesti > 0.5)));
% nanmean(nanmean(VTi(VTesti > 0.5) - VTesti(VTesti > 0.5))./VTi(VTesti > 0.5))
% [min(nanmean(VTi(VTesti > 0.5) - VTesti(VTesti > 0.5))./VTi(VTesti > 0.5))
%     max(nanmean(VTi(VTesti > 0.5) - VTesti(VTesti > 0.5))./VTi(VTesti > 0.5))]
%
save([cd '\PneumoData\' filename '_flowsound.mat'],'allstore','VTi','VTesti','-append')

return 
%% error figure
for i = 1:length(cuts)
    mxEflow(:,i) = max(cuts(i).flow(:,2));
    mxIflow(:,i) = min(cuts(i).flow(:,2));
end


VTerre = VTest - repmat(VTe,2,1);
VTerri = VTesti - repmat(VTi,2,1);

figure(1), clf, hold on
h2 = plot(mxIflow(VTesti(1,:) > 0.5),[allstore((VTesti(1,:) > 0.5)).errori],'v'); % mean flow rate error
if isfield(allstore,'sound2') == 1
    goodidx2 = find(arrayfun(@(allstore) ~isempty(allstore.erroro2),allstore));
    h3 = plot(mxIflow(goodidx2),[allstore(:).errori2],'v'); % mean flow rate error
    h4 = plot(mxEflow(goodidx2),[allstore(:).erroro2],'^'); % mean flow rate error
end
plot(mxEflow,VTerre,'k^') % tidal volume error
plot(mxIflow,VTerri,'kv') % tidal volume error

lmo = fitlm(mxEflow(goodidx),[allstore(:).erroro]);
lmi = fitlm(-mxIflow(VTesti(1,:) > 0.5),[allstore((VTesti(1,:) > 0.5)).errori]);

xlabel('Flow Rate (L/s)'), ylabel('Error')
legend('Exhaled Flow Rate','Inhaled flow rate','Exhaled VT','Inhaled VT','Location','NW')
title([regexprep(tag,'_','  ') ' error.png'])
print([cd '/AnalysisFigures/' tag '_error.png'],'-dpng')

%% or this linear model


%% are the distributions of measured and estimate different?
gd = ~isnan(VTest(1,:));
[h,p(1),~,stats] = ttest2(VTe(gd),VTest(1,gd));
gd = ~isnan(VTesti(1,:));
[h,p(2),~,stats(2)] = ttest2(VTi(gd),VTesti(1,gd));

table(sum(~isnan(VTest(1,:))),nanmean(VTe(~isnan(CUE_R))),nanstd(VTe(~isnan(CUE_R))),...
    nanmean(VTest(1,:)),nanstd(VTest(1,:)),p(1),stats(1).tstat,...
    sum(~isnan(VTesti(1,:))),nanmean(VTi(~isnan(CUE_R))),nanstd(VTi(~isnan(CUE_R))),...
    nanmean(VTesti(1,:)),nanstd(VTesti(1,:)),...
    p(2),stats(2).tstat)

return

flow = [mxflow(goodidx); -minflow(VTesti(1,:)>0.5)];
error = vertcat([allstore(:).erroro]',[allstore((VTesti(1,:) > 0.5)).errori]');
dir = vertcat(ones(length([allstore(:).erroro]),1),-ones(length(find(VTesti(1,:) > 0.5)),1));
tbl = table(flow,error,dir);
tbl.dir = categorical(tbl.dir);
fit = fitlm(tbl,'error~flow*dir');

%% this was from FlowSoundPlot_DQ2017 -- have to add specifics for if VTi exists
%% CHECK THROUGH THIS
figure(29), clf, hold on
if exist('VTe','var') ~= 1
    VTe = abs(all_SUMMARYDATA(CUE_S,5))';
    VTi = abs(all_SUMMARYDATA(CUE_S,6))';
end
plot(VTest(1,:),VTe,'^')
plot(VTesti(1,:),VTi,'v')
plot(VTest(1,goodidx(chs)),VTe(goodidx(chs)),'k^','MarkerFaceColor','k')
plot(VTesti(1,goodidx(chs)),VTi(goodidx(chs)),'k^','MarkerFaceColor','k')

plot([0 20],[0 20],'k')
xlabel('Estimated VT (L)'), ylabel('Measured VT (L)')
VTe(VTe == 0) = NaN; VTi(VTi == 0) = NaN;
nanmean(nanmean(VTe(VTest > 0) - VTest(VTest > 0))./VTe(VTest > 0))
[min(nanmean(VTe(VTest > 0) - VTest(VTest > 0))./VTe(VTest > 0))
    max(nanmean(VTe(VTest > 0) - VTest(VTest > 0))./VTe(VTest > 0))]
nanmean(nanmean(VTi(VTesti > 0) - VTesti(VTesti > 0))./VTe(VTesti > 0))
[min(nanmean(VTi(VTesti > 0) - VTesti(VTesti > 0))./VTi(VTesti > 0))
    max(nanmean(VTi(VTesti > 0) - VTesti(VTesti > 0))./VTi(VTesti > 0))]




%% plot spectral information and flow rate
F = 0:117.1875:1.1989E5; % frequencies for SL calculations
figure(88), clf, hold on
for i = 1:length(allstore)
    if isempty(allstore(i).SL_e) == 0
        plot3(repmat(mxEflow(i),1,171),F(1:171),allstore(i).SL_e(1:171))
        allstore(i).SL_e_high = mean(allstore(i).SL_e(F<3500 & F > 2500));
        allstore(i).SL_e_low = mean(allstore(i).SL_e(F<1000));
    end
end

figure(89), clf, hold on
for i = 1:length(allstore)
    if isempty(allstore(i).SL_i) == 0
        plot3(repmat(mxIflow(i),1,171),F(1:171),allstore(i).SL_i(1:171))
        allstore(i).SL_i_high = mean(allstore(i).SL_i(F<3500 & F > 2500));
        allstore(i).SL_i_low = mean(allstore(i).SL_i(F<1000));
        
    end
end

% here for example we could calculate the frequency at which 25, 50, of
% power reached and correlate with PEFR or PIFR
goodidx = find(arrayfun(@(allstore) ~isempty(allstore.Pxx_e),allstore));
clf, hold on
for i = 1:length(mxEflow)
    if isempty(allstore(i).Pxx_e) == 0
        plot3(F(1:L),zeros(L,1)+mxEflow(i),allstore(i).Pxx_e(1:L)./max(allstore(i).Pxx_e(1:L)))
    end
end

