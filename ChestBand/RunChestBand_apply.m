% import band file
warning off, % clear

BreathCommentsTest

if ~isempty(findstr(filename,'Trial53')) == 1
    ChestBand = detrend(ChestBand);
end


%% what about maxima? (peak inspiratory flow and peak expansion)
if exist('Flocs') ~= 1
    % find peaks and determine whether peak inspiration rate correlates
    [Fpks,Flocs,~,~] = findpeaks(FilteredFlow,t,'minpeakheight',10,'minpeakdistance',400,'minpeakprominence',5);
    % plot(Flocs,Fpks,'ko')
    [Bpks,Blocs,~,Bp] = findpeaks(ChestBand,t,'minpeakprominence',0.01,'minpeakdistance',400,'minpeakheight',0.01);
    save(filename,'Flocs','Fpks','Bp','Bpks','Blocs','-append')
end

% remove chuffs from 22 and 44
if ~isempty(findstr(filename,'Trial22')) == 1
    Flocs = Flocs(1:end-2); Fpks = Fpks(1:end-2); CUE = CUE(1:end-2); 
end
if ~isempty(findstr(filename,'Trial44')) == 1
    Flocs = Flocs(1:end-2); Fpks = Fpks(1:end-2); CUE = CUE(1:end-2); 
end

% find matched times between two time series
[kx,mind] = nearest(Flocs',Blocs',200);
match = find(~isnan(kx)); % band indices with matching pneumotach
[kx,mind] = nearest(Blocs',Flocs',200);
Fmatch = find(~isnan(kx)); % pneumotach indices with matching band
% find all band values not associated with a pneumotach measurement
othr = find(ismember(1:length(Blocs),match)<1);

%% compute 3dbduration
% for height
% for prominence
figure(42), clf, 
for p = 1:length(Bpks)
        
        subplot(7,6,p), hold on, title(p)
        sig = ChestBand(Blocs(p)-400:Blocs(p)+400); sig = sig - sig(1); % center around zero
        plot(sig)
        
        [newpk,newloc,~,newprom] = findpeaks(sig,'minpeakheight',0.005,'minpeakdistance',400);

        plot(newloc,newpk,'o')
        
        
        HM = newpk/2; % half max
        above = find(sig>newpk/2); % find local values above half max
        plot([above(1) above(end)],[HM HM])
        FWHM(p) = (above(end)-above(1))/tickrate; % full width half max in seconds
        %% integrate band between FWHP?
        ind1 = Blocs(p)-400+above(1); % start of FWHM
        ind2 = Blocs(p)-400+above(end); % end of FWHM
        plot(ChestBand(ind1:ind2)-ChestBand(ind1),'r') % whatever is above the FWHM
        
        Bmint(p) = abs(trapz(ChestBand(ind1:ind2)-ChestBand(ind1)));
        
        %% 
        % CALCULATE PROMINENCE AGAIN 
        
        [minv,minloc,~,minprom] = findpeaks(-sig,'minpeakheight',0.001,'minpeakdistance',700);
        plot([newloc newloc],[newpk newpk-newprom])
        plot([minloc minloc],[-minv -minv+minprom])
        if isempty(minv) == 1; 
           minv = 0; minprom = 0; 
        end
        
        HP = (newprom -(newprom/2)); % half prominence
        above = find(sig>HP);
        plot([above(1) above(end)],[HP HP])
        FWHP(p) = (above(end)-above(1))/tickrate; % full width half prominence in sec
        
        %% integrate band between FWHP?
        ind1 = Blocs(p)-400+above(1); % start of FWHP
        ind2 = Blocs(p)-400+above(end); % end of FWHPfil
        plot(ChestBand(ind1:ind2)-ChestBand(ind1),'k') % whatever is above the FWHP
        
        Bpint(p) = abs(trapz(ChestBand(ind1:ind2)-ChestBand(ind1)));
        
        %% third prominence?
        TP = (newpk-(newprom/3)); % third prominence
        above = find(sig>TP);
        plot([above(1) above(end)],[TP TP])
        FWTP(p) = (above(end)-above(1))/tickrate; % full width third prominence in sec
        
        %% integrate band between FWTP?
        ind1 = Blocs(p)-400+above(1); % start of FWHP
        ind2 = Blocs(p)-400+above(end); % end of FWHPfil
        plot(ChestBand(ind1:ind2)-ChestBand(ind1),'g') % whatever is above the FWHP
        
        Btint(p) = abs(trapz(ChestBand(ind1:ind2)-ChestBand(ind1)));
    
    Bprom(p) = newprom; % store new prominence
    new_pk(p) = newpk; % 
    min_prom(p) = minprom(1); %
    Sumprom(p) = newprom + minprom(1); % amplitude, effectively
