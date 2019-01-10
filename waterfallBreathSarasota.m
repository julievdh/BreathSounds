% waterfall with chest band and acoustics and pneumotach
% clear, 
close all, warning off 
load('SarasotaFiles')
for f = [12 14]
keep corrstore f Sarasota
tag = Sarasota{f,1};

% load resp summary data
% [all_SUMMARYDATA,RESPTIMING] = importRESP(DQ2017{f,2}); 
filename = strcat(Sarasota{f,2},'_resp');
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
load(filename)

% load tag audit data
R = loadaudit(tag);
[~,breath] = findaudit(R,'exh'); % exhales only

%% check and make sure that breaths are at the right time
figure(12); clf

plot(RAWDATA(:,1),RAWDATA(:,3),'LineWidth',2); hold on
% find pneumotach cues
[~,pneum] = findaudit(R,'pneum');
for n = 1:length(pneum.cue(:,1))
    line([pneum.cue(n,1)-tcue pneum.cue(n,1)-tcue],[0 50],'color','g')
end
% plot all exhaled breaths
for n = 1:length(breath.cue)
    line([breath.cue(n,1)-tcue breath.cue(n,1)-tcue],[0 50],'color','k')
    text(breath.cue(n,1)-tcue,50,num2str(n))
end
xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)


%% sort tag audit cues by order of tidal volume
CUE_S = find(CUE); CUE_R = CUE(find(CUE));
CUE_R = CUE(find(CUE));
pon = CUE_R(~isnan(CUE_R)); % all of the breaths where have pneumotach on
pnum = find(~isnan(CUE)); % find the breath number in SUMMARYDATA

    
B = SUMMARYDATA(:,5); % exhaled tidal volume 

