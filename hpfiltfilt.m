function [g]=hpfiltfilt(s,order,sr,hf)

[b a]=butter(order,hf/sr*2,'high');
g=filtfilt(b,a,s);