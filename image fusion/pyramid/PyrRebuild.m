function res = PyrRebuild(lp_pyr1,lp_pyr2,weight)
%% 此函数用于重构拉普拉斯金字塔
% lp_pyr1和lp_pyr2是待融合图像的拉普拉斯金字塔
% weight是加权平均法中I1的权重
% res是融合后的图像
h = [1,4,6,4,1]; kernel = h'*h/256;
maxN = floor(log2(min(size(lp_pyr1{1}))));
layer = numel(lp_pyr1);
lp_pyr = cell(layer,1);

%% 融合最顶层
if layer == maxN
    lp_pyr{layer} = PyrMaxGray(lp_pyr1{layer},lp_pyr2{layer});
elseif (layer >= maxN/2) && (layer < maxN)
    lp_pyr{layer} = PyrWeight(lp_pyr1{layer},lp_pyr2{layer},weight);
%     lp_pyr{layer} = PyrMaxGray(lp_pyr1{layer},lp_pyr2{layer});
%     lp_pyr{layer} = PyrMinGray(lp_pyr1{layer},lp_pyr2{layer});
elseif (layer > 1) && (layer < maxN/2)
%     lp_pyr{layer} = PyrMaxGrad(lp_pyr1{layer},lp_pyr2{layer});
%     lp_pyr{layer} = PyrMaxGray(lp_pyr1{layer},lp_pyr2{layer});
    lp_pyr{layer} = PyrWeight(lp_pyr1{layer},lp_pyr2{layer},weight);
%     lp_pyr{layer} = PyrMinGray(lp_pyr1{layer},lp_pyr2{layer});
else
    error(['金字塔的层数搞错了！其层数应该大于1层小于',num2str(maxN+1),'层!'] );
end

%% 融合其它层
for i = 1:layer-1
%     lp_pyr{i} = PyrEnergy(lp_pyr1{i},lp_pyr2{i});
%     lp_pyr{i} = PyrMaxGray(lp_pyr1{i},lp_pyr2{i});
%     lp_pyr{i} = PyrWeight(lp_pyr1{i},lp_pyr2{i},weight);
    lp_pyr{i} = PyrMinGray(lp_pyr1{i},lp_pyr2{i});
end

%% 重构
for j = layer:-1:2
   upI = imresize(lp_pyr{j},2);
   lp_pyr{j-1} = lp_pyr{j-1} + imfilter(upI,kernel,'replicate');
end
res = lp_pyr{1};
end

%% 以下是拉普拉斯金字塔的顶层和其他层的融合规则（这个可以按照自己的需求设定）
%% 最大灰度法（当N=maxN时）
function res = PyrMaxGray(I1,I2)
res = I1.*(I1>=I2) + I2.*(I2>I1);
end

%% 最小灰度法（当N=maxN时）
function res = PyrMinGray(I1,I2)
res = I1.*(I1<=I2) + I2.*(I2<I1);
end

%% 加权平均法（当N>maxN/2时）
function res = PyrWeight(I1,I2,weight)
res = weight*I1 + (1-weight)*I2;
end

%% 最大梯度法（当N<maxN/2时）
function res = PyrMaxGrad(I1,I2)
[Gmag1,~] = imgradient(I1); [Gmag2,~] = imgradient(I2);
res = Gmag1.*(Gmag1>=Gmag2) + Gmag2.*(Gmag2>Gmag1);
end

%% 区域能量法（非顶层的融合规则）
function res = PyrEnergy(I1,I2)
h = [1,2,1]; kernel = h'*h/16;
opI1 = imfilter(I1,kernel,'replicate'); opI2 = imfilter(I2,kernel,'replicate');
res = opI1.*(opI1>=opI2) + opI2.*(opI2>opI1);
end