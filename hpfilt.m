function [g]=hpfilt(s,order,sr,hf)

[b a]=butter(order,hf/sr*2,'high');
g=filter(b,a,s);