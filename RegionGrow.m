function [bw_out] = RegionGrow(V,seed,thresh)
V = double(V);
seed = uint16(seed);
[xmax,ymax,zmax] = size(V);
merged = false(size(V));
visit = false(size(V));
visit(seed(1),seed(2),seed(3)) = true;
flag = true;
queue = seed;
aver_gray = V(seed(1),seed(2),seed(3));
region_num = 0;
while (flag)
    flag = false;
    h = 1;
    while (true)
        [num,~] = size(queue);
        if (h > num)
            break;
        end
        point = queue(h,:);
        h = h + 1;
        x = point(1); y = point(2); z = point(3);
        if (merged(x,y,z))
            continue;
        end
        if (V(x,y,z) >= aver_gray * (1 - thresh))
            merged(x,y,z) = true;
            aver_gray = aver_gray / (region_num + 1) * region_num + V(x,y,z) / (region_num + 1);
            region_num = region_num + 1;
            for i = -1 : 1
                for j = -1 : 1
                    for k = -1 : 1
                        nx = x + i; ny = y + j; nz = z + k;
                        if (nx <= 0 || nx > xmax || ny <= 0 || ny > ymax || nz <= 0 || nz > zmax)
                            continue;
                        end
                        if (visit(nx,ny,nz))
                            continue;
                        end
                        visit(nx,ny,nz) = true;
                        flag = true;
                        queue = [queue;[nx ny nz]];
                    end
                end
            end
        end
    end
end
bw_out = merged;