end

%% also calculate inhalation duration
for F = 1:length(Flocs)
    F_HM = Fpks(F)/2; % half max
    
%     figure(43), clf, hold on
%     plot(FilteredFlow(Flocs(F)-400:Flocs(F)+400))
%     plot(400,Fpks(F),'o')
    above = find(FilteredFlow(Flocs(F)-400:Flocs(F)+400)>F_HM); % find local values above half max
%     plot([above(1) above(end)],[F_HM F_HM])
    F_FWHM(F) = (above(end)-above(1))/tickrate; % full width half max in seconds
end

%% import VT from processed data

cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
SUMfname = strcat(regexprep(filename,'.mat',''),'-DATA_SUMMARY.txt');
all_SUMMARYDATA = importDATASUMMARY(SUMfname);
TIMEfname = strcat(regexprep(filename,'.mat',''),'-RESP_TIMING.txt');
RESPTIMING = importRESPTIMING(TIMEfname);
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds'

% summary data column 5 = expired VT, 6 = inspired VT

%% correlate VT and inspired flow rates
figure(10), clf
% subplot(221), hold on
% plot(new_pk(match),all_SUMMARYDATA(Fmatch,3),'o'), xlabel('Band Peak'), ylabel('Max Inspiratory Flow Rate (L/s)')
% % plot(Bpks(match(11:12)),all_SUMMARYDATA(11:12,3),'.')
% [p,S] = polyfit(new_pk(match)',all_SUMMARYDATA(Fmatch,3), 1);
% plot(new_pk(match),polyval(p,new_pk(match))), plot(new_pk(othr),polyval(p,new_pk(othr)),'*')
% % plot(Bpks(14),polyval(p,Bpks(14)),'r*') 
% [curvefit,gof] = fit(new_pk(match)',all_SUMMARYDATA(Fmatch,3), 'poly1'); % gof.rmse
% text(0.015,25,num2str(gof.rmse))
% 
% subplot(222), hold on % prominence and max inspiratory flow
% plot(Sumprom(match),all_SUMMARYDATA(Fmatch,3),'o'), xlabel('Band Prominence')
% % plot(Bprom(match(11:12)),all_SUMMARYDATA(11:12,3),'.')
% [p,S] = polyfit(Sumprom(match)',all_SUMMARYDATA(Fmatch,3), 1);
% plot(Sumprom(match),polyval(p,Sumprom(match))), plot(Sumprom(othr),polyval(p,Sumprom(othr)),'*')
% % plot(Bprom(15),polyval(p,Bprom(15)),'r*') % 
% [curvefit,gof] = fit(Bprom(match)',all_SUMMARYDATA(Fmatch,3), 'poly1'); % gof.rmse
% text(0.05,25,num2str(gof.rmse))

%subplot(223), hold on
hold on
plot(Sumprom(match),all_SUMMARYDATA(Fmatch,6),'o'), xlabel('Band Prominence'), ylabel('Inhaled VT')
plot(Sumprom(match),abs(all_SUMMARYDATA(Fmatch,5)),'o')

[p,S] = fit(Sumprom(match)',all_SUMMARYDATA(Fmatch,6), 'poly1');
IVTest = feval(p,Sumprom(othr));
plot(Sumprom(match),feval(p,Sumprom(match)),'.-'), plot(Sumprom(othr),IVTest,'*')
text(0.1,6,num2str(S.rmse))
[ci_IVT] = predint(p,sort(Sumprom(match)'));
H = plot_ci(sort(Sumprom(match)),ci_IVT,'patchcolor',[0.6350    0.0780    0.1840],'patchalpha',0.25,'linecolor','w');

[p,S] = fit(Sumprom(match)',abs(all_SUMMARYDATA(Fmatch,5)), 'poly1');
EVTest = feval(p,Sumprom);
plot(Sumprom(match),feval(p,Sumprom(match)),'.-'), plot(Sumprom(othr),EVTest(othr),'*')
text(0.1,5,num2str(S.rmse))
[ci_EVT] = predint(p,sort(Sumprom(match)'));
H = plot_ci(sort(Sumprom(match)),ci_EVT,'patchcolor',[0.6350    0.0780    0.1840],'patchalpha',0.25,'linecolor','w');


% subplot(224), hold on
% plot(Bmint(match),all_SUMMARYDATA(Fmatch,6),'o'), xlabel('Integral at FWHM')
% [pt,S] = polyfit(Bmint(match)',all_SUMMARYDATA(Fmatch,6), 1); f = polyval(pt,Bmint(match)); 
% plot(Bmint(match),f), plot(Bmint(othr),polyval(pt,Bmint(othr)),'*')
% [curvefit,gof] = fit(Bmint(match)',all_SUMMARYDATA(Fmatch,6), 'poly1'); % gof.rmse
% text(1,6,num2str(gof.rmse))

print(strcat(regexprep(filename,'.mat',''),'-VTFlowcorrelate'),'-dpng')

%% make a better figure for paper, only what we care about 
figure(20), clf
ax1 = subplot('position',[0.1 0.1 0.5 0.6]); hold on; 
H = plot_ci(sort(Sumprom(match)),ci_IVT,'patchcolor',[0    0    0],'patchalpha',0.25,'linecolor','w');
H = plot_ci(sort(Sumprom(match)),ci_EVT,'patchcolor',[0   0   0],'patchalpha',0.25,'linecolor','w');


h = scatter(Sumprom(match),all_SUMMARYDATA(Fmatch,6),'kv','markerfacecolor','k'); % prominence and inhaled volume
h.MarkerFaceAlpha = 0.5;
h = scatter(Sumprom(match),abs(all_SUMMARYDATA(Fmatch,5)),'k^','markerfacecolor','k'); % prominence and exhaled volume
h.MarkerFaceAlpha = 0.5;
xlabel('Band Prominence'), ylabel('Tidal Volume (L)')

[p,S] = polyfit(Sumprom(match)',all_SUMMARYDATA(Fmatch,6), 1);
IVTest = polyval(p,Sumprom(othr)); % estimated inhaled volume
plot(Sumprom(match),polyval(p,Sumprom(match)),'k')
h = scatter(Sumprom(othr),IVTest,'kv','markerfacecolor',[0 146 146]/255); h.MarkerFaceAlpha = 0.5; 

[p,S] = polyfit(Sumprom(match)',abs(all_SUMMARYDATA(Fmatch,5)), 1);
EVTest = polyval(p,Sumprom); % estimated exaled volume
plot(Sumprom(match),EVTest(match),'k')
h = scatter(Sumprom(othr),EVTest(othr),'k^','markerfacecolor',[0 146 146]/255); h.MarkerFaceAlpha = 0.5; 

[curvefitI,IVTgof] = fit(Sumprom(match)',all_SUMMARYDATA(Fmatch,6), 'poly1'); % inhaled fit
[curvefitE,EVTgof] = fit(Sumprom(match)',abs(all_SUMMARYDATA(Fmatch,5)), 'poly1'); % exhaled fit



%% side: densities of tidal volumes measured and estimated
ax2 = subplot('position',[0.65 0.1 0.3 0.6]); hold on
pd_EVT = fitdist(EVTest','Kernel','Bandwidth',1); % estimated exhaled tidal volume
pd_MEVT = fitdist(abs(all_SUMMARYDATA(Fmatch,5)),'Kernel','Bandwidth',1); % measured exhaled tidal volume 
pd_IVT = fitdist(IVTest','Kernel','Bandwidth',1); % estimated inhaled tidal volume
pd_MIVT = fitdist(all_SUMMARYDATA(Fmatch,6),'Kernel','Bandwidth',1); % measured inhaled tidal volume 

x = 0:0.1:max(all_SUMMARYDATA(:,6)); % range for kernel estimation

y_EVT = pdf(pd_EVT,x);
y_MEVT = pdf(pd_MEVT,x);
y_IVT = pdf(pd_IVT,x);
y_MIVT = pdf(pd_MIVT,x);

plot(y_EVT,x,'LineWidth',2,'color',[0 146 146]/255) % because want axes flipped
plot(y_MEVT,x,'k-','LineWidth',2)
plot(y_IVT,x,'Linewidth',2,'Linestyle','--','color',[0 146 146]/255)
plot(y_MIVT,x,'k--','Linewidth',2)

ax2.YLim = ax1.YLim; 
%% top: densities of prominence pneum on and off
ax3 = subplot('position',[0.1 0.8 0.5 0.15]); hold on
pd_pneumon = fitdist(Sumprom(match)','Kernel','Bandwidth',.01); % pneumotach on
pd_pneumoff = fitdist(Sumprom(othr)','Kernel','Bandwidth',.01); % pneumotach off
x = 0:0.005:0.14; 

y_pneumon = pdf(pd_pneumon,x);
y_pneumoff = pdf(pd_pneumoff,x);

plot(x,y_pneumon,'k-','LineWidth',2)
plot(x,y_pneumoff,'color',[0 146 146]/255,'LineWidth',2)

ax3.XLim = ax1.XLim; 
return 

pdsound1 = fitdist(Best','Kernel','Bandwidth',4);
pdoff1 = fitdist(Best_off,'Kernel','Bandwidth',4);
pdoff_othr1 = fitdist(Best_off_othr,'Kernel','Bandwidth',4);

x = 0:0.1:10;
ymeas = pdf(pdmeas,x);
ysound1 = pdf(pdsound1,x);
yoff1 = pdf(pdoff1,x);
yoff_othr1 = pdf(pdoff_othr1,x); 

figure(39), clf, hold on
plot(x,ymeas,'k-','LineWidth',2)
plot(x,ysound1,'color',[0    0.4470    0.7410],'LineWidth',2)
plot(x,yoff1,'y-','LineWidth',2)
plot(x,yoff_othr1,'y-','LineWidth',2)


%%

figure(13), clf, hold on
subplot(221)
plot(Bpks(match),all_SUMMARYDATA(Fmatch,6),'o'), xlabel('Band Peak'), ylabel('Inspired VT')
subplot(222), hold on
plot(Bprom(match),all_SUMMARYDATA(Fmatch,6),'o'), xlabel('Band Prominence')
plot(Sumprom(match),all_SUMMARYDATA(Fmatch,6),'o')
subplot(223)
plot(FWHP(match),all_SUMMARYDATA(Fmatch,6),'o'), xlabel('FWHP'), ylabel('Inspired VT')
subplot(224)
plot(Bpint(match),all_SUMMARYDATA(Fmatch,6),'o'), xlabel('Integral at FWHP')
% legend('Band Peak','Band Prominence','FWHP','FWHM')

print(strcat(regexprep(filename,'.mat',''),'-VTcorrelate'),'-dpng')


figure(11), clf, hold on
subplot(221)
plot(Bpks(match),all_SUMMARYDATA(Fmatch,3),'o'), xlabel('Band Peak'), ylabel('Max Inspiratory Flow Rate (L/s)')
subplot(222)
plot(Bp(match),all_SUMMARYDATA(Fmatch,3),'o'), xlabel('Band Prominence')
subplot(223)
plot(FWHP(match),all_SUMMARYDATA(Fmatch,3),'o'), xlabel('FWHP'), ylabel('Max Inspiratory Flow Rate (L/s)')
subplot(224)
plot(FWHM(match),all_SUMMARYDATA(Fmatch,3),'o'), xlabel('FWHM')

% legend('Band Peak','Band Prominence','FWHP','FWHM')

print(strcat(regexprep(filename,'.mat',''),'-InspFlowcorrelate'),'-dpng')

