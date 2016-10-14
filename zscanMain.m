clear all
addpath('/Users/jacquesthibodeau/Documents/MATLAB/CarboneZscanNEW/')
load nCellCzscan
load mStructCzscan
mCell=nCellCzscan;
% mStructzscan = dir('/Users/jacquesthibodeau/Documents/MATLAB/zscandata/*.mat');
% nfiles = length(mStructzscan);
% mCell = cell(1, nfiles);
% for k = 1:nfiles
%    mCell{k} = importdata(mStructzscan(k).name);
% end


%% Selecting individual measurements

% mCell = {''};

%% La demi-largeur du faiceau au cours du z-scan

waistz = [160,-1.3;137.4126,0;109.0111,2;82.2162,4;52.0318,6;28.5735,8;20.0726,9.2;19.3989,9.4;20.9723,9.6;22.3092,9.8;21.8346,10;40.1330,12;69.1491,14;92.9258,16;124.3392,18;148.5318,20.0001];
waistz2 = waistz(:,2)+0.7550;%+1.4;

%% Calcul de l'intensité du faisceau laser à différentes positions

dRefBaseline = [0.605;0.693;0.805;0.96;1.166;1.524;2.07;2.73;3.55;4.2;4.54;4.75];

pMoyBaseline = [15.1;17.3;20.3;24.3;29.05;37.3;46.38;55.95;66.6;75.37;80.7;84.8];

%% Plots the T and R vs z curves

for i = 1:length(mCell)
    
    s = mCell{1,i};
    mStructzscani = mStructCzscan(i);
    subWSLength = length(who)+1;
    [Tall,Rall,Absall,Posall,intensiteall,Pmoyall] = fZscanPlotstetR(i,mStructzscani,s,subWSLength,waistz,waistz2,dRefBaseline,pMoyBaseline);
    TRAPI{i} = {Tall,Rall,Absall,Posall,intensiteall,Pmoyall};
end

% %% Plots the T and R vs I curves
% 
% for i = 1:length(mStruct)
%     
%     s = mStruct(i).name;
%     
%     fZscanPlotsI(s);
% end