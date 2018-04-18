function [Pxx,F,bw,s,sf,count] = CleanSpectra_fun(s,afs,cue)

% kurtosis filter with before-after spectrogram
% inputs: 
%    s = signal
%    afs = audio sampling rate 
%    cue = [start time, end time] of signal; 
% outputs: 
%    Pxx = Welch's one-sided PSD of signal
%    F = vector of normalized frequencies at which PSD is estimated
%    bw = RMS bandwidth
%    s = filtered signal
%    sf = hpf signal 
%    count = number of bins removed

% plot spectrogram initially
figure(8); subplot('position',[0.1 0.35 0.4 0.6])
bspectrogram(s,afs,cue);

% hpf signal input
sf = hpfilt(s,2,afs,500);

% calculate kurtosis in 0.05s windows, overlapping
winwidth = 0.05; stepsize = 0.025;
[kurtwin,winend] = BreathKurt(sf,afs,winwidth,stepsize); % do kurtosis on filtered signal

%figure(12), clf, hold on
subplot('position',[0.1 0.1 0.4 0.2])
ax = plotyy((1:length(sf))/afs,sf,winend(1:end-2),kurtwin);
xlim(ax(1),[0 length(sf)/afs]), xlim(ax(2),[0 length(sf)/afs])

% find values with kurtosis > 10
ii = find(kurtwin > 10);
% goodsection for maximum comparison
jj = find(kurtwin < 5); if isempty(jj) == 1, jj = find(min(kurtwin)); end  
for i = 1:length(jj)
    mx(i) = max(sf((winend(jj(i))-winwidth)*afs+1:winend(jj(i))*afs)); 
end
goodmax = max(mx); % max value in non-kurtotic sections

count = 0; % put in a counter to count how many bins are removed

if isempty(ii) == 0
    for i = 1:length(ii) % for each of the windows
        % is the amplitude in those bins > 1/3 max amplitude of signal?
        figure(1),clf,hold on
        if max(sf((winend(ii(i))-winwidth)*afs+1:winend(ii(i))*afs)) >= 0.3*goodmax == 1
            plot(sf)
            %plot((1:length(s))/afs,sf)
            %plot(((winend(ii(i))-winwidth)*afs+1:winend(ii(i))*afs)/afs,sf((winend(ii(i))-winwidth)*afs+1:winend(ii(i))*afs))
            inds = round((winend(ii(i))-winwidth)*afs+1:winend(ii(i))*afs); 
            [s,sf] = kurtsubwin(sf,inds,s,afs); 

            count = count+1; 
            % zero around max: 
            % s(round(winend(ii(i))-winwidth)*afs + ind-10:round(winend(ii(i))-winwidth)*afs + ind+20) = zeros(30,1); 
            
            %         if size(s((winend(ii(i))-winwidth)*afs+1:winend(ii(i))*afs)) < winwidth*afs
            %             s((winend(ii(i))-winwidth)*afs:winend(ii(i))*afs) = zeros(winwidth*afs,1);
            %         else
            %             s((winend(ii(i))-winwidth)*afs+1:winend(ii(i))*afs) = zeros(winwidth*afs,1);
            %         end
        end
    end
    % spectrogram now
    figure(8); subplot('position',[0.55 0.35 0.4 0.6])
    bspectrogram(s,afs,cue);
    
    % plot spectrum
    % Nn=abs(fft(s))/length(s)^.5;
    % figure(9); hold on
    % plot(conv(No(1:length(s)/2).^2,hanning(20)/10))
    % plot(conv(Nn(1:length(s)/2).^2,hanning(20)/10))
    BL = 2048;
    [Pxx,F] = pwelch(s,hamming(BL),floor(BL/1.3),BL,afs,'onesided');
else
    figure(8), subplot('position',[0.55 0.35 0.4 0.6]), cla % clear the axes in that subplot if breath is fine
    BL = 2048;
    [Pxx,F] = pwelch(s,hamming(BL),floor(BL/1.3),BL,afs,'onesided');
end
% calculate bandwidth, e.g.
subplot('position',[0.55 0.1 0.4 0.2])
plot(F(1:85),Pxx(1:85))
bw = rmsbw(hpfilt(s,4,afs,200));