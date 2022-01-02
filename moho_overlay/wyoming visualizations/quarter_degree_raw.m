clc;
close all;
clear;
workspace;


A = dlmread('/Users/23brianc/Documents/Internship2020/seismo-sn-lg/old_code/moho_overlay/Wyoming/ShenWeisen.txt');

x = A(:,1);
y = A(:,2);
v = A(:,3);

toDelete = true(length(x), 1);

lon_min=360-122;
lon_max=360-101.9;
lat_min=42.5;
lat_max=55.1;

for i = 1:length(x)
    if x(i)>=lon_min && x(i)<=lon_max && y(i)>=lat_min && y(i)<=lat_max
        toDelete(i) = false;
%         disp('HI!')
    end
    
end

x(toDelete, :) = [];
y(toDelete, :) = [];
v(toDelete, :) = [];



% [xx, yy] = meshgrid(min(x):0.25:max(x), min(y):0.25:max(y));

% vv = griddata(x, y, v, xx, yy, 'cubic');

markerSizes = round(-1*v);

figure;

scatter(x, y, 35, markerSizes,'filled');

% use "surf(xx, yy, vv)" instead of contourf if you just want a surface plot without contour lines
c = colormap;
c1 = colorbar;
c1.Label.String = 'Depth to Moho (km)';
% caxis([-45, -25]);
colormap (flipud(c));
shading interp;
hold on;
% plot3(x, y, z, 'ro');
grid on;
xlabel('Longitude');
ylabel('Latitude');
% ydir = 'reverse';
zlabel(gca, 'Depth');
