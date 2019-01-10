% waterfall with chest band and acoustics and pneumotach
clear, close all
load('DQfiles2017')
f = 5; tag = DQ2017{f,1};
% file 61 = 9; 44 = 5; 22 = 2;

% load resp summary data
[all_SUMMARYDATA,RESPTIMING] = importRESP(DQ2017{f,2});

% load tag audit data
R = loadaudit(tag);
[~,breath] = findaudit(R,'exh');

% load ChestBand data
% BreathCommentsTest

% RUNCHESTBAND here, then SORT CHEST BAND based on EXPECTED VT BASED ON
% BAND
RunChestBand_apply

%% get indices of matches
% find matched times between two time series
%[kx,mind] = nearest(Flocs',Blocs',200);
%match = find(~isnan(kx)); % band indices with matching pneumotach
%[kx,mind] = nearest(Blocs',Flocs',200);
%Fmatch = find(~isnan(kx)); % pneumotach indices with matching band
% find all band values not associated with a pneumotach measurement
%othr = find(ismember(1:length(Blocs),match)<1);

%% check and make sure that breaths are at the right time
figure(12); clf
plot(t/tickrate,FilteredFlow,'LineWidth',2); hold on
% find pneumotach cues
[~,pneum] = findaudit(R,'pneum');
for n = 1:length(pneum.cue(:,1))
    line([pneum.cue(n,1)-tcue pneum.cue(n,1)-tcue],[0 50],'color','g')
end
% plot all breaths - exhales only
[~,breath] = findaudit(R,'exh');
for n = 1:length(breath.cue)
    line([breath.cue(n,1)-tcue breath.cue(n,1)-tcue],[0 50],'color','k')
    text(breath.cue(n,1)-tcue,50,num2str(n)) % cue in audit structure
end
xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)

%% sort tag audit cues by order of tidal volume
CUE_S = find(CUE); CUE_R = CUE(find(CUE));

B = all_SUMMARYDATA(:,5); 
I = 1:length(all_SUMMARYDATA(:,5)); 
% [B,I] = sort(all_SUMMARYDATA(:,5),'descend'); % exhaled tidal volume
% CUE_R(I) is sorted in exhaled volume order

% plot cue numbers and ranked cues
offset = Flocs(1) - RESPTIMING(1);
for i = 1:size(all_SUMMARYDATA,1)
    text((RESPTIMING(i)+offset)/tickrate,40,num2str(i)) % row number in all_SUMMARYDATA
    text((RESPTIMING(i)+offset)/tickrate,30,num2str(I(i))) % ranked number in VT order
end

