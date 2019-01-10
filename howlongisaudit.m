function dur = howlongisaudit(tag)

R = loadaudit(tag); % load the audit
[cues,R] = findbreathcues(R); % get resp cues only
dur = (R.cue(end,1)-R.cue(1,1))/3600; 
