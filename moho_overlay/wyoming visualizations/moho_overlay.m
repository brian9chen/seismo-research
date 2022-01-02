clc;
close all;
clear;
workspace;

raypath = imread('/Users/23brianc/Documents/Internship2020/Code/moho_overlay/Wyoming/raypath.png');
moho = imread('/Users/23brianc/Documents/Internship2020/Code/moho_overlay/Wyoming/moho.png');

CompositeImage = raypath;
FirstRow = 880;
FirstColumn = 150;
CompositeImage(FirstRow : FirstRow + size(moho,1) - 1, FirstColumn : FirstColumn + size(moho,2) - 1) = moho;