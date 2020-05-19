%% function for retrieving vertical thermal conductivity value array
% Author: Louis Howell, Keele University

% kzminus - conductivity between a given temp node and the node directly
% BELOW it

% z = node reference (depth)
% dx = node spacing (m)
% gridWidthY - nodal width of temp model in y-direction
% gridWidthX - nodal width of temp model in x-direction
% gridHeight - nodal height of temp model (z-direction)
% ss = sample spacing between temp nodes

function kzminus = kzminus(gridWidthY, gridWidthX, gridHeight, dx, ss,...
    surface, top_Granite, top_Basement, Base_LBorder, Base_MBorder,...
    Base_UBorder, Base_Alston, Base_Stainmore,...
    Base_CM, Base_Perm, k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13)

%% refine geological layers so they are relative to topographic surface
% surface is assumed to be at sea level

top_Granite = top_Granite - surface;
top_Basement = top_Basement - surface;
Base_LBorder = Base_LBorder - surface;
Base_MBorder = Base_MBorder - surface;
Base_UBorder = Base_UBorder - surface;
Base_Alston = Base_Alston - surface;
Base_Stainmore = Base_Stainmore - surface;
Base_CM = Base_CM - surface;
Base_Perm = Base_Perm - surface;

%% initiate 3D TC value array (kzplus)
kzminus = zeros(gridWidthY,gridWidthX,gridHeight-1);

%% calculate k using harmonic average and populate kz array
for y=1:gridWidthY
    for x=1:gridWidthX
        for z=1:gridHeight-1
            
      % sample k values between adjacent temp nodes
      % calculate harmonic mean
            bottom_Harmonic = 0;
            
            for i=0:(dx/ss)
                
      % calculate depth based on z-loop (temp nodes) and i-loop (ss)
                depth = ((z-1)*dx) + (i*ss);
                
      % sample k values between adjacent temp nodes             
                if depth >= 9000
                    k = k2-((k2-k1)/21000*(depth-9000));
                elseif depth >= top_Granite(y,x)
                    k = k3; 
                elseif depth >= top_Basement(y,x)
                    k = k4;
                elseif depth >= Base_LBorder(y,x)
                    k = k5;
                elseif depth >= Base_MBorder(y,x)
                    k = k6;
                elseif depth >= Base_UBorder(y,x)
                    k = k7;
                elseif depth >= Base_Alston(y,x)
                    k = k8;
                elseif depth >= Base_Stainmore(y,x)
                    k = k9;
                elseif depth >= Base_CM(y,x)
                    k = k10;
                elseif depth >= Base_Perm(y,x)
                    k = k11;
                else
                    k = k12;
                end
                
                if depth <=50
                     k = k13; 
                else
                end
                
    % populate bottom half of harmonic mean fraction            
                bottom_Harmonic = bottom_Harmonic + (1/k);
            end
    
    % calculate harmonic mean
             kzminus(y,x,z) = ((dx/ss)+1)/bottom_Harmonic;
        end
    end
end
