% REGRESSION TEST FOR E vs I PARAMETERS
% IS E VS I CORRELATION DIFFERENT WHEN PNEUMOTACH ON/OFF?
%                                 WHEN SEPARATED BY INDIVIDUAL?
%                                 WHEN CHASING THE BOAT (HIGHER DRAG)?
%

% Determine effect of individual/pneum on or off/boat/before or after for a
% relationship between two parameters

% LINEAR RELATIONSHIP
% So your model is:
%     Y = m*x + b
%
% The first problem is to test the null hypothesis that there is no difference between individuals
% /pneumotach treatment/exercise level, etc
% that is, that m and b are the same.
% To test this, you would:

% load data
close all; clear all; clc

load('AllBreaths_noPEAK')
vlbs = {'e.time window','e.EFD','e.RMS','e.PP','e.Fcent',...
    'i.time window','i.EFD','i.RMS','i.PP','i.Fcent'}';

close all


%% FOR LOCATION (DQO vs. SARASOTA)

clear F h pval 

% for each combination of parameters
for param = 1:5;

%% 1.  pool the data for all LOCATION, fit the model, and record the residual sum of squares - call this RSSo
% RSS = SSE (same thing): sum over (y - yhat)^2
x = BREATHONLY(:,param); % e Param
y = BREATHONLY(:,param+5); % matching i Param
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
RSSo = sum(yresid.^2);
SStotal = (length(y)-1)*var(y);
RSq = 1 - RSSo/SStotal;
RSq_adj = 1 - RSSo/SStotal * (length(y)-1)/(length(y)-length(p));

figure(param+7)
title('DQO (blue) vs. Sarasota (red)')
plot(x,y,'k.',x,yfit,'k-')

mdl_all = LinearModel.fit(x,y);
disp(mdl_all)

%% 2.  fit the model separately to each LOCATION and record the sum of the residual sums of squares. Sum of each model's RSS = RSS1

SARASOTA = find(BREATHONLY(:,15) == 2);
DQO = find(BREATHONLY(:,15) == 1);

x = BREATHONLY(DQO,param);
y = BREATHONLY(DQO,param+5);
p1 = polyfit(x,y,1);
yfit = polyval(p1,x);
yresid = y - yfit;
RSS_before = sum(yresid.^2);

hold on
plot(x,y,'bo',x,yfit,'b-')

x = BREATHONLY(SARASOTA,param);
y = BREATHONLY(SARASOTA,param+5);
p2 = polyfit(x,y,1);
yfit = polyval(p2,x);
yresid = y - yfit;
RSS_after = sum(yresid.^2);

plot(x,y,'ro',x,yfit,'r-')
xlabel(vlbs(param))
ylabel(vlbs(param+5))


RSS1 = RSS_before + RSS_after;


%% 3.  form the F statistic: K = 3 (number of groups); n = 710 (total n data points)
%     F = ((RSSo - RSS1)/K - 1) / (RSS1/(n - K))

n = length(BREATHONLY);
K = 3; 
F(param) = ((RSSo - RSS1)/(K-1)) / (RSS1/(n-K));

%% 4.  reject the null hypothesis of no difference at significance level alpha
% if F exceeds the upper alpha-quantile of the F distribution with 4 degrees of freedom in the numerator
% and n - 6 degrees of freedom in the denominator.

% compute critical value
crit = finv((1-0.05),(K-1),(n-K));

% reject h0? (does F exceed critical value?) 1 = yes (reject); 0 = no
% (do not reject)
h(param) = F(param)>crit;

pval(param) = 1-fcdf(F(param),(K-1),(n-K));

end
h
pval

%% WITHIN DOLPHIN QUEST, ARE THERE DIFFERENCES BETWEEN INDIVIDUALS?
clear F h pval 

% for each combination of parameters
for param = 1:5;

