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

%% take first five only to make model
% count good ones - using first 5 based on previous analysis

goodidx = find(arrayfun(@(allstore) ~isempty(allstore.sound),allstore));
chs = 1:5; % randi([1 length(goodidx)],1,5); % choose 5 random
substore = allstore(goodidx(chs)); % take up to the 5th one
%goodidx = find(arrayfun(@(allstore) ~isempty(allstore.sound),allstore));
%substore = allstore(1:goodidx(5)); % take up to the 5th one


%% use relationship on sounds
% load([filename '_flowsound'])
allflow = extractfield(substore,'flow')';
allsound = extractfield(substore,'sound')';
nano = ~isnan(allsound);       % find non-nan values
allsound = allsound(nano); allflow = allflow(nano);
exhflow = find(allflow > 1);
[curve,goodness] = fit(allsound(exhflow),allflow(exhflow),'a*x^b','robust','bisquare');
all_coeff = coeffvalues(curve);
a = all_coeff(1); b = all_coeff(2);
% for first five inhales:
inhflow = find(allflow < -1);
[curvei,gofi] = fit(allsound(inhflow),-allflow(inhflow),'a*x^b','robust','bisquare');
all_coeffi = coeffvalues(curvei);       % for inhales
ai = all_coeffi(1); bi = all_coeffi(2);

fitinfo.ai = ai; fitinfo.bi = bi; fitinfo.curvei = curvei; fitinfo.gofi = gofi;
fitinfo.a = a; fitinfo.b = b; fitinfo.curve = curve; fitinfo.gof = goodness;

