function [BW_Label] = Label_Sort(BW_Filter,CT)
BW_Label = bwlabeln(BW_Filter);
up_limit = max(max(max(BW_Label)));
Sum_Voxel = [];
Voxel_Label = [];
for i = 1 : up_limit
    CT_List = CT(BW_Label == i);
    Mean_CT = mean(CT_List);
    if (Mean_CT < 200 || Mean_CT > 500)
        BW_Label(BW_Label == i) = 0;
        continue;
    end
    Sum_Voxel = [Sum_Voxel;sum(sum(sum(BW_Label == i)))];
    Voxel_Label = [Voxel_Label;i];
end
[row,col] = size(Sum_Voxel);
for i = 1 : row - 1
    for j = i + 1 : row
        if (Sum_Voxel(i) < Sum_Voxel(j))
            t_sum = Sum_Voxel(i); Sum_Voxel(i) = Sum_Voxel(j); Sum_Voxel(j) = t_sum;
            t_Label = Voxel_Label(i); Voxel_Label(i) = Voxel_Label(j); Voxel_Label(j) = t_Label;
        end
    end
end
for i = 50 : row
    BW_Label(BW_Label == Voxel_Label(i)) = 0;
    Voxel_Label(i) = 0;
end