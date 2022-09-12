close all;clear;clc;

% img = double(rgb2gray(imread("peppers.png")));
% img = imresize(img,0.3);
% imshow(img,[]);
% A = fft2(img);
img = zeros(8,8);
[m,n] = size(img);
x = zeros(m,n);
y = zeros(m,n);
M = zeros(m);
N = zeros(n);
for i = 1:m
    for j = 1:m
%         M(i,j) = exp(-1i*2*pi*(i-1)*(j-1)/m);     % DFT变换
%         M(i,j) = 1/sqrt(m)*(cos(2*pi*(i-1)*(j-1)/m)+sin(2*pi*(i-1)*(j-1)/m));   % DHT变换
%         % DCT变换
%         if (i-1)==0
%             M(i,j) = 1/sqrt(m);
%         else
%             M(i,j) = sqrt(2/m)*cos((2*(j-1)+1)*(i-1)*pi/(2*m));
%         end
        % DST变换
        M(i,j) = sqrt(2/(m+1))*sin(i*j*pi/(m+1));
    end
end
for i = 1:n
    for j = 1:n
%         N(i,j) = exp(-1i*2*pi*(i-1)*(j-1)/n);
%         N(i,j) = 1/sqrt(n)*(cos(2*pi*(i-1)*(j-1)/n)+sin(2*pi*(i-1)*(j-1)/n));
% DCT变换
%         if (i-1)==0
%             N(i,j) = 1/sqrt(n);
%         else
%             N(i,j) = sqrt(2/n)*cos((2*(j-1)+1)*(i-1)*pi/(2*n));
%         end
        % DST变换
        N(i,j) = sqrt(2/(n+1))*sin(i*j*pi/(n+1));
    end
end

% M = eye(m);
% N = eye(n);

figure;
for i = 1:m
    for j = 1:n
        x = M(:,i)*N(j,:);
        subplot(m,n,(i-1)*n+j),imshow(real(x),[]);
    end
end
figure;
for i = 1:m
    for j = 1:n
        x = M(:,i)*N(j,:);
        subplot(m,n,(i-1)*n+j),imshow(imag(x),[]);
    end
end

% for i = 1:m
%     for j = 1:n
%         y = A(i,j)*(M(:,i)*N(j,:)) + y;
%     end
% end
% figure;
% imshow(real(y),[]);