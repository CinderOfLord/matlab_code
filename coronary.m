% folder = 'D:\matlab_data\wang-shu-rong\';
% [gray,infolist] = read(folder);
% slope = infolist(1).RescaleSlope;
% intercept = infolist(1).RescaleIntercept;
% ct_ori = double(gray * slope + intercept);
% ct_top_hat = ct_ori - imopen(ct_ori,strel('cube',8));
% ct_top_hat = imresize3(ct_top_hat,0.5);
% ct_ori = imresize3(ct_ori,0.5);
% save Volume ct_ori ct_top_hat slope intercept infolist;

% load Volume;
% [bw_aorta,bw_left,bw_right,left_seed,right_seed,fail] = SearchAlongAorta(ct_ori,ct_top_hat);
% if (fail)
%     disp('fail');
%     return;
% end
% bw_out = bw_aorta | bw_left | bw_right;
% ct3wei(bw_out * 400);

ct3wei(bw_right * 400);
hold on;
[bw_rca,rca_center_list] = getRca(bw_right,right_seed);
plot3(rca_center_list(:,2),rca_center_list(:,1),rca_center_list(:,3),'g');


% ct_out = ct_ori;
% ct_out(bw_out == false) = 0;
% gray_out = uint16(round(imresize3(ct_out,2) + 1024));
% [~,~,slicers] = size(gray_out);
% for i = 1 : slicers - 1
%     dicomwrite(gray_out(:,:,i),['D:\test\grow\picture',num2str(i),'.dcm'],infolist(i));
% end
