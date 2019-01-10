% Sarasota Pneumo Tag Deployment Fig

tag = 'tt14_125a';

% load data and metadata
loadprh(tag)
R = loadaudit(tag);
[CAL,DEPLOY] = d3loadcal(tag);

% correct depth
corrdepth = correctdepth(p,fs);
corrdepth(find(corrdepth < -0)) = NaN;

% plot
figure(1), set(gcf,'position',[327  353  946  264],'paperpositionmode','auto')
hold on
plot(((1:length(p))/fs)/3600,-corrdepth)

% find and plot breath cues
[cues,R] = findbreathcues(R);
plot(cues(:,1)/3600,zeros(length(cues),1),'r.') % plot any audited cues

% find time of release
rcue = etime([2014 5 5 DEPLOY.TAGON.RELEASE],DEPLOY.TAGON.TIME);
plot([rcue rcue]/3600,[-10 0.3],'k:') % plot release time

% plot pneumotach time
pstart = etime([2014 5 5 17 50 0],DEPLOY.TAGON.TIME);
pend = etime([2014 5 5 17 55 50],DEPLOY.TAGON.TIME);
patch([pstart pend pend pstart pstart]/3600,[-10 -10 0.3 0.3 0.3],'k','facealpha',0.5)

ylim([-10 0.3]), xlim([0.82 12.44])
ylabel('Depth'), xlabel('Hours Since Tag On')
text(1.8,-8,'Release')

cd \\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\AnalysisFigures
print -dpng tt14_125a_pneumreleasebreaths