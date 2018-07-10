% folder = 'D:\matlab_data\diao-li-qing\';
% [Gray,infolist] = read(folder);
% slope = infolist(1).RescaleSlope;
% intercept = infolist(1).RescaleIntercept;
% CT_Ori = Gray * slope + intercept;
% [x,y,z] = size(CT_Ori);
% CT = CT_Ori;
% CT = CT + 300;
% CT(CT < 470) = 0;
% save Volume CT_Ori CT slope intercept infolist;
% 
% load Volume;
% options.BlackWhite = false;
% options.FrangiScaleRange = [1 4.5];
% options.FrangiScaleRatio = 1.5;
% [FValue,Scale]=FrangiFilter3D(CT,options);
% Max = max(max(max(FValue)));
% FValue = FValue / Max;
% save Filter FValue;

% BW_Label = bwlabeln(FValue > 0.25 && CT > 0);
% label_left = BW_Label(266,254,62);
% label_right = BW_Label(186,198,88);
% BW = (BW_Label == label_left) | (BW_Label == label_right);
% MeanL = mean(mean(mean((FValue(BW_Label == label_left)))));
% MeanLScale = mean(mean(mean((Scale(BW_Label == label_left)))));
% MeanR = mean(mean(mean((FValue(BW_Label == label_right)))));
% MeanRScale = mean(mean(mean((Scale(BW_Label == label_right)))));

BW_Label = bwlabeln(FValue > 0.25 & CT > 500);
[BW_aorta,label_left,label_right] = findAorta(CT,BW_Label);
if (label_left == -1 || label_right == -1)
    disp('fail');
    return;
end
BW = BW_aorta | (BW_Label == label_left) | (BW_Label == label_right);
