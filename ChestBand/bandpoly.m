function [p,f] = bandpoly(BandParam,SUMMARYDATA,match)
[p,S] = polyfit(BandParam(match)',SUMMARYDATA(:,6), 1);
f = polyval(p,BandParam(match)); 
end
