function [kurtwin,wine] = BreathKurt(xfilt,afs,winwidth,step)
% calculate kurtosis in 0.1 s bins

% %% NON OVERLAPPING
% N=100; % length of block
% nblock=length(xfilt)/N; % we fixed it to be even...
% k=zeros(nblock,1); % preallocate a result vector
% m=N-1; % adder for end of block
% i1=1;
% for i=1:nblock
%    i2=i1+m;
%    k(i)=kurtosis(xfilt(i1:i2)); % a statistic for each block
%    i1=i2+1;
% end
% 
% figure(1);clf
% plot(xfilt)
% hold on
% plot(1:N:i2,k,'.')

%% Try with overlapping
wins = 0:step:length(xfilt)/afs; % window start points
wine = wins+winwidth; % window end points
for i = 1:length(wins)-2
   kurtwin(i) = kurtosis(xfilt(wins(i)*afs+1:wine(i)*afs)); %Calculation for each window
end
% figure(12); clf; hold on
% plot((1:length(xfilt))/afs,xfilt)
% plot((wins(i)*afs+1:wine(i)*afs)/afs,xfilt(wins(i)*afs+1:wine(i)*afs))
% plot(wine(1:end-2),kurtwin)
end