save([cd '\PneumoData\' filename '_flowsound'],'fitinfo','-append')
%% Fest = a*log10(shift_y)+b;
figure(9), clf, subplot(121), hold on
plot(extractfield(allstore,'sound'),extractfield(allstore,'flow'),'o')
plot(curve), legend off
plot(allsound(exhflow),allflow(exhflow),'.')
ylabel('Measured Flow Rate (L/s)'), xlabel('Filtered sound envelope'), title('Exhale')
text(6E-4,75,num2str(goodness.rsquare,'%4.2f'))
subplot(122), hold on
plot(extractfield(allstore,'sound'),-extractfield(allstore,'flow'),'o')
plot(curvei), legend off
plot(allsound(inhflow),-allflow(inhflow),'.')
ylabel('Measured Flow Rate (L/s)'), xlabel('Filtered sound envelope'), title ('Inhale')
text(6E-4,30,num2str(gofi.rsquare,'%4.2f'))

if exist('afs','var') == 0
    afs = 240000;
    if exist('all_RAWDATA','var')
        ffs = 1/diff(all_RAWDATA(1:2,1)); % flow sampling rate
    else ffs = 1/diff(RAW_DATA(1:2,1));
    end
    dr = round(afs/ffs); % decimation rate
end
%% evaluate fit
yprede = feval(curve,allsound(exhflow));
[he,pe] = vartest2(resample(yprede-allflow(exhflow),1,10),resample(allflow(exhflow),1,10));
ypredi = feval(curvei,allsound(inhflow));
[hi,pi] = vartest2(resample(ypredi-allflow(inhflow),1,10),resample(allflow(inhflow),1,10));

%% for all aligned files

ffs = 1/diff(RAW_DATA(1:2,1)); % flow sampling rate
dr = round(afs/ffs); % decimation rate

VTest = NaN(2,length(CUE_R)); VTesti = NaN(2,length(CUE_R)); % initialize VT estimate from sound
VTe2 = NaN(1,length(CUE_R)); VTi2 = NaN(1,length(CUE_R)); % initialize VT calculation from fow
Sint1 = NaN(1,length(CUE_R)); Sint2 = NaN(1,length(CUE_R)); 
if f == 22
    VTest = NaN(2,23); VTesti = NaN(2,23); % because of tag move
end

figure(19), clf, hold on
for n = 1:length(CUE_R)
    if aligned(n) == 1,
        %% 
        if size(allstore(n).sound,2) > 1
            allstore(n).sound = allstore(n).sound';
        end
        
        ex = find(allstore(n).flow > 0);
        in = find(allstore(n).flow < -1);
        if isempty(in) == 0
            if isempty(ex) == 0
                in = in(in > ex(1));  ex = ex(ex < in(1)); % no inhaled points prior to exhale, no exhaled points after inhale
            end
        end
        
        % apply that relationship
        if sum(~isnan(allstore(n).sound)) > 2 % if there are more than 2 entries 
        allstore(n).sfill = naninterp(allstore(n).sound);                           % interpolate NaNs
        allstore(n).sfill(find(allstore(n).sfill<0)) = 0;                           % zero out any negative values at the beginning
        allstore(n).sfill(find(allstore(n).sfill>max(allstore(n).sound))) = 0;    % interpolation should never exceed max envelope
        else allstore(n).sfill = NaN(length(allstore(n).sound),1); 
        end 
        % estimate flow from sound
        allstore(n).Fest = a*(allstore(n).sfill).^b;
        % calculate error
        allstore(n).erroro = (mean(allstore(n).Fest(ex))-mean(allstore(n).flow(ex)));
        
        % calculate Sint as previously - just do it all together here 
        Sint1(n) = trapz(allstore(n).sound(ex)); % integral of filtered sound
        
        % for inhale
        allstore(n).Festi = ai*(allstore(n).sfill).^bi;
        allstore(n).Festi(isinf(allstore(n).Festi)) = 0; % replace Inf with 0
        
        % calculate error
        allstore(n).errori = (mean(allstore(n).flow(in))-mean(-allstore(n).Festi(in)));
        
        % estimate exh and inh tidal volume from flow
        VTest(1,n) = trapz(allstore(n).Fest(ex))/(afs/dr);
        VTesti(1,n) = trapz(allstore(n).Festi(in))/(afs/dr);
        
        % calculate VT from flow instead -- as a check
        VTi2(:,n) = trapz(allstore(n).flow(in))/(afs/dr);
        VTe2(:,n) = trapz(allstore(n).flow(ex))/(afs/dr);
        
        allstore(n).mnflowE = mean(allstore(n).flow(ex));
        allstore(n).mnflowI = mean(allstore(n).flow(in));
        allstore(n).ex = ex; allstore(n).dex = length(ex)/(afs/dr); 
        allstore(n).in = in; allstore(n).din = length(in)/(afs/dr); 
        
        plot(allstore(n).flow)
        plot(ex,allstore(n).Fest(ex),'.')
        plot(in,-allstore(n).Festi(in),'.')
        
        % Second hydrophone if exists
        if isfield(allstore,'sound2') == 1
            if sum(~isnan(allstore(n).sound2)) > 2 % if there are more than 2 entries 
            % fill sound
            allstore(n).sfill2 = naninterp(allstore(n).sound2);                   % interpolate NaNs
            allstore(n).sfill2(find(allstore(n).sfill2<0)) = 0;                           % zero out any negative values at the beginning
            allstore(n).sfill2(find(allstore(n).sfill2>max(allstore(n).sound2))) = 0;    % interpolation should never exceed max envelope
            
            allstore(n).Fest2 = a*(allstore(n).sfill2).^b;
            allstore(n).erroro2 = (mean(allstore(n).Fest2(ex))-mean(allstore(n).flow(ex)));
            allstore(n).Festi2 = ai*(allstore(n).sfill2).^bi;
            allstore(n).Festi2(isinf(allstore(n).Festi2)) = 0;
            allstore(n).errori2 = (mean(allstore(n).flow(in))-mean(-allstore(n).Festi2(in)));
            
            % estimate exh and inh tidal volume from flow
            VTest(2,n) = trapz(allstore(n).Fest2(ex))/(afs/dr);
            VTesti(2,n) = trapz(allstore(n).Festi2(in))/(afs/dr);
            
            Sint2(n) = trapz(allstore(n).sound2(ex)); % integral of filtered sound

            plot(ex,allstore(n).Fest2(ex),'.')
            plot(in,-allstore(n).Festi2(in),'.')
            end 
        end
        % pause
    end
end
xlabel('Time (sec)'), ylabel('Flow Rate (L/s)')
print([cd '/AnalysisFigures/' tag '_Flowmeas-est.png'],'-dpng')

%%
figure(29), clf
subplot(3,1,1:2), hold on
plot([0 20],[0 20],'k')
VTesti(VTesti < 0.5) = NaN; VTesti(VTesti > 25) = NaN;  
VTest(VTest < 0.5) = NaN; VTest(VTest > 25) = NaN; 

if size(all_SUMMARYDATA,2) == 5;
    VTe = abs(all_SUMMARYDATA(CUE_S,5))'; % this is from Andreas. Checked contingency with VTe vs VTe2 and things look good.
    if f == 10
        VTe = VTe2; 
    end
    VTi = abs(VTi2); % this is computed from flow 
end
if size(all_SUMMARYDATA,2) == 8;
    if f == 22;
        VTe = abs(all_SUMMARYDATA(CUE_S(1:23),5))';
        VTi = all_SUMMARYDATA(CUE_S(1:23),6)';
    else
        VTe = abs(all_SUMMARYDATA(CUE_S,5))';
        VTi = all_SUMMARYDATA(CUE_S,6)';
    end
end
VTi(VTi < 0.5) = NaN; 
title([regexprep(tag,'_','    ') ' VTmeas-est.png'])
plot(VTest(1,:),VTe,'^')

if exist('VTi','var')
    plot(VTesti(1,VTesti(1,:) > 0.5),VTi(1,VTesti(1,:) > 0.5),'v')
else
    plot(VTesti(1,VTesti(1,:) > 0.5),VTe(1,VTesti(1,:) > 0.5),'v')
end
plot(VTest(1,goodidx(chs)),VTe(goodidx(chs)),'k^','MarkerFaceColor','k')
plot(VTesti(1,goodidx(chs)),VTi(goodidx(chs)),'kv','MarkerFaceColor','k')


ylabel('Measured VT'), xlabel('Estimated VT')
subplot(3,1,3), hold on
pon = CUE_R(~isnan(CUE_R)); % all of the breaths where have pneumotach on
plot(breath.cue(pon)/60,VTe(~isnan(CUE_R)),'k.','markersize',10)
plot(breath.cue(pon)/60,VTi(~isnan(CUE_R)),'k.','markersize',10)


% ylim([0 12]), % set(gca,'ytick',0:2:12)
xlim([breath.cue(pon(1))/60-1 breath.cue(pon(end))/60+1])
plot(breath.cue(pon)/60,VTest(1,~isnan(CUE_R)),'^')
%plot(breath.cue(pon)/60,VTest(2,~isnan(CUE_R)),'^')
plot(breath.cue(pon)/60,VTesti(1,~isnan(CUE_R)),'v')
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


%% error figure
for i = 1:length(cuts)
    mxEflow(:,i) = max(cuts(i).flow(:,2));
    mxIflow(:,i) = min(cuts(i).flow(:,2)); 
end


VTerre = VTest - repmat(VTe,2,1);
VTerri = VTesti - repmat(VTi,2,1);

figure(1), clf, hold on
h1 = plot(mxEflow(goodidx),[allstore(:).erroro],'^'); % mean flow rate error
h2 = plot(mxIflow(VTesti(1,:) > 0.5),[allstore((VTesti(1,:) > 0.5)).errori],'v'); % mean flow rate error
if isfield(allstore,'sound2') == 1
    goodidx2 = find(arrayfun(@(allstore) ~isempty(allstore.erroro2),allstore));
    h3 = plot(mxIflow(goodidx2),[allstore(:).errori2],'v'); % mean flow rate error
    h4 = plot(mxEflow(goodidx2),[allstore(:).erroro2],'^'); % mean flow rate error
end
plot(mxEflow,VTerre,'k^') % tidal volume error
plot(mxIflow,VTerri,'kv') % tidal volume error
plot(mxEflow(1:5),VTerre(:,goodidx(chs)),'k^','Markerfacecolor','k')
plot(mxIflow(1:5),VTerri(:,goodidx(chs)),'kv','MarkerFaceColor','k') % tidal volume error

lmo = fitlm(mxEflow(goodidx),[allstore(:).erroro]);
lmi = fitlm(-mxIflow(VTesti(1,:) > 0.5),[allstore((VTesti(1,:) > 0.5)).errori]); 

xlabel('Flow Rate (L/s)'), ylabel('Error')
legend('Exhaled Flow Rate','Inhaled flow rate','Exhaled VT','Inhaled VT','Location','NW')
title([regexprep(tag,'_','  ') ' error.png'])
print([cd '/AnalysisFigures/' tag '_error.png'],'-dpng')
save([cd '\PneumoData\' filename '_flowsound'],'allstore','VTi','VTe','VTerre','VTerri','VTest','VTesti','Sint1','Sint2','-append')

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

