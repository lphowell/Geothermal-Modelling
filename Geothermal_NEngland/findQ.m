%% function to determine radiogenic heat production value (Q)
% for the heterogenous 3D temp solver application
% should spit out array so the function only has to be called once...

% z = node reference (depth)
% dx = node spacing (m) - used to determine depth in metres
% gridWidthY - width of array in y-direction
% gridWidthX - width of array in x-direction
% gridHeight - height of array (z-direction)

% call function - output is Radiogenic heat production (RHP) value (Q) (W m^-3)
function Q = findQ(gridWidthY, gridWidthX, gridHeight, dx,...
    surface, top_Granite, top_Basement, base_LBorder, base_MBorder,...
    base_UBorder, base_AlstonFm, base_StainmoreFm,...
    base_CM, base_Permian,q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12)

%% refine geological layers so they are relative to topographic surface

top_Granite = top_Granite - surface;
top_Basement = top_Basement - surface;
base_LBorder = base_LBorder - surface;
base_MBorder = base_MBorder - surface;
base_UBorder = base_UBorder - surface;
base_AlstonFm = base_AlstonFm - surface;
base_StainmoreFm = base_StainmoreFm - surface;
base_CM = base_CM - surface;
base_Permian = base_Permian - surface;

%% initialise Q-value array
Q = zeros(gridWidthY, gridWidthX, gridHeight);

%% run loop to populate Q-value array with values

for y=1:gridWidthY
    for x=1:gridWidthX
        for z=1:gridHeight
            depth = ((z-1) * dx); % convert depth from node reference to metres
            % because all geological layers are relative to the topographic
            % surface, none of the model is cut off...            
            
            % if statement based on depth of horizons to determine the RHP value...
            if depth >= 15000 % determine which rock unit you're in...
                Q(y,x,z) = q1; % and then determine the output RHP value...
                
            elseif depth >= 9000
                Q(y,x,z) = q2;
                
            elseif depth >= top_Granite(y,x)
                Q(y,x,z) = q3;
                
            elseif depth >= top_Basement(y,x)
                Q(y,x,z) = q4;
                
            elseif depth >= base_LBorder(y,x)
                Q(y,x,z) = q5;
                
            elseif depth >= isnan(base_MBorder(y,x))
                Q(y,x,z) = q6;
                
            elseif depth >= base_UBorder(y,x)
                Q(y,x,z) = q7;
                
            elseif depth >= base_AlstonFm(y,x)
                Q(y,x,z) = q8;
                
            elseif depth >= base_StainmoreFm(y,x)
                Q(y,x,z) = q9;
                
            elseif depth >= base_CM(y,x)
                Q(y,x,z) = q10;
                
            elseif depth >= base_Permian(y,x)
                Q(y,x,z) = q11;
                
            else
                Q(y,x,z) = q12;
            end
        end
    end
end
