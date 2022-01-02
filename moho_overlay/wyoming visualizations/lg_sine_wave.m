clc;
close all;
clear;
workspace;

% Define a time axis:
t = 0 : 0.1 : 20;
% Define the period
period = 3;
% Make a function for how the amplitude varies with time:
% For example the amplitude is the square root of time, 
% or whatever formula you want to use.
amplitude = sqrt(t);
% Now make the sine wave
y = amplitude .* sin(2 * pi * t / period);
plot(t, y, 'Color', '#00ffff', 'Linewidth', 5);