%% WAVREAD HERE
for k = 1:length(I)
    if isnan(CUE_R(I(k))) ~= 1
    [s,afs] = d3wavread([breath.cue(CUE_R(I(k)),1) breath.cue(CUE_R(I(k)),1)+breath.cue(CUE_R(I(k)),2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
    s1 = s(:,1); s1 = s1-mean(s1); % channel 1, remove DC offset
    sigstore{1,k} = s1; % store
    s2 = s(:,2); s2 = s2-mean(s2); % channel 2, remove DC offset
    sigstore{2,k} = s2; % store
    end
end

%% plot acoustic signals in that order
figure(6), clf,
subplot(131), hold on
for i = 1:length(I)
    %     plot((1:length(sigstore{i}))/afs,abs(sigstore{i})+i/1000)
    % filter sound
    if isempty(sigstore{i}) ~= 1
        [E,E2,E2_s_1,~] = envfilt(sigstore{1,i},afs); % channel 1
        [E,E2,E2_s_2,newfs] = envfilt(sigstore{2,i},afs); % channel 2
        figure(6)
        plot((1:length(E2_s_2))/newfs,E2_s_2+i/1000)
        text(0.5,i/1000,num2str(trapz(E2_s_2))) % integral of filtered sound
        text(-0.3,i/1000,num2str(abs(B(i)))) % exhaled VT
        text(0.6,(i+0.02)/1000,num2str(CUE_R(I(i)))) % exh cue
        
        figure(199), hold on
        Sint1(i) = trapz(E2_s_1); % integrate filtered sound
        Sint2(i) = trapz(E2_s_2); 
        h = scatter(Sint2(i),abs(B(i))); % plot integral of filtered sound channel 2 versus exhaled VT
        h.MarkerFaceColor = h.MarkerEdgeColor; h.MarkerFaceAlpha = 0.5;
    else
    Sint1(i) = NaN; % if any breaths weren't selected and can't be integrated, add NaN
    Sint2(i) = NaN; 
    end
end
figure(199)
xlabel('Integral of Filtered Sound')
ylabel('Exhaled Tidal Volume (L)')
title(regexprep(filename,'_',' '))

figure(6)
title('Band and Pneum'), xlabel('Time (sec)'), ylabel('Index+Filtered Sound Pressure')
%% COMPUTE FIT OF THAT
figure(199), % h = plot(fit1);
%[~,~,~,yresid1,fit1,gof1] = evalcorr(Sint1',abs(B),1,'c',1); legend off
[~,~,~,yresid2,fit2,gof2] = evalcorr(Sint2',abs(B),1,'g',1); legend off

%[ci1,pred1] = predint(fit1,Sint1); 
[ci2,pred2] = predint(fit2,Sint2); 

xlabel('Integral of Filtered Sound'), ylabel('Exhaled VT (L)')

%% plot breaths with band, no pneumotach
poff = find(~ismember(1:size(breath.cue),CUE));

% SORT based on estimated VT exhaled from ChestBand
% [Bandest,Iest] = sort(EVTest(othr),'ascend'); % exhaled tidal volume estimated from band
Bandest = EVTest(othr); Iest = 1:length(Bandest); 
% WHICH ONES ARE OFF BUT MATCHED?
figure(12)
plot(Blocs(match)/tickrate,Bpks(match),'k*')
plot(Blocs(othr)/tickrate,Bpks(othr),'r*')
plot(breath.cue(poff,1)-tcue,zeros(length(poff),1),'ko')
[Boffmatch,mind] = nearest(breath.cue(:,1)-tcue',Blocs(othr)'/tickrate,1,0); % find the nearest breath cue

% so Boffmatch(Iest) = ranked order of tidal volume
poffrank = Boffmatch(Iest);
poffothr = find(ismember(1:length(poff),Boffmatch)<1); % no pneumotach, no band

for k = 1:length(poffrank)
    if isnan(poffrank(k)) ~= 1
    [s,fs] = d3wavread([breath.cue(poffrank(k),1) breath.cue(poffrank(k),1)+breath.cue(poffrank(k),2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
    s1 = s(:,1); s1 = s1-mean(s1); % channel 1, remove DC offset
    off_sigstore{1,k} = s1;    s2 = s(:,2); s2 = s2-mean(s2); % channel 2, remove DC offset
    off_sigstore{2,k} = s2; % store
    else off_sigstore{1,k} = NaN; off_sigstore{2,k} = NaN;
    end
end 

%% plot
figure(6), subplot(132), hold on
for i = 1:length(off_sigstore)
    if isnan(off_sigstore{1,i}) ~= 1
        % plot3((1:length(off_sigstore{i}))/fs,zeros(length(off_sigstore{i}),1)+i,abs(off_sigstore{i}))
        [E,E2,E2_s_1,newfs] = envfilt(off_sigstore{1,i},afs);
        [E,E2,E2_s_2,newfs] = envfilt(off_sigstore{2,i},afs);
    
        figure(6), hold on
        plot((1:length(E2_s_2))/newfs,E2_s_2+i/1000) % filtered sound
        text(0,i/1000,num2str(Bandest(i))) % estimated exhaled VT
        text(0.4,i/1000,num2str(trapz(E2_s_2))) % integral of filtered sound
        figure(199), hold on
        Sint2_off(i) = trapz(E2_s_2);
        plot(Sint2_off(i),abs(Bandest(i)),'ko','markerfacecolor','k')
    else Sint2_off(i) = NaN;
    end
end
figure(6)
title('Band, No Pneum'), xlabel('Time (sec)')

%% estimate VT based on sound correlation
[ci_off,Best_off] = predint(fit2,Sint2_off');
ciplot = predint(fit2,min(Sint2_off):0.1:max(Sint2_off));
figure(199), plot(Sint2_off',Best_off,'ko')

%% do for off and no band
for b = 1:length(poffothr)
    [s,afs] = d3wavread([breath.cue(poffothr(b),1) breath.cue(poffothr(b),1)+breath.cue(poffothr(b),2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
    s = s(:,2); s = s-mean(s); % channel 2, remove DC offset
    off_othr_sigstore{b} = s; % store
end

figure(6), subplot(133), hold on
for i = 1:length(off_othr_sigstore)
    [E,E2,E2_s,newfs] = envfilt(off_othr_sigstore{i},afs);
    figure(6),
    plot((1:length(E2_s))/newfs,E2_s+i/1000) % filtered sound
    text(0.4,i/1000,num2str(trapz(E2_s))) % integral of filtered sound
    Sint_off_othr(i) = trapz(E2_s);
end

xlabel('Time (s)'), % ylabel('Index + Sound Pressure')
title('No Band, No Pneum')

% apply correlation of sound to measured VT
[ci_off_othr,Best_off_othr] = predint(fit2,Sint_off_othr');
figure(199), plot(Sint_off_othr',Best_off_othr,'o')


%% Plot the sound and band VT estimates 
figure(219), clf, hold on
plot(Sint2(Fmatch),abs(all_SUMMARYDATA(Fmatch,5)),'ko','markerfacecolor','k') % this is the sound integral versus VT measurement)
plot(Sint2(Fmatch),EVTest(match),'ko','markerfacecolor',[0 146 146]/255) % this is sound integral versus VT estimate from band
for i = 1:length(match)
    plot([Sint2(Fmatch(i)) Sint2(Fmatch(i))],[abs(all_SUMMARYDATA(Fmatch(i),5)) EVTest(match(i))],'k:')

    % calculate difference between band and pneumotach 
    % delta(i) = abs(B(i)) - EVTest(match(i));
end
xlabel('Integral of Filtered Sound')
ylabel('VT measured or estimated')


