function [Iout]=kmeans(V,r,minv)
%r = 4;
%{
cell1 = num2cell(mat(1 , :));
cell2 = num2cell(mat(2 , :));
cell3 = num2cell(mat(3 , :));
cell4 = num2cell(mat(4 , :));
%}
I = double(V);
flag = ones(size(I));
[x,y,z] = size(I);
%old_means = [I(cell1{:}) I(cell2{:}) I(cell3{:}) I(cell4{:})];
old_means = [0 1000 1500];
while 1
    new_means = double(zeros(size(old_means)));
    new_cnt = zeros(size(old_means));
    for i = 1 : x
        for j = 1 : y
            for k = 1 : z
                Min = abs(I(i,j,k) - old_means(1));
                flag(i,j,k) = 1;
                for q = 2 : r
                   if abs(I(i,j,k) - old_means(q)) < Min
                      Min = abs(I(i,j,k) - old_means(q));
                      flag(i,j,k) = q;
                   end
                end
                for q = 1 : r
                    if flag(i,j,k) == q
                        new_means(q) = new_means(q) / (new_cnt(q) + 1) * new_cnt(q) + I(i,j,k) / (new_cnt(q) + 1);
                    end
                end
            end
        end
    end

    pan = true;
    for q = 1 : r
        if abs(new_means(q) - old_means(q)) > 0.05
            pan = false;
        end
    end
    if pan == true
        break;
    else
        old_means = new_means;
        disp([num2str(new_means(1)),' ',num2str(new_means(2)),' ',num2str(new_means(3))]);
    end
    
    %disp([num2str(new_means(1)),' ',num2str(new_means(2)),' ',num2str(new_means(3)),' ',num2str(new_means(4))]);
    %break;
end

Iout = V;
Iout(flag ~= 3) = minv;




