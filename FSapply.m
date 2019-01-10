function [Fest,error] = FSapply(snd,flw,a,b)
%
%
%

if size(snd) > 1
    snd = snd';
end

if sum(~isnan(snd)) > 2                  % if there are more than 2 NaNs
    sfill = naninterp(snd);             % interpolate NaNs
    sfill(find(sfill<0)) = 0;           % zero out any negative values at the beginning
    sfill(find(sfill>max(snd))) = 0;    % interpolation should never exceed max envelope
    if sfill(1) == 0;
        sfill(1) = NaN;
    end
else sfill = NaN(length(snd),1);
end

%% HERE ADD A CATCH FOR IF TOO MANY NANS, ETC

%%
% estimate flw from snd
Fest = a*(sfill).^b;
Fest(isinf(Fest)) = 0; % replace Inf with 0

% calculate error
gd = ~isnan(Fest); % find any NaNs
error = rmse(flw(gd),Fest(gd)); % compute RMSE
end