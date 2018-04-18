function [all_SUMMARYDATA,RESPTIMING] = importRESP(filename);
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds\PneumoData'
SUMfname = strcat(regexprep(filename,'.mat',''),'-DATA_SUMMARY.txt');
all_SUMMARYDATA = importDATASUMMARY(SUMfname);
TIMEfname = strcat(regexprep(filename,'.mat',''),'-RESP_TIMING.txt');
RESPTIMING = importRESPTIMING(TIMEfname);
cd '\\uni.au.dk\Users\au575532\Documents\MATLAB\BreathSounds'
end
