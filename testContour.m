folder = 'D:\matlab_data\bai-shi-jie\';
[Gray,infolist] = read(folder);
slope = infolist(1).RescaleSlope;
intercept = infolist(1).RescaleIntercept;
CT_Ori = Gray * slope + intercept;
[x,y,z] = size(CT_Ori);
CT = CT_Ori - imopen(CT_Ori,strel('cube',15));
save Volume CT_Ori CT slope intercept infolist;

Gray = uint16(CT + 1024);
for i = 1 : z
     dicomwrite(Gray(:,:,i),['D:\test\imclose\picture',num2str(i),'.dcm'],infolist(i));
end

% for i = 48 : 84
%     I = CT(:,:,i);
%     mask = false(size(I));
%     mask(280 : 290,180 : 190) = true;
%     bw = activecontour(I,mask,200);
%     edge = boundarymask(bw);
%     [x_list,y_list] = find(edge);
%     subplot(1,2,1),imshow(I,[100 400]);
%     subplot(1,2,2),imshow(bw);
%     imshow(I,[100 400]);
%     hold on;
%     plot(_list,x_list,'r*');
%     pause(0.2);
% end

% I = imread('IMG-0004-00001.jpg');
% I = double(rgb2gray(I));
% subplot(1,2,1);
% imshow(I,[]);
% hold on;
% plot(257,313,'r*');

% CT = CT_Ori - imopen(CT_Ori,strel('cube',15));
% CT = imresize3(CT,0.5);
% V = double(CT);
% imshow(CT(:,:,30),[100 400]);
% % 127 157 30
% mask = false(size(V));
% mask(156 : 157,126 : 127,30 : 31) = true;
% % W = graydiffweight(V,156,126,30);
% % bw = imsegfmm(W,mask,0.01);
% bw = activecontour(V,mask,300);
