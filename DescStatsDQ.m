%% For DQ data

% make colormap
col = colormap(jet);
col = col(1:9:7*9,:);

% set bin centres
X = 50:100:4500;

% PLOT FMAX WITH MEDIANS AND MEANS
% make real only
tt267b.eParams.Fmax = tt267b.eParams.Fmax(find(tt267b.eParams.Fmax));
tt268c.eParams.Fmax = tt268c.eParams.Fmax(find(tt268c.eParams.Fmax));
tt268d.eParams.Fmax = tt268d.eParams.Fmax(find(tt268d.eParams.Fmax));
tt269c.eParams.Fmax = tt269c.eParams.Fmax(find(tt269c.eParams.Fmax));
tt271b.eParams.Fmax = tt271b.eParams.Fmax(find(tt271b.eParams.Fmax));
tt272a.eParams.Fmax = tt272a.eParams.Fmax(find(tt272a.eParams.Fmax));
tt273a.eParams.Fmax = tt273a.eParams.Fmax(find(tt273a.eParams.Fmax));


figure(3); clf; hold on
hist(tt267b.eParams.Fmax,X);
hist(tt268c.eParams.Fmax,X);
hist(tt268d.eParams.Fmax,X);
hist(tt269c.eParams.Fmax,X);
hist(tt271b.eParams.Fmax,X);
hist(tt272a.eParams.Fmax,X);
hist(tt273a.eParams.Fmax,X);

clear h
h = findobj(gca,'Type','patch');

for i = 1:length(h)
set(h(i),'FaceColor',col(i,:),'EdgeColor','k');
end

set (h, 'FaceAlpha', 0.7);

plot([mean(tt267b.eParams.Fmax) mean(tt267b.eParams.Fmax)],[0 18],'color',col(7,:))
plot([median(tt267b.eParams.Fmax) median(tt267b.eParams.Fmax)],[0 18],'color',col(7,:),'linestyle','--')

plot([mean(tt268c.eParams.Fmax) mean(tt268c.eParams.Fmax)],[0 18],'color',col(6,:))
plot([median(tt268c.eParams.Fmax) median(tt268c.eParams.Fmax)],[0 18],'color',col(6,:),'linestyle','--')

plot([mean(tt268d.eParams.Fmax) mean(tt268d.eParams.Fmax)],[0 18],'color',col(5,:))
plot([median(tt268d.eParams.Fmax) median(tt268d.eParams.Fmax)],[0 18],'color',col(5,:),'linestyle','--')

plot([mean(tt269c.eParams.Fmax) mean(tt269c.eParams.Fmax)],[0 18],'color',col(4,:))
plot([median(tt269c.eParams.Fmax) median(tt269c.eParams.Fmax)],[0 18],'color',col(4,:),'linestyle','--')

plot([mean(tt271b.eParams.Fmax) mean(tt271b.eParams.Fmax)],[0 18],'color',col(3,:))
plot([median(tt271b.eParams.Fmax) median(tt271b.eParams.Fmax)],[0 18],'color',col(3,:),'linestyle','--')

plot([mean(tt272a.eParams.Fmax) mean(tt272a.eParams.Fmax)],[0 18],'color',col(2,:))
plot([median(tt272a.eParams.Fmax) median(tt272a.eParams.Fmax)],[0 18],'color',col(2,:),'linestyle','--')

plot([mean(tt273a.eParams.Fmax) mean(tt273a.eParams.Fmax)],[0 18],'color',col(1,:))
plot([median(tt273a.eParams.Fmax) median(tt273a.eParams.Fmax)],[0 18],'color',col(1,:),'linestyle','--')


