% compare Sint and B values for good exercise trials with tag 401
figure(21), clf, hold on
files =  1:length(corrstore); % [16:18,20:21]; 
% corrstore(20).Sint1 = []; corrstore(20).Sint2 = []; corrstore(20).B = []; 
% color by distance from blow hole 
c = viridis; 
num = length(min([DQ2017{:,3}]):max([DQ2017{:,3}])); % how many colours to choose: here, range of cm from blowhole 
nums = min([DQ2017{:,3}]):max([DQ2017{:,3}]); 
entries = round(linspace(1,length(c),num)); % evenly spaced in vector
cvec = c(entries,:);
if isfield(corrstore,'B') == 0 % if no sorted exhaled tidal volume 
    for i = files
        if isempty(corrstore(i).all_SUMMARYDATA) == 0
        corrstore(i).B = abs(corrstore(i).all_SUMMARYDATA(corrstore(i).pnum,5)); 
        end
    end
end
for i = files
    h = plot(corrstore(i).Sint1,abs(corrstore(i).B),'o',...
        'color',cvec(DQ2017{i,3}-min([DQ2017{:,3}])+1,:));
    if DQ2017{i,4} == 119
        set(h,'marker','^')
    end
end
xlabel('Integrated Sound'), ylabel('Exhaled Tidal Volume (L)')
title('Channel 1')
colormap = cvec; cbar = colorbar;
cbar.Ticks = linspace(0,1,num/2); % evenly spaced ticks between 0 and 1 
cbar.TickLabels = num2str(nums(1:2:end)');
cbar.Label.String = 'Distance from blow hole (cm)';

if isfield(corrstore,'Sint2') == 1
figure(22), clf, hold on
for i = files
    h = plot(corrstore(i).Sint2,abs(corrstore(i).B),'o',...
        'color',cvec(DQ2017{i,3}-min([DQ2017{:,3}])+1,:));
    if DQ2017{i,4} == 119
        set(h,'marker','^')
    end
end
xlabel('Integrated Sound'), ylabel('Exhaled Tidal Volume (L)')
title('Channel 2')
cbar = colorbar;
cbar.Ticks = linspace(0,1,num/2); % evenly spaced ticks between 0 and 1 
cbar.TickLabels = num2str(nums(1:2:end)');
cbar.Label.String = 'Distance from blow hole (cm)';

figure(23), clf, hold on
for i = files
    h1 = plot(corrstore(i).Sint1,abs(corrstore(i).B),'o',...
        'color',cvec(1,:));
    h2 = plot(corrstore(i).Sint2,abs(corrstore(i).B),'o',...
        'color',cvec(end,:));
    if DQ2017{i,4} == 119
        set(h1,'marker','^')
        set(h2,'marker','^')
    end
end
xlabel('Integrated Sound'), ylabel('Exhaled Tidal Volume (L)')
title('Channels 1 and 2')

figure(24), clf, hold on
for i = files
    h = plot(corrstore(i).Sint1,corrstore(i).Sint2,'o',...
        'color',cvec(DQ2017{i,3}-min([DQ2017{:,3}])+1,:));
    if DQ2017{i,4} == 119
        set(h,'marker','^')
    end
end
plot([0 0.25],[0 0.25],'k')
xlabel('Channel 1'), ylabel('Channel 2')
end 

return 

%% fit coefficients 
figure(25), clf, hold on 
for i = 16:27
cf = coeffvalues(corrstore(i).lmp);
subplot(211), hold on 
plot(i,cf(1),'o')
subplot(212), hold on 
plot(i,cf(2),'o')
end

