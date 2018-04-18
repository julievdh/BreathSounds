%test = iParams; 
%resp.cue(1); % what is first resp cue?
% how many cues in R before that? 
%toadd = find(R.cue(:,1) < resp.cue(1,1)); 

[~,exh] = findaudit(R,'exh'); % exhales
[~,inh] = findaudit(R,'inh'); % inhales
[~,breath] = findaudit(R,'breath'); % breaths
[~,fbreath] = findaudit(R,'fbreath'); % full breaths

% here we know that we have each breath only once 
clf, hold on
plot(fbreath.cue(:,1),zeros(length(fbreath.cue)),'k*')
plot(breath.cue(:,1),zeros(length(breath.cue))+1,'r*')
plot(inh.cue(:,1),zeros(length(inh.cue)),'go')
plot(exh.cue(:,1),zeros(length(exh.cue)),'bo')

% check lengths agree
% isequal(length(resp.cue)+length(toadd),length(R.cue))

% add 44 lines - ShiftParamIndex 
% iParams
iParams.time_window = ShiftParamIndex(iParams.time_window); 
iParams.dur = ShiftParamIndex(iParams.dur); 
iParams.start = ShiftParamIndex(iParams.start); 
iParams.stop = ShiftParamIndex(iParams.stop); 
iParams.RMS = ShiftParamIndex(iParams.RMS);
iParams.EFD = ShiftParamIndex(iParams.EFD); 
iParams.pp = ShiftParamIndex(iParams.pp); 
iParams.Fmax = ShiftParamIndex(iParams.Fmax); 
iParams.Fcent = ShiftParamIndex(iParams.Fcent); 

% eParams
eParams.time_window = ShiftParamIndex(eParams.time_window); 
eParams.dur = ShiftParamIndex(eParams.dur); 
eParams.start = ShiftParamIndex(eParams.start); 
eParams.stop = ShiftParamIndex(eParams.stop); 
eParams.RMS = ShiftParamIndex(eParams.RMS);
eParams.EFD = ShiftParamIndex(eParams.EFD); 
eParams.pp = ShiftParamIndex(eParams.pp); 
eParams.Fmax = ShiftParamIndex(eParams.Fmax); 
eParams.Fcent = ShiftParamIndex(eParams.Fcent); 

% tParams
tParams.time_window = ShiftParamIndex(tParams.time_window); 
tParams.dur = ShiftParamIndex(tParams.dur); 
tParams.start = ShiftParamIndex(tParams.start); 
tParams.stop = ShiftParamIndex(tParams.stop); 
tParams.RMS = ShiftParamIndex(tParams.RMS);
tParams.EFD = ShiftParamIndex(tParams.EFD); 
tParams.pp = ShiftParamIndex(tParams.pp); 
tParams.Fmax = ShiftParamIndex(tParams.Fmax); 
tParams.Fcent = ShiftParamIndex(tParams.Fcent); 

% exp, ins
ins(:,1) = ShiftParamIndex(ins(:,1));
ins(:,2) = ShiftParamIndex(ins(:,2));
exo(:,1) = ShiftParamIndex(exp(:,1));
exp(:,2) = ShiftParamIndex(exp(:,2));

% Quality
Quality = ShiftParamIndex(Quality);


