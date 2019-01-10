% NAN OUT ZEROS OF BREATH PARAMETERS

if exist('eParams') == 1
    eParams.time_window(~eParams.time_window) = NaN;
    eParams.start(~eParams.start) = NaN;
    eParams.stop(~eParams.stop) = NaN;
    eParams.RMS(~eParams.RMS) = NaN;
    eParams.EFD(~eParams.EFD) = NaN;
    eParams.pp(~eParams.pp) = NaN;
    eParams.Fcent(~eParams.Fcent) = NaN;
    eParams.Fmax(~eParams.Fmax) = NaN;
    
    if isequal(length(eParams.Fcent),length(R.cue)) ~=1
        eParams.time_window(length(eParams.time_window):length(R.cue)) = NaN;
        eParams.start(length(eParams.start):length(R.cue)) = NaN;
        eParams.stop(length(eParams.stop):length(R.cue)) = NaN;
        eParams.RMS(length(eParams.RMS):length(R.cue)) = NaN;
        eParams.EFD(length(eParams.EFD):length(R.cue)) = NaN;
        eParams.pp(length(eParams.pp):length(R.cue)) = NaN;
        eParams.Fcent(length(eParams.Fcent):length(R.cue)) = NaN;
        eParams.Fmax(length(eParams.Fmax):length(R.cue)) = NaN;
    end
end

if exist('iParams') == 1 && isempty(iParams) == 0
    if isempty('iParams.time_window') == 0
        iParams.time_window(~iParams.time_window) = NaN;
        iParams.start(~iParams.start) = NaN;
        iParams.stop(~iParams.stop) = NaN;
        iParams.RMS(~iParams.RMS) = NaN;
        iParams.EFD(~iParams.EFD) = NaN;
        iParams.pp(~iParams.pp) = NaN;
        iParams.Fcent(~iParams.Fcent) = NaN;
        iParams.Fmax(~iParams.Fmax) = NaN;
        if isequal(length(iParams.Fcent),length(R.cue)) ~=1
            iParams.time_window(length(iParams.time_window):length(R.cue)) = NaN;
            iParams.start(length(iParams.start):length(R.cue)) = NaN;
            iParams.stop(length(iParams.stop):length(R.cue)) = NaN;
            iParams.RMS(length(iParams.RMS):length(R.cue)) = NaN;
            iParams.EFD(length(iParams.EFD):length(R.cue)) = NaN;
            iParams.pp(length(iParams.pp):length(R.cue)) = NaN;
            iParams.Fcent(length(iParams.Fcent):length(R.cue)) = NaN;
            iParams.Fmax(length(iParams.Fmax):length(R.cue)) = NaN;
        end
    end
end

if exist('sParams') == 1
    if exist('sParams.time_window') == 1
        sParams.time_window(~sParams.time_window) = NaN;
        sParams.start(~sParams.start) = NaN;
        sParams.stop(~sParams.stop) = NaN;
        sParams.RMS(~sParams.RMS) = NaN;
        sParams.EFD(~sParams.EFD) = NaN;
        sParams.pp(~sParams.pp) = NaN;
        sParams.Fcent(~sParams.Fcent) = NaN;
        sParams.Fmax(~sParams.Fmax) = NaN;
        if isequal(length(sParams.Fcent),length(R.cue)) ~=1
            sParams.time_window(length(sParams.time_window):length(R.cue)) = NaN;
            sParams.start(length(sParams.start):length(R.cue)) = NaN;
            sParams.stop(length(sParams.stop):length(R.cue)) = NaN;
            sParams.RMS(length(sParams.RMS):length(R.cue)) = NaN;
            sParams.EFD(length(sParams.EFD):length(R.cue)) = NaN;
            sParams.pp(length(sParams.pp):length(R.cue)) = NaN;
            sParams.Fcent(length(sParams.Fcent):length(R.cue)) = NaN;
            sParams.Fmax(length(sParams.Fmax):length(R.cue)) = NaN;
        end
    end
end