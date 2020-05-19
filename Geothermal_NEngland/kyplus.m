%% function for retrieving lateral thermal conductivity value array (y-direction)
% Author: Louis Howell, Keele University

% kyplus - conductivity between a given temp node and the adjacent node to
% the east

% z = node reference (depth)
% dx = node spacing (m)
% gridWidthY - nodal width of temp model in y-direction
% gridWidthX - nodal width of temp model in x-direction
% gridHeight - nodal height of temp model (z-direction)
% ss = sample spacing between temp nodes

function kyplus = kyplus(gridWidthY, gridWidthX, gridHeight, dx, ss,...
    surface, top_Granite, top_Basement, Base_LBorder, Base_MBorder,...
    Base_UBorder, Base_Alston, Base_Stainmore,...
    Base_CM, Base_Perm, k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12)

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

%% initiate 3D TC value array (kyplus)
kyplus = zeros(gridWidthY-1,gridWidthX,gridHeight);

%% calculate k using harmonic average and populate kyplus array
for y=1:gridWidthY-1
    for x=1:gridWidthX
        
    % Interpolate geological boundaries (surfaces) in between temp nodes in y-direction
        surface1 = NaN((dx/ss)+1,1);
        for i=0:dx/ss
            surface1(i+1) = top_Granite(y,x) + (i*ss) * ((top_Granite(y+1,x)...
                - top_Granite(y,x))/dx);
        end
        
        surface2 = NaN((dx/ss)+1,1);
        for i=0:dx/ss
            surface2(i+1) = top_Basement(y,x) + (i*ss) * ((top_Basement(y+1,x)...
                - top_Basement(y,x))/dx);
        end
        
        surface3 = NaN((dx/ss)+1,1);
        for i=0:dx/ss
            surface3(i+1) = Base_LBorder(y,x) + (i*ss) * ((Base_LBorder(y+1,x)...
                - Base_LBorder(y,x))/dx);
        end
        
        surface4 = NaN((dx/ss)+1,1);
        for i=0:dx/ss
            surface4(i+1) = Base_MBorder(y,x) + (i*ss) * ((Base_MBorder(y+1,x)...
                - Base_MBorder(y,x))/dx);
        end
        
        surface5 = NaN((dx/ss)+1,1);
        for i=0:dx/ss
            surface5(i+1) = Base_UBorder(y,x) + (i*ss) * ((Base_UBorder(y+1,x)...
                - Base_UBorder(y,x))/dx);
        end
        
        surface6 = NaN((dx/ss)+1,1);
        for i=0:dx/ss
            surface6(i+1) = Base_Alston(y,x) + (i*ss) * ((Base_Alston(y+1,x)...
                - Base_Alston(y,x))/dx);
        end
        
        surface7 = NaN((dx/ss)+1,1);
        for i=0:dx/ss
            surface7(i+1) = Base_Stainmore(y,x) + (i*ss) * ((Base_Stainmore(y+1,x)...
                - Base_Stainmore(y,x))/dx);
        end
        
        surface8 = NaN((dx/ss)+1,1);
        for i=0:dx/ss
            surface8(i+1) = Base_CM(y,x) + (i*ss) * ((Base_CM(y+1,x)...
                - Base_CM(y,x))/dx);
        end
        
        surface9 = NaN((dx/ss)+1,1);
        for i=0:dx/ss
            surface9(i+1) = Base_Perm(y,x) + (i*ss) * ((Base_Perm(y+1,x)...
                - Base_Perm(y,x))/dx);
        end      
        
        
        for z=2:gridHeight-1
            
      % calculate depth based on z-loop (temp nodes) and i-loop (ss)
            depth = (z-1) * dx;
            
      % sample k values between adjacent temp nodes
      % calculate harmonic mean
            bottom_Harmonic = 0;
            
                for i=1:(dx/ss) + 1
                
      % sample k values between adjacent temp nodes   
                if depth >= 9000
                    k = k2-((k2-k1)/21000*(depth-9000));
                elseif depth >= surface1(i)
                    k = k3;                 
                elseif depth >= surface2(i)
                    k = k4;
                elseif depth >= surface3(i)
                    k = k5;
                elseif depth >= surface4(i)
                    k = k6;
                elseif depth >= surface5(i)
                    k = k7;
                elseif depth >= surface6(i)
                    k = k8;
                elseif depth >= surface7(i)
                    k = k9;
                elseif depth >= surface8(i)
                    k = k10;
                elseif depth >= surface9(i)
                    k = k11; 
                else
                    k = k12;
                end
                
    % populate bottom half of harmonic mean fraction   
                bottom_Harmonic = bottom_Harmonic + (1/k);
                end
                
    % calculate harmonic mean
            kyplus(y,x,z) = ((dx/ss)+1)/bottom_Harmonic;
        end
    end
end