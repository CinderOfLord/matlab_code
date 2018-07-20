function [visit] = mergeGrow(aorta,CT,spoint,sigma)
V = double(CT);
[r1,r2,r3] = size(aorta);
[Dxx, Dyy, Dzz, Dxy, Dxz, Dyz] = Hessian3D(V,sigma);
queue = [];
queue = [queue;spoint];
visit = zeros(size(V));
[a,b,c] = size(CT);
visit(spoint(1),spoint(2),spoint(3)) = 1;
h = 1;
t = 1;
r = 2;
while (h <= t)
   H = queue(h , :);
   h = h + 1;
   x = H(1); y = H(2); z = H(3);
   for s1 = -r : r
       for s2 = -r : r
           for s3 = -r : r
               nx = x + s1;
               ny = y + s2;
               nz = z + s3;
               if (nx >= 1 && nx <= a && ny >= 1 && ny <= b && nz >= 1 && nz <= c)
                   if (visit(nx,ny,nz) == 1)
                       continue;
                   end
                   if (nz <= r3 && aorta(nx,ny,nz) == 1)                       
                      queue = [queue ; [nx ny nz]];
                      visit(nx,ny,nz) = 1;
                      t = t + 1;
                   else
                       Hessian = (sigma ^ 2) * [Dxx(nx,ny,nz) Dxy(nx,ny,nz) Dxz(nx,ny,nz); Dxy(nx,ny,nz) Dyy(nx,ny,nz) Dyz(nx,ny,nz); Dxz(nx,ny,nz) Dyz(nx,ny,nz) Dzz(nx,ny,nz)];
                       if (V(nx,ny,nz) >= 0 && getValue(Hessian) >= 0.5)
                            queue = [queue ; [nx ny nz]];
                            visit(nx,ny,nz) = 1;
                            t = t + 1;
                       end
                   end
               end
           end
       end
   end
end



function [value] = getValue(H)
C = norm(H,Inf) / 2;
[vector,lambda] = eig(H);
L(1) = lambda(1,1); V(:,1) = vector(:,1);
L(2) = lambda(2,2); V(:,2) = vector(:,2);
L(3) = lambda(3,3); V(:,3) = vector(:,3);
for i = 1 : 2
    for j = (i + 1) : 3
        if (abs(L(i)) > abs(L(j)))
            t = L(i); L(i) = L(j); L(j) = t;
            vt = V(:,i); V(:,i) = V(:,j); V(:,j) = vt;
        end
    end
end
L1 = L(1); L2 = L(2); L3 = L(3);
%V1 = V(:,1); V2 = V(:,2); V3 = V(:,3);
if (L2 > 0 || L3 > 0)
    value = 0;
    return;
end
S = sqrt(L1 ^ 2 + L2 ^ 2 + L3 ^ 2);
A = 2 * 0.5 ^ 2; 
B = 2 * 0.5 ^ 2;  
Ra = abs(L2 / L3);
Rb = abs(L1 / sqrt(abs(L2 * L3)));
expRa = (1 - exp(-(Ra ^ 2 / A)));
expRb = exp(-(Rb ^ 2 / B));
expS  = (1-exp(-S ^ 2 / (2 * C ^ 2)));
value = expRa * expRb * expS;

