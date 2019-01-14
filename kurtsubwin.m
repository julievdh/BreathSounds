function [s,sf] = kurtsubwin(sf,inds,s,afs)

% sf is the filtered signal
% s is the original signal
% inds is the indexed values of the kurtosis bin

% pull in subsection of signal
plot(inds,sf(inds))
% find the maximum
[m,ind] = max(sf(inds));
plot(inds(ind),m,'o')
% remove x seconds before and after
cut = 0.01*afs;
if inds(ind)-cut <= 0
    plot(inds(1):inds(ind)+2*cut,sf(inds(1):inds(ind)+2*cut))
else
    if inds(end) > inds(ind)+2*cut == 1
        plot(inds(ind)-cut:inds(ind)+2*cut,sf(inds(ind)-cut:inds(ind)+2*cut))
    else
        plot(inds(ind)-cut:inds(end),sf(inds(ind)-cut:inds(end)))
    end
end

% but only until the end of the indexed values
if inds(ind)-cut <= 0
    s(inds(1):inds(ind)+2*cut) = zeros(length(inds(1):inds(ind)+2*cut),1); % cleaned original signal
    sf(inds(1):inds(ind)+2*cut) = zeros(length(inds(1):inds(ind)+2*cut),1); % cleaned filtered signal
else
    if inds(end) > inds(ind)+2*cut == 1
        s(inds(ind)-cut:inds(ind)+2*cut) = zeros(length(3*cut+1),1); % cleaned original signal
        sf(inds(ind)-cut:inds(ind)+2*cut) = zeros(length(3*cut+1),1); % cleaned filtered signal
    else % in case the index is towards the end of the window
        s(inds(ind)-cut:inds(end)) = zeros(length(inds(ind)-cut:inds(end)),1);
        sf(inds(ind)-cut:inds(end)) = zeros(length(inds(ind)-cut:inds(end)),1);
    end
end
