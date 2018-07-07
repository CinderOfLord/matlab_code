folder = 'D:\test\enhance\';
filelist = dir([folder,'*.dcm']);
lenfiles = length(filelist);
L = filelist(1).name;
for i = 2 : lenfiles
    L = char(L,filelist(i).name);
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
slope = infolist(1).RescaleSlope;
intercept = infolist(1).RescaleIntercept;
CT = V * slope + intercept;
[x,y,z] = size(CT);
Center = bwskel(CT);
for k = 1 : z
    dicomwrite(Center(:,:,k),['D:\test\centerline\picture' , num2str(k) , '.dcm'],infolist(:,:,k));
end


