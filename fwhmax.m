function [mx,FWHM,int] = fwhmax(y,fs,integrate);
 
% y is signal
% fs is sampling rate
% integrate is option to also calculate integral 

if nargin < 3
    integrate = 0;
end
        
% find max
[mx,ind] = max(y);

% find 3db point
above = find(y > mx/2); % find local values above half max

figure(90), clf, hold on
plot(y), plot(ind,mx,'o')
plot([above(1) above(end)],[mx/2 mx/2])

% calculate width
FWHM = (above(end)-above(1))/fs;

% % integratea option
% if int == 1
%     %% integrate band between FWHP?
%         ind1 = Blocs(p)-400+above(1); % start of FWHP
%         ind2 = Blocs(p)-400+above(end); % end of FWHPfil
%         plot(ChestBand(ind1:ind2)-ChestBand(ind1)) % whatever is above the FWHP
%         
%         Bmint(p) = abs(trapz(ChestBand(ind1:ind2)-ChestBand(ind1)));
% end

end
