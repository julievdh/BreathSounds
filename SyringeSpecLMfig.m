% syringe spectra linear model figure
% julie van der Hoop
% 23 april 2018

function SyringeSpecLMfig(lm,co)

set(gcf,'position',1E3*[2.0897   -0.1323    1.4540    0.4773],...
    'paperpositionmode','auto')

x(:,1) = 10:22; % range of distances to evaluate over 
sphsprd = 20*log10(x(:,1)/10); % calculate expected loss
x(:,2) = ones(length(x),1,1)+2;
x(:,3) = ones(length(x),1,1)+1;

[xs.dist,ypred.dist,yci.dist] = plotSlice_jvdh(x,lm);

ax1 = axes('position',[0.08 0.1 0.18 0.8]); hold on, box on
plot(ax1,xs.dist,ypred.dist,'color',co)
plot(ax1,xs.dist,yci.dist,'--','color',co)
plot(ax1,xs.dist,ypred.dist(1)-sphsprd,'k:')
ax1.XLim = [min(x(:,1))-0.1*min(x(:,1)) max(x(:,1))+0.1*min(x(:,1))];  ax1.YLim = [-140 -80];
h = get(ax1,'xlabel'); set(h,'string','Distance (cm)');
h = get(ax1,'ylabel'); set(h,'string','Predicted SL (dB)');

set(gca,'color','none')


clear x
x(:,2) = 1:5; % range of flows to calculate over
x(:,1) = zeros(length(x),1,1)+16; % hold stable at 16 
x(:,3) = ones(length(x),1,1)+1;

[~,ypred.flow,yci.flow] = plotSlice_jvdh(x,lm);

ax2 = axes('position',[0.3 0.1 0.18 0.8]); hold on
plot(ax2,x(:,2),ypred.flow,'o-','color',co)
plot(ax2,x(:,2),yci.flow,'--','color',co)
ax2.XLim = [min(x(:,2))-0.3*min(x(:,2)) max(x(:,2))+0.3*min(x(:,2))]; 
ax2.XTick = 1:5;  ax2.YLim = [-140 -80];
set(gca,'color','none'), box on

clear x
x(:,3) = [1 2];
x(:,2) = [3 3]; % range of flows to calculate over
x(:,1) = [16 16]; % hold stable at 16 

[~,ypred.pneum,yci.pneum] = plotSlice_jvdh(x,lm);

ax3 = axes('position',[0.52 0.1 0.18 0.8]); hold on
plot(ax3,x(:,3),ypred.pneum,'o-','color',co)
plot(ax3,x(:,3),yci.pneum,'--','color',co)
ax3.XTick = [1 2]; ax3.YLim = [-140 -80]; ax3.XLim = [0.8 2.2]; 
ax3.XTickLabel = {'Off','On'};
set(gca,'color','none'), box on

subplot('position',[0.8 0.1 0.18 0.8]); hold on 
h = plotEffects(lm); set(h,'color',co), box on

h = get(ax2,'xlabel'); set(h,'string','Flow'); 
h = get(ax3,'Xlabel'); set(h,'string','Pneumotach'); 
