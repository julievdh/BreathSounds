% r vs L Pneumotach design
% Following Giannella-Neto et al. 1998 JAppliedPhysiology 

%% for Rats 
[L, r] = meshgrid(5:0.5:25, 0:.05:1.2);
% p = rand(2, 1); %# In this example p = [0.1, 0.2]
Vmax = 12.0; % ml s^-1 Max Flow Rate
Vmin = 0.1; % ml s^-1 Min Flow Rate
VT = 2.0; % mL Tidal Volume
rho = 1.176; % kg m^-3 Density
eta = 1.839E-5; % N s m^-2 Dynamic Viscosity 
delPmin = 0.1; % Pa Minimal measurable pressure differential
Ltot = 4.*L; % Total pneumotachograph length 
aR = 0.2; % Fraction of respiratory system resistance "allowable"
aV = 0.1; % Fraction of tidal volume "allowable" in the pneumotachograph
Rrs = 0.24; % cm H20 s ml^-1 or = 0.24E8 kg m^-4 s Animal's Respiratory system resistance

ineq1 = r >= (Vmax*rho/1000)/(1000*pi*eta);             %# First inequation: Laminar Flow
ineq2 = r <= nthroot((8*eta*L*Vmin*1000)/(pi*delPmin),4); %# Second inequation: Measurable differential Pressure
ineq3 = r >= nthroot((8*eta*Ltot)/(aR*pi*Rrs),4); %# Third inequation: Minimal interference with respiratory mechanics
ineq4 = r <= sqrt((aV*VT*1000)./(pi*Ltot)); %# Fourth inequation: minimal dead space
all = ineq1 & ineq2 & ineq3 & ineq4;                      %# Intersection of both inequations

figure(1); clf; hold on
c = 1:5;                                    %# Contour levels
contour(c(1) * ineq1, [c(1), c(1)], 'b');  %# Fill area for first inequation
contour(c(2) * ineq2, [c(2), c(2)], 'g')   %# Fill area for second inequation
contour(c(3) * ineq3, [c(3), c(3)],'r')
contour(c(4) * ineq4,  [c(4), c(4)], 'm')

contourf(c(5) * all, [c(5), c(5)], 'y')     %# Fill area for both inequations

legend('Laminar','Measurable Pressure','Minimal Interference','Deadspace','All')
xlabel('Length (mm)'); ylabel('Internal radius (mm)')
set(gca,'Xtick',1:4:41,'Xticklabel',min(min(L)):2:max(max(L)),...
    'Ytick',0:2:25,'Yticklabel',min(min(r)):0.1:max(max(r)))

%% For Dolphins

[L, r] = meshgrid(10:100, 0:10:3000);
% 1 cm to 10 cm length between ports
% 0 to 3000 mm radius = 3 m hahahahahahahaaahahahahaa.

Vmax = 140*1000; % ml s^-1 Max Flow Rate
Vmin = 0.1; % ml s^-1 Min Flow Rate
VT = 6*1000; % mL Tidal Volume
rho = 1.176; % kg m^-3 Density
eta = 1.839E-5; % N s m^-2 Dynamic Viscosity 
delPmin = 1; % Pa Minimal measurable pressure differential
Ltot = 4.*L; % Total pneumotachograph length 
aR = 0.2; % Fraction of respiratory system resistance "allowable"
aV = 0.1; % Fraction of tidal volume "allowable" in the pneumotachograph
Rrs = 40; % cm H20 s ml^-1 or = 0.24E8 kg m^-4 s Animal's Respiratory system resistance

ineq1 = r >= (Vmax*rho/1000)/(1000*pi*eta);             %# First inequation: Laminar Flow
ineq2 = r <= nthroot((8*eta*L*Vmin*1000)/(pi*delPmin),4); %# Second inequation: Measurable differential Pressure
ineq3 = r >= nthroot((8*eta*Ltot)/(aR*pi*Rrs),4); %# Third inequation: Minimal interference with respiratory mechanics
ineq4 = r <= sqrt((aV*VT*1000)./(pi*Ltot)); %# Fourth inequation: minimal dead space
all = ineq1 & ineq2 & ineq3 & ineq4;                      %# Intersection of both inequations

figure(2); clf; hold on
c = 1:5;                                    %# Contour levels
contour(c(1) * ineq1, [c(1), c(1)], 'b');  %# Fill area for first inequation
contour(c(2) * ineq2, [c(2), c(2)], 'g')   %# Fill area for second inequation
contour(c(3) * ineq3, [c(3), c(3)],'r')
contour(c(4) * ineq4,  [c(4), c(4)], 'm')

contourf(c(5) * all, [c(5), c(5)], 'y')     %# Fill area for both inequations

legend('Laminar','Measurable Pressure','Minimal Interference','Deadspace')
xlabel('Length (mm)'); ylabel('Internal radius (mm)')
set(gca,'Xtick',0:10:90,'Xticklabel',min(min(L)):10:max(max(L)),...
     'Ytick',0:50:300,'Yticklabel',min(min(r)):500:max(max(r)))

%% is there a common space if we ignore laminar flow?
clear L r ineq1 ineq2 ineq3 ineq4
[L, r] = meshgrid(10:100, 0:1:50);
% 1 cm to 10 cm length between ports
% 0 to 50 mm radius = 5 cm 
Ltot = 4.*L; % Total pneumotachograph length 


ineq1 = r >= (Vmax*rho/1000)/(1000*pi*eta);             %# First inequation: Laminar Flow
ineq2 = r <= nthroot((8*eta*L*Vmin*1000)/(pi*delPmin),4); %# Second inequation: Measurable differential Pressure
ineq3 = r >= nthroot((8*eta*Ltot)/(aR*pi*Rrs),4); %# Third inequation: Minimal interference with respiratory mechanics
ineq4 = r <= sqrt((aV*VT*1000)./(pi*Ltot)); %# Fourth inequation: minimal dead space


all = ineq2 & ineq3 & ineq4;

figure(3); clf; hold on
c = 1:5;                                    %# Contour levels
contour(c(2) * ineq2, [c(2), c(2)], 'g')   %# Fill area for second inequation
contour(c(3) * ineq3, [c(3), c(3)],'r')
contour(c(4) * ineq4,  [c(4), c(4)], 'm')

contourf(c(5) * all, [c(5), c(5)], 'y')     %# Fill area for both inequations

legend('Measurable Pressure','Minimal Interference','Deadspace','All')
xlabel('Length (mm)'); ylabel('Internal radius (mm)')
set(gca,'Xtick',0:10:90,'Xticklabel',min(min(L)):10:max(max(L)))

% NO SOLUTION 