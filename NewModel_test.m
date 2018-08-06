FlowSoundPlot_Syringe
FlowSoundAssess_Syringe

%% plot 5 different flows separately
figure(9), clf, hold on
plot(allstore(pon(1)).soundi,allstore(pon(1)).flowi,'o')
plot(allstore(pon(2)).soundi,allstore(pon(2)).flowi,'o')
plot(allstore(pon(3)).soundi,allstore(pon(3)).flowi,'o')
plot(allstore(pon(4)).soundi,allstore(pon(4)).flowi,'o')
plot(allstore(pon(5)).soundi,allstore(pon(5)).flowi,'o')

%% make flow-sound relationships for different flow rates
for n = 1:5
    % find ~NaNs
    gd = ~isnan(allstore(pon(n)).soundi);
    [curvei,gofi] = fit(allstore(pon(n)).soundi(gd),allstore(pon(n)).flowi(gd)','a*x^b','robust','bisquare');
    plot(curvei)
    as(n) = curvei.a;
    bs(n) = curvei.b;
    legend off
end

% need Pxx for syringe here

%% for a DQ 2017 exercise trial
f = 16; FlowSoundPlot_DQ2017
%%
F = 0:117.1875:1.2E5; % frequencies for SL calculations
B1 = find(F<1000); % band 1
B2 = find(F>=2500 & F <= 3500); % band 2

figure(91), clf,
%%
for n = 1:length(allstore)
    if ~isempty(allstore(n).Pxx_i)
        subplot(1,3,1:2), hold on
        plot(allstore(n).sound(allstore(n).in),-allstore(n).flow(allstore(n).in),'o')
        
        gd = ~isnan(allstore(n).sound(allstore(n).in));
        if size(gd,1) > 3 == 1
            [curvei,gofi] = fit(allstore(n).sound(allstore(n).in(gd)),-allstore(n).flow(allstore(n).in(gd)),'a*x^b','robust','bisquare');
            plot(curvei)
            as(n) = curvei.a;
            bs(n) = curvei.b;
            legend off
        end
        
        subplot(1,3,3), hold on
        dPxx(n) = mean(allstore(n).Pxx_i(B2))-mean(allstore(n).Pxx_i(B1));
        
        plot(dPxx(n),-allstore(n).mnflowI,'o')
        plot(dPxx(n),-min(allstore(n).flow(in)),'*')
    end
end

