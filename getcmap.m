function [cvec,c_all] = getcmap(val)
c = viridis; 
num = length(unique(val)); % how many colours to choose: here, range of cm from blowhole 
nums = unique(val); % actual values
entries = round(linspace(1,length(c),num)); % unique values evenly spaced in vector
cvec = c(entries,:);
c_all = nan(length(val),3);
for i = 1:length(nums)
ii = find(val == nums(i)); % find original value 
for j = 1:length(ii)
c_all(ii(j),:) = cvec(i,:); % assign colours back
end 
end 
colormap = cvec; cbar = colorbar;
cbar.Ticks = linspace(0,1,num); % evenly spaced ticks between 0 and 1 
cbar.TickLabels = num2str(nums(1:end)');
cbar.Label.String = 'Distance from blow hole (cm)';





