% Open both Sam and Julie's audits
% Compare breaths chosen as good: consistent?
% Compare quality: consistent?
% Compare parameters measured: what % are they within?

%% Select tag
tag = 'tt14_128a';
path = 'D:\tt14\tt14_128a\';

settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],...
    'audit',[path 'audit\'])
recdir = d3makefname(tag,'RECDIR');

% load prh
loadprh(tag)

% load calibration and deployment info, tag audit
[CAL,DEPLOY] = d3loadcal(tag);

% Load Julie's audits
R(1) = loadaudit(tag);
cd D:\tt14\tt14_128a\audit\
Julie = load(strcat(tag,'_PQ'));

% change path for Sam's audits
settagpath('audit',[path 'audit\SAM\'])
R(2) = loadaudit(tag);
cd D:\tt14\tt14_128a\audit\SAM
Sam = load(strcat(tag,'_PQ'));

%% Build proper Param structures
eParams(1) = Julie.eParams; eParams(2) = Sam.eParams;
iParams(1) = Julie.iParams; iParams(2) = Sam.iParams;
sParams(1) = Julie.sParams; sParams(2) = Sam.sParams;

%% Compare number of breaths
ii = find(R(1).cue(:,1) <= R(2).cue(end,1));

disp('Are they the same length?')
disp(isequal(length(R(2).cue),length(R(1).cue(ii,1))))

% % Compare quality of breaths
% set time index
% t = (1:length(p))/fs;
% 
% figure(1); hold on
% plot(t,-p)
% plot(R(2).cue(:,1),ones(length(R(2).cue)),'ro')
% plot(R(1).cue(:,1),ones(length(R(1).cue))-0.1,'g.')
% 
% plot(R(2).cue(:,1),Sam.Quality,'ro')
% plot(R(1).cue(:,1),Julie.Quality(ii),'g.')
% 
% disp('Are they the same quality?')
% disp(isequal(Julie.Quality(ii),Sam.Quality))
% 
% % Compare offsets?
% ii = find(Julie.eParams.EFD(1:84));
% figure(10)
% plot(R(1).cue(ii,1),ones(length(ii)),'b.')
% hold on
% ii = find(Sam.eParams.EFD);
% plot(R(2).cue(ii,1),ones(length(ii)),'ro')
% ii = find(Sam.iParams.EFD);
% plot(R(2).cue(ii,1),ones(length(ii))+1,'ro')
% ii = find(Sam.sParams.EFD);
% plot(R(2).cue(ii,1),ones(length(ii))+2,'ro')
% ii = find(Julie.iParams.EFD(1:84));
% plot(R(1).cue(ii,1),ones(length(ii))+1,'b.')
% ii = find(Julie.sParams.EFD(1:84));
% plot(R(1).cue(ii,1),ones(length(ii))+2,'b.')
% 
% % 
% figure(2)
% compare Exhale, Inhale, Surface indices for breaths marked
% imagesc(Sam.btype-Julie.btype)
% light green = zero (same)
% blue = Julie marked, Sam didn't
% red = Sam marked, Julie didn't
% 
% % Compare parameters measured
% figure(3)
% subplot(221); hold on; box on
% plot(eParams(1).Fcent(ii),'r.')
% plot(eParams(2).Fcent)
% title('eParams.Fcent')
% 
% subplot(222); hold on; box on
% plot(eParams(1).stop(ii),'r.')
% plot(eParams(2).stop)
% plot(eParams(1).start(ii),'r.')
% plot(eParams(2).start)
% title('eParams.start and stop')
% 
% subplot(223); hold on; box on
% plot(iParams(1).EFD(ii),'r.')
% plot(iParams(2).EFD)
% title('iParams.EFD')
% 
% subplot(224); hold on; box on
% plot(iParams(1).RMS(ii),'r.')
% plot(iParams(2).RMS)
% title('iParams.RMS')
% 
% % calculate percent within
% e_pdiff(1) = median((abs(eParams(2).time_window - eParams(1).time_window(ii))./((eParams(2).time_window + eParams(1).time_window(ii))/2) ) * 100);
% e_pdiff(2) = median((abs(eParams(2).start - eParams(1).start(ii))./((eParams(2).start + eParams(1).start(ii))/2) ) * 100);
% e_pdiff(3) = median((abs(eParams(2).stop - eParams(1).stop(ii))./((eParams(2).stop + eParams(1).stop(ii))/2) ) * 100);
% e_pdiff(4) = median((abs(eParams(2).RMS - eParams(1).RMS(ii))./((eParams(2).RMS + eParams(1).RMS(ii))/2) ) * 100);
% e_pdiff(5) = median((abs(eParams(2).EFD - eParams(1).EFD(ii))./((eParams(2).EFD + eParams(1).EFD(ii))/2) ) * 100);
% e_pdiff(6) = median((abs(eParams(2).pp - eParams(1).pp(ii))./((eParams(2).pp + eParams(1).pp(ii))/2) ) * 100);
% e_pdiff(7) = median((abs(eParams(2).Fmax - eParams(1).Fmax(ii))./((eParams(2).Fmax + eParams(1).Fmax(ii))/2) ) * 100);
% e_pdiff(8) = median((abs(eParams(2).Fcent - eParams(1).Fcent(ii))./((eParams(2).Fcent + eParams(1).Fcent(ii))/2) ) * 100);
% 
% i_pdiff(1) = nanmedian((abs(iParams(2).time_window - iParams(1).time_window(ii))./((iParams(2).time_window + iParams(1).time_window(ii))/2) ) * 100);
% i_pdiff(2) = nanmedian((abs(iParams(2).start - iParams(1).start(ii))./((iParams(2).start + iParams(1).start(ii))/2) ) * 100);
% i_pdiff(3) = nanmedian((abs(iParams(2).stop - iParams(1).stop(ii))./((iParams(2).stop + iParams(1).stop(ii))/2) ) * 100);
% i_pdiff(4) = nanmedian((abs(iParams(2).RMS - iParams(1).RMS(ii))./((iParams(2).RMS + iParams(1).RMS(ii))/2) ) * 100);
% i_pdiff(5) = nanmedian((abs(iParams(2).EFD - iParams(1).EFD(ii))./((iParams(2).EFD + iParams(1).EFD(ii))/2) ) * 100);
% i_pdiff(6) = nanmedian((abs(iParams(2).pp - iParams(1).pp(ii))./((iParams(2).pp + iParams(1).pp(ii))/2) ) * 100);
% i_pdiff(7) = nanmedian((abs(iParams(2).Fmax - iParams(1).Fmax(ii))./((iParams(2).Fmax + iParams(1).Fmax(ii))/2) ) * 100);
% i_pdiff(8) = nanmedian((abs(iParams(2).Fcent - iParams(1).Fcent(ii))./((iParams(2).Fcent + iParams(1).Fcent(ii))/2) ) * 100);



%% FOR tt129a (but not counting e + i separation post-release)

figure(99); hold on
plot(t,-p) % depth record
plot(R(1).cue(:,1),1,'k.') % all of Julie's audit cues
plot(R(2).cue(:,1),2,'b.') % all of Sam's audit cues
xlabel('Time (sec)'); ylabel('Depth')

%% FOR EXPIRATIONS
ii = find(Julie.eParams.EFD);
jj = find(Sam.eParams.EFD);

figure(99)
plot(R(1).cue(ii,1),1,'go')
plot(R(2).cue(jj,1),2,'go')


[tf,ib] = ismember(round(R(1).cue(ii,1)),round(R(2).cue(jj,1)));

% CHECK WHERE THEY ARE
figure(20); hold on
plot(R(1).cue(ii(find(tf)),1),'b.')
plot(R(2).cue(jj(ib(tf)),1),'ro')
figure(21); hold on
plot(R(1).cue(ii(find(tf)),1),eParams(1).EFD(ii(find(tf))),'b.')
plot(R(2).cue(jj(ib(tf)),1),eParams(2).EFD(jj(ib(tf))),'ro')

% calculate difference between:
e_pdiff(1) = median(pdiff(eParams(1).time_window(ii(find(tf))),eParams(2).time_window(jj(ib(tf)))));
e_pdiff(2) = median(pdiff(eParams(1).start(ii(find(tf))),eParams(2).start(jj(ib(tf)))));
e_pdiff(3) = median(pdiff(eParams(1).stop(ii(find(tf))),eParams(2).stop(jj(ib(tf)))));
e_pdiff(4) = median(pdiff(eParams(1).RMS(ii(find(tf))),eParams(2).RMS(jj(ib(tf)))));
e_pdiff(5) = median(pdiff(eParams(1).EFD(ii(find(tf))),eParams(2).EFD(jj(ib(tf)))));
e_pdiff(6) = median(pdiff(eParams(1).pp(ii(find(tf))),eParams(2).pp(jj(ib(tf)))));
e_pdiff(7) = median(pdiff(eParams(1).Fmax(ii(find(tf))),eParams(2).Fmax(jj(ib(tf)))));
e_pdiff(8) = median(pdiff(eParams(1).Fcent(ii(find(tf))),eParams(2).Fcent(jj(ib(tf)))));


%% FOR INSPIRATIONS

ii = find(Julie.iParams.EFD);
jj = find(Sam.iParams.EFD);

figure(99)
plot(R(1).cue(ii,1),1.1,'mo')
plot(R(2).cue(jj,1),1.9,'mo')

[tf,ib] = ismember(round(R(1).cue(ii,1)),round(R(2).cue(jj,1)));

% CHECK WHERE THEY ARE
figure(20); clf; hold on
plot(R(1).cue(ii(find(tf)),1),'b.')
plot(R(2).cue(jj(ib(tf)),1),'ro')
figure(21); clf; hold on
plot(R(1).cue(ii(find(tf)),1),iParams(1).EFD(ii(find(tf))),'b.')
plot(R(2).cue(jj(ib(tf)),1),iParams(2).EFD(jj(ib(tf))),'ro')
ylabel('EFD'); xlabel('Cue time (s)')

% calculate difference between:
i_pdiff(1) = median(pdiff(iParams(1).time_window(ii(find(tf))),iParams(2).time_window(jj(ib(tf)))));
i_pdiff(2) = median(pdiff(iParams(1).start(ii(find(tf))),iParams(2).start(jj(ib(tf)))));
i_pdiff(3) = median(pdiff(iParams(1).stop(ii(find(tf))),iParams(2).stop(jj(ib(tf)))));
i_pdiff(4) = median(pdiff(iParams(1).RMS(ii(find(tf))),iParams(2).RMS(jj(ib(tf)))));
i_pdiff(5) = median(pdiff(iParams(1).EFD(ii(find(tf))),iParams(2).EFD(jj(ib(tf)))));
i_pdiff(6) = median(pdiff(iParams(1).pp(ii(find(tf))),iParams(2).pp(jj(ib(tf)))));
i_pdiff(7) = median(pdiff(iParams(1).Fmax(ii(find(tf))),iParams(2).Fmax(jj(ib(tf)))));
i_pdiff(8) = median(pdiff(iParams(1).Fcent(ii(find(tf))),iParams(2).Fcent(jj(ib(tf)))));


%% FOR SURFACE BREATHS

ii = find(Julie.sParams.EFD);
jj = find(Sam.sParams.EFD);

figure(99)
plot(R(1).cue(ii,1),1,'ro')
plot(R(2).cue(jj,1),2,'ro')

[tf,ib] = ismember(round(R(1).cue(ii,1)),round(R(2).cue(jj,1)));

% CHECK WHERE THEY ARE
figure(20); hold on
plot(R(1).cue(ii(find(tf)),1),'b.')
plot(R(2).cue(jj(ib(tf)),1),'ro')
figure(21); hold on
plot(R(1).cue(ii(find(tf)),1),sParams(1).EFD(ii(find(tf))),'b.')
plot(R(2).cue(jj(ib(tf)),1),sParams(2).EFD(jj(ib(tf))),'ro')

% calculate difference between:
s_pdiff(1) = median(pdiff(sParams(1).time_window(ii(find(tf))),sParams(2).time_window(jj(ib(tf)))));
s_pdiff(2) = median(pdiff(sParams(1).start(ii(find(tf))),sParams(2).start(jj(ib(tf)))));
s_pdiff(3) = median(pdiff(sParams(1).stop(ii(find(tf))),sParams(2).stop(jj(ib(tf)))));
s_pdiff(4) = median(pdiff(sParams(1).RMS(ii(find(tf))),sParams(2).RMS(jj(ib(tf)))));
s_pdiff(5) = median(pdiff(sParams(1).EFD(ii(find(tf))),sParams(2).EFD(jj(ib(tf)))));
s_pdiff(6) = median(pdiff(sParams(1).pp(ii(find(tf))),sParams(2).pp(jj(ib(tf)))));
s_pdiff(7) = median(pdiff(sParams(1).Fmax(ii(find(tf))),sParams(2).Fmax(jj(ib(tf)))));
s_pdiff(8) = median(pdiff(sParams(1).Fcent(ii(find(tf))),sParams(2).Fcent(jj(ib(tf)))));


