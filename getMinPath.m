function [min_path_list] = getMinPath(start_point,end_point,path_list)
%calculate the min cost path from start point to end point using dijikstra
[path_num,~] = size(path_list);
v = false(path_num,1);
dis = ones(path_num,1);
pre = zeros(path_num,1);
dis = dis * Inf;
for i = 1 : path_num
    if (isequal(path_list(i,:),start_point))
        s = i;
    end
    if (isequal(path_list(i,:),end_point))
        e = i;
    end
end
dis(s) = 0;
while (true)   
    mini = -1;
    for i = 1 : path_num
        if (~v(i) &&(mini == -1 || dis(i) < dis(mini)))
            mini = i;
        end
    end
    if (mini == -1 || mini == e)
        break;
    end
    k = mini;
    v(k) = true;
    for j = 1 : path_num
        point = path_list(j,:);
        distance = norm(point - path_list(k,:));
        if (distance > sqrt(6))
            continue;
        end
        if (~v(j) && dis(k) + distance <= dis(j))
            dis(j) = dis(k) + distance;
            pre(j) = k;
        end
    end
end
i = e;
min_path_list = [];
while (i ~= s)
    point = path_list(i,:);
    min_path_list = [min_path_list;point];
    i = pre(i);
end
min_path_list = [min_path_list;start_point];