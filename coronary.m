

%read dicom files and downsample
folder = 'D:\matlab_data\bai-shan-lin\';
[Gray,infolist] = read(folder);
slope = infolist(1).RescaleSlope;
intercept = infolist(1).RescaleIntercept;
CT = Gray * slope + intercept;
CT = imresize3(CT,0.5);
[x,y,z] = size(CT);
save Volume CT slope intercept infolist;

%Hessian Filter
load Volume;
options.BlackWhite = false;
options.FrangiScaleRange = [0.3 0.9];
options.FrangiScaleRatio = 0.2;
[FValue]=FrangiFilter3D(CT,options);
save Filter FValue;

%get best 10 point pair
BW_Label = Label_Sort(FValue > 0.1,CT);
save BW_Filter BW_Label;


%calc the best point pair
load Volume;
[BW_Filter,Found] = calc_best_pair(BW_Label,CT);
save BW_Filter BW_Label BW_Filter;