%% 1.  pool the data for all INDIVIDUALS, fit the model, and record the residual sum of squares - call this RSSo
% RSS = SSE (same thing): sum over (y - yhat)^2
x = BREATHONLY(DQO,param); % e.EFD
y = BREATHONLY(DQO,param+5); % i.EFD
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
RSSo = sum(yresid.^2);
SStotal = (length(y)-1)*var(y);
RSq = 1 - RSSo/SStotal;
RSq_adj = 1 - RSSo/SStotal * (length(y)-1)/(length(y)-length(p));

figure(param)
plot(x,y,'.',x,yfit,'c-')

mdl_all = LinearModel.fit(x,y);
disp(mdl_all)

%% 2.  fit the model separately to each INDIVIDUAL and record the sum of the residual sums of squares. Sum of each model's RSS = RSS1

kolohe = find(BREATHONLY(DQO,11) == 1);
liko = find(BREATHONLY(DQO,11) == 2);
lono = find(BREATHONLY(DQO,11) == 3);
nainoa = find(BREATHONLY(DQO,11) == 4);

x = BREATHONLY(kolohe,param);
y = BREATHONLY(kolohe,param+5);
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
RSS_kolohe = sum(yresid.^2);

hold on
plot(x,y,'bo',x,yfit,'b-')

x = BREATHONLY(liko,param);
y = BREATHONLY(liko,param+5);
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
RSS_liko = sum(yresid.^2);

plot(x,y,'ro',x,yfit,'r-')

x = BREATHONLY(lono,param);
y = BREATHONLY(lono,param+5);
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
RSS_lono = sum(yresid.^2);

plot(x,y,'ko',x,yfit,'k-')

x = BREATHONLY(nainoa,param);
y = BREATHONLY(nainoa,param+5);
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
RSS_nainoa = sum(yresid.^2);

plot(x,y,'go',x,yfit,'g-')

xlabel(vlbs(param))
ylabel(vlbs(param+5))

RSS1 = RSS_kolohe + RSS_liko + RSS_lono + RSS_nainoa;


%% 3.  form the F statistic: K = 5 (number of groups); n = 232 (total n data points)
%     F = ((RSSo - RSS1)/K - 1) / (RSS1/(n - K))

n = length(BREATHONLY(DQO));
K = 5; 
F = ((RSSo - RSS1)/(K-1)) / (RSS1/(n-K));

%% 4.  reject the null hypothesis of no difference at significance level alpha
% if F exceeds the upper alpha-quantile of the F distribution with 4 degrees of freedom in the numerator
% and n - 6 degrees of freedom in the denominator.

% compute critical value
crit = finv((1-0.05),(K-1),(n-K));

% reject h0? (does F exceed critical value?) 1 = yes (reject); 0 = no
% (do not reject)
h(param) = F>crit;

pval(param) = 1-fcdf(F,(K-1),(n-K));

end

h
pval



%% FOR PNEUM ON/OFF

clear F h pval 

% Sarasota Unique IDs:
SarID = [133; 142; 164; 175; 176; 185; 196; 241; 242; 268; 276];

% for each combination of parameters
for animal = 1:10
for param = 1:5;

%% 1.  pool the data for all BREATHS, fit the model, and record the residual sum of squares - call this RSSo
% RSS = SSE (same thing): sum over (y - yhat)^2

% for a given individual
indv = find(BREATHONLY(:,11) == SarID(animal));

x = BREATHONLY(indv,param); % e Param
y = BREATHONLY(indv,param+5); % matching i Param
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
RSSo = sum(yresid.^2);
SStotal = (length(y)-1)*var(y);
RSq = 1 - RSSo/SStotal;
RSq_adj = 1 - RSSo/SStotal * (length(y)-1)/(length(y)-length(p));

figure(param+14)
plot(x,y,'k.',x,yfit,'k-')

%% 2.  fit the model separately to each PNEUMOTACH CONDITION and record the sum of the residual sums of squares. Sum of each model's RSS = RSS1

ON = find(BREATHONLY(indv,14) == 1);
OFF = find(BREATHONLY(indv,14) == 0);

