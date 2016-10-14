function [Tall,Rall,Absall,Posall,intensiteall,Pmoyall]= fZscanPlotTandR(i,di,s,subWSLength,waistz,waistz2,dRefBaseline,pMoyBaseline)
%fZscanPlotstetR: Plots the transmittance et reflectance figures

%Load the calibration workspace for the different lasers/modes
load pentezscanWSV2.mat

%di is mStructzscani so this simply deletes the .mat of the name of each
%file in order to save the file without it later
file = di.name(1:end-4);

%Looks at the name of each file to figure out which laser/mode was used in
%order to use the correct calibration.
if length(strfind(di.name,'ML'))==1
    D1D2fit=D1D2fitML;
else
    D1D2fit=D1D2fitCW;
end

%The length of s is the number of goings and comings added together
k = length(s);

for j = 1:k
    
    zs = s{j};
    
    if mod(j,2) == 1
        position = positionsioa1;
        yTblocker = yTblockera1; yRefblocker = yRefblockera1; yRrien = yRriena1; yRefrien = yRefriena1;
        mT = mTa1; mR = mRa1;
    else
        position = positionsior1;
        yTblocker = yTblockerr1; yRefblocker = yRefblockerr1; yRrien = yRrienr1; yRefrien = yRefrienr1;
        mT = mTr1; mR = mRr1;
    end
    
    dDRef = polydeg(zs(:,1),zs(:,4));
    dDT = polydeg(zs(:,1),zs(:,3));
    dDR = polydeg(zs(:,1),zs(:,5));
    
    pDRef = polyfit(zs(:,1),zs(:,4),dDRef);
    pDT = polyfit(zs(:,1),zs(:,3),dDT);
    pDR = polyfit(zs(:,1),zs(:,5),dDR);
    
    DRef{j} = polyval(pDRef,position);
    DT{j} = polyval(pDT,position);
    DR{j} = polyval(pDR,position);
    
    D1val{j} = polyval(D1D2fit,DRef{j});
    penteD1D2T = D1val{j}./DRef{j} - yTblocker./yRefblocker;
    
%     DRef{j} = interp1(zs(:,1),zs(:,4),position);
%     DT{j} = interp1(zs(:,1),zs(:,3),position);
%     DR{j} = interp1(zs(:,1),zs(:,5),position);
    
    DTDRef{j} = DT{j}./DRef{j} - yTblocker./yRefblocker;
    DRDRef{j} = DR{j}./DRef{j} - yRrien./yRefrien;

    T{j} = (DTDRef{j}./penteD1D2T).*100;
    R{j} = (DRDRef{j}./mR(:,2)).*100;
    Abs{j} = 100-T{j}-R{j};
    Pos{j} = position;
    
    dW = polydeg(waistz2,waistz(:,1).*10^-6);
    dPmoy = polydeg(dRefBaseline,pMoyBaseline);
    
    pW = polyfit(waistz2,waistz(:,1).*10^-6,dW);
    pPmoy = polyfit(dRefBaseline,pMoyBaseline,dPmoy);
    
    W{j} = polyval(pW,position);
    Pmoy{j} = polyval(pPmoy,DRef{j}).*10^-3;
    
%     W{j} = interp1(waistz2,waistz(:,1).*10^-6,position);
%     
%     Pmoy{j} = interp1(dRefBaseline,pMoyBaseline,DRef{j},'linear','extrap');

    Pcrete{j} = Pmoy{j}*(1.25*10^-8)/(100*10^-15);
    intensite{j} = 2*Pcrete{j}./(pi*W{j}.^2);
    
end

Tall = cat(1,T{:});
Rall = cat(1,R{:});
Absall = cat(1,Abs{:});
Posall = cat(1,Pos{:});
intensiteall = cat(1,intensite{:});
Pmoyall = cat(1,Pmoy{:});

%% Plots

figure(1)
plot(Posall,Tall,'-s',Posall,Rall,'-o',Posall,Absall,'-d','linewidth',0.5,'MarkerSize',2);
xlabel('Position en z (mm)')
ylabel('Transmittance et réflectance (%)')
legend('T','R','\alpha')
grid on

% file_name = strcat(file,'Pos');
% saveas(gcf,file_name,'fig')
% saveas(gcf,file_name,'epsc')

figure(2)
semilogx(intensiteall,Tall,'-s',intensiteall,Rall,'-o',intensiteall,Absall,'-d','linewidth',0.5,'MarkerSize',2);
xlabel('Intensité (W/m^2)')
ylabel('Transmittance et réflectance (%)')
legend('T','R','\alpha')
grid on

% file_name = strcat(file);
% saveas(gcf,file_name,'fig')
% saveas(gcf,file_name,'epsc')

end