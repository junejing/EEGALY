function RMS_percentile_250

%%%%%%%%%%%%%%%%%%%%       滤波器参数    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = 250;  % Sampling Frequency    
%%% filter_design(Fs,Fstop1,Fpass1,Fpass2,Fstop2)    % 滤波器系数的计算，并存储系数 B
Hd = kasier_filter;
% load('B.mat'); 
B = Hd.Numerator;
prefile = spm_select(1, 'dir', 'Select imported EEG file','' ...
            ,pwd,'.*');

%%%%%%%%%%%%%%%%%%%%        参数       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
unit_num = 125;    %多少个点算一次rms
N2_dir_path = prefile;  % （N2_dir_path：所有被试的数据文件夹的路径）
N2_dir = dir(N2_dir_path); %（ N2_dir：N2数据文件夹的信息的结构体）
m = length(N2_dir); % m-2 为被试个数
percentile = 95;
%%%%%%%%%%%%%%%%%%%   rms, threshold   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h=waitbar(0,'Please waiting...');
number_segment = zeros(1,m-2);
for subj_i = 3:m
    subj_name = N2_dir(subj_i).name; % （subj_name：当前被试的名字）
    subj_dir_path = [N2_dir_path,subj_name]; % （subj_dir_path：当前被试文件夹的路径）
    subj_dir = dir(subj_dir_path);
    number_segment(subj_i-2) = length(subj_dir)-2;
