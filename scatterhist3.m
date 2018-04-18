function [ax1, ax2, ax3] = scatterhist3(x,y,marker,square,kernel)
% [ax1, ax2, ax3] = scatterhist3(x,y,marker,kernel)
% make scatterhist but with control over each of the panels and allowed to
% overlap, etc

% x is x input
% y is y input
% marker is marker shape (default is o)
% square is if want equal x and y axes
% kernel is size of bandwidth kernel, default 0.5

if nargin < 3
    marker = 'o';
end
if nargin < 4
    square = 0;
end
if nargin < 5
    kernel = 0.5;
end

% reshape any inputs
if size(y,1) < size(y,2)
    y = y';
end
if size(x,1) < size(x,2)
    x = x';
end


ax1 = subplot('position',[0.1 0.1 0.5 0.6]); hold on;

h = scatter(x,y,marker);
h.MarkerFaceAlpha = 0.5;
if square == 1
    minlim = min([ax1.YLim ax1.XLim]);
    mxlim = max([ax1.YLim ax1.XLim]);
    ax1.YLim = [minlim mxlim]; ax1.XLim = [minlim mxlim];
end


%% side: densities of x and y
ax2 = subplot('position',[0.65 0.1 0.15 0.6]); hold on
pd_x = fitdist(x,'Kernel','Bandwidth',kernel);
pd_y = fitdist(y,'Kernel','Bandwidth',kernel);

idx = floor(min(x))-1:0.1:ceil(max(x))+1; % range for kernel estimation
idy = floor(min(y))-1:0.1:ceil(max(y))+1;

xhat = pdf(pd_x,idx);
yhat = pdf(pd_y,idy);

plot(yhat,idy) %,'LineWidth',1.5,'color',[0 146 146]/255) % because want axes flipped

ax2.YLim = ax1.YLim;
%% top: densities of prominence pneum on and off
ax3 = subplot('position',[0.1 0.8 0.5 0.15]); hold on

plot(idx,xhat)% ,'k-','LineWidth',1.5)

ax3.XLim = ax1.XLim;