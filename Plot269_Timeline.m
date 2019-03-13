f = 4; AlignData

% load PQ audit
load(strcat('C:\Users\au575532\Dropbox (Personal)\tag\tagdata\',tag,'_PQ'))
CUE_S = find(CUE); CUE_R = CUE(find(CUE));
[~,breath] =  findbreathcues(R); % findaudit(R,'breath'); % findbreathcues(R);
    load([cd '\PneumoData\' filename '_flowsound.mat'])
    load([cd '\PneumoData\' filename '_surfsound.mat'])

%%
figure(29), clf
subplot(211), hold on 
expdur = exp(:,2)-exp(:,1);
insdur = ins(:,2)-ins(:,1);
plot(breath.cue(:,1)/60,expdur,'^','color',[202 0 32]/255)
plot(breath.cue(:,1)/60,insdur,'v','color',[5 113 176]/255)
xlim([floor(breath.cue(1,1)/60)-1 30])
xlabel('Time (min)'), ylabel('Duration ')


subplot(212), hold on 
pon = CUE_R(~isnan(CUE_R)); % all of the breaths where have pneumotach on
plot(breath.cue(pon)/60,VTi(~isnan(CUE_R)),'k.','markersize',10)
plot(breath.cue(pon)/60,VTesti(1,~isnan(CUE_R)),'v','color',[230 159 0]/255)

q = find(Quality == 20);
plot(breath.cue(q)/60,extractfield(surfstore,'VTesti'),'v','color',[86 180 233]/255)

% get swimming values and fill in NaN when quality is not good
VTi_swim = extractfield(surfstore,'VTesti');
VTi_swim(VTi_swim < 1) = NaN;
NA = find(isnan(VTi_swim)); % replace NaN with mean and sd

for i = 1:length(NA)
    plot([breath.cue(q(NA(i)),1)/60 breath.cue(q(NA(i)),1)/60],[nanmean(VTi_swim)-nanstd(VTi_swim) nanmean(VTi_swim)+nanstd(VTi_swim)],'k')
end
plot(breath.cue(q(NA),1)/60,repmat(nanmean(VTi_swim),length(NA),1),'kv','markerfacecolor',[0.5 0.5 0.5])
VTi_swim(NA) = nanmean(VTi_swim);

% resting

q0 = find(Quality == 0);
lia = ismember(q0,pon);
q = q0(lia == 0);
plot(breath.cue(q,1)/60,extractfield(reststore,'VTesti'),'v','color',[153 153 153]/255)

xlim([floor(breath.cue(1,1)/60)-1 30])
xlabel('Time (min)'), ylabel('Tidal Volume (L)')

mass = assignmass(filename); 
TLC = 0.135*mass^0.92; % estimate from Kooyman 1973
ylim([0 TLC]), plot([0 30],[TLC TLC],'k')
text(30.25,TLC,'TLCest','fontsize',14)

adjustfigurefont('Helvetica',16)

set(gcf,'position',[21.6667  127.0000  756.6667  420.0000],'paperpositionmode','auto')
print([cd '\AnalysisFigures\tt13_269_timeline_PRES.png'],'-dpng')

