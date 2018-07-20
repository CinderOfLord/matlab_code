function [Point,Variant,Dis] = calc(start,dirp,center,grow)
dir = dirp - start;
now = start;
findnext = true;
Vari = [];
Point = [];
dis = [];
r1 = 2;
r2 = 7;
while (findnext == true)
    findnext = false;
    nextp = [0 0 0];
    bestangle = 90;
    for i = -r1 : r1
        for j = -r1 : r1
            for k = -r1 : r1
                link = now + [i j k];
                dir1 = link - now;
                angle = acosd(sum(dir.* dir1)/(norm(dir) * norm(dir1)));
                if (center(link(1),link(2),link(3)) == 1 && angle < bestangle)
                    bestangle = angle;
                    findnext = true;
                    nextp = link;
                end
            end
        end
    end
    if (findnext == false)
        break;
    end
    dir = nextp - now;
    Point = [Point;nextp];
    dis = [dis;norm(nextp - start)];
    now = nextp;
    queue = [];
    for i = -r2 : r2
        for j = -r2 : r2
            for k = -r2 : r2
                if (i == 0 && j == 0 && k == 0)
                    continue;
                end
                neibor = nextp + [i j k];
                dir1 = [i j k];
                angle = acosd(sum(dir.* dir1)/(norm(dir) * norm(dir1)));
                if (abs(angle) > 88 && abs(angle) < 92 && grow(neibor(1),neibor(2),neibor(3)) > 100)
                    queue = [queue ; neibor];
                end
            end
        end
    end
    [c,l] = size(queue);
    gray = zeros(c,1);
    for i = 1 : c
        point = queue(i,:);
        gray(i) = grow(point(1),point(2),point(3));
    end
    Vari = [Vari;var(gray)];
end
Variant = Vari;
Dis = dis;
end
