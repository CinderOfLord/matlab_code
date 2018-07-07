function [BW_aorta,spoint] = findAorta(CT)
%return if this is an arota true or false
I = CT(: , : , 1);
[m,n,r] = size(CT);
V = zeros(m,n,r);
I(I < 200) = 0;
Y = imbinarize(I);
Y = imfill(Y,'hole');
[centers,radii] = imfindcircles(Y , [15 35]);
center = centers(1 , :);
x = round(center(1));
y = round(center(2));
center = [y x];
radiu = radii(1 , :);
t = 1;
while (t <= 50)
    spoint = [center,t];
    [BW,center] = growAorta(CT(: , : ,t),center,radiu);
    V(:,:,t) = BW;    
    imshow(BW);
    pause(0.3);
    t = t + 1;
end
BW_aorta = V == 1;

function [OutBw,center] = growAorta(I,lastc,radiu)
I(I < 200) = 0;
Y = imbinarize(I);
Y = imfill(Y,'hole');
Label = bwlabel(Y);
cen_label = Label(lastc(1),lastc(2));
OutBw = (Label == cen_label);
[p,q] = size(OutBw);
queue = [];
for i = 1 : p
    for j = 1 : q
        if (abs(i - lastc(1)) > radiu + 10 || abs(j - lastc(2)) > radiu + 10)
            OutBw(i,j) = 0;
            continue;
        end
        if (OutBw(i,j))
            queue = [queue;[i j]];
        end
    end
end
cx = round(mean(queue(: , 1)));
cy = round(mean(queue(: , 2)));
center = [cx cy];



