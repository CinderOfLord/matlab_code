function [BW_Filter,Found] = calc_best_pair(BW_Label,CT)
BW = BW_Label > 0;
BW_Skel = bwskel(BW);
BW_EndPoint = bwmorph3(BW_Skel,'endpoints');
[endx,endy,endz] = ind2sub(size(BW_EndPoint),find(BW_EndPoint == 1));
[r,c] = size(endx);
Label = zeros(r,1);
for i = 1 : r
    Label(i) = BW_Label(endx(i),endy(i),endz(i));
end
Label1 = [];
Label2 = [];
Dis = [];
MidPoint = [];
queue_num = 0;
for i = 1 : r - 1
    for j = i + 1 : r
        p = Label(i); 
        q = Label(j);
        x = min([p;q]);
        y = max([p;q]);
        if (p == q)
            continue;
        end
        distance = norm([endx(i) endy(i) endz(i)] - [endx(j) endy(j) endz(j)]);
        mid_point = ([endx(i) endy(i) endz(i)] + [endx(j) endy(j) endz(j)]) / 2;
        Flag = false;
        for k = 1 : queue_num
            if (Label1(k) == x && Label2(k) == y)
                Flag = true;
                if (Dis(k) > distance)                    
                    Dis(k) = distance;
                    MidPoint(k,:) = mid_point;
                end
                break;
            end
        end
        if (Flag == false)
            queue_num = queue_num + 1;
            Label1 = [Label1;x];
            Label2 = [Label2;y];
            Dis = [Dis;distance];
            MidPoint = [MidPoint;mid_point];
        end
    end  
end

[row_number,l] = size(Label1);
[ctmaxx,ctmaxy,ctmaxz] = size(CT);
Found = false;
L1_List = [];
L2_List = [];
for i = 1 : row_number
    center_point = MidPoint(i,:);
    radiu = floor(Dis(i) / 2);
    if (radiu < 20 || radiu > 45)
        continue;
    end
    nz = center_point(3);
    if (norm(center_point - [ctmaxx / 2 , ctmaxy / 2 , nz]) > 45)
        continue;
    end
    summary = 0;
    for s1 = -radiu : radiu
        for s2 = -radiu : radiu
            for s3 = -radiu : radiu
                nx = floor(center_point(1) + s1);
                ny = floor(center_point(2) + s2);
                nz = floor(center_point(3) + s3);
                if (nx >= 1 && nx <= ctmaxx && ny >= 1 && ny <= ctmaxy && nz >= 1 && nz <= ctmaxz && CT(nx,ny,nz) >= 200)
                    summary = summary + 1;
                end
            end
        end
    end
    if (summary < 0.5 * 8 * radiu ^ 3)
        continue;
    end
    L1 = Label1(i);
    L2 = Label2(i);
    L1_List = [L1_List;L1];
    L2_List = [L2_List;L2];
    Found = true;
    break;
end
[r,l] = size(L1_List);
BW_Filter = zeros(size(BW_Label));
if (Found == true)
    for i = 1 : r
        BW_Filter = BW_Filter | (BW_Label == L1_List(i)) | (BW_Label == L2_List(i));
    end
else
    BW_Filter = 0;
end
    
