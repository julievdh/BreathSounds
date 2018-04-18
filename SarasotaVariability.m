
clear all; close all; clc 

% load in summary file
cd '/Users/julievanderhoop/Dropbox (MIT)/Sarasota/May8/8may14_deck_tt128y_F175/Summary_data'
filename = '/Users/julievanderhoop/Dropbox (MIT)/Sarasota/May8/8may14_deck_tt128z_F133/data summary/DATA_SUMMARY-8may14_deck_tt128z_F133_2A-USE.txt';
LoadPneumSummary
% for this file, for some reason, starts as 2rows of NaN - remove
EndtidalO2 = EndtidalO2(3:end); EndtidalCO2 = EndtidalCO2(3:end);
MaxExp = MaxExp(3:end); MaxInsp = MaxInsp(3:end); VT = VT(3:end);

% load in breaths file - timing
filename = '/Users/julievanderhoop/Dropbox (MIT)/Sarasota/May8/8may14_deck_tt128z_F133/data summary/breaths-8may14_deck_tt128z_F133_2A-USE.txt';
LoadPneumBreaths

% plot through time
figure(1); clf; hold on
plot(V1/200/60,abs(VT),'o-')
plot(V1/200/60,MaxExp,'o-')
plot(V1/200/60,MaxInsp,'o-')
xlabel('Time (min)')
legend('Tidal Volume (L)','Max Exp Flow (L/s)','Max Insp Flow (L/s)')

% how variable is VT? 
[mean(abs(VT)) std(abs(VT))]

% how variable is duration? 

% are they autocorrelated?
figure
autocorr(VT)

figure
autocorr(MaxExp)


%% Load in all Pneumodata and look at autocorrelation? 
cd '/Users/julievanderhoop/Dropbox (MIT)/BreathSounds/JulieMatlab/BreathSounds/PneumoData'
d = dir('*.mat');
close all
acf = nan(20,32);
for i = 1:15 % first 15 files are in sarasota, pre-exercise
    load(d(i).name)
    figure(1); hold on
    plot(abs(SUMMARYDATA(:,5)),'o-')
    xlabel('Breath Number'), ylabel('Exh Tidal Volume (L)')
    pause
    dummy = autocorr(SUMMARYDATA(:,5));
    [acf(1:length(dummy),i)] = dummy;
    
    % Ljung-Box Q-test for autocorrelation at lag 1
    [h,p(i),Qstat,crit] = lbqtest(SUMMARYDATA(:,5),'Lags',[1]);
    clear SUMMARYDATA
end

figure(2)
plot(acf)
xlabel('Lag'), ylabel('Autocorrelation')

min(acf(2,:)) % autocorrelation at lag 2 is min -0.4 to 0.5. 
max(acf(2,:))

% any significant autocorrelation at lag 1? 
sig = find(p<0.05);

%% DQ Pre Files? 
clear SUMMARYDATA
for i = 16:length(d) % first 15 files are in sarasota, pre-exercise
    load(d(i).name)
    figure(21); hold on
    plot(abs(pre_SUMMARYDATA(:,5)),'o-')
    xlabel('Breath Number'), ylabel('Exh Tidal Volume (L)')
    dummy = autocorr(pre_SUMMARYDATA(:,5));
    [acf(1:length(dummy),i)] = dummy;
    
    % Ljung-Box Q-test for autocorrelation at lag 1
    [h,p(i),Qstat,crit] = lbqtest(pre_SUMMARYDATA(:,5),'Lags',[1]);
end
%% 
for i = 16:length(d) % first 15 files are in sarasota, pre-exercise
    load(d(i).name)
    figure(31); hold on
    plot(abs(post_SUMMARYDATA(:,5)),'o-')
    
    dummy = autocorr(post_SUMMARYDATA(:,5));
    [acf(1:length(dummy),i)] = dummy;
    
    % Ljung-Box Q-test for autocorrelation at lag 1
    [h,p(i),Qstat,crit] = lbqtest(post_SUMMARYDATA(:,5),'Lags',[1]);
end
