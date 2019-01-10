% import band file
warning off, clear

BreathCommentsTest
ChestBand = detrend(ChestBand);


%% what about maxima? (peak inspiratory flow and peak expansion)

% if exist('Flocs') ~= 1
%     % find peaks and determine whether peak inspiration rate correlates
%     [Fpks,Flocs,~,Fp] = findpeaks(FilteredFlow,t,'minpeakheight',10,'minpeakdistance',400,'minpeakprominence',5);
%     % plot(Flocs,Fpks,'ko')
[Bpks,Blocs,~,Bp] = findpeaks(ChestBand,t,'minpeakprominence',0.01,'minpeakdistance',400,'minpeakheight',0.01);
% this is for the corrected prominence    
Bpold = Bp; Bp = Bpold + [0 -0.004 0 0.0 0 0.004 0 -.015 0 -0.005 -0.001 0 0 0 0 -0.008 0.007 -0.01 -0.005 0 0 0 0];

save(filename,'Flocs','Fpks','Bp','Bpks','Blocs','-append')
% end

% find matched times between two time series
[kx,mind] = nearest(Flocs',Blocs',200);
match = find(~isnan(kx));
% find all band values not associated with a pneumotach measurement
othr = find(ismember(1:length(Blocs),match)<1);


figure(9), clf
subplot(231), hold on, plot(Bp(match),Fpks,'ro')
[coeffs,rsq,RMSE] = evalcorr(Bp(match),Fpks,1);
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
plot(Bmint(match),all_SUMMARYDATA(:,6),'o'), 
plot(Bpint(match),all_SUMMARYDATA(:,6),'o'), 
plot(Btint(match),all_SUMMARYDATA(:,6),'o'), 
ylabel('Inspired VT'), xlabel('Band Parameter')
legend('Half Max','Half P','Third P','location','nw')

[pp,S] = polyfit(Bpint(match)',all_SUMMARYDATA(:,6), 1); 
[Bpstat.coeffs,Bpstat.rsq,Bpstat.RMSE] = evalcorr(Bpint(match)',all_SUMMARYDATA(:,6),1);
plot(Bpint(othr),polyval(pp,Bpint(othr)),'r*')
[pm,S] = polyfit(Bmint(match)',all_SUMMARYDATA(:,6), 1); 
[Bmstat.coeffs,Bmstat.rsq,Bmstat.RMSE] = evalcorr(Bmint(match)',all_SUMMARYDATA(:,6),1); 
plot(Bmint(othr),polyval(pm,Bmint(othr)),'c*')
[pt,S] = polyfit(Btint(match)',all_SUMMARYDATA(:,6), 1); 
[Btstat.coeffs,Btstat.rsq,Btstat.RMSE] = evalcorr(Btint(match)',all_SUMMARYDATA(:,6),1);
plot(Btint(othr),polyval(pt,Btint(othr)),'y*')

text(2.5,12,num2str([Bpstat.rsq; Bpstat.RMSE]))
text(1.5,15,num2str([Bmstat.rsq; Bmstat.RMSE]))
text(0.9,15,num2str([Btstat.rsq; Btstat.RMSE]))


%% correlate VT and inspired flow rates
figure(10), clf
subplot(221), hold on
plot(Bpks(match),all_SUMMARYDATA(:,3),'o'), xlabel('Band Peak'), ylabel('Max Inspiratory Flow Rate (L/s)')
plot(Bpks(match(9:10)),all_SUMMARYDATA(9:10,3),'.')
[p,S] = polyfit(Bpks(match)',all_SUMMARYDATA(:,3), 1);
plot(Bpks(match),polyval(p,Bpks(match))), plot(Bpks(othr),polyval(p,Bpks(othr)),'*')
plot(Bpks(15),polyval(p,Bpks(15)),'r*') 
[curvefit,gof] = fit(Bpks(match)',all_SUMMARYDATA(:,3), 'poly1'); % gof.rmse
text(0.015,25,num2str(gof.rmse))


subplot(222), hold on % prominence and max inspiratory flow
plot(Bp(match),all_SUMMARYDATA(:,3),'o'), xlabel('Band Prominence')
plot(Bp(match(9:10)),all_SUMMARYDATA(9:10,3),'.')
[p,S] = polyfit(Bp(match)',all_SUMMARYDATA(:,3), 2);
plot(Bp(match),polyval(p,Bp(match))), plot(Bp(othr),polyval(p,Bp(othr)),'*')
plot(Bp(15),polyval(p,Bp(15)),'r*') % 
[curvefit,gof] = fit(Bp(match)',all_SUMMARYDATA(:,3), 'poly2'); % gof.rmse
text(0.01,25,num2str(gof.rmse))

subplot(223), hold on
plot(Bp(match),all_SUMMARYDATA(:,6),'o'), xlabel('Band Prominence'), ylabel('Inspired VT (L)')
plot(Bp(match(9:10)),all_SUMMARYDATA(9:10,6),'.')
[p,S] = polyfit(Bp(match)',all_SUMMARYDATA(:,6), 1);
plot(Bp(match),polyval(p,Bp(match))), plot(Bp(othr),polyval(p,Bp(othr)),'*')
plot(Bp(15),polyval(p,Bp(15)),'r*') % 
[curvefit,gof] = fit(Bp(match)',all_SUMMARYDATA(:,6), 'poly1'); % gof.rmse
text(0.01,18,num2str(gof.rmse))

subplot(224), hold on
plot(Btint(match),all_SUMMARYDATA(:,6),'o'), xlabel('Integral at FWTP')
plot(Btint(match(9:10)),all_SUMMARYDATA(9:10,6),'.')
[pt,S] = polyfit(Btint(match)',all_SUMMARYDATA(:,6), 1); f = polyval(pt,Btint(match)); 
plot(Btint(match),f), plot(Btint(othr),polyval(pt,Btint(othr)),'*')
plot(Btint(15),polyval(pt,Btint(15)),'r*')
[curvefit,gof] = fit(Btint(match)',all_SUMMARYDATA(:,6), 'poly1'); % gof.rmse
text(0.01,18,num2str(gof.rmse))


print(strcat(regexprep(filename,'.mat',''),'-VTFlowcorrelate'),'-dpng')

%% %% plot all envelopes in subplot

load('DQFiles2017')
f = 5; tag = DQ2017{f,1};
R = loadaudit(tag); recdir = d3makefname(tag,'RECDIR');

% get cues
CUE_S = find(CUE); % cues in pneumotach summary file
CUE_R = CUE(find(CUE)); % cues in R audit structure

[~,breath] = findaudit(R,'breath');

for i = 1:length(CUE_R)
    [b(i).clean(:,1),afs] = cleanbreath_fun(tag,breath.cue(CUE_R(i),:),recdir,0,1); % channel 1
    [~,~,b(i).env(:,1),fs] = envfilt(b(i).clean(:,1),afs);
    
    [b(i).clean(:,2),afs] = cleanbreath_fun(tag,breath.cue(CUE_R(i),:),recdir,0,2); % channel 2
    [~,~,b(i).env(:,2),fs] = envfilt(b(i).clean(:,2),afs);
    
    figure(21),
    subplot(ceil(length(CUE_R)/3),3,i), hold on, ylim([-0.1E-4 2E-3]), xlim([0 1])
    plot((1:length(b(i).env))/fs,b(i).env(:,1),'color',[194/255 165/255 207/255]) % dark purple
    plot((1:length(b(i).env))/fs,b(i).env(:,2),'color',[123/255 50/255 148/255]) % light purple
end
