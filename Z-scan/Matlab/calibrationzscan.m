clear all

%Transmittance and reflectance of a SiO2 substrate
% xT1 = 0.9301;
xR1 = 0.0662;

%Create vectors containing all positions the z-scan will move to. 
nump = 550; %number of points
zi = 0; %initial value of z
zf = 20; %final value of z

positionsioa = linspace(zi,zf,nump)'; positionsior = flipud(positionsioa(2:end-1,:));
yRefblockera = ones(1,nump)*yRefblockera; yRefblockerr = flipud(yRefblockera(2:end-1,:));
yRefriena = ones(1,nump)*yRefriena; yRefrienr = flipud(yRefriena(2:end-1,:));
yRefsioa = ones(1,nump)*yRefsioa; yRefsior = flipud(yRefsioa(2:end-1,:));
yTblockera = ones(1,nump)*yTblockera; yTblockerr = flipud(yTblockera(2:end-1,:));
yTriena = ones(1,nump)*yTriena; yTrienr = flipud(yTriena(2:end-1,:));
yTsioa = ones(1,nump)*yTsioa; yTsior = flipud(yTsioa(2:end-1,:));
yRriena = ones(1,nump)*yRrien; yRrienr = flipud(yRriena(2:end-1,:));
yRsioa = ones(1,nump)*yRsioa; yRsior = flipud(yRsioa(2:end-1,:));

%% The following 4 vectors contain the mean value of the transmission detector
%% and reference detector at different mean power values from the beam

D1rienML = [0.142110791;0.181647532;0.230481712;0.303102218;0.412561276;0.612063621;1.026240766;1.299462572;1.676696979;2.180725028;2.646719314;2.751258502;2.754787629;3.017848095];
D2rienML = [0.155692975;0.198821318;0.252802186;0.330501494;0.450221058;0.660297264;1.087755555;1.414160106;1.91793184;2.599219754;3.228954467;3.408443673;3.387094886;3.778000598];

D1rienCW = [0.568914416;0.705263215;0.918083211;1.1250742;1.161535846;1.165479861;1.280760383;1.443903827;1.696039763;1.875496477;2.070261716;2.313632254;2.504701906;2.686685316;2.938407415;3.114759902;3.306918013;3.563733202];
D2rienCW = [0.457385305;0.544026034;0.772128368;1.067020827;1.067296206;1.075976959;1.226998852;1.366397337;1.585378145;1.765662542;1.90229661;2.110371313;2.285256318;2.474057332;2.692925244;2.831082966;2.982370234;3.223628383];

D1D2degML = polydeg(D2rienML,D1rienML);
D1D2fitML = polyfit(D2rienML,D1rienML,D1D2degML);

D1D2degCW = polydeg(D2rienCW,D1rienCW);
D1D2fitCW = polyfit(D2rienCW,D1rienCW,D1D2degCW);

%% Calibration des données pour la transmission et réflection

yTa = yTriena./yRefriena - yTblockera./yRefblockera; yTr = yTrienr./yRefrienr - yTblockerr./yRefblockerr;
yRa = yRsioa./yRefsioa - yRriena./yRefriena; yRr = yRsior./yRefsior - yRrienr./yRefrienr;

%% Pente pour l'interpolation des mesures prises avec les couches minces

penteTa = (yTa)./(1); penteTr = (yTr)./(1);
penteRa = (yRa)./(xR1); penteRr = (yRr)./(xR1);

mTa1 = [positionsioa,penteTa]; mTr = [positionsior,penteTr];
mRa1 = [positionsioa,penteRa]; mRr = [positionsior,penteRr];

Tt = [0;1];
Rt = [0;xR1];