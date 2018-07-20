function [bw_rca,rca_center_list] = getRca(bw_right,right_seed)
center_line = bwskel(bw_right);
% bw_branch = bwmorph3(center_line,'branchpoints');
bw_end = bwmorph3(center_line,'endpoints');
[p,q,r] = ind2sub(size(bw_end),find(bw_end));
end_list = [p q r];
[num_end,~] = size(end_list);
[p,q,r] = ind2sub(size(center_line),find(center_line));
path_list = [p q r];

% plot3(q,p,r,'b+');
% hold on;

% [p,q,r] = ind2sub(size(bw_branch),find(bw_branch));
% branch_list = [p q r];
% [num_branch,~] = size(branch_list);
%find the real start point
dis = 1 : num_end;
for i = 1 : num_end
    dis(i) = norm(right_seed - end_list(i,:));
end
[~,st_post] = min(dis);
start_point = end_list(st_post,:);
for i = 1 : num_end
    if (isequal(start_point,end_list(i,:)))
        dis(i) = Inf;
        continue;
    end
    dis(i) = norm(start_point - end_list(i,:));
end
[~,ed_post] = min(dis);
end_point = end_list(ed_post,:);
min_path_list = getMinPath(start_point,end_point,path_list);
rca_center_list = min_path_list;
mask = false(size(bw_right));
[center_num,~] = size(rca_center_list);
for i = 1 : center_num
    point = rca_center_list(i,:);
    x = point(1); y = point(2); z = point(3);
    mask(x - 5 : x + 5,y - 5 : y + 5, z - 5 : z + 5) = true;
end
bw_rca = bw_right & mask;
end