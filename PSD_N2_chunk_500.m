function PSD_N2_chunk_500
close all;
clear all;
prefile = spm_select(1, 'dir', 'Select PSD-data of EEG file','' ...
            ,pwd,'.*');
index = find(prefile == '\');
index_find = index(end-1);
excel_path = prefile(1:index_find);
filename = 'N2_chunk-cylce.xlsx';
exceldata = xlsread([excel_path,filename]);
newfile_name_path = [excel_path,'N2_chunk_result_psd-data']; %创建result_psd-data
mkdir(newfile_name_path); %在PSD—data文件夹下创建新的文件夹N2_chunk-data-psd,将处理后的psd数据存入
hwait=waitbar(0,'Please waiting...');   
fs = 500;%采样率
unit_s = 4;   %对多少秒的数据进行计算，默认4s
unit_num = fs*unit_s;  %%计算每次频率计算的点数，默认500*4 = 2000个
num_subject = length(exceldata); %被试的个数
cycle_num = zeros(num_subject,1); %每个人的周期个数
sum_subj_mat = zeros(num_subject,1);%每个人的mat个数
exceldata_NaN = isnan(exceldata); %判断excel中数值是否是NaN
for subj_i= 1:num_subject  %对每个被试循环
    cycle_num(subj_i) = length(find(exceldata_NaN(subj_i,:)==0)); %%每个人的周期个数 56*1   
    sum_subj_mat(subj_i,1) = sum(exceldata(subj_i,1:cycle_num(subj_i)),2); %每个人的mat总个数
    % 提取N2_chunk-data 中被试的mat文件  oo1-caofurong  19个mat
    subj_dir=dir(prefile); %N2_chunk-data数据文件夹的结构体
    subj_name = subj_dir(subj_i+2).name; %当前被试的名字  001-caofurong
    subj_dir_path = [prefile,subj_name]; %当前被试文件夹的路径  E:\PSD-data\N2_chunk-data\001-caofurong
    subj_mat = dir([subj_dir_path,'\','*.mat']); %当前被试文件夹的结构体 001-caofurong下struct  19*1 struct
    subj_cycle_num = cycle_num(subj_i);  %每个人的周期数
    cycle_all_mat_mean_psd = cell(subj_cycle_num,1); %存储每个人各个周期的平均功率谱
    %在result_psd-data文件夹下创建001-caorurong文件夹
    result_subj_data_psd_path = [newfile_name_path,'\',subj_name];
    mkdir(result_subj_data_psd_path); %在result_psd-data文件夹下创建新的文件夹001-caofurong，存储各个被试的psd   
    for subj_cycle_i =1:cycle_num(subj_i) %对每人每个周期的循环
        subj_cycle_mat_num = exceldata(subj_i,subj_cycle_i); %存储第一个人第一个周期的mat数 9个
        each_subj_cycle = exceldata(subj_i,:); %存储第一个人各个周期的mat数
        each_cycle_mat_num = zeros(1,subj_cycle_mat_num); %存储每一个mat里的nuit_num个数
        each_mat_mean_psd = zeros(unit_num,subj_cycle_mat_num,10);  %对每个4s求平均 2000*9*10
        each_cycle_mat_raw_psd = cell(subj_cycle_mat_num,1);  
        i = 0; %为each_cycle_mat_num = zeros(1,subj_cycle_mat_num)服务
        if subj_cycle_i == 1;
            for subj_cycle_mat_i = 1:exceldata(subj_i,subj_cycle_i)  %对当前被试第一个周期中的mat数进行循环
                [i,each_mat_mean_psd,each_cycle_mat_num,each_cycle_mat_raw_psd] = cycle_mat_psd(i,each_cycle_mat_num,subj_cycle_i,subj_dir_path,subj_mat,subj_cycle_mat_i,unit_num,result_subj_data_psd_path,each_cycle_mat_raw_psd);
            end
                subj_cycle_psd_1 = reshape(each_mat_mean_psd,size(each_mat_mean_psd,1),[]);  %将当前mat的psd由三维转存为二维
                subj_cycle_psd_1_L = repmat(each_cycle_mat_num,size(subj_cycle_psd_1,1),size(subj_cycle_psd_1,2)/subj_cycle_mat_num); %将各数据段的长度矩阵复制成上面sum_subj_cycle_psd的大小
                subj_cycle_psd_2 = reshape(subj_cycle_psd_1.*subj_cycle_psd_1_L,size(subj_cycle_psd_1,1),subj_cycle_mat_num,[]); %将各数据段的平均功率谱，构造带有权重的功率谱信息，存为三维
                cycle_unit_length = sum(each_cycle_mat_num); %计算当前周期全部mat的总长度，即有多少个unit_num
                cycle_mean_psd = reshape(sum(subj_cycle_psd_2,2)/cycle_unit_length,size(subj_cycle_psd_2,1),[]); %计算当前周期全部mat数据的平均功率谱，二维
        else
            for subj_cycle_mat_i = sum(exceldata(subj_i,1:subj_cycle_i-1))+1:sum(exceldata(subj_i,1:subj_cycle_i)) %对当前被试第一个周期之后的mat数进行循环
                [i,each_mat_mean_psd,each_cycle_mat_num,each_cycle_mat_raw_psd] = cycle_mat_psd(i,each_cycle_mat_num,subj_cycle_i,subj_dir_path,subj_mat,subj_cycle_mat_i,unit_num,result_subj_data_psd_path,each_cycle_mat_raw_psd);
            end
                subj_cycle_psd_1 = reshape(each_mat_mean_psd,size(each_mat_mean_psd,1),[]);  %将当前mat的psd由三维转存为二维
                subj_cycle_psd_1_L = repmat(each_cycle_mat_num,size(subj_cycle_psd_1,1),size(subj_cycle_psd_1,2)/subj_cycle_mat_num); %将各数据段的长度矩阵复制成上面sum_subj_cycle_psd的大小
                subj_cycle_psd_2 = reshape(subj_cycle_psd_1.*subj_cycle_psd_1_L,size(subj_cycle_psd_1,1),subj_cycle_mat_num,[]); %将各数据段的平均功率谱，构造带有权重的功率谱信息，存为三维
                cycle_unit_length = sum(each_cycle_mat_num); %计算当前周期全部mat的总长度，即有多少个unit_num
                cycle_mean_psd = reshape(sum(subj_cycle_psd_2,2)/cycle_unit_length,size(subj_cycle_psd_2,1),[]); %计算当前周期全部mat数据的平均功率谱，二维
        end
        savefile1 = [result_subj_data_psd_path,'\',subj_name,'_psd.mat']; %存储路径 E:\PSD-data\result_psd-data\001-caofurong\oo1-caofurong-psd.mat
        cycle_all_mat_mean_psd(subj_cycle_i,1) = {cycle_mean_psd}; %每个人各个周期的平均功率谱    4*1  cell
        save(savefile1,'each_subj_cycle','subj_cycle_num','cycle_all_mat_mean_psd');                       
    end 
    Perstr = subj_i/num_subject;
    str = ['已完成',num2str(Perstr*100),'%'];
    waitbar(Perstr,hwait,str);
end
close(hwait);
end



%%

function [i,each_mat_mean_psd,each_cycle_mat_num,each_cycle_mat_raw_psd] = cycle_mat_psd(i,each_cycle_mat_num,subj_cycle_i,subj_dir_path,subj_mat,subj_cycle_mat_i,unit_num,result_subj_data_psd_path,each_cycle_mat_raw_psd)
subj_cycle_mat_path = [subj_dir_path,'\',subj_mat(subj_cycle_mat_i).name]; %当前被试第一个周期第subj_cycle_mat_i个mat的路径  E:\PSD-data\N2_chunk-data\001-caofurong\01.mat
load(subj_cycle_mat_path);
subj_cycle_mat_orgn_data = b([1:10,29:30],:); %load的原始数据  10个电极
subj_cycle_mat_orgn_length = size(subj_cycle_mat_orgn_data,2);%原始数据的长度
i = i+1;

subj_cycle_mat_length = subj_cycle_mat_orgn_length-mod(subj_cycle_mat_orgn_length,unit_num);%计算数据长度中能被unit_num整除的部分
subj_cycle_mat_1 = subj_cycle_mat_orgn_data(:,1:subj_cycle_mat_length); %将当前数据中不能被unit_num整除的部分从最后去掉
subj_cycle_mat_2 = zeros(10,subj_cycle_mat_length); %subj_cycle_mat_2：subj_cycle_mat_1-参考电压数据 10*457000
subj_cycle_mat_2(1,:) = subj_cycle_mat_1(1,:)-subj_cycle_mat_1(30,:); %FP1相对于乳突的信号
subj_cycle_mat_2(2,:) = subj_cycle_mat_1(2,:)-subj_cycle_mat_1(29,:); %FP2相对于乳突的信号
subj_cycle_mat_2(3,:) = subj_cycle_mat_1(3,:)-subj_cycle_mat_1(30,:); %F3相对于乳突的信号
subj_cycle_mat_2(4,:) = subj_cycle_mat_1(4,:)-subj_cycle_mat_1(29,:); %F4相对于乳突的信号
subj_cycle_mat_2(5,:) = subj_cycle_mat_1(5,:)-subj_cycle_mat_1(30,:); %C3相对于乳突的信号
subj_cycle_mat_2(6,:) = subj_cycle_mat_1(6,:)-subj_cycle_mat_1(29,:); %C4相对于乳突的信号
subj_cycle_mat_2(7,:) = subj_cycle_mat_1(7,:)-subj_cycle_mat_1(30,:); %P3相对于乳突的信号
subj_cycle_mat_2(8,:) = subj_cycle_mat_1(8,:)-subj_cycle_mat_1(29,:); %P4相对于乳突的信号
subj_cycle_mat_2(9,:) = subj_cycle_mat_1(9,:)-subj_cycle_mat_1(30,:); %O1相对于乳突的信号
subj_cycle_mat_2(10,:) = subj_cycle_mat_1(10,:)-subj_cycle_mat_1(29,:); %O2相对于乳突的信号
clear subj_cycle_mat_orgn_data;
clear subj_cycle_mat_1;

subj_cycle_mat_3 = reshape(subj_cycle_mat_2',unit_num,[]); %对数据进行维度转换，便于一次性进行功率谱计算  
clear subj_cycle_mat_2;

subj_cycle_fft = fft(subj_cycle_mat_3,unit_num);  %求fft  
subj_cycle_mat_psd = subj_cycle_fft.*conj(subj_cycle_fft)/(unit_num); %当前mat的功率谱  

each_mat_raw_psd = reshape(subj_cycle_mat_psd,size(subj_cycle_mat_psd,1),size(subj_cycle_mat_psd,2)/10,10);  %每个mat最原始的psd
each_cycle_mat_num(i) = size(subj_cycle_mat_3,2)/10; %存储当前周期里mat的unit_num数  1*9 
result_mat_psd = reshape(subj_cycle_mat_psd,size(subj_cycle_mat_psd,1),size(subj_cycle_mat_psd,2)/10,10); %将功率谱转换成三维  2000*unit_num个数*电极
each_mat_mean_psd(:,i,:) = mean(result_mat_psd,2);  %对每个4s求平均    1000*9*10

savefile2 = ['cycle','_',num2str(subj_cycle_i),'_mat_raw_psd.mat']; %将每个人各个周期所有mat的原始psd存到文件名为 cycle-(subj_cycle_i)_mat_psd.mat
savefile3 = [result_subj_data_psd_path,'\',savefile2];
each_cycle_mat_raw_psd(i) = {each_mat_raw_psd};  %每个人每个周期中所有mat的原始psd  第一个周期 9*1，第二个周期 3*1
save(savefile3,'each_cycle_mat_raw_psd'); %在oo1-caofurong_psd.mat 下存放 each_cycle_all_mat_raw_psd
end

        