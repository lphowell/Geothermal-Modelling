%% Temp_solver for 3D Geothermal model
% Louis Howell, Keele University
clear

%% load 3D geological model with thermal properties
% Radiogenic heat production values
load 'Q.mat';
% Conductivity values for x,y and z axes
load 'kx.mat';
load 'ky.mat';
load 'kz.mat';

%% load prior temp grid to reduce convergence time
load 'tg.mat';

%% determine model parameters
dx = 500; % node spacing (m)
gridHeight = 61; % height of section (dx * (gridHeight-1) = actual grid height)
gridWidthX = 291; % width of section (x-axis)
gridWidthY = 201; % width of section (y-axis)
UpperB = 10; % temp at upper boundary (*C)
LowerB = 655.6; % lower boundary - approximate temp at Moho - calculated earlier... (655.6)
ni = 2000; % number of iterations

%% initialise 3D temp grid and set upper/lower boundary conditions
tg(1:gridWidthY, 1:gridWidthX, 1) = UpperB;
tg(1:gridWidthY, 1:gridWidthX, end) = LowerB;

%% Calculate temperature
% FD method, steady-state..
% (y, x, z)

% loop for total number of iterations per node
for iter=1:ni
    % loop for shifting through y-values
    for y=1:gridWidthY
        % loop for shifting through x-values
        for x=1:gridWidthX
            
    % FD method for corners of temp grid
            if x==1 && y==1
                for z=2:gridHeight-1
                    tg(y, x, z) = GBcorner(tg(y, x+1, z), tg(y+1, x, z),...
                        tg(y, x, z-1), tg(y, x, z+1), dx, Q(y,x,z), kx(y,x,z),...
                        ky(y,x,z), kz(y,x,z-1), kz(y,x,z));
                end
                
            elseif x==1 && y==gridWidthY
                for z=2:gridHeight-1
                    tg(y, x, z) = GBcorner(tg(y, x+1, z), tg(y-1, x, z),...
                        tg(y, x, z-1), tg(y, x, z+1), dx, Q(y,x,z), kx(y,x,z),...
                        ky(y-1,x,z), kz(y,x,z-1), kz(y,x,z));
                end
                
            elseif x==gridWidthX && y==1
                for z=2:gridHeight-1
                    tg(y, x, z) = GBcorner(tg(y, x-1, z), tg(y+1, x, z),...
                        tg(y, x, z-1), tg(y, x, z+1), dx, Q(y,x,z), kx(y,x-1,z),...
                        ky(y,x,z), kz(y,x,z-1), kz(y,x,z));
                end
                
            elseif x==gridWidthX && y==gridWidthY
                for z=2:gridHeight-1
                    tg(y, x, z) = GBcorner(tg(y, x-1, z), tg(y-1, x, z),...
                        tg(y, x, z-1), tg(y, x, z+1), dx, Q(y,x,z), kx(y,x-1,z),...
                        ky(y-1,x,z), kz(y,x,z-1), kz(y,x,z));
                end
                
    % FD method for lateral margins of temp grid   
            elseif x==1
                for z=2:gridHeight-1
                    tg(y, x, z) = GBsideX(tg(y, x+1, z), tg(y-1, x, z), tg(y+1, x, z),...
                        tg(y, x, z+1), tg(y, x, z-1), dx, Q(y,x,z), kx(y,x,z),...
                        ky(y-1,x,z), ky(y,x,z),...
                        kz(y,x,z-1), kz(y,x,z));
                end
                
            elseif x==gridWidthX
                for z=2:gridHeight-1
                    tg(y, x, z) = GBsideX(tg(y, x-1, z), tg(y-1, x, z), tg(y+1, x, z),...
                        tg(y, x, z+1), tg(y, x, z-1), dx, Q(y,x,z),...
                        kx(y,x-1,z), ky(y-1,x,z), ky(y,x,z),...
                        kz(y,x,z-1), kz(y,x,z));
                end
                
            elseif y==1
                for z=2:gridHeight-1
                    tg(y, x, z) = GBsideY(tg(y, x-1, z), tg(y, x+1, z),...
                        tg(y+1, x, z), tg(y, x, z-1), tg(y, x, z+1), dx, Q(y,x,z),...
                        kx(y,x-1,z),...
                        kx(y,x,z), ky(y,x,z),...
                        kz(y,x,z-1), kz(y,x,z));
                end
                
            elseif y==gridWidthY
                for z=2:gridHeight-1
                    tg(y, x, z) = GBsideY(tg(y, x-1, z), tg(y, x+1, z),...
                        tg(y-1, x, z), tg(y, x, z-1), tg(y, x, z+1), dx,...
                        Q(y,x,z), kx(y,x-1,z),...
                        kx(y,x,z), ky(y-1,x,z),...
                        kz(y,x,z-1), kz(y,x,z));
                end
            
     % FD method for model centre
            else
                for z=2:gridHeight-1
                    tg(y, x, z) = FDmethod(tg(y, x-1, z), tg(y, x+1, z),...
                        tg(y-1, x, z), tg(y+1, x, z), tg(y, x, z-1),...
                        tg(y, x, z+1), dx, Q(y,x,z), kx(y,x-1,z),...
                        kx(y,x,z), ky(y-1,x,z), ky(y,x,z),...
                        kz(y,x,z-1), kz( y,x,z));
                end
            end
        end
    end
end

%% save temperature model
save('tg.mat','tg')
% overwrites prior model
