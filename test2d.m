%{
V = imread('test1.png');
I = double(rgb2gray(V));
I = 255 - I;
[m,n] = size(I);
Y = I;
imshow(I,[]);
sigma = [12 15 18];
F = zeros(m,n,3);
for i = 1 : 3
    F(:,:,i) = imgaussfilt(I,sigma(i));
end
save Filter I F sigma;
H = [46 270]';
while (I(round(H(1)),round(H(2))) > 100)
    x = round(H(1)); y = round(H(2));
    Y(x,y) = 0;
    flag = -1;
    max = 0;
    bestV = [0 ; 0];
    for k = 1 : 3
        Dxx = F(x + 1 , y , k) - 2 * F(x , y , k) + F(x - 1 , y , k);
        Dyy = F(x , y + 1 , k) - 2 * F(x , y , k) + F(x , y - 1 , k);
        Dxy = F(x + 1, y + 1 , k) - F(x , y + 1 , k) - F(x + 1 , y , k) + F(x , y , k);
        Hessian = [Dxx Dxy; Dxy Dyy] * (sigma(k) ^ 2);
        [vector,lambda] = eig(Hessian);
        p = lambda(1,1);
        q = lambda(2,2);
        if (abs(p) < abs(q))
            L1 = abs(p);
            V1 = vector(:,1);
            L2 = abs(q);
            V2 = vector(:,2);
        else
            L1 = abs(q);
            V1 = vector(:,2);
            L2 = abs(p);
            V2 = vector(:,1);
        end
        if (flag == -1)
            max = abs(L2 / (L1 + 1));
            flag = 0;
            bestV = V1;
        else
            if (abs(L2 / (L1 + 1)) > max)
                max = abs(L2 / (L1 + 1));
                bestV = V1;
            end
        end        
    end
    dir = bestV ./ norm(V1);
    if (dir(1) < 0)
        dir = - dir;
    end
    
    H = H + dir;
end
figure,
subplot(1,2,1), imshow(I,[]);
subplot(1,2,2), imshow(Y,[]);
%}

V = imread('test1.png');
I = double(rgb2gray(V));
I = 255 - I;
[m,n] = size(I);
sigma = 8;
F = imgaussfilt(I,sigma);
Dirx = zeros(m,n);
Diry = zeros(m,n);
Fvalue = zeros(m,n);
for i = 2 : m - 1
    for j = 2 : n - 1
        Dxx = F(i + 1 , j) - 2 * F(i , j) + F(i - 1 , j);
        Dyy = F(i , j + 1) - 2 * F(i , j) + F(i , j - 1);
        Dxy = F(i + 1, j + 1) - F(i , j + 1) - F(i + 1 , j) + F(i , j);
        Hessian = [Dxx Dxy; Dxy Dyy] * (sigma ^ 2);
        [vector,lambda] = eig(Hessian);
        p = lambda(1,1);
        q = lambda(2,2);
        if (abs(p) < abs(q))
            L1 = p;
            V1 = vector(:,1);
            L2 = q;
            V2 = vector(:,2);
        else
            L1 = q;
            V1 = vector(:,2);
            L2 = p;
            V2 = vector(:,1);
        end
        Dirx(i,j) = V1(1);
        Diry(i,j) = V1(2); 
        if (L2 > 0)
            continue;
        end
        Rb = L1 / L2;
        S = sqrt(L1 ^ 2 + L2 ^ 2);
        Fvalue(i,j) = exp(- Rb ^ 2 / 2 / 0.5 ^ 2) * (1 - exp(- S ^ 2 / 2 / 25 ^ 2));
    end
end
%save Test I F MyL1 MyL2 Dirx Diry;

subplot(2,2,1),imshow(I,[]);
subplot(2,2,2),imshow(Fvalue,[]);
subplot(2,2,3),imshow(Dirx,[]);
subplot(2,2,4),imshow(Diry,[]);
%{
Fvalue = zeros(size(I));
[m,n] = size(Fvalue);
for i = 1 : m
    for j = 1 : n
        L1 = MyL1(i,j);
        L2 = MyL2(i,j);
        if (L2 < 0)
            Rb = L1 / L2;
            S = sqrt(L1 ^ 2 + L2 ^ 2);
            Fvalue(i,j) = exp(- Rb ^ 2 / 2 / 0.5 ^ 2) * (1 - exp(- S ^ 2 / 2 / 25 ^ 2));
        else
            Fvalue(i,j) = 0;
        end
    end
end
save Fvalue Fvalue;
figure,
subplot(1,2,1), imshow(I,[]);
subplot(1,2,2), imshow(Fvalue,[]);
%}

%{
load Test;
options.BlackWhite = false;
options.FrangiScaleRange = [5 5];
options.FrangiScaleRatio = 1;
V = FrangiFilter2D(I,options);
load Lambda;
figure,
subplot(1,2,1),imshow(MyL1,[]);
subplot(1,2,2),imshow(MyL2,[]);
%}

%{
load Test;
load Lambda;
figure,
subplot(1,2,1), imshow(MyL2,[]);
subplot(1,2,2), imshow(Lambda1,[]);
%}

%{
load Test;
Fvalue = zeros(size(I));
[m,n] = size(Fvalue);
for i = 1 : m
    for j = 1 : n
        L1 = MyL1(i,j);
        L2 = MyL2(i,j);
        if (L2 < 0)
            Rb = L1 / L2;
            S = sqrt(L1 ^ 2 + L2 ^ 2);
            Fvalue(i,j) = exp(- Rb ^ 2 / 2 / 0.5 ^ 2) * (1 - exp(- S ^ 2 / 2 / 15 ^ 2));
        else
            Fvalue(i,j) = 0;
        end
    end
end
save Fvalue Fvalue;
%}

%{
load Test;
options.BlackWhite = false;
options.FrangiScaleRange = [2 2];
options.FrangiScaleRatio = 1;
V = FrangiFilter2D(I,options);
load Fvalue
figure,
subplot(1,2,1), imshow(V,[]);
subplot(1,2,2), imshow(Fvalue,[]);
%}
