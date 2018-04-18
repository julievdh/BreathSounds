% waterfall with chest band and acoustics and pneumotach
% clear, 
close all, warning off 
load('DQfiles2017')
for f = [16:25 27]
keep corrstore f DQ2017 
tag = DQ2017{f,1};

% load resp summary data
% [all_SUMMARYDATA,RESPTIMING] = importRESP(DQ2017{f,2}); 
filename = strcat(DQ2017{f,2},'_resp');
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
load(filename)

% load tag audit data
R = loadaudit(tag);
[~,breath] = findaudit(R,'exh'); % exhales only

%% check and make sure that breaths are at the right time
PneumCueTimeline 

%% sort tag audit cues by order of tidal volume
CUE_S = find(ECUE); CUE_R = ECUE(find(ECUE));

if f == 17
    all_SUMMARYDATA = all_SUMMARYDATA(1:47,:); % because tag slipped
end
if f == 22
    all_SUMMARYDATA = all_SUMMARYDATA(1:23,:); % because tag slipped
end 

[B,I] = sort(all_SUMMARYDATA(:,5),'descend'); % exhaled tidal volume 
% CUE_R(I) is sorted in exhaled volume order


% WAVREAD HERE: store both hydrophones. 
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
subplot(121), hold on
for i = 1:length(I)
    if isempty(sigstore{1,i}) ~= 1
    [E,E2,E2_s_1,~] = envfilt(sigstore{1,i},afs); % channel 1
    [E,E2,E2_s_2,newfs] = envfilt(sigstore{2,i},afs); % channel 1
    figure(6),
    plot((1:length(E2_s_2))/newfs,E2_s_2+i/1000) 
    text(-0.3,i/1000,num2str(abs(B(i)))) % exhaled VT
    Sint1(i) = trapz(E2_s_1); % integral of filtered sound
    Sint2(i) = trapz(E2_s_2); 
    Sint1_NF(i) = trapz(abs(sigstore{1,i})); % integral of raw sound
    Sint2_NF(i) = trapz(abs(sigstore{2,i}));
    text(0.6,i/1000,num2str(Sint1(i))) % integrated sound from channel 1
    text(0.6,(i+0.02)/1000,num2str(CUE_R(I(i)))) % exh cue 
    else
    Sint1(i) = NaN; % if any breaths weren't selected and can't be integrated, add NaN
    Sint2(i) = NaN; 
    Sint1_NF(i) = NaN; Sint2_NF(i) = NaN; 
    end
    figure(91), hold on
    plot(Sint1_NF(i),abs(B(i)),'ko','markerfacecolor','k')
    plot(Sint2_NF(i),abs(B(i)),'ko','markerfacecolor',[0.75 0.75 0.75])
    % pause
end 

figure(19), clf, hold on
plot(Sint1,abs(B),'ko')
plot(Sint2,abs(B),'o','color',[0.75 0.75 0.75])
xlabel('Integrated Sound'), ylabel('Exhaled Tidal Volume (L)')

% evaluate correlation
[~,~,~,yresid1,fit1,gof1] = evalcorr(Sint1',abs(B),1,'c',1);
[~,~,~,yresid2,fit2,gof2] = evalcorr(Sint2',abs(B),1,'g',1);

[ci1,pred1] = predint(fit1,Sint1); 
[ci2,pred2] = predint(fit2,Sint2); 

%% plot breaths with no pneumotach
pon = CUE_R(~isnan(CUE_R)); % all of the breaths where have pneumotach on
poff = find(~ismember(1:size(breath.cue),ECUE));
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
    [E,E2,E2_s_1,newfs] = envfilt(off_sigstore{1,i},afs);
    [E,E2,E2_s_2,newfs] = envfilt(off_sigstore{2,i},afs);
    
    figure(6),
    plot((1:length(E2_s_1))/newfs,E2_s_1+i/1000) 
    Sint1_off(i) = trapz(E2_s_1);
    Sint2_off(i) = trapz(E2_s_2); 
    text(0.6,i/1000,num2str(Sint1_off(i)))
end
xlabel('Time (s)'), ylabel('Index'), zlabel('Sound Pressure') 
 

%% estimate volumes from those breaths
[ci_off1,pred_off1] = predint(fit1,Sint1_off);
[ci_off2,pred_off2] = predint(fit2,Sint2_off);
figure(19)
plot(Sint1_off,pred_off1,'ro')
plot(Sint2_off,pred_off2,'bo')
%%% 
figure(202), clf, hold on
allSint = vertcat(Sint2',Sint2_off'); 
allVT = vertcat(abs(B),fit2(Sint2_off)); 
Pon = vertcat(ones(length(Sint2),1),zeros(length(Sint2_off),1)); 
scatterhist(allSint,allVT,'group',Pon,'kernel','on','location','NE','direction','out')

end

%% store 
corrstore(f).Sint1 = Sint1;
corrstore(f).Sint2 = Sint2;
if exist('Sint1_off','var') == 1
corrstore(f).Sint1_off = Sint1_off;
corrstore(f).Sint2_off = Sint2_off;
corrstore(f).count_off = repmat(f,1,length(Sint1_off)); 
corrstore(f).pred_off1 = pred_off1; 
corrstore(f).pred_off2 = pred_off2; 

end 
corrstore(f).B = B; 
corrstore(f).count = repmat(f,1,length(Sint1)); 
corrstore(f).pon = pon; 
corrstore(f).poff = poff; 

corrstore(f).pred1 = pred1; corrstore(f).pred2 = pred2; 
corrstore(f).fit1 = fit1; corrstore(f).fit2 = fit2; 
corrstore(f).gof1 = gof1; corrstore(f).gof2 = gof2; 
end 

save('corrstoreET','corrstore')
