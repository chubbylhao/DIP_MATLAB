close all;clear;clc;
figure("Name","待处理的原图像");
for k = 1:6
    temp = imread("Fig1138("+string(k)+").tif");
    if size(temp,3) == 3
        temp = rgb2gray(temp);
    end
    img(:,:,k) = double(temp);
    subplot(2,3,k),imshow(img(:,:,k),[]);
end
[r, c, d] = size(img);
for i = 1:r
    for j = 1:c
        x(:,(i-1)*c+j) = img(i,j,:);
    end
end
x_aver = sum(x,2)/size(x,2);
x_cent = x - x_aver*ones(1,r*c);
Cx = x_cent*x_cent'/(d-1);
[U, D] = eig(Cx);
[m, n] = size(D);
seq = sort(D(D~=0),"descend");
D_max = eye(m,n).*(seq*ones(1,n));
for k = 1:n
    [~, o_y] = find(D==seq(k));
    U_max(:,k) = U(:,o_y);
end
y = U_max'*x_cent;
figure("Name","变换后的图像");
for k = 1:6
    res(:,:,k) = reshape(y(k,:),[r,c])';
    subplot(2,3,k),imshow(res(:,:,k),[]);
end
t1 = 1; t2 = 5;
x_rebuild = U_max(:,t1:t2)*y(t1:t2,:) + x_aver*ones(1,r*c);
figure("Name","重建后的图像");
for k = 1:6
    rebuild(:,:,k) = reshape(x_rebuild(k,:),[c,r])';
    subplot(2,3,k),imshow(rebuild(:,:,k),[]);
end
figure("Name","原图与重建图像的差");
for k = 1:6
    minus(:,:,k) = img(:,:,k) - rebuild(:,:,k);
    subplot(2,3,k),imshow(minus(:,:,k),[]);
end
max(minus(:))