function PSD_N2_chunk_250
close all;
clear all;
prefile = spm_select(1, 'dir', 'Select PSD-data of EEG file','' ...
            ,pwd,'.*');
index = find(prefile == '\');
index_find = index(end-1);
excel_path = prefile(1:index_find);
filename = 'N2_chunk-cylce.xlsx';
exceldata = xlsread([excel_path,filename]);
newfile_name_path = [excel_path,'N2_chunk_result_psd-data']; %����result_psd-data
mkdir(newfile_name_path); %��PSD��data�ļ����´����µ��ļ���N2_chunk-data-psd,��������psd���ݴ���
hwait=waitbar(0,'Please waiting...');   
fs = 250;%������
unit_s = 4;   %�Զ���������ݽ��м��㣬Ĭ��4s
unit_num = fs*unit_s;  %%����ÿ��Ƶ�ʼ���ĵ�����Ĭ��250*4 = 1000��
num_subject = length(exceldata); %���Եĸ���
cycle_num = zeros(num_subject,1); %ÿ���˵����ڸ���
sum_subj_mat = zeros(num_subject,1);%ÿ���˵�mat����
exceldata_NaN = isnan(exceldata); %�ж�excel����ֵ�Ƿ���NaN
for subj_i= 1:num_subject  %��ÿ������ѭ��
    cycle_num(subj_i) = length(find(exceldata_NaN(subj_i,:)==0)); %%ÿ���˵����ڸ��� 56*1   
    sum_subj_mat(subj_i,1) = sum(exceldata(subj_i,1:cycle_num(subj_i)),2); %ÿ���˵�mat�ܸ���
    % ��ȡN2_chunk-data �б��Ե�mat�ļ�  oo1-caofurong  19��mat
    subj_dir=dir(prefile); %N2_chunk-data�����ļ��еĽṹ��
    subj_name = subj_dir(subj_i+2).name; %��ǰ���Ե�����  001-caofurong
    subj_dir_path = [prefile,subj_name]; %��ǰ�����ļ��е�·��  E:\PSD-data\N2_chunk-data\001-caofurong
    subj_mat = dir([subj_dir_path,'\','*.mat']); %��ǰ�����ļ��еĽṹ�� 001-caofurong��struct  19*1 struct
    subj_cycle_num = cycle_num(subj_i);  %ÿ���˵�������
    cycle_all_mat_mean_psd = cell(subj_cycle_num,1); %�洢ÿ���˸������ڵ�ƽ��������
    %��result_psd-data�ļ����´���001-caorurong�ļ���
    result_subj_data_psd_path = [newfile_name_path,'\',subj_name];
    mkdir(result_subj_data_psd_path); %��result_psd-data�ļ����´����µ��ļ���001-caofurong���洢�������Ե�psd   
    for subj_cycle_i =1:cycle_num(subj_i) %��ÿ��ÿ�����ڵ�ѭ��
        subj_cycle_mat_num = exceldata(subj_i,subj_cycle_i); %�洢��һ���˵�һ�����ڵ�mat�� 9��
        each_subj_cycle = exceldata(subj_i,:); %�洢��һ���˸������ڵ�mat��
        each_cycle_mat_num = zeros(1,subj_cycle_mat_num); %�洢ÿһ��mat���nuit_num����
        each_mat_mean_psd = zeros(unit_num,subj_cycle_mat_num,19);  %��ÿ��4s��ƽ�� 1000*9*19
        each_cycle_mat_raw_psd = cell(subj_cycle_mat_num,1);  
        i = 0; %Ϊeach_cycle_mat_num = zeros(1,subj_cycle_mat_num)����
        if subj_cycle_i == 1;
            for subj_cycle_mat_i = 1:exceldata(subj_i,subj_cycle_i)  %�Ե�ǰ���Ե�һ�������е�mat������ѭ��
                [i,each_mat_mean_psd,each_cycle_mat_num,each_cycle_mat_raw_psd] = cycle_mat_psd(i,each_cycle_mat_num,subj_cycle_i,subj_dir_path,subj_mat,subj_cycle_mat_i,unit_num,result_subj_data_psd_path,each_cycle_mat_raw_psd);
            end
                subj_cycle_psd_1 = reshape(each_mat_mean_psd,size(each_mat_mean_psd,1),[]);  %����ǰmat��psd����άת��Ϊ��ά
                subj_cycle_psd_1_L = repmat(each_cycle_mat_num,size(subj_cycle_psd_1,1),size(subj_cycle_psd_1,2)/subj_cycle_mat_num); %�������ݶεĳ��Ⱦ����Ƴ�����sum_subj_cycle_psd�Ĵ�С
                subj_cycle_psd_2 = reshape(subj_cycle_psd_1.*subj_cycle_psd_1_L,size(subj_cycle_psd_1,1),subj_cycle_mat_num,[]); %�������ݶε�ƽ�������ף��������Ȩ�صĹ�������Ϣ����Ϊ��ά
                cycle_unit_length = sum(each_cycle_mat_num); %���㵱ǰ����ȫ��mat���ܳ��ȣ����ж��ٸ�unit_num
                cycle_mean_psd = reshape(sum(subj_cycle_psd_2,2)/cycle_unit_length,size(subj_cycle_psd_2,1),[]); %���㵱ǰ����ȫ��mat���ݵ�ƽ�������ף���ά
        else
            for subj_cycle_mat_i = sum(exceldata(subj_i,1:subj_cycle_i-1))+1:sum(exceldata(subj_i,1:subj_cycle_i)) %�Ե�ǰ���Ե�һ������֮���mat������ѭ��
                [i,each_mat_mean_psd,each_cycle_mat_num,each_cycle_mat_raw_psd] = cycle_mat_psd(i,each_cycle_mat_num,subj_cycle_i,subj_dir_path,subj_mat,subj_cycle_mat_i,unit_num,result_subj_data_psd_path,each_cycle_mat_raw_psd);
            end
                subj_cycle_psd_1 = reshape(each_mat_mean_psd,size(each_mat_mean_psd,1),[]);  %����ǰmat��psd����άת��Ϊ��ά
                subj_cycle_psd_1_L = repmat(each_cycle_mat_num,size(subj_cycle_psd_1,1),size(subj_cycle_psd_1,2)/subj_cycle_mat_num); %�������ݶεĳ��Ⱦ����Ƴ�����sum_subj_cycle_psd�Ĵ�С
                subj_cycle_psd_2 = reshape(subj_cycle_psd_1.*subj_cycle_psd_1_L,size(subj_cycle_psd_1,1),subj_cycle_mat_num,[]); %�������ݶε�ƽ�������ף��������Ȩ�صĹ�������Ϣ����Ϊ��ά
                cycle_unit_length = sum(each_cycle_mat_num); %���㵱ǰ����ȫ��mat���ܳ��ȣ����ж��ٸ�unit_num
                cycle_mean_psd = reshape(sum(subj_cycle_psd_2,2)/cycle_unit_length,size(subj_cycle_psd_2,1),[]); %���㵱ǰ����ȫ��mat���ݵ�ƽ�������ף���ά
        end
        savefile1 = [result_subj_data_psd_path,'\',subj_name,'_psd.mat']; %�洢·�� E:\PSD-data\result_psd-data\001-caofurong\oo1-caofurong-psd.mat
        cycle_all_mat_mean_psd(subj_cycle_i,1) = {cycle_mean_psd}; %ÿ���˸������ڵ�ƽ��������    4*1  cell
        save(savefile1,'each_subj_cycle','subj_cycle_num','cycle_all_mat_mean_psd');                       
    end 
    Perstr = subj_i/num_subject;
    str = ['�����',num2str(Perstr*100),'%'];
    waitbar(Perstr,hwait,str);
end
close(hwait);
end



%%

function [i,each_mat_mean_psd,each_cycle_mat_num,each_cycle_mat_raw_psd] = cycle_mat_psd(i,each_cycle_mat_num,subj_cycle_i,subj_dir_path,subj_mat,subj_cycle_mat_i,unit_num,result_subj_data_psd_path,each_cycle_mat_raw_psd)
subj_cycle_mat_path = [subj_dir_path,'\',subj_mat(subj_cycle_mat_i).name]; %��ǰ���Ե�һ�����ڵ�subj_cycle_mat_i��mat��·��  E:\PSD-data\N2_chunk-data\001-caofurong\01.mat
load(subj_cycle_mat_path);
subj_cycle_mat_orgn_data = b(1:21,:); %load��ԭʼ����  19���缫
subj_cycle_mat_orgn_length = size(subj_cycle_mat_orgn_data,2);%ԭʼ���ݵĳ���
i = i+1;

subj_cycle_mat_length = subj_cycle_mat_orgn_length-mod(subj_cycle_mat_orgn_length,unit_num);%�������ݳ������ܱ�unit_num�����Ĳ���
subj_cycle_mat_1 = subj_cycle_mat_orgn_data(:,1:subj_cycle_mat_length); %����ǰ�����в��ܱ�unit_num�����Ĳ��ִ����ȥ��
subj_cycle_mat_2 = zeros(19,subj_cycle_mat_length); %subj_cycle_mat_2��subj_cycle_mat_1-�ο���ѹ���� 19*457000
subj_cycle_mat_2(1,:) = subj_cycle_mat_1(1,:)-subj_cycle_mat_1(17,:); %FP1�����A2���ź�
subj_cycle_mat_2(2,:) = subj_cycle_mat_1(2,:)-subj_cycle_mat_1(16,:); %FP2�����A1���ź�
subj_cycle_mat_2(3,:) = subj_cycle_mat_1(3,:)-subj_cycle_mat_1(17,:); %F3�����A2���ź�
subj_cycle_mat_2(4,:) = subj_cycle_mat_1(4,:)-subj_cycle_mat_1(16,:); %F4�����A1���ź�
subj_cycle_mat_2(5,:) = subj_cycle_mat_1(5,:)-subj_cycle_mat_1(17,:); %C3�����A2���ź�
subj_cycle_mat_2(6,:) = subj_cycle_mat_1(6,:)-subj_cycle_mat_1(16,:); %C4�����A1���ź�
subj_cycle_mat_2(7,:) = subj_cycle_mat_1(7,:)-subj_cycle_mat_1(17,:); %P3�����A2���ź�
subj_cycle_mat_2(8,:) = subj_cycle_mat_1(8,:)-subj_cycle_mat_1(16,:); %P4�����A1���ź�
subj_cycle_mat_2(9,:) = subj_cycle_mat_1(9,:)-subj_cycle_mat_1(17,:); %O1�����A2���ź�
subj_cycle_mat_2(10,:) = subj_cycle_mat_1(10,:)-subj_cycle_mat_1(16,:); %O2�����A1���ź�
subj_cycle_mat_2(11,:) = subj_cycle_mat_1(11,:)-subj_cycle_mat_1(17,:); %F7�����A2���ź�
subj_cycle_mat_2(12,:) = subj_cycle_mat_1(12,:)-subj_cycle_mat_1(16,:); %F8�����A1���ź�
subj_cycle_mat_2(13,:) = subj_cycle_mat_1(13,:)-mean(subj_cycle_mat_1(16:17,:),1); %Fz�����A1��A2ƽ�����ź�
subj_cycle_mat_2(14,:) = subj_cycle_mat_1(14,:)-mean(subj_cycle_mat_1(16:17,:),1); %Cz�����A1��A2ƽ�����ź�
subj_cycle_mat_2(15,:) = subj_cycle_mat_1(15,:)-mean(subj_cycle_mat_1(16:17,:),1); %Pz�����A1��A2ƽ�����ź�
subj_cycle_mat_2(16,:) = subj_cycle_mat_1(18,:)-subj_cycle_mat_1(17,:); %T3�����A2���ź�
subj_cycle_mat_2(17,:) = subj_cycle_mat_1(19,:)-subj_cycle_mat_1(16,:); %T4�����A1���ź�
subj_cycle_mat_2(18,:) = subj_cycle_mat_1(20,:)-subj_cycle_mat_1(17,:); %T5�����A2���ź�
subj_cycle_mat_2(19,:) = subj_cycle_mat_1(21,:)-subj_cycle_mat_1(16,:); %T6�����A1���ź�
clear subj_cycle_mat_orgn_data;
clear subj_cycle_mat_1;

subj_cycle_mat_3 = reshape(subj_cycle_mat_2',unit_num,[]); %�����ݽ���ά��ת��������һ���Խ��й����׼���  1000*3705=19��(1000*195)
clear subj_cycle_mat_2;

subj_cycle_fft = fft(subj_cycle_mat_3,unit_num);  %��fft  1000*3705=19��(1000*195)
subj_cycle_mat_psd = subj_cycle_fft.*conj(subj_cycle_fft)/(unit_num); %��ǰmat�Ĺ�����   1000*3705=19��(1000*195)

each_mat_raw_psd = reshape(subj_cycle_mat_psd,size(subj_cycle_mat_psd,1),size(subj_cycle_mat_psd,2)/19,19);  %ÿ��mat��ԭʼ��psd
each_cycle_mat_num(i) = size(subj_cycle_mat_3,2)/19; %�洢��ǰ������mat��unit_num��  1*9 
result_mat_psd = reshape(subj_cycle_mat_psd,size(subj_cycle_mat_psd,1),size(subj_cycle_mat_psd,2)/19,19); %��������ת������ά  1000*unit_num����*�缫
each_mat_mean_psd(:,i,:) = mean(result_mat_psd,2);  %��ÿ��4s��ƽ��    1000*9*19

savefile2 = ['cycle','_',num2str(subj_cycle_i),'_mat_raw_psd.mat']; %��ÿ���˸�����������mat��ԭʼpsd�浽�ļ���Ϊ cycle-(subj_cycle_i)_mat_psd.mat
savefile3 = [result_subj_data_psd_path,'\',savefile2];
each_cycle_mat_raw_psd(i) = {each_mat_raw_psd};  %ÿ����ÿ������������mat��ԭʼpsd  ��һ������ 9*1���ڶ������� 3*1
save(savefile3,'each_cycle_mat_raw_psd'); %��oo1-caofurong_psd.mat �´�� each_cycle_all_mat_raw_psd
end

        