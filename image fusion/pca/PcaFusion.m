function [res,pcaWeightCoef] = PcaFusion(I1,I2)
%% 函数功能：由PCA法确定融合的加权系数（仍属于非多尺度分解的融合算法，即加权平均算法）
% I1和I2：待融合的两幅图像
% res：融合后的图像
% pcaWeightCoef：I1和I2的加权系数列向量

%% 简单实现
C = cov([I1(:),I2(:)]);
[V,D] = eig(C);
if D(1,1) >= D(2,2)
    pcaWeightCoef = V(:,1) / sum(V(:,1));    % 注意，取的是列向量（取行向量就错了）
else
    pcaWeightCoef = V(:,2) / sum(V(:,2));
end
res = pcaWeightCoef(1)*I1 + pcaWeightCoef(2)*I2;
end