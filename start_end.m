%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�ҵ��Ĵ����Ŀ�ʼʱ��ͽ���ʱ��
function [start_position end_position] = start_end(each_subject)
[Row,column] = size(each_subject);
if Row > column
    each_subject = each_subject';%��������ת��Ϊ������
end
length_subject = length(each_subject);
each_diff = diff(each_subject);
start_position = find(each_diff == 1) + 1;
end_position = find(each_diff == -1);
if each_subject(1) == 1  
   %��each_subject��һ������1����ô��һ���Ĵ����Ŀ�ʼ����Ϊ1
    start_position = [1,start_position];
end
if each_subject(end) == 1 
    %��each_subjec�����һ������1����ô���һ���Ĵ����Ľ�������Ϊlength_subject
    end_position = [end_position,length_subject];  
end
end