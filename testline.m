V = imread('test1.png');
I = double(rgb2gray(V));
I = 255 - I;
Y = imbinarize(I);
%BW2 = zs(imbinarize(I));
%BW2 = bwmorph(X,'skel',Inf);
BW2 = bwskel(Y);

[m,n] = size(I);
for i = 1 : m
    for j = 1 : n
        if (BW2(i,j) == 1)
            I(i,j) = 0;
        end
    end
end
imshow(I);
