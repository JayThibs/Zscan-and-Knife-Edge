function [waistML,waistCW] = knifeedgefit()

%% knifeedgefit
% This code will find the value of the half-width of a beam by providing it
% with the data of the change in transmission intensity while a knife edge 
% moves in front of the beam.
%
% This code uses the error function to fit the data points obtained with
% the knife-edge method.
%
% In order to use this code, you need to place all the knife-edge files in
% a folder. The code will go through all the files in the folder, fit all
% of the data, and place all the values in a matrix. This way, you won't
% need to fit each file individually, saving yourself some time.
%
% You will need to save your data as .csv file.
format long
%Add the folder containing the knife-edge files to the path.
addpath('/Users/jacquesthibodeau/Documents/MATLAB/knifeedgedate/') 

%The following will create a structure with the information of the data
%files as well as a cell containing the data of each file within an
%element. 
mStructKE = dir('/Users/jacquesthibodeau/Documents/MATLAB/knifeedgedate/*.csv');
nfiles = length(mStructKE);
mCellKE = cell(1, nfiles);
for k = 1:nfiles
   mCellKE{k} = importdata(mStructKE(k).name);
end

%Values for the element number the loop has reached for a certain laser or
%mode.
l = 1; %Modelocked mode
c = 1; %CW mode

%This loop will go through all your files and fit the data contained in
%each of the files.
for i = 1:length(mCellKE)

%Please change the column number for the position and intensity to match
%the columns contained in your .csv files.
position = mCellKE{1,i}(:,2)-mCellKE{1,i}(1,2);

%Transmission detector divided by the reference detector.
intensity = mCellKE{1,i}(:,3)./mCellKE{1,i}(:,4);

%I substract the mean of the final few data points in intensity in order to
%give the transmittance a baseline to prepare for the fit.
minIntensity = mean(intensity(end-10:end));
transmittance = intensity-minIntensity;

% Here we will fit the data with the error function.
ft=fittype('1-A*erf((sqrt(2)*position-b)/waist)+c', 'independent', 'position', 'dependent', 'transmittance' );

% Update the Start Points accordingly. The order is: A, b, c, waist.
fitresult = fit(position,transmittance,ft,'StartPoint', [1.3,0.44,0.29,0.01]);
coeffvalues(fitresult);

% The next if statement was made in the case where you are switching
% between lasers or laser modes, so you'll be able to store the half-width
% values in different matrices. In order to tell the difference between
% which laser or mode, simply write a specific pattern of letters in your
% file names. Change "ML" to what suits you.

    if length(strfind(mStructKE(i).name,'ML'))==1
        waistML(l,:) = [ans(4)*1000,mCellKE{1,i}(1,7)];
        l = l+1;
    else
        waistCW(c,:) = [ans(4)*1000,mCellKE{1,i}(1,7)];
        c = c+1;
    end

% You can check each plot to make sure the fit worked well by placing a
% breakpoint after the following code for a plot.

% plot(fitresult,position,transmittance,'o')
% xlabel( 'Position en z (mm)' ,'fontsize',28);
% ylabel( 'Transmittance','fontsize',28);
% axis auto
% grid on
% set(gca, 'FontSize', 24)
end

% This will sort the rows of your half-width matrix in terms of the
% position where the knife-edge was taken.
waistML = sortrows(waistML,2);
waistCW = sortrows(waistCW,2);

%Plot the half-width values obtained from the fit.
% plot(waistML(:,2),waistML(:,1),'-o',waistCW(:,2),waistCW(:,1),'-*')
% xlabel( 'Position in z' ,'fontsize',28);
% ylabel( 'Half-width','fontsize',28);
% axis auto
% grid on
% set(gca, 'FontSize', 24)
end