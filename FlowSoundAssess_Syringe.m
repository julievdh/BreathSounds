% FlowSoundAssess_Syringe
% For syringe FlowSound because of specific aspects of that dataset
if exist('pon','var') == 0
    pon = pon3;
end

%% plot with flow rate
figure(111), clf
for x = 1:length(allstore)/10 % sets of 5 speeds each on-off
    subplot(3,3,x), hold on
    for n = 1:length(pon)
        plot(allstore(pon(n)).soundi,allstore(pon(n)).flowi,'o')
    end
end
%linkaxes
figure(112), clf
for x = 1:length(allstore)/10 % sets of 5 speeds each on-off
    subplot(3,3,x), hold on
    for n = 1:length(pon)
        plot(allstore(pon(n)).soundo,allstore(pon(n)).flowo,'o')
    end
end
%linkaxes
%% take first five only to make model
% count good ones
goodidx = find(arrayfun(@(allstore) ~isempty(allstore.flowi),allstore));
chs = 1:5; % randi([1 length(goodidx)],1,5); % choose 5 random
substore = allstore(goodidx(chs)); % take up to the 5th one
%goodidx = find(arrayfun(@(allstore) ~isempty(allstore.sound),allstore));
%substore = allstore(1:goodidx(5)); % take up to the 5th one


%% use relationship on sounds
% load([filename '_flowsound'])
allflowi = extractfield(substore,'flowi')';
allsoundi = extractfield(substore,'soundi')';
nano = ~isnan(allsoundi);       % find non-nan values
allsoundi = allsoundi(nano); allflowi = allflowi(nano);

[curvei,gofi] = fit(allsoundi,allflowi,'a*x^b','robust','bisquare');
all_coeffi = coeffvalues(curvei);       % for inhales
ai = all_coeffi(1); bi = all_coeffi(2);

allflowo = extractfield(substore,'flowo')';
allsoundo = extractfield(substore,'soundo')';
nano = ~isnan(allsoundo);       % find non-nan values
allsoundo = allsoundo(nano); allflowo = allflowo(nano);

[curve,goodness] = fit(allsoundo,-allflowo,'a*x^b','robust','bisquare');

all_coeff = coeffvalues(curve);
a = all_coeff(1); b = all_coeff(2);

fitinfo.ai = ai; fitinfo.bi = bi; fitinfo.curvei = curvei; fitinfo.gofi = gofi;
fitinfo.a = a; fitinfo.b = b; fitinfo.curve = curve; fitinfo.gof = goodness;

