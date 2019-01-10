function [B F T] = bspectrogram(rawsignal,afs,startcue,CLIM)
% some adjustments from d3tagaudit
% inputs are signal, afs, [start cue end cue], optional colour axis limits (CLIM) 

x = rawsignal; % -mean(rawsignal); % remove DC
BL = 1024;
fhigh = 20000; % limit (Hz) on the frequency display
[B F T] = spectrogram(x,hamming(BL),floor(BL/1.3),BL,afs, 'yaxis') ;
BB = adjust2Axis(20*log10(abs(B))) ;

if nargin == 4
    CLIM = [-90 -10] ;  % color axis limits in dB for specgram
    imagesc(startcue(1)+T,F/1000,BB, CLIM);
else
    imagesc(startcue(1)+T,F/1000,BB);
end


yl = get(gca,'YLim') ;
yl(2) = min([yl(2) fhigh/1000]) ; yl(1) = 0;
axis([startcue(1) startcue(1)+startcue(2) yl]) ;
axis xy, grid ;

