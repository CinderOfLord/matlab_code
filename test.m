
%{
load Volume;
load Filter;
BW_Label = Label_Sort(FValue > 0.1,CT);
save BW_Filter BW_Label;
%}
%{
load Volume;
load BW_Filter;
[BW_Filter,Found] = calc_best_pair(BW_Label,CT);
save BW_Filter BW_Label BW_Filter;
%}

%{
folder = 'D:\matlab_data\diao-li-qing\';
[Gray,infolist] = read(folder);
slope = infolist(1).RescaleSlope;
intercept = infolist(1).RescaleIntercept;
CT = Gray * slope + intercept;
[x,y,z] = size(CT);
save Volume CT slope intercept infolist;

load Volume;
options.BlackWhite = false;
options.FrangiScaleRange = [2 8];
options.FrangiScaleRatio = 2;
[FValue,Scale]=FrangiFilter3D(CT,options);
Max = max(max(max(FValue)));
FValue = FValue / Max;
save Filter FValue;
%}

BW_Label = bwlabeln(FValue > 0.3);
[BW_aorta,label_left,label_right] = findAorta(CT,BW_Label);
if (label_left == -1 || label_right == -1)
    disp('fail');
    return;
end
save BW_Filter BW_aorta BW_Label;

BW = BW_aorta | (BW_Label == label_left) | (BW_Label == label_right);
MeanL = mean(mean(mean((FValue(BW_Label == label_left)))));
MeanLScale = mean(mean(mean((Scale(BW_Label == label_left)))));
MeanR = mean(mean(mean((FValue(BW_Label == label_right)))));
MeanRScale = mean(mean(mean((Scale(BW_Label == label_right)))));
