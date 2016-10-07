function spindle_detection_MP_250
warning off all
prefile = spm_select(1, 'dir', 'Select imported EEG file','' ...
    ,pwd,'.*');

%%  参数读取
% num_subj = 30;                                                 %% 读取被试人数；
h=waitbar(0,'Please waiting...');
fs = 250;                         %% 采样频率；
ds = 2;                              %% 下采样比例（默认4）；
d_fs = fs/ds;                                                               %% 计算下采样后的采样率；
N = 1024;                               %% 读取每次分解的信号点数，默认
load('GaborAtom_1024.mat');                    %% 读取原子库；                                                                %% 释放不再使用的存储空间；
ep = 0.05;                                                                  %% 信号重构残差截止阈值；
H_psd = 16;                            %% 读取定义spindle的最高频率；
L_psd = 9;                             %% 读取定义spindle的最低频率；
TH1 = 7.5;                                 %% 读取定义的spindle幅度阈值（大于7.5）；
S_duration = 0.5;                           %% 读取定义spindle的最短持续时间；
L_duration = 2;                           %% 读取定义spindle的最长持续时间；
Hd = kaiser_filter;
bbb = Hd.Numerator;
number_channel = 19;
%%  数据读取和计算
total_len = 0;
data_path=prefile;
data_dir=dir(prefile);
num_subj=length(data_dir);
number_segment = zeros(1,num_subj-2);
for subj_i = 3:num_subj
    subj_name = data_dir(subj_i).name; % （subj_name：当前被试的名字）
    subj_dir_path = [data_path,subj_name]; % （subj_dir_path：当前被试文件夹的路径）
    subj_dir = dir(subj_dir_path);
    number_segment(subj_i-2) = length(subj_dir)-2;
