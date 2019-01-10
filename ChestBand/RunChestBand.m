% import band file
warning off, clear

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
    Flocs = Flocs(1:end-2); Fpks = Fpks(1:end-2);
end
if ~isempty(findstr(filename,'Trial44')) == 1
    Flocs = Flocs(1:end-2); Fpks = Fpks(1:end-2);
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
        
        [min,minloc,~,minprom] = findpeaks(-sig,'minpeakheight',0.001,'minpeakdistance',700);
        plot([newloc newloc],[newpk newpk-newprom])
        plot([minloc minloc],[-min -min+minprom])
        if isempty(min) == 1; 
           min = 0; minprom = 0; 
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


% figure(9), clf, hold on
% subplot(231),plot(Bprom(match),Fpks(Fmatch),'ro')
% title(regexprep(filename,'_',' '))
% ylabel('Max Flow'), xlabel('Band Prominence')
% subplot(232), plot(Bpks(match),Fpks(Fmatch),'b^')
% ylabel('Max Flow'), xlabel('Band Max')
% 
% subplot(233), plot(FWHP(match),Fpks(Fmatch),'*')
% ylabel('Max Flow'), xlabel('Full Width Half Prominence')
% subplot(234),plot(FWHM(match),Fpks(Fmatch),'s')
% ylabel('Max Flow'), xlabel('Full Width Half Max')
% subplot(235),plot(FWHP(match),F_FWHM(Fmatch),'s')
% ylabel('Full Width Half Max Flow'), xlabel('Full Width Half Prominence Band')
% subplot(236),plot(FWHM(match),F_FWHM(Fmatch),'s')
% ylabel('Full Width Half Max Flow'), xlabel('Full Width Half Max Band')
% 
% set(gcf,'paperpositionmode','auto')
% print(strcat(regexprep(filename,'.mat',''),'-correlate'),'-dpng')

%% import VT from processed data

cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
SUMfname = strcat(regexprep(filename,'.mat',''),'-DATA_SUMMARY.txt');
all_SUMMARYDATA = importDATASUMMARY(SUMfname);
TIMEfname = strcat(regexprep(filename,'.mat',''),'-RESP_TIMING.txt');
RESPTIMING = importRESPTIMING(TIMEfname);
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds'

% summary data column 5 = expired VT, 6 = inspired VT

% correlate VT with height, prominence, FWHP, FWHM
%% correlate VT and inspired flow rates
figure(10), clf
subplot(221), hold on
plot(new_pk(match),all_SUMMARYDATA(Fmatch,3),'o'), xlabel('Band Peak'), ylabel('Max Inspiratory Flow Rate (L/s)')
% plot(Bpks(match(11:12)),all_SUMMARYDATA(11:12,3),'.')
[p,S] = polyfit(new_pk(match)',all_SUMMARYDATA(Fmatch,3), 1);
plot(new_pk(match),polyval(p,new_pk(match))), plot(new_pk(othr),polyval(p,new_pk(othr)),'*')
% plot(Bpks(14),polyval(p,Bpks(14)),'r*') 
[curvefit,gof] = fit(new_pk(match)',all_SUMMARYDATA(Fmatch,3), 'poly1'); % gof.rmse
text(0.015,25,num2str(gof.rmse))

subplot(222), hold on % prominence and max inspiratory flow
plot(Sumprom(match),all_SUMMARYDATA(Fmatch,3),'o'), xlabel('Band Prominence')
% plot(Bprom(match(11:12)),all_SUMMARYDATA(11:12,3),'.')
[p,S] = polyfit(Sumprom(match)',all_SUMMARYDATA(Fmatch,3), 1);
plot(Sumprom(match),polyval(p,Sumprom(match))), plot(Sumprom(othr),polyval(p,Sumprom(othr)),'*')
% plot(Bprom(15),polyval(p,Bprom(15)),'r*') % 
[curvefit,gof] = fit(Bprom(match)',all_SUMMARYDATA(Fmatch,3), 'poly1'); % gof.rmse
text(0.05,25,num2str(gof.rmse))

subplot(223), hold on
plot(Sumprom(match),all_SUMMARYDATA(Fmatch,6),'o'), xlabel('Band Prominence'), ylabel('Inhaled VT')
[p,S] = polyfit(Sumprom(match)',all_SUMMARYDATA(Fmatch,6), 1);
plot(Sumprom(match),polyval(p,Sumprom(match))), plot(Sumprom(othr),polyval(p,Sumprom(othr)),'*')
[curvefit,gof] = fit(Sumprom(match)',all_SUMMARYDATA(Fmatch,6), 'poly1'); % gof.rmse
text(0.1,6,num2str(gof.rmse))

subplot(224), hold on
plot(Bmint(match),all_SUMMARYDATA(Fmatch,6),'o'), xlabel('Integral at FWHM')
[pt,S] = polyfit(Bmint(match)',all_SUMMARYDATA(Fmatch,6), 1); f = polyval(pt,Bmint(match)); 
plot(Bmint(match),f), plot(Bmint(othr),polyval(pt,Bmint(othr)),'*')
[curvefit,gof] = fit(Bmint(match)',all_SUMMARYDATA(Fmatch,6), 'poly1'); % gof.rmse
text(1,6,num2str(gof.rmse))

print(strcat(regexprep(filename,'.mat',''),'-VTFlowcorrelate'),'-dpng')

return 

%% remove chuffs

reg = find(abs(all_SUMMARYDATA(:,4) - mean(all_SUMMARYDATA(:,4))) < 1.5*std(all_SUMMARYDATA(:,4)));
[kx,mind] = nearest(Flocs(reg)',Blocs',200);
regmatch = find(~isnan(kx)); % band indices with matching pneumotach


return

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

