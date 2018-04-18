tag = 'mn14_247b';
prefix = strcat(tag(1:2),tag(6:9));
settagpath('audio','O:\ST_Bio-Kaskelot\australien14\DTAG\')
recdir = 'O:\ST_Bio-Kaskelot\australien14\DTAG\';
recdir = d3makefname(tag,'RECDIR');

R = loadaudit(tag);

for i = 1:length(R.cue)
[x_d,xfilt] = BreathFilt(i,R,recdir,tag,1);
pause
end

%% 
[new_s,afs] = cleanbreath_fun(tag,R.cue(4,:),recdir,1); % filter the signal for the nth breath

envfilt
figure
plott(-averageenv,afs)

