% take data
for n = 1:length(allstore)
% fit original a*x^b model
[ai,bi] = FSfit(extractfield(allstore,'soundi'),-extractfield(allstore,'flowi'),0.5);
% fit a*log10(x) model
[ai2] = FSfitlog(extractfield(allstore,'soundi'),-extractfield(allstore,'flowi'),0.5);

% apply to rest of breaths
[allstore(n).Festi,allstore(n).errori] = FSapply(allstore(n).soundi,-allstore(n).flowi,ai,bi); % inhales
[allstore(n).Festi2,allstore(n).errori2] = FSapplylog(allstore(n).soundi,-allstore(n).flowi,ai2); % inhales
end 

% look at difference
for n = 1:length(allstore)
plot(-allstore(n).flowi)
plot(allstore(n).Festi)
plot(allstore(n).Festi2,'--')
pause, clf, hold on, end


% but the big problem is when we apply the surface breaths, I think. --
% they are louder than the ones we measure 
load([filename '_surfstore'])
n = 1; 
surfstore(n).Festi = ai*(surfstore(n).sfilli).^bi;
plot(surfstore(n).sfilli,surfstore(n).Festi,'*') % .. is this unreasonable?

