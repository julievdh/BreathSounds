% waterfall with chest band and acoustics and pneumotach
clear, close all
load('DQfiles2017')
f = 13; tag = DQ2017{f,1};

% load resp summary data
[all_SUMMARYDATA,RESPTIMING] = importRESP(DQ2017{f,2});
filename = strcat(DQ2017{f,2},'_resp');
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
load(filename)

% load tag audit data
R = loadaudit(tag);
[~,breath] = findaudit(R,'exh');

%% check and make sure that breaths are at the right time
% figure(12); clf
% 
% plot(t/tickrate,FilteredFlow,'LineWidth',2); hold on
% % find pneumotach cues
% [~,pneum] = findaudit(R,'pneum');
% for n = 1:length(pneum.cue(:,1))
%     line([pneum.cue(n,1)-tcue pneum.cue(n,1)-tcue],[0 50],'color','g')
% end
% % plot all breaths
% [~,breath] = findaudit(R,'breath');
% for n = 1:length(breath.cue)
%     line([breath.cue(n,1)-tcue breath.cue(n,1)-tcue],[0 50],'color','k')
%     text(breath.cue(n,1)-tcue,50,num2str(n))
% end
% xlabel('Time (s)','FontSize',12); ylabel('Flow rate (L/s)','FontSize',12)


%% sort tag audit cues by order of tidal volume
CUE_S = find(CUE); CUE_R = CUE(find(CUE));

[B,I] = sort(all_SUMMARYDATA(:,5),'descend'); % exhaled tidal volume
% CUE_R(I) is sorted in exhaled volume order


% WAVREAD HERE
for k = 1:length(I)
    if isnan(CUE_R(I(k))) ~= 1
    [s,afs] = d3wavread([breath.cue(CUE_R(I(k)),1) breath.cue(CUE_R(I(k)),1)+breath.cue(CUE_R(I(k)),2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
    s = s(:,2); s = s-mean(s); % channel 2, remove DC offset
    sigstore{k} = s; % store
    end
end

%% plot acoustic signals in that order
figure(6), clf, 
subplot(121), hold on
for i = 1:length(I)
    [E,E2,E2_s,newfs] = envfilt(sigstore{i},afs);
    figure(6),
    plot((1:length(E2_s))/newfs,E2_s+i/1000) 
    text(-0.3,i/1000,num2str(abs(B(i)))) % exhaled VT
    Sint(i) = trapz(E2_s);
text(0.6,i/1000,num2str(Sint(i)))
end

figure(19), clf, hold on
plot(Sint,abs(B),'ko')
%% plot breaths with no pneumotach
poff = find(~ismember(1:size(breath.cue),CUE));
for k = 1:length(poff)
    [s,fs] = d3wavread([breath.cue(poff(k),1) breath.cue(poff(k),1)+breath.cue(poff(k),2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
    s = s(:,2); s = s-mean(s); % channel 2, remove DC offset
    off_sigstore{k} = s; % store
end

% demarcate on and off
% plot3([0 2],[length(sigstore) length(sigstore)],[0 0],'k:')
figure(6), subplot(122), hold on
for i = 1:length(off_sigstore)
    [E,E2,E2_s,newfs] = envfilt(off_sigstore{i},afs);
    figure(6),
    plot((1:length(E2_s))/newfs,E2_s+i/1000) 
    Sint_off(i) = trapz(E2_s);
    text(0.6,i/1000,num2str(Sint_off(i)))
end

xlabel('Time (s)'), ylabel('Index'), zlabel('Sound Pressure') 

