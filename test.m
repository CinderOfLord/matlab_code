
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


folder = 'D:\matlab_data\fang-guo-quan\';
[Gray,infolist] = read(folder);
slope = infolist(1).RescaleSlope;
intercept = infolist(1).RescaleIntercept;
CT = Gray * slope + intercept;
CT = imresize3(CT,0.5);
[x,y,z] = size(CT);
save Volume CT slope intercept infolist;

[BW_aorta,spoint] = findAorta(CT);