% could this be a useful way to detect artefacts
figure(2), clf
for i = 1:length(I) 
    if isnan(CUE_R(I(i))) ~= 1
        sound = abs(sigstore{1,i}); % channel 2
        vol = cumsum(sound);
        figure(2)
        plot(vol,sound)
        figure(3)
        plot(sound)
        title(num2str(CUE_R(I(i)))) % value for audit : R = d3tagaudit(tag,breath.cue(19,1),R,20000,'envelope');
        pause
    end
end

% if shape isn't good, then donøt use it
% or mark point at which to stop it?