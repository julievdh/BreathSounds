% import band file
warning off, clear

BreathCommentsTest

%% what about maxima? (peak inspiratory flow and peak expansion)
if exist('Flocs') ~= 1
    % find peaks and determine whether peak inspiration rate correlates
    [Fpks,Flocs,~,Fp] = findpeaks(FilteredFlow,t,'minpeakheight',10,'minpeakdistance',400,'minpeakprominence',5);
    % plot(Flocs,Fpks,'ko')
    [Bpks,Blocs,~,Bp] = findpeaks(ChestBand,t,'minpeakprominence',0.01,'minpeakdistance',400,'minpeakheight',0.01);
    save(filename,'Flocs','Fpks','Bp','Bpks','Blocs','-append')
end

if ~isempty(findstr(filename,'Trial53')) == 1
    ChestBand = detrend(ChestBand);
end


% find matched times between two time series
[kx,mind] = nearest(Flocs',Blocs',200);
match = find(~isnan(kx));
% find all band values not associated with a pneumotach measurement
othr = find(ismember(1:length(Blocs),match)<1);

figure(9), clf, hold on
subplot(231),plot(Bp(match),Fpks,'ro')
title(regexprep(filename,'_',' '))
ylabel('Max Flow'), xlabel('Band Prominence')
subplot(232), plot(Bpks(match),Fpks,'b^')
ylabel('Max Flow'), xlabel('Band Max')
% title('Height')
%xlabel('Max Flow'), ylabel('Max Band')

%% compute 3dbduration
% for height
% for prominence
figure(42), clf, 
for p = 1:length(Bpks)
    HM = Bpks(p)/2; % half max
    if isnan(HM) == 0
        
        subplot(4,6,p), hold on, title(p)
        plot(ChestBand(Blocs(p)-400:Blocs(p)+400))
        plot(400,Bpks(p),'o')
        above = find(ChestBand(Blocs(p)-400:Blocs(p)+400)>Bpks(p)/2); % find local values above half max
        plot([above(1) above(end)],[HM HM])
        FWHM(p) = (above(end)-above(1))/tickrate; % full width half max in seconds
        %% integrate band between FWHP?
        ind1 = Blocs(p)-400+above(1); % start of FWHP
        ind2 = Blocs(p)-400+above(end); % end of FWHPfil
        plot(ChestBand(ind1:ind2)-ChestBand(ind1)) % whatever is above the FWHP
        
        Bmint(p) = abs(trapz(ChestBand(ind1:ind2)-ChestBand(ind1)));
        
        %% 
        HP = (Bpks(p)-(Bp(p)/2)); % half prominence
        plot([400 400],[Bpks(p) Bpks(p)-Bp(p)])
        above = find(ChestBand(Blocs(p)-400:Blocs(p)+400)>HP);
        plot([above(1) above(end)],[HP HP])
        FWHP(p) = (above(end)-above(1))/tickrate; % full width half prominence in sec
        
        %% integrate band between FWHP?
        ind1 = Blocs(p)-400+above(1); % start of FWHP
        ind2 = Blocs(p)-400+above(end); % end of FWHPfil
        plot(ChestBand(ind1:ind2)-ChestBand(ind1)) % whatever is above the FWHP
        
        Bpint(p) = abs(trapz(ChestBand(ind1:ind2)-ChestBand(ind1)));
        
        %% third prominence?
        TP = (Bpks(p)-(Bp(p)/3)); % third prominence
        above = find(ChestBand(Blocs(p)-400:Blocs(p)+400)>TP);
        plot([above(1) above(end)],[TP TP])
        FWTP(p) = (above(end)-above(1))/tickrate; % full width third prominence in sec
        
        %% integrate band between FWTP?
        ind1 = Blocs(p)-400+above(1); % start of FWHP
        ind2 = Blocs(p)-400+above(end); % end of FWHPfil
        plot(ChestBand(ind1:ind2)-ChestBand(ind1)) % whatever is above the FWHP
        
        Btint(p) = abs(trapz(ChestBand(ind1:ind2)-ChestBand(ind1)));
    end
end

