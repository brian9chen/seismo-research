clc;
close all;
clear;
workspace;

% IMPORTANT: replace the file path in the line below with your file path of the moho depth data from CRUST 1.0 website 
% .xyz files can be found in the "Files ready for individual download:" section of the website but needs to be converted to a .txt file (just change the name of downloaded file from .xyz to .txt)
A = dlmread('/Users/23brianc/Documents/Internship2020/Code/moho_overlay/Wyoming/xyzcoords_moho.txt');

x = A(:,1);
y = A(:,2);
v = A(:,3);

toDelete = true(length(x), 1);

% IMPORTANT: change longitude/latitude ranges to the region you want to plot
longitude_min = -125;
longitude_max = -95;
latitude_min = 32;
latitude_max = 50;

for i = 1:length(x)
    if x(i)>longitude_min && x(i)<longitude_max && y(i)>latitude_min && y(i)<latitude_max
        toDelete(i) = false;
    end
    
end

x(toDelete, :) = [];
y(toDelete, :) = [];
v(toDelete, :) = [];


[xx, yy] = meshgrid(min(x):0.25:max(x), min(y):0.25:max(y));

vv = griddata(x, y, v, xx, yy, 'cubic');

figure;

% use "surf(xx, yy, vv)" instead of contourf if you just want a surface plot without contour lines
contourf(xx, yy, vv, 20);
c = colorbar;
c.Label.String = 'Depth to Moho (km)';
caxis([-45, -25]);
shading interp;
hold on;
% plot3(x, y, z, 'ro');
grid on;
xlabel('Longitude');
ylabel('Latitude');
% ydir = 'reverse';
zlabel(gca, 'Depth');

% to get a 2d moho map instead of a 3d one, rotate the figure so you are viewing from the top, then take a screen capture.