save([cd '\PneumoData\' filename '_flowsound'],'fitinfo','-append')
%% Fest = a*log10(shift_y)+b;
figure(9), clf, subplot(121), hold on
%plot(extractfield(allstore,'soundo'),-extractfield(allstore,'flowo'),'o')
%plot(extractfield(allstore,'sound2o'),-extractfield(allstore,'flowo'),'o')
plot(allsoundo,-allflowo,'.')
plot(curve), legend off
ylabel('Measured Flow Rate (L/s)'), xlabel('Filtered sound envelope'), title ('Syringe Exhale')

text(6E-4,65,num2str(goodness.rsquare,'%4.2f'))
subplot(122), hold on
%plot(extractfield(allstore,'soundi'),extractfield(allstore,'flowi'),'o')
%plot(extractfield(allstore,'sound2i'),extractfield(allstore,'flowi'),'o')
plot(allsoundi,allflowi,'.')
plot(curvei), legend off
ylabel('Measured Flow Rate (L/s)'), xlabel('Filtered sound envelope'), title ('Syringe Inhale')
text(6E-4,30,num2str(gofi.rsquare,'%4.2f'))

%% evaluate fit
yprede = feval(curve,allsoundo);
[he,pe] = vartest2(resample(yprede-allflowo,1,10),resample(allflowo,1,10));
ypredi = feval(curvei,allsoundi);
[hi,pi] = vartest2(resample(ypredi-allflowi,1,10),resample(allflowi,1,10));

%% for all aligned files

ffs = tickrate(1); % flow sampling rate
afs = 250000; 
dr = round(afs/ffs); % decimation rate

VTest = NaN(2,length(tags(f).sin)); VTesti = NaN(2,length(tags(f).sin)); % estimates from both hydrophones
for n = 1:length(tags(f).sin)
    if aligned(n) == 1,
        if size(allstore(n).soundi,2) > 1
            allstore(n).soundi = allstore(n).soundi';
        end
        if sum(~isnan(allstore(n).soundi)) > 1
        % apply that relationship
        allstore(n).sfilli = naninterp(allstore(n).soundi);                   % interpolate NaNs
        allstore(n).sfilli(find(allstore(n).sfilli<0)) = 0;                           % zero out any negative values at the beginning
        allstore(n).sfilli(find(allstore(n).sfilli>max(allstore(n).soundi))) = 0;    % interpolation should never exceed max envelope
        % hydrophone 2
        allstore(n).sfilli2 = naninterp(allstore(n).sound2i);                   % interpolate NaNs
        allstore(n).sfilli2(find(allstore(n).sfilli2<0)) = 0;                           % zero out any negative values at the beginning
        allstore(n).sfilli2(find(allstore(n).sfilli2>max(allstore(n).sound2i))) = 0;    % interpolation should never exceed max envelope
        end
        % out
        allstore(n).sfillo = naninterp(allstore(n).soundo);                   % interpolate NaNs
        allstore(n).sfillo(find(allstore(n).sfillo<0)) = 0;                           % zero out any negative values at the beginning
        allstore(n).sfillo(find(allstore(n).sfillo>max(allstore(n).soundo))) = 0;    % interpolation should never exceed max envelope
        % hydrophone 2
        allstore(n).sfillo2 = naninterp(allstore(n).sound2o);                   % interpolate NaNs
        allstore(n).sfillo2(find(allstore(n).sfillo2<0)) = 0;                           % zero out any negative values at the beginning
        allstore(n).sfillo2(find(allstore(n).sfillo2>max(allstore(n).sound2o))) = 0;    % interpolation should never exceed max envelope
        
        % estimate flow from sound - both hydrophones
        allstore(n).Festi = ai*(allstore(n).sfilli).^bi;
        allstore(n).Festi2 = ai*(allstore(n).sfilli2).^bi;
        allstore(n).Festo = a*(allstore(n).sfillo).^b;
        allstore(n).Festo2 = a*(allstore(n).sfillo2).^b;
        
        % calculate mean error in L/s
        allstore(n).erroro = mean(allstore(n).Festo)-abs(mean(allstore(n).flowo));
        allstore(n).erroro2 = mean(allstore(n).Festo2)-abs(mean(allstore(n).flowo));
        allstore(n).errori = abs(mean(-allstore(n).Festi))-mean(allstore(n).flowi);
        allstore(n).errori2 = abs(mean(-allstore(n).Festi2))-mean(allstore(n).flowi);
        
        % calculate tidal volume from estimated flow
        VTest(1,n) = trapz(allstore(n).Festo)/(afs/dr);
        VTest(2,n) = trapz(allstore(n).Festo2)/(afs/dr);
        VTesti(1,n) = trapz(allstore(n).Festi)/(afs/dr);
        VTesti(2,n) = trapz(allstore(n).Festi2)/(afs/dr);
        
        figure(19), clf, hold on
        title(n)
        plot(allstore(n).flowo)
        plot(allstore(n).flowi)
        plot(-allstore(n).Festo,'.')
        plot(-allstore(n).Festo2,'.')
        plot(allstore(n).Festi,'.')
        plot(allstore(n).Festi2,'.')
        text(10,10,num2str(VTesti(1,n)))
        text(10,-10,num2str(VTest(1,n)))
        pause
    end
end
xlabel('Time (sec)'), ylabel('Flow Rate (L/s)')
print([cd '/AnalysisFigures/Syringe' filename '_Flowmeas-est.png'],'-dpng')

%%
figure(29), clf
subplot(3,1,1:2), hold on
% get volume from syringe
VTi = zeros(1,length(aligned)); VTe = zeros(1,length(aligned));
for i = 1:length(cuts)
    if isempty(cuts(i).vol) == 0
        % find max
        [mx,ind] = max(cuts(i).vol);
        % find max-min in first half
        VTi(:,i) = mx-min(cuts(i).vol(1:ind));
        % find max-min in second half
        VTe(:,i) = mx-min(cuts(i).vol(ind:end));
    end
end

PlotSyringeAssess

save([cd '\PneumoData\' filename '_flowsound'],'allstore','VTi','VTe','VTerre','VTerri','VTest','VTesti','-append')

%% linear models
lmo = fitlm(-minflow(pon),[allstore(:).erroro]); 
lmi = fitlm(mxflow(pon),[allstore(:).errori]); 
lmoVT = fitlm(-minflow(pon),VTerre(1,pon))
