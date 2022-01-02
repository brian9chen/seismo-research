clc;
close all;
clear;
workspace;


A = dlmread('/Users/23brianc/Documents/Internship2020/seismo-sn-lg/old_code/moho_overlay/Wyoming/xyzcoords_moho.txt');

x = A(:,1);
y = A(:,2);
v = A(:,3);

% toDelete = true(length(x), 1);
% 
% for i = 1:length(x)
%     if x(i)>-125 && x(i)<-95 && y(i)>32 && y(i)<50
%         toDelete(i) = false;
%     end
%     
% end
% 
% x(toDelete, :) = [];
% y(toDelete, :) = [];
% v(toDelete, :) = [];


point1_x = -109.128;
point1_y = 42.975;

point2_x = -123;
point2_y = 42;

slope = (point1_y-point2_y)/(point1_x-point2_x);
a = point1_y - slope*point1_x;

moho_cross = [];

counter = 0;

% new_v = zeros(14, 50);
new_v = [];



for i = 1:length(x)
    if x(i)>point2_x && x(i)<point1_x && y(i)>point2_y && y(i)<point1_y
        
        if y(i)-slope*x(i)<a+1 && y(i)-slope*x(i)>a-1
            
            depth = -1*round(v(i));
            
            if depth >= 50
                depth = 49;
            end
            
            temp = (0:1:depth);
            
            zero = zeros(1,50-depth-1);
            
            temp = [temp zero];
            
            new_v(:,end+1) = temp;
            
            counter = counter + 1;
            
            
        end
        
    end
    
end


% length(x)
% length(y)
% length(new_v)

[xx, yy] = meshgrid(1:1:counter,1:1:50);
% 
% vv = griddata(x, y, new_v, xx, yy, 'cubic');

figure;
% surf(xx, yy, new_v);
contourf(xx, yy, new_v, 20);

ax = gca;

ax.CLim = [0 50];

c = colorbar;
% c.set_clim(20 , 0);
c.Label.String = 'Depth to Moho (km)';
caxis([0, 50]);
shading interp;
hold on;
%plot3(x, y, z, 'ro');
grid on;
xlabel('Longitude');
ylabel('Latitude');
% % ydir = 'reverse';
zlabel(gca, 'Depth');
