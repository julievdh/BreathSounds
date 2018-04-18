function [start,stop,time_window] = energy95(x,fs,Fig)

% Import wav file for a breath based on tag cues from audit, plot 95%
% energy range
% Inputs:
%       x = signal
%       fs = sampling frequency of signal
%       Fig = Figure number; default = 1
%       
% Outputs: start (time in s), stop (time in s), 95% energy duration
%
% Julie van der Hoop jvanderhoop@whoi.edu
% 27 June 2014 // modified 19 July 2017

% if Figure number not specified, default = 1
if nargin < 3
    Fig = 0;
end

% figure(9)
time = (1:length(x))/fs;
% plot(time,x); title('Filtered')
% xlabel('Time (s)'); ylabel('Pressure (Pa)')
% xlim([0 time(end)]); 


%% CALCULATE 95% ENERGY

% calculate total energy
total_energy = x'*x;
energy = x.^2;              % energy = pressure^2

% find 95% energy
tot = cumsum(energy);
criterion = 0.95;

lo = ((1-criterion)/2)*total_energy;    % low and high cutoff points
hi = (1-(1-criterion)/2)*total_energy;

WITHIN = find(tot > lo & tot < hi);
% plot(WITHIN,tot(WITHIN),'r')

start = WITHIN(1)/fs;
stop = WITHIN(end)/fs;

% find time of 95% energy in SECONDS
time_window  = (stop-start);

% figure(9); hold on
% plot((start:stop)/fs,x(start:stop),'k')
% 
if Fig ~= 0
figure(Fig); hold on
% figure(2); clf; set(gcf,'Position',[980   375   560   420])
% cumulative energy with cutoff points
perc = (tot/tot(end))*100;
plot(time,perc,'LineWidth',2)
xlabel('Time (s)','FontSize',12); ylabel('Cumulative Energy (%)','FontSize',12)
line([0 start],[lo/tot(end)*100 lo/tot(end)*100],'color','r','LineWidth',2); line([start start],[0 lo/tot(end)*100],'color','r','LineWidth',2)
line([stop max(time)],[hi/tot(end)*100 hi/tot(end)*100],'color','r','LineWidth',2); line([stop stop],[hi/tot(end)*100 100],'color','r','LineWidth',2)
ylim([0 100])
end
end