CH = 2; 
for cuen = 1:length(breath.cue)
    % cuen = pon(c);
    [s,afs] = d3wavread([breath.cue(cuen,1) breath.cue(cuen,1)+breath.cue(cuen,2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
    s(:,1) = s(:,1)-mean(s(:,1)); s(:,2) = s(:,2)-mean(s(:,2));
    [Pxx(:,cuen),Freq,bw,s] = CleanSpectra_fun(s(:,CH),afs,breath.cue(cuen,:));
    [SL_o(:,cuen),F] = speclev(s,2048,afs);
    [E,E2,E2_s,newfs] = envfilt(s,afs); %
    figure(16), hold on
    plot((1:length(E2_s))/newfs,E2_s+cuen/1000)
    Sint1(cuen) = trapz(E2_s); % integral of filtered sound
    envstore{cuen} = E2_s; % store
    
    figure(14),
    subplot(ceil(length(breath.cue)/6),6,cuen), hold on;
    bspectrogram(s,afs,breath.cue(cuen,:));
end
% 
% % WAVREAD HERE: store both hydrophones. f
% for k = 1:length(I)
%     if isnan(CUE_R(I(k))) ~= 1
%     [s,afs] = d3wavread([breath.cue(CUE_R(I(k)),1) breath.cue(CUE_R(I(k)),1)+breath.cue(CUE_R(I(k)),2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
%     s1 = s(:,1); s1 = s1-mean(s1); % channel 1, remove DC offset
%     sigstore{1,k} = s1; % store
%     s2 = s(:,2); s2 = s2-mean(s2); % channel 2, remove DC offset
%     sigstore{2,k} = s2; % store
%     end
% end

%% plot acoustic signals in that order
% figure(6), clf, 
% subplot(121), hold on
% for i = 1:length(I)
%     if isempty(sigstore{1,i}) ~= 1
%     [E,E2,E2_s_1,~] = envfilt(sigstore{1,i},afs); % channel 1
%     [E,E2,E2_s_2,newfs] = envfilt(sigstore{2,i},afs); % channel 1
%     figure(6),
%     plot((1:length(E2_s_2))/newfs,E2_s_2+i/1000) 
%     text(-0.3,i/1000,num2str(abs(B(i)))) % exhaled VT
%     Sint1(i) = trapz(E2_s_1); % integral of filtered sound
%     Sint2(i) = trapz(E2_s_2); 
%     Sint1_NF(i) = trapz(abs(sigstore{1,i})); % integral of raw sound
%     Sint2_NF(i) = trapz(abs(sigstore{2,i}));
%     text(0.6,i/1000,num2str(Sint1(i))) % integrated sound from channel 1
%     text(0.6,(i+0.02)/1000,num2str(CUE_R(I(i)))) % exh cue 
%     else
%     Sint1(i) = NaN; % if any breaths weren't selected and can't be integrated, add NaN
%     Sint2(i) = NaN; 
%     Sint1_NF(i) = NaN; Sint2_NF(i) = NaN; 
%     end
%     figure(91), hold on
%     plot(Sint1_NF(i),abs(B(i)),'ko','markerfacecolor','k')
%     plot(Sint2_NF(i),abs(B(i)),'ko','markerfacecolor',[0.75 0.75 0.75])
% %    pause
% end 

figure(4), hold on
plot3(Sint1(pon),abs(SUMMARYDATA(pnum,5)),abs(SUMMARYDATA(pnum,4)),'o')
xlabel('Integral of Filtered Sound'), ylabel('Measured VT (L)'), zlabel('Max Flow Rate (L/s)')
% can we plot envelope next to the values?
for i = 1:length(pon)
    plot3(Sint1(pon(i))+(1:length(envstore{pon(i)}))/(afs/4),2000*envstore{pon(i)}+abs(SUMMARYDATA(pnum(i),5)),abs(SUMMARYDATA(pnum(i),4))+(1:length(envstore{pon(i)}))/(afs/4))
end

figure(90), clf, hold on
strt=find(Freq > 200,1,'first');
L = find(Freq < 0.5E4,1,'last'); % zoom in on the first half of F range

for i = 1:length(pon)
    plot3(Freq(1:L),zeros(L,1)+abs(SUMMARYDATA(pnum(i),4)),Pxx(1:L,pon(i))/sum(Pxx(1:L,pon(i))))
end
xlabel('Frequency'), ylabel('Max Exhaled Flow Rate (L/s)'), zlabel('norm PSD')

besthigh = 3000; bestlow = 500; width = 1000; 
% recompute SL with the best bands, for both inhales and exhales
for k = 1:size(SL_o,2)
    SLlow_o(k) = mean(SL_o(F>bestlow-width/2 & F <bestlow+width/2,k));
    SLhigh_o(k) = mean(SL_o(F>besthigh-width/2 & F <besthigh+width/2,k));
    if exist('SL_i','var') == 1 % only if also have exhales
    SLlow_i(k) = mean(SL_i(F>bestlow-width/2 & F <bestlow+width/2,k));
    SLhigh_i(k) = mean(SL_i(F>besthigh-width/2 & F <besthigh+width/2,k));
    end 
end
SLdiff_o = SLlow_o - SLhigh_o;

figure(13); clf, hold on
subplot(121), hold on
plot(SLlow_o(pon),abs(SUMMARYDATA(pnum,4)),'o')
plot(SLhigh_o(pon),abs(SUMMARYDATA(pnum,4)),'o')
xlabel('SLlow and SLhigh'), ylabel('Max Syringe Out Flow (L/s)')
subplot(122)
plot(SLdiff_o(pon),abs(SUMMARYDATA(pnum,4)),'o')
xlabel('SLlow-SLhigh')



tbl_o = table(abs(SUMMARYDATA(pnum,4)),abs(SUMMARYDATA(pnum,5)),Sint1(pon)',SLlow_o(pon)',SLhigh_o(pon)',SLdiff_o(pon)',...
    'VariableNames',{'MaxFlow','VT','Sint','SLlow','SLhigh','SLdiff'});
% fit a linear model: can Sint or SLlow-high-diff be used to indicate flow?
lm = fitlm(tbl_o,'MaxFlow~Sint+SLhigh+SLdiff'); % plotSlice(lm)
lm = fitlm(tbl_o,'VT~Sint+SLhigh+SLdiff'); % plotSlice(lm)

% try power curve 
lmp = fitlm(log10(Sint1(pon)'),log10(abs(SUMMARYDATA(pnum,5)))); 

%% plot breaths with no pneumotach
poff = find(~ismember(1:size(breath.cue),CUE));
for k = 1:length(poff)
    [s,fs] = d3wavread([breath.cue(poff(k),1) breath.cue(poff(k),1)+breath.cue(poff(k),2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
    s1 = s(:,1); s1 = s1-mean(s1); % channel 1, remove DC offset
    off_sigstore{1,k} = s1; % store
    s2 = s(:,2); s2 = s2-mean(s2); % channel 2, remove DC offset
    off_sigstore{2,k} = s2; % store
end

% demarcate on and off
% plot3([0 2],[length(sigstore) length(sigstore)],[0 0],'k:')
if exist('off_sigstore')
figure(6), subplot(122), hold on
for i = 1:length(off_sigstore)
    [E,~,E2_s_1,newfs] = envfilt(off_sigstore{1,i},afs);
    [E,E2,E2_s_2,newfs] = envfilt(off_sigstore{2,i},afs);
    
    figure(6),
    plot((1:length(E2_s_1))/newfs,E2_s_1+i/1000) 
    Sint1_off(i) = trapz(E2_s_1);
    Sint2_off(i) = trapz(E2_s_2); 
    text(0.6,i/1000,num2str(Sint1_off(i)))
end
xlabel('Time (s)'), ylabel('Index'), zlabel('Sound Pressure') 
 

%% estimate volumes from those breaths
%pred_off1 = feval(fit1,Sint1_off);
%pred_off2 = feval(fit2,Sint2_off);
%figure(19)
%plot(Sint1_off,pred_off1,'ro')
%plot(Sint2_off,pred_off2,'bo')
end

%% store 
corrstore(f).Sint1 = Sint1;
corrstore(f).pon = pon; 
corrstore(f).pnum = pnum; 
% corrstore(f).Sint2 = Sint2;
corrstore(f).B = B; 
corrstore(f).lm = lm;
corrstore(f).lmp = lmp; 

end 

%% 