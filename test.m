for i = 50 : 70
    subplot(1,3,1),imshow(CT(:,:,i),[400 600]);
    subplot(1,3,2),imshow(FValue(:,:,i),[0.1 0.3]);   
    subplot(1,3,3),imshow(BW(:,:,i));
    pause;
end

% load Volume;
% options.BlackWhite = false;
% options.FrangiScaleRange = [1 2];
% options.FrangiScaleRatio = 1;
% [FValue,Scale]=FrangiFilter3D(CT,options);
% Max = max(max(max(FValue)));
% FValue = FValue / Max;
% save Filter FValue;

% BW_Label = bwlabeln(FValue > 0.25);
% label_left = BW_Label(266,254,62);
% label_right = BW_Label(186,198,88);
% BW = (BW_Label == label_left) | (BW_Label == label_right);
% MeanL = mean(mean(mean((FValue(BW_Label == label_left)))));
% MeanLScale = mean (mean(mean((Scale(BW_Label == label_left)))));
% MeanR = mean(mean(mean((FValue(BW_Label == label_right)))));
% MeanRScale = mean(mean(mean((Scale(BW_Label == label_right)))));