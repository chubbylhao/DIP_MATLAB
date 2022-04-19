close all;clear;clc;
I1 = imread('painting_original_padded.tif');
I2 = imread('painting_halfsize_padded.tif');
I3 = imread('painting_mirrored_padded.tif');
I4 = imread('painting_rot45deg.tif');
I5 = imread('painting_rot90deg_padded.tif');
I6 = imread('painting_translated_padded.tif');
Phi1 = log10(Hu(I1));
Phi2 = log10(Hu(I2));
Phi3 = log10(Hu(I3));
Phi4 = log10(Hu(I4));
Phi5 = log10(Hu(I5));
Phi6 = log10(Hu(I6));
Phi = [Phi1,Phi2,Phi3,Phi4,Phi5,Phi6];

%%
close all;clear;clc;
J = imread('fingerprint.tif');
Phij = log10(Hu(J));
J1 = imresize(J,0.5);
J1 = padarray(J1,[240,200]);
Phij2 = log10(Hu(J1));
res = [Phij,Phij2];
imshowpair(J,J1,'montage');