
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
CT = imresize3(CT,0.5);
[x,y,z] = size(CT);
save Volume CT slope intercept infolist;


load Volume;
options.BlackWhite = false;
options.FrangiScaleRange = [0.3 0.9];
options.FrangiScaleRatio = 0.2;
[FValue]=FrangiFilter3D(CT,options);
save Filter FValue;

BW_Label = bwlabeln(FValue > 0.1);
[BW_aorta,label_left,label_right] = findAorta(CT,BW_Label);
if (label_left == -1 || label_right == -1)
    disp('fail');
    return;
end
BW = BW_aorta | (BW_Label == label_left) | (BW_Label == label_right);
%}

ct3wei(BW * 400);