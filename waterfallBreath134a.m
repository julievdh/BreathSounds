%% sort tag audit cues by order of tidal volume
[~,exh] = findaudit(R,'exh');
CUE_S = [2:5 7:23]; CUE_R = [NaN 1:4 NaN 5:21]; % i think this will do the right thing


%% store both hydrophones. 
figure(6), clf, hold on
for k = 1:length(CUE_R)
    if isnan(CUE_R(k)) ~= 1
        [s,afs] = d3wavread([exh.cue(CUE_R(k),1) exh.cue(CUE_R(k),1)+exh.cue(CUE_R(k),2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
        s1 = s(:,1); s1 = s1-mean(s1); % channel 1, remove DC offset
        sigstore{1,k} = s1; % store
        s2 = s(:,2); s2 = s2-mean(s2); % channel 2, remove DC offset
        sigstore{2,k} = s2; % store
        
        % compute filtered envelopes
        [E,E2,E2_s_1,~] = envfilt(sigstore{1,k},afs); % channel 1
        [E,E2,E2_s_2,newfs] = envfilt(sigstore{2,k},afs); % channel 2
        figure(6)
        plot((1:length(E2_s_1))/newfs,E2_s_1+k/1000,'color',[194/255 165/255 207/255]) % channel 1
        plot((1:length(E2_s_2))/newfs,E2_s_2+k/1000,'color',[123/255 50/255 148/255]) % channel 2
        text(0.5,k/1000,num2str(trapz(E2_s_2))) % integral of filtered sound
        % text(-0.3,i/1000,num2str(abs(B(i)))) % exhaled VT
        text(0.6,(k+0.02)/1000,num2str(CUE_R(k))) % exh cue
        
        % figure(199), hold on
        Sint1(k) = trapz(E2_s_1); % integrate filtered sound
        Sint2(k) = trapz(E2_s_2);
        %h = scatter(Sint2(i),abs(B(i))); % plot integral of filtered sound channel 2 versus exhaled VT
        %h.MarkerFaceColor = h.MarkerEdgeColor; h.MarkerFaceAlpha = 0.5;
    else
        Sint1(k) = NaN; % if any breaths weren't selected and can't be integrated, add NaN
        Sint2(k) = NaN;
    end
end


figure(19), clf, hold on
plot(Sint1,eVT,'ko')
plot(Sint2,eVT,'o','color',[0.75 0.75 0.75])
xlabel('Integrated Sound'), ylabel('Exhaled Tidal Volume (L)')

% evaluate correlation
[~,~,~,yresid1,fit1,gof1] = evalcorr(Sint1',eVT,1,'c',1);
[~,~,~,yresid2,fit2,gof2] = evalcorr(Sint2',eVT,1,'g',1);

[ci1,pred1] = predint(fit1,Sint1); 
[ci2,pred2] = predint(fit2,Sint2); 

return

%% plot breaths with no pneumotach
poff = find(~ismember(1:size(exh.cue),CUE));
for k = 1:length(poff)
    [s,fs] = d3wavread([exh.cue(poff(k),1) exh.cue(poff(k),1)+exh.cue(poff(k),2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
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
end