x = BREATHONLY(indv(ON),param);
y = BREATHONLY(indv(ON),param+5);
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
RSS_ON = sum(yresid.^2);

hold on
plot(x,y,'bo',x,yfit,'b-')

x = BREATHONLY(indv(OFF),param);
y = BREATHONLY(indv(OFF),param+5);
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
RSS_OFF = sum(yresid.^2);

plot(x,y,'ro',x,yfit,'r-')
xlabel(vlbs(param))
ylabel(vlbs(param+5))


RSS1 = RSS_ON + RSS_OFF;


%% 3.  form the F statistic: K = 3 (number of groups); n = 232 (total n data points)
%     F = ((RSSo - RSS1)/K - 1) / (RSS1/(n - K))

n = length(BREATHONLY(indv));
K = 3; 
F(param) = ((RSSo - RSS1)/(K-1)) / (RSS1/(n-K));

%% 4.  reject the null hypothesis of no difference at significance level alpha
% if F exceeds the upper alpha-quantile of the F distribution with K-1 degrees of freedom in the numerator
% and n - K degrees of freedom in the denominator.

% compute critical value
crit = finv((0.95),(K-1),(n-K));

% reject h0? (does F exceed critical value?) 1 = yes (reject); 0 = no
% (do not reject)
h(animal,param) = F(param)>crit;

pval(animal,param) = 1-fcdf(F(param),(K-1),(n-K));

end
end

h
pval

return
%% FOR BOAT

clear F h pval 

% for each combination of parameters
for param = 1:5;

%% 1.  pool the data for all INDIVIDUALS, fit the model, and record the residual sum of squares - call this RSSo
% RSS = SSE (same thing): sum over (y - yhat)^2
x = BREATHONLY(DQO,param); % e Param
y = BREATHONLY(DQO,param+5); % matching i Param
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
RSSo = sum(yresid.^2);
SStotal = (length(y)-1)*var(y);
RSq = 1 - RSSo/SStotal;
RSq_adj = 1 - RSSo/SStotal * (length(y)-1)/(length(y)-length(p));

figure(param+21)
plot(x,y,'.',x,yfit,'c-')

%% 2.  fit the model separately to each INDIVIDUAL and record the sum of the residual sums of squares. Sum of each model's RSS = RSS1

BOAT = find(BREATHONLY(DQO,13) > 14 & BREATHONLY(DQO,13) < 17);
NOBOAT = find(BREATHONLY(DQO,13) < 15 | BREATHONLY(DQO,13) > 16);

x = BREATHONLY(BOAT,param);
y = BREATHONLY(BOAT,param+5);
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
RSS_BOAT = sum(yresid.^2);

hold on
plot(x,y,'bo',x,yfit,'b-')

x = BREATHONLY(NOBOAT,param);
y = BREATHONLY(NOBOAT,param+5);
p = polyfit(x,y,1);
yfit = polyval(p,x);
yresid = y - yfit;
RSS_NOBOAT = sum(yresid.^2);

plot(x,y,'ro',x,yfit,'r-')
xlabel(vlbs(param))
ylabel(vlbs(param+5))


RSS1 = RSS_ON + RSS_NOBOAT;


%% 3.  form the F statistic: K = 3 (number of groups); n = 232 (total n data points)
%     F = ((RSSo - RSS1)/K - 1) / (RSS1/(n - K))

n = length(BREATHONLY(DQO));
K = 3; 
F(param) = ((RSSo - RSS1)/(K-1)) / (RSS1/(n-K));

%% 4.  reject the null hypothesis of no difference at significance level alpha
% if F exceeds the upper alpha-quantile of the F distribution with K-1 degrees of freedom in the numerator
% and n - K degrees of freedom in the denominator.

% compute critical value
crit = finv((0.95),(K-1),(n-K));

% reject h0? (does F exceed critical value?) 1 = yes (reject); 0 = no
% (do not reject)
h(param) = F(param)>crit;

pval(param) = 1-fcdf(F(param),(K-1),(n-K));

end
h
pval