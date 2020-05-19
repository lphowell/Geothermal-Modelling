%% Generate thermal property matrices from geological models
% Louis Howell, Keele University
clear

%% Model parameters
dx = 500; % node spacing (m)
ss = 10; % sampling spacing for thermal property calculation (m)
gridHeight = 61; % height of section (dx * (gridHeight-1) = actual grid height)
gridWidthX = 291; % width of section (x-axis)
gridWidthY = 201; % width of section (y-axis)

%% load geological model
% depth map for northern England study area with 500 m point spacing
% Terrington and Thorpe (2013); based on Chadwick et al (1995).
% Granite thickness - Kimbell et al (2006) >> assuming flat base granite @
% 9 km depth.
load surface.txt;
load top_Granite.txt;
load top_Basement.txt;
load Base_UBorder.txt;
load Base_Stainmore.txt;
load Base_Perm.txt;
load Base_MBorder.txt;
load Base_LBorder.txt;
load Base_CM.txt;
load Base_Alston.txt;

%% define thermal properties for geological layers (Thermal conductivity - W m^-1 K^-1)
k1 = 2.2; % lower crust
k2 = 3.1; % middle crust
k3 = 3.1; % Granite
k4 = 2.87; % Caledonian basement
k5 = 2.92; % Ballagan Formation
k6 = 2.7; % Lyne Formation
k7 = 2.6; % Fell Sandstone Formation
k8 = 2.7; % Tyne Limestone Formation
k9 = 2.5; % Alston Formation
k10 = 2.38; % Stainmore Formation
k11 = 1.9; % Coal Measures Group
k12 = 2.5; % Base Permian
k13 = 2.1; % soil (top 50 m)

%% define thermal properties (Radiogenic heat production - W m^-3)
q1 = 0.1e-06; % Lower-crust
q2 = 1.5e-06; % Middle-crust
q3 = 4.1e-06; % Granite (Manning et al, 2007)
q4 = 1.49e-06; % Caledonian basement
q5 = 0.85e-06; % Basement beds (anything below the Lower Border Gp)
q6 = 0.85e-06; % Lower Border Gp
q7 = 0.85e-06; % Middle Border Gp
q8 = 0.85e-06; % Upper Border Gp
q9 = 0.88e-06; % Alston Fm
q10 = 0.88e-06; % Stainmore Fm
q11 = 0.92e-06; % Coal Measures
q12 = 1.0e-06; % Base Permian (Bayer et al. 1997)

%% initialise and assign values to Radiogenic heat production (RHP) array
% RHP for different rock layers within the findQ() function...
Q = findQ(gridWidthY, gridWidthX, gridHeight, dx, surface,...
    top_Granite, top_Basement, Base_LBorder, Base_MBorder,...
    Base_UBorder, Base_Alston, Base_Stainmore,...
    Base_CM, Base_Perm,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12);

%% initialise and assign values for conductivity (k) tensor arrays
kz = kzminus(gridWidthY, gridWidthX, gridHeight, dx, ss,...
    surface, top_Granite, top_Basement, Base_LBorder, Base_MBorder,...
    Base_UBorder, Base_Alston, Base_Stainmore,...
    Base_CM, Base_Perm, k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13);

ky = kyplus(gridWidthY, gridWidthX, gridHeight, dx, ss,...
    surface, top_Granite, top_Basement, Base_LBorder, Base_MBorder,...
    Base_UBorder, Base_Alston, Base_Stainmore,...
    Base_CM, Base_Perm, k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12);

kx = kxplus(gridWidthY, gridWidthX, gridHeight, dx, ss,...
    surface, top_Granite, top_Basement, Base_LBorder, Base_MBorder,...
    Base_UBorder, Base_Alston, Base_Stainmore,...
    Base_CM, Base_Perm, k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12);

%% save thermal property matrices
save('Q.mat','Q');
save('kz.mat','kz');
save('ky.mat','ky');
save('kx.mat','kx');