%% PLOT FCENT WITH MEDIANS AND MEANS
% make real only
tt267b.eParams.Fcent = tt267b.eParams.Fcent(find(tt267b.eParams.Fcent));
tt268c.eParams.Fcent = tt268c.eParams.Fcent(find(tt268c.eParams.Fcent));
tt268d.eParams.Fcent = tt268d.eParams.Fcent(find(tt268d.eParams.Fcent));
tt269c.eParams.Fcent = tt269c.eParams.Fcent(find(tt269c.eParams.Fcent));
tt271b.eParams.Fcent = tt271b.eParams.Fcent(find(tt271b.eParams.Fcent));
tt272a.eParams.Fcent = tt272a.eParams.Fcent(find(tt272a.eParams.Fcent));
tt273a.eParams.Fcent = tt273a.eParams.Fcent(find(tt273a.eParams.Fcent));

figure(4); clf; hold on
hist(tt267b.eParams.Fcent,X);
hist(tt268c.eParams.Fcent,X);
hist(tt268d.eParams.Fcent,X);
hist(tt269c.eParams.Fcent,X);
hist(tt271b.eParams.Fcent,X);
hist(tt272a.eParams.Fcent,X);
hist(tt273a.eParams.Fcent,X);

clear h
h = findobj(gca,'Type','patch');

for i = 1:length(h)
set(h(i),'FaceColor',col(i,:),'EdgeColor','k');
end

set (h, 'FaceAlpha', 0.7);

plot([mean(tt267b.eParams.Fcent) mean(tt267b.eParams.Fcent)],[0 18],'color',col(7,:))
plot([median(tt267b.eParams.Fcent) median(tt267b.eParams.Fcent)],[0 18],'color',col(7,:),'linestyle','--')

plot([mean(tt268c.eParams.Fcent) mean(tt268c.eParams.Fcent)],[0 18],'color',col(6,:))
plot([median(tt268c.eParams.Fcent) median(tt268c.eParams.Fcent)],[0 18],'color',col(6,:),'linestyle','--')

plot([mean(tt268d.eParams.Fcent) mean(tt268d.eParams.Fcent)],[0 18],'color',col(5,:))
plot([median(tt268d.eParams.Fcent) median(tt268d.eParams.Fcent)],[0 18],'color',col(5,:),'linestyle','--')

plot([mean(tt269c.eParams.Fcent) mean(tt269c.eParams.Fcent)],[0 18],'color',col(4,:))
plot([median(tt269c.eParams.Fcent) median(tt269c.eParams.Fcent)],[0 18],'color',col(4,:),'linestyle','--')

plot([mean(tt271b.eParams.Fcent) mean(tt271b.eParams.Fcent)],[0 18],'color',col(3,:))
plot([median(tt271b.eParams.Fcent) median(tt271b.eParams.Fcent)],[0 18],'color',col(3,:),'linestyle','--')

plot([mean(tt272a.eParams.Fcent) mean(tt272a.eParams.Fcent)],[0 18],'color',col(2,:))
plot([median(tt272a.eParams.Fcent) median(tt272a.eParams.Fcent)],[0 18],'color',col(2,:),'linestyle','--')

plot([mean(tt273a.eParams.Fcent) mean(tt273a.eParams.Fcent)],[0 18],'color',col(1,:))
plot([median(tt273a.eParams.Fcent) median(tt273a.eParams.Fcent)],[0 18],'color',col(1,:),'linestyle','--')

meanmedian = mean([median(tt267b.eParams.Fcent),median(tt268c.eParams.Fcent),...
    median(tt268d.eParams.Fcent),median(tt269c.eParams.Fcent),median(tt271b.eParams.Fcent),...
    median(tt272a.eParams.Fcent),median(tt273a.eParams.Fcent)]);
plot([meanmedian meanmedian],[0 18],'LineStyle',':','color','k','LineWidth',3)

meanmedian = median([median(tt267b.eParams.Fcent),median(tt268c.eParams.Fcent),...
    median(tt268d.eParams.Fcent),median(tt269c.eParams.Fcent),median(tt271b.eParams.Fcent),...
    median(tt272a.eParams.Fcent),median(tt273a.eParams.Fcent)]);
plot([medianmedian medianmedian],[0 18],'LineStyle','--','color','k','LineWidth',2)
