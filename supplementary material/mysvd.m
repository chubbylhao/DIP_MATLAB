function [U, S, V] = mysvd(M)
[U, Du] = eig(M * M');
[V, ~] = eig(M' * M);
S = sqrt(Du * eye(size(M)));
end