%% also calculate inhalation duration
for F = 1:length(Flocs)
    F_HM = Fpks(F)/2; % half max
    
    figure(43), clf, hold on
    plot(FilteredFlow(Flocs(F)-400:Flocs(F)+400))
    plot(400,Fpks(F),'o')
    above = find(FilteredFlow(Flocs(F)-400:Flocs(F)+400)>F_HM); % find local values above half max
    plot([above(1) above(end)],[F_HM F_HM])
    F_FWHM(F) = (above(end)-above(1))/tickrate; % full width half max in seconds
end


figure(9)
subplot(233), plot(FWHP(match),Fpks,'*')
ylabel('Max Flow'), xlabel('Full Width Half Prominence')
subplot(234),plot(FWHM(match),Fpks,'s')
ylabel('Max Flow'), xlabel('Full Width Half Max')
subplot(235),plot(FWHP(match),F_FWHM,'s')
ylabel('Full Width Half Max Flow'), xlabel('Full Width Half Prominence Band')
subplot(236),plot(FWHM(match),F_FWHM,'s')
ylabel('Full Width Half Max Flow'), xlabel('Full Width Half Max Band')

set(gcf,'paperpositionmode','auto')
print(strcat(regexprep(filename,'.mat',''),'-correlate'),'-dpng')

%% import VT from processed data

cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
SUMfname = strcat(regexprep(filename,'.mat',''),'-DATA_SUMMARY.txt');
all_SUMMARYDATA = importDATASUMMARY(SUMfname);
TIMEfname = strcat(regexprep(filename,'.mat',''),'-RESP_TIMING.txt');
RESPTIMING = importRESPTIMING(TIMEfname);
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds'

% summary data column 5 = expired VT, 6 = inspired VT
%% compare fits
figure(5), clf, hold on
plot(all_SUMMARYDATA(:,6),Bmint(match),'o'), 
plot(all_SUMMARYDATA(:,6),Bpint(match),'o'), 
plot(all_SUMMARYDATA(:,6),Btint(match),'o'), 
xlabel('Inspired VT'), ylabel('Band Parameter')
legend('Half Max','Half P','Third P','location','nw')

[p,S] = polyfit(all_SUMMARYDATA(:,6), Bpint(match)',1);
f = polyval(p,all_SUMMARYDATA(:,6)); 
plot(all_SUMMARYDATA(:,6),f)

Bpstat = regstats(all_SUMMARYDATA(:,6),Bpint(match)','linear','rsquare');
Bmstat = regstats(all_SUMMARYDATA(:,6),Bmint(match)','linear','rsquare');
Btstat = regstats(all_SUMMARYDATA(:,6),Btint(match)','linear','rsquare');

%% correlate VT and inspired flow rates
figure(10), clf
subplot(221), hold on
plot(Bpks(match),all_SUMMARYDATA(:,3),'o'), xlabel('Band Peak'), ylabel('Max Inspiratory Flow Rate (L/s)')
plot(Bpks(2:3),all_SUMMARYDATA(2:3,3),'.')
plot(Bpks(11),14,'r*') % FIT DATA AND PUT MAX INSP VALUE WITH ERROR IN HERE

subplot(222), hold on
plot(Bp(match),all_SUMMARYDATA(:,3),'o'), xlabel('Band Prominence')
plot(Bp(2:3),all_SUMMARYDATA(2:3,3),'.')
plot(Bp(11),14,'r*') % FIT DATA AND PUT MAX INSP VALUE WITH ERROR IN HERE

subplot(223), hold on
plot(Bp(match),all_SUMMARYDATA(:,6),'o'), xlabel('Band Prominence'), ylabel('Inspired VT (L)')
plot(Bp(2:3),all_SUMMARYDATA(2:3,6),'.')
plot(Bp(11),4,'r*')

subplot(224), hold on
plot(Bpint(match),all_SUMMARYDATA(:,6),'o'), xlabel('Integral at FWHP')
plot(Bpint(2:3),all_SUMMARYDATA(2:3,6),'.')
plot(Bpint(11),4,'r*')
% legend('Band Peak','Band Prominence','FWHP','FWHM')

print(strcat(regexprep(filename,'.mat',''),'-VTFlowcorrelate'),'-dpng')


