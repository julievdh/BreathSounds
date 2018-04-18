% Load in tag data


CUE_S = find(CUE);
CUE_R = CUE(find(CUE));
% find flow data based on cue
[pks,locs] = findpeaks(RAWDATA(:,2),'minpeakheight',1,'minpeakdistance',300);
% cut into chunks
for i = 1:length(locs)
    %figure(2); hold on
    cuts(i).flow = RAWDATA(locs(i)-100:locs(i)+200,:);
    %plot(cuts(i).flow(:,2))
end

afs = 240000/4;

%% BEFORE RELEASE == IN WATER
for i = 1:length(CUE_R)
    [x,xfilt] = BreathFilt(CUE_R(i),R,recdir,tag,1);
    envelope
    env{i,1} = averageenv;
    mx_env(:,i) = max(averageenv);
    
    mx_flow(:,i) = max(cuts(i).flow(:,2)); % get max measured flow rate
    
    % plot together
     t = (1:length(env{i,1}))/(afs);
     % find start of breath flow rate
     figure(2); clf; hold on
     plotyy(t, env{i,1},cuts(i).flow(60:end,1)-cuts(i).flow(60,1),cuts(i).flow(60:end,2))
end

figure(3); 
plot(mx_flow,mx_env,'o')
xlabel('Max Resp Flow Rate'),ylabel('Max Sound Envelope Pressure')

%% 
filename = strcat('FlowEnvelope_',tag);
save(filename,'env','cuts','mx_env','mx_flow')