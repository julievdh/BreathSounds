function energy95sub(xfilt,i,cue,Fig)

% Import wav file for a subset of a breath based on tag cues from audit, 
% plot 95% energy range
% Inputs:
%       xfilt = downsampled and filtered respiratory sound signal
%       i = breath number, to correspond with cue number
%       start = start time in breath (seconds)
%       Fig = Figure number; default = 1
%       
%
% Julie van der Hoop jvanderhoop@whoi.edu
% 27 June 2014

% if Figure number not specified, default = 1
if nargin < 4
    Fig = 1;
end

BL = 1024; % FFT size
afs = 60000; % audio sampling frequency

% figure(9)
time = cue+(1:length(xfilt))/afs;
% plot(time,xfilt); title('Filtered')
% xlabel('Time (s)'); ylabel('Pressure (Pa)')
% xlim([0 time(end)]); 


%% CALCULATE 95% ENERGY

% calculate total energy
total_energy = xfilt'*xfilt;
energy = xfilt.^2;              % energy = pressure^2

% find 95% energy
tot = cumsum(energy);
criterion = 0.95;

lo = ((1-criterion)/2)*total_energy;    % low and high cutoff points
hi = (1-(1-criterion)/2)*total_energy;

WITHIN = find(tot > lo & tot < hi);
% plot(WITHIN,tot(WITHIN),'r')

start = WITHIN(1);
stop = WITHIN(end);

% find time of 95% energy in SECONDS
time_window  = (stop-start)/afs ;

% figure(9); hold on
% plot((start:stop)/afs,xfilt(start:stop),'k')
% 
figure(Fig); hold on
% figure(2); clf; set(gcf,'Position',[980   375   560   420])
% cumulative energy with cutoff points
perc = (tot/tot(end))*100;
plot(time,perc,'LineWidth',2)
xlabel('Time (s)','FontSize',12); ylabel('Cumulative Energy (%)','FontSize',12)
line([cue cue+start/afs],[lo/tot(end)*100 lo/tot(end)*100],'color','r','LineWidth',2); line([cue+start/afs cue+start/afs],[0 lo/tot(end)*100],'color','r','LineWidth',2)
line([cue+stop/afs max(time)],[hi/tot(end)*100 hi/tot(end)*100],'color','r','LineWidth',2); line([cue+stop/afs cue+stop/afs],[hi/tot(end)*100 100],'color','r','LineWidth',2)
ylim([0 100])

end
