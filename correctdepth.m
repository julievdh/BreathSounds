function corrdepth = correctdepth(p,fs,L)
% function p = correctdepth(p,fs)
% Corrects errors (gaps, jumps) in depth profile, as well as small 
% long-term fluctuations caused by e.g. temperature
%
% Input
%   p   Depth of animal in meters (positive down - direct from prh)
%   fs  Sample rate of depth sensor (min 1 Hz)
%   L   Time window for estimating minimum depth - should be on average
%       one surfacing or more per time window for good performance
%   
% Output
%   corrdepth   Corrected depth vector with same sample rate as original
%               depth vector
%
% Dependencies:
% fixsensor.m
%
% FHJ, aias, 2017

if nargin<3
    L = 60 ;
end


% Fix gaps or other bad sensor values
knoise = find(abs(diff(p))>(13/fs));

% Measure time to break if needed
tic
while ~isempty(knoise),
    gap = diff(knoise);
    if max(gap)>10,
        k = knoise(1):knoise(find(gap>10,1,'first'));
        p = fixsensor(p,k,10);
        knoise = find(abs(diff(p))>0.5);
    else
        k = knoise(1):knoise(end);
        p = fixsensor(p,k,10);
        knoise = find(abs(diff(p))>0.5);
    end

    if toc>300,
        disp('Fixing gaps took too long! Change line 31 if ok')
        break
    end
end

% Find baseline depth as minimum depth in L second windows (50% overlap)
P = buffer(p,L*fs,L/2*fs);
minP=min(P(:,2:end-1));

% And smooth minimum using Robust Loess smoother
surf = smooth(minP,30,'rloess');

% Finally, correct depth
corrdepth = p - interp1([1:length(minP)]*L/2,surf,[1:length(p)]'/fs,'linear','extrap');