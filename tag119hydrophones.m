% tag119 check hydrophones

tags = {'tt17_152b'; 'tt17_152z'; 'tt17_149d'; 'tt17_149z'; 'tt17_136b'; 'tt13_278a'};
% D119, D421, D401 in 2017, D401 in 2013

for j = 1:length(tags)
    tag = tags{j};
    prefix = strcat(tag(1:2),tag(6:9));
    if tag(3:4) == '13'
        hdd = driveletter('DQ');
    else if tag(3:4) == '17'
            hdd = driveletter('JVDH');
        end
    end
    settagpath('AUDIO',[hdd,':/']);
    recdir = strcat(gettagpath('AUDIO'),'/',tag(1:4),'/',tag);
    R = loadaudit(tag); % load tag audit
    ts = findaudit(R,'t'); % find selected times in audit of small noises, LF
    
    for i = 1:length(ts);
        % load
        [s,fs] = d3wavread([ts(i,1) ts(i,1)+ts(i,2)],recdir, [tag(1:2) tag(6:9)], 'wav' );
        % remove zero offset
        s(:,1) = s(:,1)-mean(s(:,1));
        s(:,2) = s(:,2)-mean(s(:,2));
        
        % % plot if interested
        % figure(1)
        % subplot(211)
        % spectrogram(s(:,1),512,500,4096,fs,'yaxis'); colorbar off; ylim([0 20])
        % subplot(212)
        % spectrogram(s(:,2),512,500,4096,fs,'yaxis'); colorbar off; ylim([0 20])
        
        % difference in levels on two hydrophones
        % RMS amplitude
        CL2(j,i) = 20*log10(sqrt(mean(s(:,2).^2))) - 20*log10(sqrt(mean(s(:,1).^2)));
        % peak to peak
        p2p(j,i) = 20*log10(max(s(:,2))-min(s(:,2))) - 20*log10(max(s(:,1))-min(s(:,1)));
   
    end
end

median(CL2')
% median(p2p')

figure(82), clf, hold on 
plot(CL2'), legend(tags)
plot(p2p','--')