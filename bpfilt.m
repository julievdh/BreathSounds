function [g]=bpfilt(is,order,sr,lf,hf)

[b a]=butter(order,[lf/sr*2 hf/sr*2]);

g=filter(b,a,is);