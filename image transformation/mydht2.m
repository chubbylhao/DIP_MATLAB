function res = mydht2(matrix)
[M, N] = size(matrix);
matM = zeros(M);
matN = zeros(N);
for i = 1:M
    for j = 1:M
        matM(i,j) = cos(2*pi*(i-1)*(j-1)/M) + sin(2*pi*(i-1)*(j-1)/M);
    end
end
for i = 1:N
    for j = 1:N
        matN(i,j) = cos(2*pi*(i-1)*(j-1)/N) + sin(2*pi*(i-1)*(j-1)/N);
    end
end
res = sqrt(1/(M*N)) * matM * matrix * matN;
end