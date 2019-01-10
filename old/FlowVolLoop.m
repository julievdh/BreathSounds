% FlowVolLoop

% load data - test this file
load('/Users/julievanderhoop/Dropbox (MIT)/BreathSounds/JulieMatlab/BreathSounds/PneumoData/7May2014_water_tt127zEKG_FB241_resp.mat')

% find breath subset
st = 106200; ed = 106700; 
flowt = RAWDATA(st:ed,1);
flow = RAWDATA(st:ed,2);

% plot(flowt,flow)

vol = cumsum(flow); 

figure(2);
plot(vol,flow)