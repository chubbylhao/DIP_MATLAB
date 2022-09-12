function res = mywht2(matrix)
[M, N] = size(matrix);
matM = sqrt(1/M) * hadamard(M);
matN = sqrt(1/N) * hadamard(N);
res = matM * matrix * matN;
end