end
total_step = sum(number_segment)*number_channel;
n = 0;
for subj_i = 3:num_subj    % 对被试的循环 所以要从3开始
    subj_name = data_dir(subj_i).name; % （subj_name：当前被试的名字）
    subj_dir_path = [data_path,subj_name]; % （subj_dir_path：当前被试文件夹的路径）
    subj_dir = dir(subj_dir_path);
    for sub_matj = 3:length( subj_dir)  %%对mat文件的循环
        spindle_num = zeros(1,number_channel);
        data_len = 0; 
        load([subj_dir_path,'\',subj_dir(sub_matj).name]);
        SigLen = size(b,2);
        data = b; % 将当前数据不能被unit_num整除的部分从最后去掉
        left_data = [data(1:2:11,:);data(18:2:20,:)];
        right_data = [data(2:2:12,:);data(19:2:21,:)];
        middle_data = data(13:15,:);
        left_data = left_data-ones(size(left_data,1),1)*data(17,:);
        right_data = right_data-ones(size(right_data,1),1)*data(16,:);
        middle_data = middle_data-ones(size(middle_data,1),1)*mean(data(16:17,:),1);
        data_all = [left_data;right_data;middle_data];
        data_all_medi = zeros(size(data_all,1),size(data_all,2));
        data_all_medi(1:2:11,:) = left_data(1:6,:);
        data_all_medi(2:2:12,:) = right_data(1:6,:);
        data_all_medi(13:15,:) = middle_data;
        data_all_medi(16:2:18,:) = left_data(7:8,:);
        data_all_medi(17:2:19,:) = right_data(7:8,:);
        data_all = data_all_medi;     
        data_matrix = data_all;
        clear data_all_medi;  
        detection = zeros(number_channel,SigLen);
        decimate_data = decimate(data_matrix(1,:),ds);
        data_dowsample = zeros(size(data_matrix,1),length(decimate_data));
        for channel = 1:size(data_matrix,1)
            data_dowsample(channel,:) = decimate(data_matrix(channel,:),ds);%降采样
        end
        data_matrix = data_dowsample;
        SigLen_vailid = size(data_matrix,2)-mod(size(data_matrix,2),N);  %% 计算数据长度中能被数据单元整除的部分；
        data_19channels = data_matrix(:,1:SigLen_vailid);  %% 将当前数据不能被计算单元整除的部分从最后去掉；
        clear data_matrix;                                                  %% 释放不再使用的存储空间；
        num_cc = SigLen/N;
        data_len = data_len + num_cc;           %% 初始化为：data_len = zeros(1,num_subj)；
        data_filter = filtfilt(bbb,1,data_19channels');                       %% 对数据进行35Hz的低通滤波；
        clear data_10channels;
        data_tran = reshape(data_filter,N,num_cc,[]);                  %% 将数据转换为三维：N行*num_cc列*10层
        clear data_filter;        
        for chs = 1:number_channel
            n = n+1;
            spindle_frequency = [];
            spindle_amplitude = [];
            spindle_duration = [];
            spindle_data = zeros(1,N);
            spindle_atom = zeros(1,N);
            spindle_marker = zeros(1,N);
            for len = 1:num_cc               
                x_xdata = data_tran(:,len,chs)';
                [g_atomCoe_totle,g_atom,a,x_error] = matchPursuit(x_xdata,g,ep);
                [N1,M1] = size(g_atom);                                     %% N代表分解后选择原子的个数，M表示每个原子的长度
                for i = 1:N1
                    g_atom(i,:) = g_atom(i,:)*g_atomCoe_totle(i);
                    [atom_peak,index_atom] = findpeaks(g_atom(i,:));
                    if numel(atom_peak) < 2
                        continue;
                    end
                    yu = abs(fftshift(fft(g_atom(i,:)))).^2;               %% 周期图计算原子能量谱（正负半轴各N/2个点）；
                    yu1 = yu(N/2+1:end);                                   %% 只要正半轴的N/2个点，对应频率：0Hz 到 (N/2-1)/(N/d_fs) Hz;
                    [yu1_peak,index1] = findpeaks(yu1);                    %% 计算能量谱的峰值
                    if isempty(index1)                                     %% 检测是否有峰值，如没有峰值，计算下一个原子；
                        continue;
                    end
                    [yu1_max,index2] = max(yu1_peak);                      %% 计算能量谱的最大峰值
                    index = index1(index2);
                    index_tran0 = ((0:N-1)-N/2)*(d_fs/N);
                    index_tran = index_tran0(N/2+1:end);
                    if (index_tran(index) >= L_psd) && (index_tran(index) <= H_psd)   %% 检测能量谱的最大峰值是否在spindle频带范围内
                        B = find(g_atom(i,:) >= TH1);
                        if isempty(B)
                            continue;
                        end
                        duration = (B(end) - B(1))/d_fs;
                        if duration >= S_duration && duration <= L_duration
                            marker_s = zeros(1,N);
                            spindle_num(chs) = spindle_num(chs) +1;        %% 初始化为：spindle_num = zeros(10,num_subj);
                            spindle_frequency(spindle_num(chs)) = index_tran(index);%纺锤波频率
                            spindle_amplitude(spindle_num(chs)) = 2*max(atom_peak);%纺锤波振幅
                            spindle_duration(spindle_num(chs)) = duration;%纺锤波持续时间
                            marker_s(B(1):B(end)) = 1;
                            spd_st=(B(1)+N*(len-1)-1)*ds;
                            spd_ed=(B(end)+N*(len-1)-1)*ds;
                            detection(chs,spd_st:spd_ed)=1;%0,1
                            spindle_data(spindle_num(chs),:) = x_xdata;
                            spindle_atom(spindle_num(chs),:) = g_atom(i,:);
                            spindle_marker(spindle_num(chs),:) = marker_s;                         
                        end
                    end
                end 
            end
            spindle_parameter(chs) = struct('spindle_frequency',spindle_frequency,'spindle_amplitude',spindle_amplitude,...
                'spindle_duration',spindle_duration,'spindle_data',spindle_data,'spindle_atom',spindle_atom,'spindle_marker',spindle_marker);
            i = n/total_step;
            waitbar(i,h,['已完成' num2str(i*100) '%']);
        end
        spindle_density = spindle_num./(data_len*N/d_fs/60);
        spindle_results_segment(sub_matj-2) = struct('spindle_parameter',spindle_parameter,...
            'detection',detection,'spindle_num',spindle_num,'data_len',data_len,'spindle_density',spindle_density);
        total_len = total_len + data_len;
    end
    spindle_result_all(subj_i-2) = struct('spindle_results_segment',spindle_results_segment); 
end
index = find(prefile,'\');
mp_path = prefile(1:index(end));
mkdir([mp_path,'MP_results_250']);
str_path = [mp_path,'MP_results_250\'];
save([str_path,'Spindle_result_MP_250.mat'],'spindle_result_all','-v7.3');    
close(h);
end
%% -----------------------------------------------------
function [g_atomCoe_totle,g_atom,a,x_error] = matchPursuit(x,g,ep)
%% 进行匹配追踪
% num = size(g,1);
num = 1000;
[row,colomn] = size(x);
if row > colomn
    x = x';
end
x_error = x;
g_atom = zeros(num,colomn);
g_atomCoe_totle = zeros(1,num);
a = zeros(1,num);
for m = 1:num
    inner_product = g*x_error';%将数据和原子做内积，取数值最大
    [inner_max_abs,index] = max(abs(inner_product));
    g_atom(m,:) = g(index,:);%每次迭代后得到的原子
    g_atomCoe_totle(m) = inner_product(index);%每次迭代的内积系数
    x_error = x_error - inner_product(index).*g(index,:);%残差
    a(m) = (norm(x_error)^2)/(norm(x)^2);
    if a(m) < ep %
        break;
    end
end
g_atom = g_atom(1:m,:);
g_atomCoe_totle = g_atomCoe_totle(1:m);
a = a(1:m);
end
%%
function Hd = kaiser_filter
%UNTITLED Returns a discrete-time filter object.

%
% MATLAB Code
% Generated by MATLAB(R) 7.14 and the Signal Processing Toolbox 6.17.
%
% Generated on: 16-Sep-2015 20:04:24
%

% FIR Window Bandpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 250;  % Sampling Frequency

N    = 830;      % Order
Fc1  = 0.3;      % First Cutoff Frequency
Fc2  = 35;       % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
Beta = 10;       % Window Parameter
% Create the window vector for the design algorithm.
win = kaiser(N+1, Beta);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);

% [EOF]

end


