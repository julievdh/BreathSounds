% Correlation between acoustics and ultrasound and tidal volume

expVT = [5.00460422851643;5.14305093307647;5.61088480175293;
    5.70349766273412;5.76698102184719;5.97139839327268;
    6.28988722874711;6.36449842819644;6.69739615926150;
    6.84366546411586;6.84979663696931;7.28542861484245;
    6.89394397186128;7.42955685507339;7.88703213356441;
    7.95370735990777;8.08063891443444;8.13895717904297;
    8.66396497652570;8.66969736819753];
inspVT = expVT-rand(20,1);
expUSdispl = [0.104792332268371;0.146964856230032;0.169968051118211;
    0.214057507987220;0.219808306709265;0.192971246006390;
    0.221725239616613;0.217891373801917;0.246645367412141;
    0.290734824281150;0.267731629392971;0.300319488817891;
    0.338658146964856;0.346325878594249;0.317571884984026;
    0.325239616613419;0.336741214057508;0.357827476038339;
    0.334824281150160;0.384664536741214];
inspUSdispl = expUSdispl-abs(0.15*rand(20,1));

figure(1); clf; hold on
plot(expVT,expUSdispl,'k.','MarkerSize',15)
plot(inspVT,inspUSdispl,'r.','MarkeRSize',15)
xlabel('Expired Tidal Volume (L)')
ylabel('Lung Displacement (mm)')
box on


print -dtiff ONRProposalFigure

%% ultrasound VT vs acoustic VT

acousVTpneum = expVT-rand(20,1);
acousVTnopneum = expVT+rand(20,1);

figure(2); clf; hold on
plot(acousVTnopneum,expUSdispl,'k.','MarkerSize',20)
plot(acousVTpneum,expUSdispl,'ko','MarkerSize',10)
xlabel('Acoustic Tidal Volume (L)')
ylabel('Lung Displacement (cm)')
box on
