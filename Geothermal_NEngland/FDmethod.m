%% function for the FD method - interior

% xminus = temp of adjacent node along the x-axis
% xplus = temp of adjacent node along the x-axis
% yminus = temp of adjacent node along the y-axis
% yminus = temp of adjacent node along the y-axis
% zminus = temp of adjacent node along z-axis (below)
% zplus = temp of adjacent node along z-axis (above)
% dx = node spacing
% Q = radiogenic heat production
% kxminus = conductivity in the x-direction towards x=0
% kxplus = conductivity in the x-direction towards x=infinity
% kyminus = conductivity in the y-direction towards x=0
% kyplus = conductivity in the y-direction towards x=infinity
% kzminus = conductivity in the z-direction towards x=0
% kzplus = conductivity in the z-direction towards x=infinity

function temp = FDmethod(xminus, xplus, yminus, yplus, zminus, zplus, dx, Q,...
    kxminus, kxplus, kyminus, kyplus, kzminus, kzplus)

temp = (Q*dx*dx + kxminus*xminus+kxplus*xplus + kyminus*yminus+kyplus*yplus...
    + kzminus*zminus + kzplus*zplus)/...
    (kxminus+kxplus + kyminus+kyplus + kzminus+kzplus);

end