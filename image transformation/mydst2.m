function res = mydst2(matrix)
[M, N] = size(matrix);
matM = zeros(M);
matN = zeros(N);
for i = 1:M
    for j = 1:M
        matM(i,j) = sqrt(2/(M+1))*sin(i*j*pi/(M+1));
    end
end
for i = 1:N
    for j = 1:N
        matN(i,j) = sqrt(2/(N+1))*sin(i*j*pi/(N+1));
    end
end
res = matM * matrix * matN;
end