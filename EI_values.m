% Regression coefficients and significance values for E I relationship

% load data
close all; clear all; clc

load('AllBreaths_noPEAK')
vlbs = {'e.time window','e.EFD','e.RMS','e.PP','e.Fcent',...
    'i.time window','i.EFD','i.RMS','i.PP','i.Fcent'}';

close all

%%

before = find(BREATHONLY(:,12) == 1);
after = find(BREATHONLY(:,12) == 2);
deck = find(BREATHONLY(:,12) == 3);
water = find(BREATHONLY(:,12) == 4);
swim = find(BREATHONLY(:,12) == 5);

for param = 1:5;

%% 1.  pool the data for all LOCATION, fit the model, and record the residual sum of squares - call this RSSo
% RSS = SSE (same thing): sum over (y - yhat)^2
x = BREATHONLY(swim,param); % e Param
y = BREATHONLY(swim,param+5); % matching i Param
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
RSSo = sum(yresid.^2);
SStotal = (length(y)-1)*var(y);
RSq(param) = 1 - RSSo/SStotal;
RSq_adj = 1 - RSSo/SStotal * (length(y)-1)/(length(y)-length(p));

a = p(1); % slope
b = p(2); % intercept

n = length(x); 

Sxx=sum((x-mean(x)).^2);
Syy=sum((y-mean(y)).^2);
Sxy=sum((x-mean(x)).*(y-mean(y)));
SSE=Syy-a*Sxy;
S2yx=SSE/(n-2);

%Standard error of estimate:
Syx=sqrt(SSE/(n-2));
Sb=sqrt(S2yx/Sxx);
A=0;

% significant fit?
t=(a-A)/Sb;
Pvalue(param)=2*(1-tcdf(abs(t),n-2));

end
