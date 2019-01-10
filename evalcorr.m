function [coeffs,rsq,RMSE,yresid,fit2,gof2] = evalcorr(x,y,fig,color,exclude)
% evaluate correlation 
% [coeffs,rsq,RMSE,yresid,fit2,gof2] = evalcorr(x,y,fig,color,exclude)
% inputs
%   x, y elements to correlate
%   fig: 1 or 0 to plot the fitted data, default 0
%   color: if plot, what color?
%   exclude: exclude outliers?
%
% outputs
%   rsq: fit
%   coeffs: coefficients from regression 

% default don't plot
if nargin < 3 
    fig = 0; 
end

% default make it black
if nargin < 4
    color = [0 0 0];
end

% remove NaNs 
y(any(isnan(x), 2)) = []; % remove lines from B before remove them from Sint
x(any(isnan(x), 2)) = [];

coeffs = polyfit(x,y,1); % linear
yfit = polyval(coeffs,x); % fitted data
yresid = y - yfit; % calculate residuals
SSresid = sum(yresid.^2); 
SStotal = (length(y)-1) * var(y);
SSerror = SStotal - SSresid;
RMSE = sqrt(sum(yresid.^2)/length(y));
rsq = 1 - SSresid/SStotal; % calculate rsq 

if fig == 1
plot(linspace(min(x),max(x),20),polyval(coeffs,linspace(min(x),max(x),20)),'color',color)
end

% alternative: 
% [f1,gof] = fit(x,y,'poly1')
% plot(f1,x,y) 

if exclude == 1
% or find outliers and exclude 
% fdata = feval(f1,x); 
I = abs(yfit - y) > 1.5*std(y);
outliers = excludedata(x,y,'indices',I);


[fit2,gof2] = fit(x,y,'poly1',...
            'Exclude',outliers,'robust','LAR'); 
         plot(fit2,x,y,outliers)
end