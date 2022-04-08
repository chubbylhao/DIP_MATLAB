function res = DwtFusion(x1,x2,N,wname)
%% 函数功能：实现一个粗糙的小波图像融合（效果不太好）
% x1和x2：待融合图像
% N：小波分解的层数
% wname：分解所使用的小波基
% res：融合后的图像
h = [1,2,1]; kernel = h'*h/16;    % 区域最大能量法用到的加权系数
[C1,S1] = wavedec2(x1,N,wname);
[C2,S2] = wavedec2(x2,N,wname);

%% 低频融合策略
A1 = appcoef2(C1,S1,wname,N);
A2 = appcoef2(C2,S2,wname,N);
A = 0.5*A1 + 0.5*A2;
% A = max(A1,A2);

C = reshape(A,1,S1(1,1)*S1(1,2));
for i = N:-1:1
    %% 获得高频系数
    [H1,V1,D1] = detcoef2('all',C1,S1,i);
    [H2,V2,D2] = detcoef2('all',C2,S2,i);
    
    %% 均值融合策略
    H = 0.5*H1 + 0.5*H2;
    D = 0.5*D1 + 0.5*D2;
    V = 0.5*V1 + 0.5*V2;
    
    %% 最大值融合策略
%     H = max(H1,H2);
%     D = max(D1,D2);
%     V = max(V1,V2);

    %% 区域能量最大法融合策略
%     opH1 = imfilter(H1,kernel,'replicate');
%     opV1 = imfilter(V1,kernel,'replicate');
%     opD1 = imfilter(D1,kernel,'replicate');
%     opH2 = imfilter(H2,kernel,'replicate');
%     opV2 = imfilter(V2,kernel,'replicate');
%     opD2 = imfilter(D2,kernel,'replicate');
%     H = H1.*(opH1>=opH2) + H2.*(opH2>opH1);
%     V = V1.*(opV1>=opV2) + V2.*(opV2>opV1);
%     D = D1.*(opD1>=opD2) + D2.*(opD2>opD1);

    %% 得到小波分解向量C（和S一起使用）
    h = reshape(H,1,S1(N+2-i,1)*S1(N+2-i,2));
    v = reshape(V,1,S1(N+2-i,1)*S1(N+2-i,2));
    d = reshape(D,1,S1(N+2-i,1)*S1(N+2-i,2));
    C = [C,h,v,d];
end

%% 重构
res = waverec2(C,S1,wname);
end