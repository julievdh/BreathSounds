% PUT BREATH INFO INTO SARASOTA STRUCTURE

% n breaths eParams
Sarasota{i,3} = sum(~isnan(eParams.time_window));

% n breaths iParams
if exist('iParams') == 1
    if sum(size(iParams)) >= 1
Sarasota{i,4} = sum(~isnan(iParams.time_window));
% n breaths e + i Params
Sarasota{i,5} =  sum(~isnan(iParams.time_window) & ~isnan(eParams.time_window));
    end
end

% n breaths sParams
if exist('sParams') == 1
    if sum(size(sParams)) >= 1
Sarasota{i,6} = sum(~isnan(sParams.time_window));
    end
end

cd C:\Users\Julie\Documents\MATLAB\MAS500\
save('SarasotaFiles','Sarasota')

return
% n breaths eParams
Sarasota{1,3} = sum(~isnan(eParams.time_window));

% n breaths iParams
Sarasota{1,4} = sum(~isnan(iParams.time_window));

% n breaths e + i Params
Sarasota{1,5} =  sum(~isnan(iParams.time_window) & ~isnan(eParams.time_window));

% n breaths sParams
Sarasota{1,6} = sum(~isnan(sParams.time_window));
