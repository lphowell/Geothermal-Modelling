%% Generate figures

%% load 3D temp model
load 'tg.mat';

%% 1 km depth temp plot
figure
imagesc(tg(:,:,3));
set(gca,'Ydir','normal')
xlim([20 271])
ylim([20 181])
set(gca,'XTick',[0 50 100 150 200 250] );
set(gca,'XTickLabel',[300 325 350 375 400 425] );
set(gca,'YTick',[0 50 100 150 200] );
set(gca,'YTickLabel',[500 525 550 575 600] );
colormap(jet);
title('Temperature at 1 km depth');
xlabel('Easting (km)');
ylabel('Northing (km)');
grid on
pbaspect([250 160 1])

%% 5 km depth temp plot
figure 
imagesc(tg(:,:,11));
colormap(jet);
xlim([20 271])
ylim([20 181])
set(gca,'XTick',[0 50 100 150 200 250] );
set(gca,'XTickLabel',[300 325 350 375 400 425] );
set(gca,'YTick',[0 50 100 150 200] );
set(gca,'YTickLabel',[500 525 550 575 600] );
title('Temperature at 5 km depth');
xlabel('Easting (km)');
ylabel('Northing (km)');
set(gca,'Ydir','normal')
grid on
pbaspect([250 160 1])

%% 7 km depth temp plot
figure 
imagesc(tg(:,:,15));
colormap(jet);
xlim([20 271])
ylim([20 181])
set(gca,'XTick',[0 50 100 150 200 250] );
set(gca,'XTickLabel',[300 325 350 375 400 425] );
set(gca,'YTick',[0 50 100 150 200] );
set(gca,'YTickLabel',[500 525 550 575 600] );
title('Temperature at 7 km depth');
xlabel('Easting (km)');
ylabel('Northing (km)');
set(gca,'Ydir','normal')
grid on
pbaspect([250 160 1])

%% x-section 1 - Lake District, Vale of Eden, Alston Block
% initiate 2D array for x-section (only down to 10 km depth)
xsection1 = zeros(21,291);

% pass values from 3D array to a 2D array.
for z=1:21
    for x=1:291
        xsection1(z,x) = tg(70,x,z);
    end
end

% interpolate 2D cross-section - improve resolution.
Vxsection1 = interp2(xsection1,5, 'cubic');

% plot x-section
figure
imagesc(Vxsection1(:,:));
colormap(jet);
title('X-section: Lake District, Vale of Eden and Alston Block');
xlabel('distance km/2');
ylabel('Depth km/2');

%% x-section 2 - Solway syncline
figure
% initiate 2D array for x-section
xsection2 = zeros(21,120);

% pass values from 3D temp array to 2D array
for z=1:21
    for x=1:120
        xsection2(z,x) = tg(120,x,z);
    end
end

% interpolate 2D cross-section - improve resolution.
Vxsection2 = interp2(xsection2,5, 'cubic');

% plot x-section
imagesc(Vxsection2(:,:));
colormap(jet);
title('X-section: Solway syncline');
xlabel('distance km/2');
ylabel('Depth km/2');

%% generate depth to 100 C isotherm map
figure
% define 2D array geomteries
gridWidthY = 201;
gridWidthX = 291;

depth = linspace(0,30,61);
% initiates 1D depth array in metres

iso_100 = zeros(201,291);
% initiate isotherm depth array (100 C)

temp = zeros(61,1);
% initiates a 1D geotherm which will recieve the value at each point (x,y)
% in the 3D temp grid and be interpolated to find the depth at which the
% lines intercepts 100 C.

for y=1:gridWidthY
    for x=1:gridWidthX
        
        % repopulate geotherm array for each x,y point
        for z=1:61
            temp(z,1) = tg(y,x,z);
        end
        
        iso_100(y,x) = interp1(temp,depth,100);
    end
end

% imagesc(iso_100(:,:));
surf(iso_100(:,:));
s.EdgeColor = 'none';
xlim([20 271])
ylim([20 181])
colormap(flipud(jet));
set(gca,'XTick',[0 50 100 150 200 250] );
set(gca,'XTickLabel',[300 325 350 375 400 425] );
set(gca,'YTick',[0 50 100 150 200] );
set(gca,'YTickLabel',[500 525 550 575 600] );
title('Depth to 100 ^oC isotherm');
xlabel('Easting (km)');
ylabel('Northing (km)');
zlabel('Depth (km)')
set(gca,'Ydir','normal')
set(gca,'Zdir','reverse')
pbaspect([250 160 50])
grid on

%% generate heat flow map
figure

load 'kz.mat';
hf = zeros(201,291);

for x=1:291
    for y=1:201
        hf(y,x) = kz(y,x,1)*1000*(tg(y,x,2)-tg(y,x,1))/500;
    end
end

imagesc(hf(:,:));
xlim([20 271])
ylim([20 181])
set(gca,'XTick',[0 50 100 150 200 250] );
set(gca,'XTickLabel',[300 325 350 375 400 425] );
set(gca,'YTick',[0 50 100 150 200] );
set(gca,'YTickLabel',[500 525 550 575 600] );
title('Predicted heat flow');
xlabel('Easting (km)');
ylabel('Northing (km)');
set(gca,'Ydir','normal')
grid on
pbaspect([250 160 1])