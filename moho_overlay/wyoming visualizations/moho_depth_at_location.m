clc;
close all;
clear;
workspace;

% IMPORTANT: replace the file path in the line below with your file path of the moho depth data from CRUST 1.0 website 
% .xyz files can be found in the "Files ready for individual download:" section of the website but needs to be converted to a .txt file (just change the name of downloaded file from .xyz to .txt)
A = dlmread('/Users/23brianc/Documents/Internship2020/seismo-sn-lg/old_code/moho_overlay/Wyoming/xyzcoords_moho.txt');

x = A(:,1);
y = A(:,2);
v = A(:,3);

longitude = -113.322;
latitude = 49.051;

mohodepth = 0;

for i = 1:length(x)
    if x(i)<longitude+.5 && x(i)>longitude-.5 && y(i)<latitude+0.5 && y(i)>latitude-.5
        mohodepth = v(i)
    end
    
end

