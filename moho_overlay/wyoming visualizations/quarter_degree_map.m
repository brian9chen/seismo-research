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


x = -1*(360-x);
v = v*-1;

[xx, yy] = meshgrid(min(x):0.25:max(x), min(y):0.25:max(y));

vv = griddata(x, y, v, xx, yy, 'cubic');

% markerSizes = round(-1*v);

figure;
surf(xx, yy, vv)
% contourf(xx, yy, vv, 20);
c = colormap;
c1 = colorbar;
% colormap (flipud(c));
c1.Label.String = 'Depth to Moho (km)';
% set(c1, 'ylim', [-45 -25])
shading interp;
hold on;
%plot3(x, y, z, 'ro');
grid on;
xlabel('Longitude');
ylabel('Latitude');
% ydir = 'reverse';
zlabel(gca, 'Depth');
