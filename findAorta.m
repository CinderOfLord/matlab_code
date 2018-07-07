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
while (1)
    if (t == 5)
        spoint = [center,t];
    end
    [BW,center] = growAorta(CT(: , : ,t),center);
    imshow(BW);
    pause(0.1);
    t = t + 1;
    Vnum = sum(sum(BW));
    if ((t > 2 && Vnum > lastVnum * 1.5) || t > r)
        break;
    end
    lastVnum = Vnum;
    V(:,:,t - 1) = BW;    
end
BW_aorta = V == 1;

function [OutBw,center] = growAorta(I,lastc)
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
        if (OutBw(i,j))
            queue = [queue;[i j]];
        end
    end
end
cx = round(mean(queue(: , 1)));
cy = round(mean(queue(: , 2)));
center = [cx cy];

%{
x = round(lastc(1));
y = round(lastc(2));
lastc = [x y];
queue = lastc;
head = 1;
tail = 1;
OutBw = false(size(I));
while (head <= tail)
    p0 = queue(head,:);
    head = head + 1;
    for p = -1 : 1
        for q = -1 : 1
            point = p0 + [p q];
            x = point(1);
            y = point(2);
            if (x > 0 && y > 0 && Y(x,y) == 1 && OutBw(x,y) == false)
                OutBw(x,y) = true;
                queue = [queue;[x y]];
                tail = tail + 1;
            end
        end
    end
end
%}



