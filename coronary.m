folder = 'D:\matlab_data\diao-li-qing\';
[Gray,infolist] = read(folder);
slope = infolist(1).RescaleSlope;
intercept = infolist(1).RescaleIntercept;
CT = Gray * slope + intercept;
CT = imresize3(CT,0.5);
[x,y,z] = size(CT);
save Volume CT slope intercept infolist;


load Volume;
options.BlackWhite = false;
options.FrangiScaleRange = [0.3 0.9];
options.FrangiScaleRatio = 0.2;
[FValue,Scale]=FrangiFilter3D(CT,options);
Max = max(max(max(FValue)));
FValue = FValue / Max;
save Filter FValue;

BW_Label = bwlabeln(FValue > 0.25);
[BW_aorta,label_left,label_right] = findAorta(CT,BW_Label);
if (label_left == -1 || label_right == -1)
    disp('fail');
    return;
end