end
total_step = sum(number_segment)*10;
n = 0;
for subj_i = 3:m     % 对被试的循环 (因为N2_dir的前两个是当前文件夹和上层文件夹，所以要从3开始)
    subj_name = N2_dir(subj_i).name; % （subj_name：当前被试的名字）
    subj_dir_path = [N2_dir_path,subj_name]; % （subj_dir_path：当前被试文件夹的路径）
    subj_dir = dir(subj_dir_path);
    for segment = 3:length(subj_dir)
        subj_dir_name = subj_dir(segment).name;
        load([subj_dir_path,'\',subj_dir_name]);
        mat_orgn_length = size(b,2);   % （mat_length：mat_orgn_data的长度）
        mat_length = mat_orgn_length-mod(mat_orgn_length,unit_num); % (mat_length:计算数据长度中能被unit_num整除的部分)
        data = b(:,1:mat_length); % 将当前数据不能被unit_num整除的部分从最后去掉
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
        mat_data_2 = data_all';
        clear data_all_medi;  
        mat_data_3 = filtfilt(B,1,mat_data_2); % 对mat_data_2进行滤波，得到10列数据；需要较长时间，所以save  mat_data_3。
        mat_data_4 = reshape(mat_data_3,unit_num,[],size(data_all,1)); % 对数据进行维度转换，便于一次性rms计算。
        each_mat_rms= rms(mat_data_4);
        each_mat_rms = reshape(each_mat_rms,[],size(data_all,1));
        detection = zeros(size(mat_data_3,1),size(mat_data_3,2));
        for channel = 1:size(each_mat_rms,2)
            n = n+1;
            Spd_amplitude = [];
            Spd_frequency = [];
            Spd_duration = [];
            thres = prctile(each_mat_rms(:,channel),percentile);
            rms_data_1 = (each_mat_rms(:,channel)>thres);
            res = lianxu_1(rms_data_1,unit_num,Fs);    % 计算连续1的位置和个数   
            if isempty(res)
                continue;
            else
                [spd_num,~] = size(res);%纺锤波个数    
                spindle_position=zeros(spd_num,2);%纺锤波的开始时间和结束时间
                for spd_i = 1:spd_num
                    st = res(spd_i,1);  % 计算rms纺锤波的起点index
                    ed =res(spd_i,1)+res(spd_i,2)-1;  % 计算rms纺锤波的结束index
                    st = (st-1)*unit_num+1;   % 换算纺锤波的起点index
                    ed = ed*unit_num;     % 换算纺锤波的结束index
                    detection(st:ed,channel)=1;
                    spindle_position(spd_i,:)=[st ed];
                    spd_data = mat_data_3(st:ed,channel);  %得到纺锤波数据
                    [pks_p,locs_p] = findpeaks(spd_data);  % 得到极大值
                    [pks_n,locs_n] = findpeaks(-spd_data);  %得到极小值
                    locs_p = st-1+locs_p;  %得到极大值在mat_data_3 的绝对index
                    locs_n = st-1+locs_n;  %得到极小值在mat_data_3 的绝对index
                    %%%%%%%%%%%%%%%     计算幅值   %%%%%%%%%%%%%%%%%%%%%%%%%
                    length_p = length(locs_p);
                    length_n = length(locs_n);
                    length_union = length_p+length_n;
                    pks_union = zeros(1,length_union);                    
                    if (locs_p(1)<locs_n(1))  % 极大值在前面
                        pks_union(1:2:end) = pks_p;
                        pks_union(2:2:end) = pks_n;    % 进行峰值的插缝拼接，便于计算pks-to-pks
                        pks_union_1 = [pks_union(2:end),0];   % 从第二个开始取
                        pks_union_2 = pks_union+pks_union_1;  %  计算 pks-to-pks
                        pks_union = pks_union_2(1:end-1);   % 取的实际的pks-to-pks
                        [amplitude,index_1] = max(pks_union);  % 得到最大的peak-to-peak                                               
                    else
                        pks_union(1:2:end) = pks_n;
                        pks_union(2:2:end) = pks_p;
                        pks_union_1 = [pks_union(2:end),0];
                        pks_union_2 = pks_union+pks_union_1;  %  计算 pks-to-pks
                        pks_union = pks_union_2(1:end-1);
                        [amplitude,index_1] = max(pks_union);  % 得到最大的peak-to-peak
                    end
                    Spd_amplitude = [Spd_amplitude,amplitude];
                    %%%%%%%%%%%%%%%%%%  计算频率  %%%%%%%%%%%%%%%%%
                    N=2*Fs;
                    FFT_data=abs(fft(spd_data,N)); 
                    freqs=(1:N/2)*Fs/N;
                    index_freq1 = find(freqs <= 11);
                    index_freq2 = find(freqs <= 16);
                    [pks,locs]=findpeaks(FFT_data(index_freq1(end):index_freq2(end)));
                    [~,pks_pos] = max(pks);
                    frequency = freqs(locs(pks_pos)+index_freq1(end)-1);
                    Spd_frequency = [Spd_frequency,frequency];
                    %%%%%%%%%%%%%%%%%  计算持续时间   %%%%%%%%%%%%%%%%%%%%%%%%%
                    duration = res(spd_i,2)*(unit_num/Fs);   %
                    Spd_duration = [Spd_duration,duration];
                end
            end
            Spd(channel).number = spd_num;
            Spd(channel).amplitude = Spd_amplitude;
            Spd(channel).posiiton = spindle_position;
            Spd(channel).frequency = Spd_frequency;
            Spd(channel).duration = Spd_duration; 
            i = n/total_step;
            waitbar(i,h,['已完成' num2str(i*100) '%']);
        end
        Spindle_segment(segment).detection = detection;
        Spindle_segment(segment).length = mat_length;
        Spindle_segment(segment).spindle = Spd;
    end
    mkdir([subj_dir_path,'\',subj_name]);
    subject_result_path = [subj_dir_path,'\',subj_name];
    save([subject_result_path,'\','spindle_result_',num2str(subj_i-2)],'Spindle_segment');
end
close(h);
end
%%%%%%%%%%%%%%%%%%%%    filter_design    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Hd = kasier_filter
%UNTITLED Returns a discrete-time filter object.

%
% MATLAB Code
% Generated by MATLAB(R) 7.14 and the Signal Processing Toolbox 6.17.
%
% Generated on: 08-Sep-2015 18:31:40
%

% FIR Window Bandpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 250;  % Sampling Frequency

N    = 2400;     % Order
Fc1  = 11;       % First Cutoff Frequency
Fc2  = 15;       % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
Beta = 5;        % Window Parameter
% Create the window vector for the design algorithm.
win = kaiser(N+1, Beta);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);

% [EOF]

end

%%%%%%%%%%%%%%%%%%%%%%%     lianxu_1    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = lianxu_1(a,Num,Fs)
%a = [0 ones(1,5)  0 0 1 0 ones(1,10) 0] ;
b = find(a) ; %找出rms计算结果中大于阈值被赋值为1的位置
res = [] ;
n = 1 ; 
i = 1 ;
while i < length(b)
    j = i+1 ;
    while j <= length(b) &&  b(j)==b(j-1)+1 %如果出现连续为1
        n = n + 1 ;%连续为1的个数
        j = j + 1 ;
    end
    if n >= ((0.5*Fs)/Num) && n <= ((2*Fs)/Num)    % 连续为1的个数范围在此之内，则满足纺锤波的持续时间，就将这个值记录下来
        res = [res ; b(i),n] ;
   
    end
    n = 1 ;
    i = j ;
end
end

 
