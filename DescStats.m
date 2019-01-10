% make colormap
col = colormap(jet);
col = col(1:9:7*9,:);

% set bin centres
X = [50:100:1000];

%% For some deck Sarasota

% PLOT FMAX WITH MEDIANS AND MEANS
figure(1); clf; hold on
hist(tt126x.eParams.Fmax,X);
hist(tt126y.eParams.Fmax,X);
hist(tt126z.eParams.Fmax,X);
hist(tt127z.eParams.Fmax,X);
hist(tt128y.eParams.Fmax,X);
hist(tt128z.eParams.Fmax,X);
hist(tt129x.eParams.Fmax,X);

clear h
h = findobj(gca,'Type','patch');

for i = 1:length(h)
set(h(i),'FaceColor',col(i,:),'EdgeColor','k');
end

set (h, 'FaceAlpha', 0.7);

plot([mean(tt126x.eParams.Fmax) mean(tt126x.eParams.Fmax)],[0 18],'color',col(7,:))
plot([median(tt126x.eParams.Fmax) median(tt126x.eParams.Fmax)],[0 18],'color',col(7,:),'linestyle','--')

plot([mean(tt126y.eParams.Fmax) mean(tt126y.eParams.Fmax)],[0 18],'color',col(6,:))
plot([median(tt126y.eParams.Fmax) median(tt126y.eParams.Fmax)],[0 18],'color',col(6,:),'linestyle','--')

plot([mean(tt126z.eParams.Fmax) mean(tt126z.eParams.Fmax)],[0 18],'color',col(5,:))
plot([median(tt126z.eParams.Fmax) median(tt126z.eParams.Fmax)],[0 18],'color',col(5,:),'linestyle','--')

plot([mean(tt127z.eParams.Fmax) mean(tt127z.eParams.Fmax)],[0 18],'color',col(4,:))
plot([median(tt127z.eParams.Fmax) median(tt127z.eParams.Fmax)],[0 18],'color',col(4,:),'linestyle','--')

plot([mean(tt128y.eParams.Fmax) mean(tt128y.eParams.Fmax)],[0 18],'color',col(3,:))
plot([median(tt128y.eParams.Fmax) median(tt128y.eParams.Fmax)],[0 18],'color',col(3,:),'linestyle','--')

plot([mean(tt128z.eParams.Fmax) mean(tt128z.eParams.Fmax)],[0 18],'color',col(2,:))
plot([median(tt128z.eParams.Fmax) median(tt128z.eParams.Fmax)],[0 18],'color',col(2,:),'linestyle','--')

plot([mean(tt129x.eParams.Fmax) mean(tt129x.eParams.Fmax)],[0 18],'color',col(1,:))
plot([median(tt129x.eParams.Fmax) median(tt129x.eParams.Fmax)],[0 18],'color',col(1,:),'linestyle','--')

%% 
% PLOT FCENT WITH MEDIANS AND MEANS
figure(2); clf; hold on
hist(tt126x.eParams.Fcent,X);
hist(tt126y.eParams.Fcent,X);
hist(tt126z.eParams.Fcent,X);
hist(tt127z.eParams.Fcent,X);
hist(tt128y.eParams.Fcent,X);
hist(tt128z.eParams.Fcent,X);
hist(tt129x.eParams.Fcent,X);

clear h
h = findobj(gca,'Type','patch');

for i = 1:length(h)
set(h(i),'FaceColor',col(i,:),'EdgeColor','k');
end

set (h, 'FaceAlpha', 0.7);

plot([mean(tt126x.eParams.Fcent) mean(tt126x.eParams.Fcent)],[0 18],'color',col(7,:))
plot([median(tt126x.eParams.Fcent) median(tt126x.eParams.Fcent)],[0 18],'color',col(7,:),'linestyle','--')

plot([mean(tt126y.eParams.Fcent) mean(tt126y.eParams.Fcent)],[0 18],'color',col(6,:))
plot([median(tt126y.eParams.Fcent) median(tt126y.eParams.Fcent)],[0 18],'color',col(6,:),'linestyle','--')

plot([mean(tt126z.eParams.Fcent) mean(tt126z.eParams.Fcent)],[0 18],'color',col(5,:))
plot([median(tt126z.eParams.Fcent) median(tt126z.eParams.Fcent)],[0 18],'color',col(5,:),'linestyle','--')

plot([mean(tt127z.eParams.Fcent) mean(tt127z.eParams.Fcent)],[0 18],'color',col(4,:))
plot([median(tt127z.eParams.Fcent) median(tt127z.eParams.Fcent)],[0 18],'color',col(4,:),'linestyle','--')

plot([mean(tt128y.eParams.Fcent) mean(tt128y.eParams.Fcent)],[0 18],'color',col(3,:))
plot([median(tt128y.eParams.Fcent) median(tt128y.eParams.Fcent)],[0 18],'color',col(3,:),'linestyle','--')

plot([mean(tt128z.eParams.Fcent) mean(tt128z.eParams.Fcent)],[0 18],'color',col(2,:))
plot([median(tt128z.eParams.Fcent) median(tt128z.eParams.Fcent)],[0 18],'color',col(2,:),'linestyle','--')

plot([mean(tt129x.eParams.Fcent) mean(tt129x.eParams.Fcent)],[0 18],'color',col(1,:))
plot([median(tt129x.eParams.Fcent) median(tt129x.eParams.Fcent)],[0 18],'color',col(1,:),'linestyle','--')


meanmedian = mean([median(tt129x.eParams.Fcent),median(tt128z.eParams.Fcent),...
    median(tt128y.eParams.Fcent),median(tt127z.eParams.Fcent),median(tt126z.eParams.Fcent),...
    median(tt126y.eParams.Fcent),median(tt126x.eParams.Fcent)]);
plot([meanmedian meanmedian],[0 18],'LineStyle',':','color','k','LineWidth',3)

medianmedian = median([median(tt129x.eParams.Fcent),median(tt128z.eParams.Fcent),...
    median(tt128y.eParams.Fcent),median(tt127z.eParams.Fcent),median(tt126z.eParams.Fcent),...
    median(tt126y.eParams.Fcent),median(tt126x.eParams.Fcent)]);
plot([medianmedian medianmedian],[0 18],'LineStyle','--','color','k','LineWidth',2)

