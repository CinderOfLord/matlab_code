
load Volume;
I = CT(: , : , 1);
I(I < 200) = 0;
K = zeros(size(I));
Y = imbinarize(I);
Y = imfill(Y,'hole');
imshow(Y,[]);
[centers,radii] = imfindcircles(Y , [40 60]);
center = centers(1 , :);
radiu = radii(1 , :);
viscircles(center, radiu,'EdgeColor','b');
[m,n] = size(I);
queue = [];
for i = 1 : m
    for j = 1 : n
        if (Y(i , j) == 1 && (i - center(2)) ^ 2 + (j - center(1)) ^ 2 <= radiu ^ 2)
           queue = [queue; [j , i]];
           K(i,j) = I(i,j);
        end 
    end
end
cx = mean(queue(: , 1));
cy = mean(queue(: , 2));

%{
I = imread('testHough.png');
I = rgb2gray(I);
I = imbinarize(255 - I);
imshow(I,[]);
[centers,r] = imfindcircles(I , [40 60]);
viscircles(centers, r,'EdgeColor','b');
%}