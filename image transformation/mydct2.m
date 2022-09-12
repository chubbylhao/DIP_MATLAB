function res = mydct2(matrix)
[M, N] = size(matrix);
matM = zeros(M);
matN = zeros(N);
for i = 1:M
    for j = 1:M
        if (i-1)==0
            matM(i,j) = sqrt(1/M);
        else
            matM(i,j) = sqrt(2/M)*cos((2*(j-1)+1)*(i-1)*pi/(2*M));
        end
    end
end
for i = 1:N
    for j = 1:N
        if (i-1)==0
            matN(i,j) = sqrt(1/N);
        else
            matN(i,j) = sqrt(2/N)*cos((2*(j-1)+1)*(i-1)*pi/(2*N));
        end
    end
end
res = matM * matrix * matN;
end