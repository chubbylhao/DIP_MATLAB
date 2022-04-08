close all; clear; clc;

%% 一幅高分辨率的灰度图像+一幅低分辨率的彩色图像
PAN = imread('PAN.jpg');
MS = imread('MS.jpg');
R = MS(:,:,1); G = MS(:,:,2); B = MS(:,:,3);

%% IHS变换
I = PAN;
V1 = (2*B-R-G)*sqrt(2)/6;
V2 = (R-G)/sqrt(2);

%% 逆IHS变换
RN = I + (V2-V1)/sqrt(2);
GN = I - (V1+V2)/sqrt(2);
BN = I + sqrt(2)*V1;
IM_IHS(:,:,1) = RN; IM_IHS(:,:,2) = GN; IM_IHS(:,:,3) = BN;
% figure; imshow(IM_IHS,[]);

%% Brovey变换
RNN = R./(R+G+B).*PAN;
GNN = G./(R+G+B).*PAN;
BNN = B./(R+G+B).*PAN;
IM_Brovey(:,:,1) = RNN; IM_Brovey(:,:,2) = GNN; IM_Brovey(:,:,3) = BNN;
% figure; imshow(IM_Brovey,[]);

%% 观察
figure;
subplot(221),imshow(MS,[]),title('低分辨率多光谱图像');
subplot(222),imshow(PAN,[]),title('高分辨率全色图像');
subplot(223),imshow(IM_IHS,[]),title('使用IHS法融合的图像');
subplot(224),imshow(IM_Brovey,[]),title('使用Brovey法融合的图像');