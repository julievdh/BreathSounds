function [Params] = EnvParams(env,fs,Params,R)

% Import wav file for a breath based on tag cues from audit, filter audio,
% and calculate RMS sound pressure and Energy Flux Density of the filtered
% signal.
%
% Inputs:
%       env = downsampled and filtered respiratory sound signal
%       fs = sampling rate of envelope
%
% Outputs:
%       Params: structure with the following parameters
%       time_window = 95% energy duration
%       RMS = Root mean square sound pressure [dB re 1 uPa]
%       EFD = Energy Flux Density [(Pa^2)*s]
%       pp = peak-peak sound pressure level [dB re 1 uPa]
%       Fmax = peak frequency [Hz]
%       Fcent = centroid frequency [Hz]
%       
%
% Julie van der Hoop jvanderhoop@whoi.edu
% 1 April 2014 // Updated 19 July 2017 for envelope

figure(9), hold on
time = (1:length(env))/fs;
plot(time,env); title('Filtered')
xlabel('Time (s)'); ylabel('Pressure (Pa)')
xlim([0 time(end)]); 

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
plot((start:stop)/afs,xfilt(start:stop),'k')
% 
figure(1); clf, hold on
% figure(2); clf; set(gcf,'Position',[980   375   560   420])
% cumulative energy with cutoff points
perc = (tot/tot(end))*100;
plot(time,perc,'LineWidth',2)
xlabel('Time (s)','FontSize',12); ylabel('Cumulative Energy (%)','FontSize',12)
line([0 start/afs],[lo/tot(end)*100 lo/tot(end)*100],'color','r','LineWidth',2); line([start/afs start/afs],[0 lo/tot(end)*100],'color','r','LineWidth',2)
line([stop/afs max(time)],[hi/tot(end)*100 hi/tot(end)*100],'color','r','LineWidth',2); line([stop/afs stop/afs],[hi/tot(end)*100 100],'color','r','LineWidth',2)
ylim([0 100])
title(R.stype(i))


%% CALCULATE PEAK PEAK SPL, RMS and ENERGY FLUX DENSITY

RMS = 178 + 20*log10( sqrt ( mean ( xfilt.^2)) );    % dB re 1uPa
EFD = RMS  + 10*log10 ( 1e-6 * time_window );        % Pa^2s
pp = 178 + 20*log10( max(xfilt) - min(xfilt) );       % dB re 1uPa

%% CALCULATE POWER SPECTRAL DENSITY (PSD, Welch's) TO FIND PEAK AND
% CENTROID FREQUENCIES
[Pxx,F] = pwelch(xfilt,hamming(BL),floor(BL/1.3),BL,60000,'onesided');
figure(400); 
subplot(211)
loglog(F,Pxx); hold on
xlabel('Frequency (Hz)'); ylabel('Power Spectral Density')

subplot(212)
plot(F,Pxx); hold on
xlabel('Frequency (Hz)'); ylabel('Power Spectral Density')

% peak frequency
ii = find(Pxx == max(Pxx));
Fmax = F(ii); 
plot(Fmax,Pxx(ii),'r.')

% centroid frequency
Fcent = sum(Pxx.*F)./sum(Pxx);
plot(Fcent,1E-5,'k.')
legend('PSD','Fmax','Fcent')
xlim([0 5000])

% Save to structure
Params.time_window(i) = time_window;
Params.start(i) = start;
Params.stop(i) = stop;
Params.RMS(i) = RMS;
Params.EFD(i) = EFD;
Params.pp(i) = pp;
Params.Fmax(i) = Fmax;
Params.Fcent(i) = Fcent;

end
