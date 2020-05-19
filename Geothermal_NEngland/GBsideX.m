%% function for the FD method along the side of a 3D temp grid
% ghost boundary method - adjacent node in X direction are referred
% to twice

% xminus = temp of adjacent node along the x-axis (+ / -)
% yminus = temp of adjacent node along the y-axis
% yplus = temp of adjacent node along the y-axis
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

function temp = GBsideX(xminus, yminus, yplus, zminus, zplus, dx, Q, kxminus,...
    kyminus, kyplus, kzminus, kzplus)

temp = (Q*dx*dx + kxminus*xminus+kxminus*xminus + kyminus*yminus+kyplus*yplus...
    + kzminus*zminus + kzplus*zplus)/...
    (kxminus+kxminus + kyminus+kyplus + kzminus+kzplus);

end