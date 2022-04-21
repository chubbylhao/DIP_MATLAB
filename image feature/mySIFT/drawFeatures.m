function drawFeatures(img,locs)
%% 在原图上画出SIFT特征点的位置
if size(img,3) == 3
    img = rgb2gray(img);
end
figure;
imshow(img);
hold on;
% locs(:,1)是关键点的行坐标，locs(:,2)是关键点的列坐标
plot(locs(:,2),locs(:,1),'+g');
hold off;
end