function [BW_aorta,label_left,label_right] = findAorta(CT,Label)
%return if this is an arota true or false
t = 5;
[m,n,r] = size(CT);
while (t <= r / 2)
    I = CT(: , : , t);
    I(I < 300) = 0;
    Y = imbinarize(I);
    Y = imfill(Y,'hole');
    [centers,radii] = imfindcircles(Y , [15 35]);
    [row_radii,~] = size(radii);
    if (row_radii == 0)
        t = t + 1;
        continue;
    end
    center = centers(1 , :);
    x = round(center(1));
    y = round(center(2));
    center = [y x];
    imshow(Y');
    hold on;
    plot(center(1),center(2),'r*');
    pause(0.3);
    radiu = radii(1 , :);
    break;
end
label_left = -1;
label_right = -1;
V = zeros(m,n,r);
while (t <= r / 2)
    [BW,center] = growAorta(CT(: , : ,t),center,radiu);
    V(:,:,t) = BW; 
    Edge = bwmorph(BW,'remove');
    [x_list,y_list] = find(Edge);
    [list_row,~] = size(x_list);
    imshow(BW');
    hold on;
    plot(center(1),center(2),'r*');
    pause(0.3);
    for lk = 1 : list_row
        tx = x_list(lk);
        ty = y_list(lk);
        label = Label(tx,ty,t);
        if (label == 0 || sum(sum(sum(Label == label))) < 300)
            continue;
        end
        if (label_left == -1)
            if (center(2) < ty)
                label_left = label;
                plot(tx,ty,'b*');
                pause(0.5);
            end
            continue;
        end   
        if (label_left == label)
            continue;
        end
        label_right = label;
        plot(tx,ty,'b*');
        pause(0.5);
        break;
    end
    if (label_left ~= -1 && label_right ~= -1)
        break;
    end
    t = t + 1;
end
BW_aorta = V == 1;

function [OutBw,center] = growAorta(I,lastc,radiu)
I(I < 300) = 0;
Y = imbinarize(I);
%Y = imerode(Y,strel('square',1));
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



