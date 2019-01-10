function [ct] = resprate(R,interval)
% R is structure of cues, cue types
% iterval is [ ] over which to evaluate respiratory rate

% rate is calculated in 60 s bins starting from the first cue in interval

% find R.cues within interval
inint = find(R.cue(:,1) < interval(2) & R.cue(:,1) > interval(1)); % cues are in seconds

% set initial window
ind1 = floor(R.cue(inint(1),1));
win = 1; % first window
while ind1 < interval(2)
    % set end of window based on first window
    ind2 = ind1+60;
    % plot
    %plot([ind1 ind1],[-1 1])
    %plot([ind2 ind2],[-1 1])
    % count cues within window
    ct(1,win) = sum(iswithin(R.cue(inint,1),[ind1 ind2])); % store
    ct(2,win) = ind1; % save index
    % text(ind1,0.01,num2str(ct(win)))
    % move to next bin, set next window number
    ind1 = ind2; win = win+1;
end