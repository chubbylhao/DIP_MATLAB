function Phi = Hu(I)
I = double(I);
[row,col] = size(I);

%% 0阶矩和1阶矩
weights1 = [1:row];
weights2 = [1:col];
sum1 = sum(I);
sum2 = sum(I,2);
% 0阶矩，图像的“总质量”
m00 = sum(I(:));
% 1阶矩，x、y方向的“加权质量”
m01 = sum1*weights2';
m10 = weights1*sum2;
% 图像的“质心坐标”
cenx = m10/m00;
ceny = m01/m00;

%% 2阶矩和3阶矩
Mu00 = m00;
diffx = weights1-cenx;
diffy = weights2-ceny;
% 2阶中心矩
Mu02 = sum1*diffy.^2';
Mu20 = diffx.^2*sum2;
Mu11 = sum(diffx'*diffy.*I,'All');
% 3阶中心矩
Mu03 = sum1*diffy.^3';
Mu30 = diffx.^3*sum2;
Mu12 = sum(diffx'*diffy.^2.*I,'All');
Mu21 = sum(diffx.^2'*diffy.*I,'All');

%% （2阶和3阶）归一化中心矩
Eta02 = Mu02/Mu00^2;
Eta20 = Mu20/Mu00^2;
Eta11 = Mu11/Mu00^2;
Eta03 = Mu03/Mu00^2.5;
Eta30 = Mu30/Mu00^2.5;
Eta12 = Mu12/Mu00^2.5;
Eta21 = Mu21/Mu00^2.5;

%% 一组7个二维矩不变量
Phi1 = Eta20+Eta02;
Phi2 = (Eta20-Eta02)^2+4*Eta11^2;
Phi3 = (Eta30-3*Eta12)^2+(3*Eta21-Eta03)^2;
Phi4 = (Eta30+Eta12)^2+(Eta21+Eta03)^2;
Phi5 = (Eta30-3*Eta12)*(Eta30+Eta12)*((Eta30+Eta12)^2-3*(Eta21+Eta03)^2)+...
    (3*Eta21-Eta03)*(Eta21+Eta03)*(3*(Eta30+Eta12)^2-(Eta21+Eta03)^2);
Phi6 = (Eta20-Eta02)*((Eta30+Eta12)^2-(Eta21+Eta03)^2)+...
    4*Eta11*(Eta30+Eta12)*(Eta21+Eta03);
Phi7 = (3*Eta21-Eta03)*(Eta30+Eta12)*((Eta30+Eta12)^2-3*(Eta21+Eta03)^2)+...
    (3*Eta12-Eta30)*(Eta21+Eta03)*(3*(Eta30+Eta12)^2-(Eta21+Eta03)^2);
Phi = [Phi1;Phi2;Phi3;Phi4;Phi5;Phi6;Phi7];
end