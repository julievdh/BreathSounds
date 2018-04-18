[~,resp] = findaudit(R,'resp'); 
CH = 2; 
for cuen = 1:length(resp.cue)
    % cuen = pon(c);
    [s,afs] = d3wavread([resp.cue(cuen,1) resp.cue(cuen,1)+resp.cue(cuen,2)],d3makefname(tag,'RECDIR'), [tag(1:2) tag(6:9)], 'wav' );
    s(:,1) = s(:,1)-mean(s(:,1)); s(:,2) = s(:,2)-mean(s(:,2));
    [Pxx(:,cuen),Freq,bw,s] = CleanSpectra_fun(s(:,CH),afs,resp.cue(cuen,:));
    [SL_o(:,cuen),F] = speclev(s,2048,afs);
    [E,E2,E2_s,newfs] = envfilt(s,afs); %
    figure(16), hold on
    plot((1:length(E2_s))/newfs,E2_s+cuen/1000)
    Sint1(cuen) = trapz(E2_s); % integral of filtered sound
    envstore{cuen} = E2_s; % store
    
%     if length(resp.cue) <= 75
%     figure(14),
%     subplot(ceil(length(resp.cue)/6),6,cuen), hold on;
%     bspectrogram(s,afs,resp.cue(cuen,:));
%     end
%     if length(resp.cue) < 75
%         while cuen < 75
%                 figure(14),
%     subplot(ceil(length(resp.cue)/6),6,cuen), hold on;
%     bspectrogram(s,afs,resp.cue(cuen,:));
%         end
%     end
    
end