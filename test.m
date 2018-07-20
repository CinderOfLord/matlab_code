% % folder = 'D:\matlab_data\bai-shi-jie\';
% % [Gray,infolist] = read(folder);
% % slope = infolist(1).RescaleSlope;
% % intercept = infolist(1).RescaleIntercept;
% % CT_Ori = Gray * slope + intercept;
% % [x,y,z] = size(CT_Ori);
% % % save Volume CT_Ori CT slope intercept infolist;
% % load Volume;
% % CT = CT_Ori - imopen(CT_Ori,strel('cube',15));
% 
% % BW_Label = bwlabeln(CT >= 200);
% % [BW_aorta,label_left,label_right] = findAorta(CT_Ori,BW_Label);
% % if (label_left == -1 || label_right == -1)
% %     disp('fail');
% %     return;
% % end
% % BW = BW_aorta | (BW_Label == label_left) | (BW_Label == label_right);
% 
% % Gray = uint16(CT + 1024);
% % for i = 1 : z
% %      dicomwrite(Gray(:,:,i),['D:\test\contrast\picture',num2str(i),'.dcm'],infolist(i));
% % end
% % BW = BW | BW_Label == 800;
% % Gray = uint16(BW * 400 + 1024);
% % for i = 1 : z
% %      dicomwrite(Gray(:,:,i),['D:\test\grow\picture',num2str(i),'.dcm'],infolist(i));
% % end



% folder = 'D:\matlab_data\wang-shu-rong\';
% [gray,infolist] = read(folder);
% slope = infolist(1).RescaleSlope;
% intercept = infolist(1).RescaleIntercept;
% ct_ori = double(gray * slope + intercept);
% ct_top_hat = ct_ori - imopen(ct_ori,strel('cube',8));
% ct_top_hat = imresize3(ct_top_hat,0.5);
% ct_ori = imresize3(ct_ori,0.5);
% save Volume ct_ori ct_top_hat slope intercept infolist;


% [bw_aorta,bw_left,bw_right,left_seed,right_seed,fail] = SearchAlongAorta(ct_ori,ct_top_hat);
% if (fail)
%     disp('fail');
%     return;
% end
% bw_out = bw_aorta | bw_left | bw_right;
% ct3wei(bw_out * 400);
% mask = false(size(ct_top_hat));
% mask(86:87,104:105,47:48) = true;
% bw_right1 = activecontour(ct_top_hat,mask,300);
% bw_right2 = RegionGrow(ct_top_hat,right_seed,0.3);
for i = 43 : 100
    subplot(1,3,1),imshow(ct_top_hat(:,:,i),[100 300]);
    subplot(1,3,2),imshow(bw_right1(:,:,i));
    subplot(1,3,3),imshow(bw_right2(:,:,i));
    pause;
end
% ct3wei(bw_left1 * 400);

% ct_out = ct_ori;
% ct_out(bw_out == false) = 0;
% gray_out = uint16(round(imresize3(ct_out,2) + 1024));
% [~,~,slicers] = size(gray_out);
% for i = 1 : slicers - 1
%     dicomwrite(gray_out(:,:,i),['D:\test\grow\picture',num2str(i),'.dcm'],infolist(i));
% end



% for i = 28 : 93
%     subplot(1,2,1),imshow(ct_top_hat(:,:,i),[100 400]);
%     subplot(1,2,2),imshow(bw_out(:,:,i));
%     pause(0.3);
%     pause;
% end