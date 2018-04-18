function    B = findbrflow(f,sample_freq,th,baseline)
%
%    B = findbrflow(f,fs,th,surface)
%    Find time cues for the edges of breaths.
%    f is the flow time series in L/s, sampled at sample_freq Hz.
%    th is the threshold in m at which to recognize an exhalation or inhalation
%    Breaths more shallow than th will be ignored.
%    baseline is the baseline value at which it is considered that the
%    breath is over. Default value is 0.
%
%    B is the matrix of cues with columns:
%    [start_cue end_cue mean_depth mean_compression]
%
%    This code was adapted from Mark Johnson's finddives
%
%    Julie van der Hoop jvanderhoop@bios.au.dk
%    last modified: 27 May 2017

if nargin<2,
   help('findbrflow') ;
   return
end

if nargin<3,
   th = 10 ;
end

if nargin<4,
   baseline = 0 ;       
end

if sample_freq>1000,
   fprintf('Suspicious fs of %d Hz - check\n', round(sample_freq)) ;
   return
end

searchlen = 10 ;        % how far to look in seconds to find actual end of breath
dpthresh = 0.25 ;        % vertical velocity threshold for surfacing
dp_lp = 0.1 ;           % low-pass filter frequency for vertical velocity

% first remove any NaN at the start of p
% (these are used to mask bad data points and only occur in a few data sets)
kgood = find(~isnan(f)) ;
f = f(kgood) ;
tgood = (min(kgood)-1)/sample_freq ;

% find threshold crossings and surface times
tth = find(diff(f>th)>0) ;
tbreath = find(f<baseline) ;
ton = 0*tth ;
toff = ton ;
k = 0 ;

% sort through threshold crossings to find valid breath start and end points
for kth=1:length(tth) ;
   if all(tth(kth)>toff),
      ks0 = find(tbreath<tth(kth)) ;
      ks1 = find(tbreath>tth(kth)) ;
      if ~isempty(ks0) & ~isempty(ks1)
         k = k+1 ;    
         ton(k) = max(tbreath(ks0)) ;
         toff(k) = min(tbreath(ks1)) ;
      end
   end
end

% truncate dive list to only dives with starts and stops in the record
ton = ton(1:k) ;
toff = toff(1:k) ;

% filter vertical velocity to find actual surfacing moments
[b a] = butter(4,dp_lp/(sample_freq/2)) ;
dp = filtfilt(b,a,[0;diff(f)]*sample_freq) ;

% for each ton, look back to find last time whale was at the surface
% for each toff, look forward to find next time whale is at the surface
% find peak height here
% removed since other part of Dolphin MR code finds max flow rates 
%
% dmax = zeros(length(ton),2) ;
% for k=1:length(ton),
%    ind = ton(k)+(-round(searchlen*fs):0) ;
%    ind = ind(find(ind>0)) ;
%    ton(k) = ind(max(find(dp(ind)<dpthresh))) ;
%    ind = toff(k)+(0:round(searchlen*fs)) ;
%    ind = ind(find(ind<=length(p))) ;
%    toff(k) = ind(min(find(dp(ind)>-dpthresh))) ;
%    [dm km] = max(p(ton(k):toff(k))) ;
%    dmax(k,:) = [dm (ton(k)+km-1)/fs+tgood] ;
% end

% measure breath statistics
% some of these are relics from Mark's code - 3rd and 4th unused 
pmean = 0*ton ;
pcomp = pmean ;
for k=1:length(ton),
   pdive = f(ton(k):toff(k)) ;
   pmean(k) = mean(pdive) ;
   pcomp(k) = mean((1+0.1*pdive).^(-1)) ;
end
 
% assemble output
B = [[ton toff]/sample_freq+tgood pmean pcomp] ;

