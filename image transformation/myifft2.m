function res = myifft2(matrix)
[M, N] = size(matrix);
matM = zeros(M);
matN = zeros(N);
for i = 1:M
    for j = 1:M
        matM(i,j) = exp(1i*2*pi*(i-1)*(j-1)/M);
    end
end
for i = 1:N
    for j = 1:N
        matN(i,j) = exp(1i*2*pi*(i-1)*(j-1)/N);
    end
end
res = matM * matrix * matN / (M * N);   % 为了和MATLAB自带函数统一结果
end