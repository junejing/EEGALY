%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%找到纺锤波的开始时间和结束时间
function [start_position end_position] = start_end(each_subject)
[Row,column] = size(each_subject);
if Row > column
    each_subject = each_subject';%将列向量转化为行向量
end
length_subject = length(each_subject);
each_diff = diff(each_subject);
start_position = find(each_diff == 1) + 1;
end_position = find(each_diff == -1);
if each_subject(1) == 1  
   %当each_subject第一个点是1，那么第一个纺锤波的开始点设为1
    start_position = [1,start_position];
end
if each_subject(end) == 1 
    %当each_subjec的最后一个点是1，那么最后一个纺锤波的结束点设为length_subject
    end_position = [end_position,length_subject];  
end
end