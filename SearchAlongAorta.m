function [bw_aorta,bw_left,bw_right,left_seed,right_seed,fail] = SearchAlongAorta(ct_ori,ct_top_hat)
%return if this is an arota true or false
t = 1;
[m,n,r] = size(ct_ori);
while (t <= r / 2)
    I = ct_ori(: , : , t);
    Y = I >= 200;
    Y = imfill(Y,'hole');
    [centers,radii] = imfindcircles(Y , [15 35]);
    [row_radii,~] = size(radii);
    if (row_radii == 0)
        t = t + 1;
        continue;
    end
    center = centers(1 , :);
    x = uint16(round(center(1)));
    y = uint16(round(center(2)));
    center = [y x];
    subplot(1,2,1),imshow(ct_ori(:,:,t),[100 400]);
    subplot(1,2,2),imshow(Y),hold on,plot(center(2),center(1),'r*');
    pause(0.2);
    radiu = radii(1 , :);
    break;
end
bw_aorta = false(m,n,r);
visit = false(m,n,r);
find_left = false;
find_right = false;
while (t <= r / 2)
    subplot(1,2,1),imshow(ct_ori(:,:,t),[100 400]);
    [BW,center] = growAorta(ct_ori(:,:,t),center,radiu);
    bw_aorta(:,:,t) = BW; 
    edge = boundarymask(BW);
    vt = visit(:,:,t);
    I = ct_top_hat(:,:,t);
    filt = edge & vt == false & I >= 250;
    [x_list,y_list] = find(filt);
    [list_row,~] = size(x_list);
    subplot(1,2,2),imshow(BW),hold on,plot(center(2),center(1),'r*');
    pause(0.2);
    for lk = 1 : list_row
        tx = x_list(lk);
        ty = y_list(lk);   
        if (visit(tx,ty,t) == true)
            continue;
        end
        if (find_left == false)
            if (center(2) >= ty)
                continue;
            end
            [TempSeg,sum_num] = growCoronary(ct_top_hat,[tx ty t]);
            visit = visit | TempSeg;
            ct_top_hat = ct_top_hat .* (~visit);
            if (sum_num < 600)
                continue;
            end
            left_seed = [tx ty t];
            find_left = true;
            plot(ty,tx,'b*');
            bw_left = TempSeg;
            pause(0.5);
            continue;
        end
        [TempSeg,sum_num] = growCoronary(ct_top_hat,[tx ty t]);
        visit = visit | TempSeg;
        ct_top_hat = ct_top_hat .* (~visit);
        if (sum_num < 600)
            continue;
        end
        find_right = true;
        right_seed = [tx ty t];
        bw_right = TempSeg;
        plot(ty,tx,'b*');
        pause(0.5);
        break;
    end
    if (find_left && find_right)
        break;
    end
    t = t + 1;
end
fail = ~(find_left && find_right);
end

function [bw_out,center] = growAorta(I,lastc,radiu)
radiu = uint16(round(radiu));
cube = false(size(I));
cube(lastc(1) - radiu - 10 : lastc(1) + radiu + 10,lastc(2) - radiu - 10 : lastc(2) + radiu + 10) = true;
I = I .* cube;
mask = false(size(I));
mask(lastc(1) : lastc(1) + 1,lastc(2) : lastc(2) + 1) = true;
bw_out = activecontour(I,mask,200);
[x_list,y_list] = find(bw_out);
cx = uint16(round(mean(x_list)));
cy = uint16(round(mean(y_list)));
center = [cx cy];
end

function [bw_out,sum_num] = growCoronary(V,center)
% mask = false(size(V));
% mask(center(1) : center(1) + 1,center(2) : center(2) + 1,center(3) : center(3) + 1) = true;
% bw_out = activecontour(V,mask,300);
bw_out = RegionGrow(V,center,0.3);
sum_num = sum(bw_out(:));
end