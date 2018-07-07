function [Gray,InfoOut] = read(folder)
filelist = dir([folder,'*.dcm']);
lenfiles = length(filelist);
L = filelist(1).name;
for i = 2 : lenfiles
    L = char(L,filelist(i).name);
end
L = cellstr(L);
num = (1 : lenfiles)';
for i = 1 : lenfiles
    s = char(L(i));
    s1 = strsplit(s , '.');
    s2 = s1(length(s1) - 1);
    if (length(s2) > 8)
        s3 = s2(length(s2) - 7 : length(s2));
    else
        s3 = s2;
    end
    num(i) = str2num(char(s3));
end
for i = 1 : lenfiles
    for j = i + 1 : lenfiles
        if num(i) > num(j)
            t = num(i); num(i) = num(j); num(j) = t;
            t = L(i); L(i) = L(j); L(j) = t;
        end
    end
end
for i = 1 : lenfiles
   s = [folder,char(L(i))];
   Im = dicomread(s);
   info = dicominfo(s);
   if i == 1
       V = Im; 
       infolist = info;
   else
       infolist = cat(3,infolist,info);
       V = cat(3,V,Im);
   end   
end
Gray = V;
InfoOut = infolist;


