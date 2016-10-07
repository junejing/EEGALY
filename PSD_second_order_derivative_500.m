function PSD_second_order_derivative_500
close all;
clear all;
prefile = spm_select(1, 'dir', 'Select imported EEG file','' ...
            ,pwd,'.*');
fs = 500;%采样率
raw_data = dir(prefile);
raw_path =prefile;
length_rawdata = length(raw_data);%length_rawdata-2个被试的数据
h=waitbar(0,'Please waiting...');
number_channel = 10;
spectra_time = 4;%每4s算一个频谱
num_point = 4096;%做fft时的点数
hanning_window = hann(spectra_time*fs);%hanning窗,是列向量
frequency = (1:num_point/2)*fs/num_point;%行向量
fre_9_16 = frequency(frequency >= 9 & frequency <= 16);%9~16hz的频率
fre_9_16_downsample = fre_9_16(1:2:end);%9~16hz的频率序列以2进行降采样
min_duration = 0.5;%纺锤波的最小持续时间
max_duration = 2;%纺锤波的最大持续时间
slow_spindle_frequency_all = zeros(number_channel,length_rawdata-2,2);
slow_amplitude_criteria_all = zeros(number_channel,length_rawdata-2);
fast_spindle_frequency_all = zeros(number_channel,length_rawdata-2,2);
fast_amplitude_criteria_all = zeros(number_channel,length_rawdata-2);
length_segment_all = zeros(1,length_rawdata-2);
Hd = kaiser_filter;
B =  Hd.Numerator;
for raw_file = 3:length_rawdata%被试
    data_path = fullfile(raw_path,raw_data(raw_file).name);
    sub_file = dir(data_path);
    length_segment_all(raw_file-2) = length(sub_file);
end
total_step = sum(length_segment_all)*number_channel;
n = 0;
for raw_file = 3:length_rawdata%被试
    data_path = fullfile(raw_path,raw_data(raw_file).name);
    sub_file = dir(data_path);
    length_segment = length(sub_file);
    for segment = 3:length_segment
        data_path = fullfile(raw_path,raw_data(raw_file).name,'\',sub_file(segment).name);
        segment_data = load(data_path);%load第segment-2段数据
        SigLen = size(segment_data.b,2);
        data_10channels = zeros(number_channel,SigLen);  %% 建立用于分析的数据存储空间；
        data_10channels(1,:) = segment_data.b(1,:) - segment_data.b(30,:);%FP1电极，以乳突为参考
        data_10channels(2,:) = segment_data.b(2,:) - segment_data.b(29,:);%FP2电极，以乳突为参考
        data_10channels(3,:) = segment_data.b(3,:) - segment_data.b(30,:);%F3电极，以乳突为参考
        data_10channels(4,:) = segment_data.b(4,:) - segment_data.b(29,:);%F4电极，以乳突为参考
        data_10channels(5,:) = segment_data.b(5,:) - segment_data.b(30,:);%C3电极，以乳突为参考
        data_10channels(6,:) = segment_data.b(6,:) - segment_data.b(29,:);%C4电极，以乳突为参考
        data_10channels(7,:) = segment_data.b(7,:) - segment_data.b(30,:);%P3电极，以乳突为参考
        data_10channels(8,:) = segment_data.b(8,:) - segment_data.b(29,:);%P4电极，以乳突为参考
        data_10channels(9,:) = segment_data.b(9,:) - segment_data.b(30,:);%O1电极，以乳突为参考
        data_10channels(10,:) = segment_data.b(10,:) - segment_data.b(29,:);%O2电极，以乳突为参考
        data_segment(segment-2) = struct('data_10channels',data_10channels);
    end
    Nrem_data(raw_file-2) = struct('nrem_data',data_segment);%该被试10个电极减去参考的数据
    for channel = 1:number_channel
        FFT_spectra_channel = [];
        for segment = 1:length_segment-2
            length_channel = length(Nrem_data(raw_file-2).nrem_data(segment).data_10channels(channel,:));%该段数据FP1电极的长度
            fact_length_channel = floor(length_channel/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
            channel_data = reshape(Nrem_data(raw_file-2).nrem_data(segment).data_10channels(channel,1:fact_length_channel),fs*spectra_time,[]);
            num_spectra_channel = size(channel_data,2);
            channel_correct = repmat(hanning_window,1,num_spectra_channel).* channel_data;%加hanning窗
            FFT_channel = 2*abs(fft(channel_correct,num_point))/num_point;%振幅谱,标准化
            FFT_spectra_channel = [FFT_spectra_channel,FFT_channel(1:(num_point/2),:)];%只分析一半
        end
        mean_spectra_channel = mean(FFT_spectra_channel,2);%平均振幅谱
        clear FFT_spectra_channel;
        clear FFT_channel;
        clear channel_correct;
        clear channel_data;
        spectra_channel = mean_spectra_channel(frequency >= 9 & frequency <= 16);%只分析9~16hz内的频谱
        spectra_channel_down = spectra_channel(1:2:end);
        %二次方程拟合，求二阶导
        derivative_channel = polyfit_2_derivation(spectra_channel_down,fre_9_16_downsample);
        %找两个最大负峰附近的零点,确定快慢纺锤波的频率边界以及振幅阈值
        [slow_spindle_frequency,slow_amplitude_criteria,fast_spindle_frequency,fast_amplitude_criteria] = freq_bound_amp(derivative_channel,fre_9_16_downsample,fre_9_16,spectra_channel);
        slow_spindle_frequency_all(channel,raw_file-2,:) = slow_spindle_frequency;
        slow_amplitude_criteria_all(channel,raw_file-2) = slow_amplitude_criteria;
        fast_spindle_frequency_all(channel,raw_file-2,:) = fast_spindle_frequency;
        fast_amplitude_criteria_all(channel,raw_file-2) = fast_amplitude_criteria;
    end
    %得到快慢纺锤波的包络
    for segment = 1:length_segment-2
        length_data = size(Nrem_data(raw_file-2).nrem_data(segment).data_10channels,2);
        detection = zeros(number_channel,length_data);
        for channel = 1:number_channel
            n = n+1;
            length_channel = length(Nrem_data(raw_file-2).nrem_data(segment).data_10channels(channel,:));%该段数据FP1电极的长度
            fact_length_channel = floor(length_channel/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
            mod_length = mod(length_channel,fs*spectra_time);
            channel_data = reshape(Nrem_data(raw_file-2).nrem_data(segment).data_10channels(channel,1:fact_length_channel),fs*spectra_time,[]);
            [detection_slow,detection_fast] = detection_spindle_envelope(channel_data,slow_spindle_frequency_all(channel,raw_file-2,:),...
                slow_amplitude_criteria_all(channel,raw_file-2,:),fast_spindle_frequency_all(channel,raw_file-2,:),fast_amplitude_criteria_all(channel,raw_file-2,:),fs,num_point);
            [detection_slow,~,~,detection_fast,~,~] = detection_duration(detection_slow,detection_fast,fs);
            detection_channel = detection_slow + detection_fast;
            detection_channel(detection_channel>=1) = 1;
            [start_position_channel,end_position_channel] = start_end(detection_channel);
            [detection_channel,start_position_channel,end_position_channel] = find_duration_min(detection_channel,start_position_channel,end_position_channel,min_duration,fs);
            [detection_channel,start_position_channel,end_position_channel] = find_duration_max(detection_channel,start_position_channel,end_position_channel,max_duration,fs);
            detection_channel = [detection_channel,zeros(1,mod_length)];
            detection(channel,:) = detection_channel;%0,1
            start_end_pos = [start_position_channel',end_position_channel'];
            duration = (end_position_channel-start_position_channel)./fs;
            spindle_pos(channel,segment) = struct('start_end_pos',start_end_pos);
            spindle_duration(channel,segment) = struct('duration',duration);
            %%%%%%%%%%%%%%%%%%  计算频率  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     计算幅值   %%%%%%%%%%%%%%%%%%%%%%%%%
            Spd_frequency = [];
            Spd_amplitude = [];
            data_raw = Nrem_data(raw_file-2).nrem_data(segment).data_10channels(channel,:);
            data_filtered = filtfilt(B,1,data_raw);
            if ~isempty(start_position_channel)
                for number_spindle = 1:length(start_position_channel)
                    N=2*fs;
                    spd_data = data_filtered(start_position_channel(number_spindle):end_position_channel(number_spindle));
                    FFT_data=abs(fft(spd_data,N));
                    freqs=(1:N/2)*fs/N;
                    index_freq1 = find(freqs <= 11);
                    index_freq2 = find(freqs <= 16);
                    [pks,locs]=findpeaks(FFT_data(index_freq1(end):index_freq2(end)));
                    [~,pks_pos] = max(pks);
                    frequency_1 = freqs(index_freq1(end)+locs(pks_pos)-1);
                    Spd_frequency = [Spd_frequency,frequency_1];
                    amplitude = 2*max(spd_data);
                    Spd_amplitude = [Spd_amplitude,amplitude];
                end              
            end            
            spindle_frequency(channel,segment) = struct('frequency',Spd_frequency);
            spindle_amplitude(channel,segment) = struct('amplitude',Spd_amplitude);                         
            i = n/total_step;
            waitbar(i,h,['已完成' num2str(i*100) '%']);
        end
        detection_segment(raw_file-2,segment) = struct('detection',detection);    
    end
    spindle_amplitude_segment(raw_file-2) = struct('spindle_amplitude',spindle_amplitude);
    spindle_frequency_segment(raw_file-2) = struct('spindle_frequency',spindle_frequency);
    spindle_duration_segment(raw_file-2) = struct('spindle_duration',spindle_duration);
    spindle_pos_segment(raw_file-2) = struct('spindle_pos',spindle_pos);
end
index = find(prefile,'\');
psd_path = prefile(1:index(end));
mkdir([psd_path,'PSD_2order_results_500']);
str_path = [psd_path,'PSD_2order_results_500\'];
save([str_path,'PSD_2order_spindle_result.mat'],'detection_segment','spindle_amplitude_segment','spindle_frequency_segment','spindle_duration_segment','spindle_pos_segment',...
    'slow_spindle_frequency_all','slow_amplitude_criteria_all','fast_spindle_frequency_all','fast_amplitude_criteria_all');
close(h);
end

%%
%二次方程拟合，求二阶导
function derivative = polyfit_2_derivation(spectra_downsample,fre_downsample)
%spectra_downsample:降采样后的振幅谱；
%fre_downsample：振幅谱对应的频率；
%derivative：该振幅谱的二阶导；
[spec_row,spec_colum] = size(spectra_downsample);
[freq_row,freq_colum] = size(fre_downsample);
if (spec_colum - spec_row) * (freq_colum - freq_row) < 0 
    fre_downsample = fre_downsample';%确保polyfit的x,y向量的维数相等，即同时为行向量，或同时为列向量
end
length_spectra_down = length(spectra_downsample);
derivative = zeros(1,length_spectra_down);
for n = 2:length_spectra_down-1
    p = polyfit(fre_downsample(n-1:n+1),spectra_downsample(n-1:n+1),2);%二次方程拟合 a*x^2+b*x+c
    derivative(n) = 2*p(1);%2*p(1)为二阶导
end
end

%%
% %找两个最大负峰附近的零点,确定快慢纺锤波的频率边界以及振幅阈值
function [slow_spindle_frequency,slow_amplitude_criteria,fast_spindle_frequency,fast_amplitude_criteria] = freq_bound_amp(derivative,fre_downsample,fre,spectra)
%derivative:平均振幅谱降采样后的二阶导
%fre_downsample：降采样后的频率序列
%fre：降采样前的频率序列
%spectra：平均振幅谱，没有降采样
%slow_spindle_frequency：慢纺锤波的频率范围；
%slow_amplitude_criteria:慢纺锤波的振幅阈值
%fast_spindle_frequency：快纺锤波的频率范围；
%fast_amplitude_criteria:快纺锤波的振幅阈值
[slow_spindle_frequency,slow_spindle_frequency_index,fast_spindle_frequency,fast_spindle_frequency_index] = frequency_boundary(derivative,fre_downsample,fre);
%确定快慢纺锤波各自的振幅范围
slow_spindle_bandwidth = slow_spindle_frequency_index(2) - slow_spindle_frequency_index(1) + 1;
slow_amplitude_criteria = slow_spindle_bandwidth * (spectra(slow_spindle_frequency_index(1))+spectra(slow_spindle_frequency_index(2)))/2;%慢纺锤波的振幅阈值
fast_spindle_bandwidth = fast_spindle_frequency_index(2) - fast_spindle_frequency_index(1) + 1;
fast_amplitude_criteria = fast_spindle_bandwidth * (spectra(fast_spindle_frequency_index(1))+spectra(fast_spindle_frequency_index(2)))/2;%快纺锤波的振幅阈值
end

%%
function [slow_spindle_frequency,slow_spindle_frequency_index,fast_spindle_frequency,fast_spindle_frequency_index] = frequency_boundary(average_spectra_derivative,fre_9_16_downsample,fre_9_16)
%average_spectra_derivative：平均振幅谱的二阶导；
%fre_9_16：9~16hz的频率序列；
%fre_9_16_downsample：9~16hz以4降采样后的频率序列；
%slow_spindle_frequency：慢纺锤波的频率范围；
%slow_spindle_frequency_index：慢纺锤波的频率边界对应的位置坐标；
%fast_spindle_frequency：快纺锤波的频率范围；
%fast_spindle_frequency_index：快纺锤波的频率边界对应的位置坐标；
%首先找到波谷；
%t = 0:0.5:4*pi;
% average_spectra_derivative = sin(t);%测试数据
% average_spectra_derivative(1:2) = average_spectra_derivative(2);
% average_spectra_derivative(4:5) = average_spectra_derivative(4);
% average_spectra_derivative(11:15) = average_spectra_derivative(14);
% average_spectra_derivative(20:21) = average_spectra_derivative(20);
% average_spectra_derivative(22:23) = average_spectra_derivative(23);
% average_spectra_derivative(24:26) = average_spectra_derivative(25);
% figure;
% plot(average_spectra_derivative);
% hpeaks = dsp.PeakFinder('PeakType','Minima','PeakIndicesOutputPort',true,'PeakValuesOutputPort',true,'MaximumPeakCount',100);
% [peak_num, peak_index, peak_value] = step(hpeaks, average_spectra_derivative);%出现错误提示，To find a peak the input must have three or more rows.
diff_aver_spec = diff(average_spectra_derivative);
diff_aver_spec(diff_aver_spec > 0) = 1;
diff_aver_spec(diff_aver_spec < 0) = -1;
zero_index = find(diff_aver_spec == 0);
length_zero_index = length(zero_index);
start_end_index = [];
if length_zero_index > 0 
    for j = 1:length_zero_index
        if j == 1
            if  zero_index(j) == 1
                start_index = 1;
                if (zero_index(j+1)-zero_index(j)) ~= 1 
                    end_index = start_index;
                end 
            end
        elseif j == length_zero_index
            if (zero_index(j)-zero_index(j-1)) ~= 1
                start_index = zero_index(j);
                end_index = zero_index(j);
            else
                 end_index = zero_index(j);
            end
        else
            %diff_aver_spec == 0时，且第一个0位置的左和最后一个连续0位置的右边的值相等（或为1，或为-1），
                %左右都等于1，说明信号是先增大，然后不变，然后继续增大；
                %左右都等于-1，说明信号是先减小，然后不变，然后继续减小；
            if (zero_index(j+1)-zero_index(j)) == 1 && (zero_index(j)-zero_index(j-1)) ~= 1
                start_index = zero_index(j);
                continue;
            elseif (zero_index(j+1)-zero_index(j)) == 1 && (zero_index(j)-zero_index(j-1)) == 1
                continue;
            elseif (zero_index(j+1)-zero_index(j)) ~= 1 &&(zero_index(j)-zero_index(j-1)) ~= 1
                start_index = zero_index(j);
                end_index = zero_index(j);
            elseif (zero_index(j+1)-zero_index(j)) ~= 1 &&(zero_index(j)-zero_index(j-1)) == 1
                end_index = zero_index(j);
            end
        end
        start_end_index = [start_end_index;start_index,end_index];
    end
    for i = 1:size(start_end_index,1);
        if start_end_index(i,1) == 1 
            diff_aver_spec(start_end_index(i,1):start_end_index(i,2)) = diff_aver_spec(start_end_index(i,2)+1);
        elseif start_end_index(i,2) == length(diff_aver_spec) 
            diff_aver_spec(start_end_index(i,1):start_end_index(i,2)) = diff_aver_spec(start_end_index(i,1)-1);
        elseif diff_aver_spec(start_end_index(i,1)-1) == diff_aver_spec(start_end_index(i,2)+1)
            diff_aver_spec(start_end_index(i,1):start_end_index(i,2)) = diff_aver_spec(start_end_index(i,1)-1);
        end
    end
end
diff2_aver_spec = diff(diff_aver_spec);
%diff2_max_index = find(diff2_aver_spec < 0)+1;%极大位置。即波峰的位置
diff2_min_index = find(diff2_aver_spec > 0)+1;%极小位置,即波谷的位置
% hold on;
% plot(diff2_max_index,average_spectra_derivative(diff2_max_index),'sr');
% hold on;
% plot(diff2_min_index,average_spectra_derivative(diff2_min_index),'sb');
%找两大负峰对应的零点
min_value = average_spectra_derivative(diff2_min_index);
min_value(min_value > 0) = 0;
[first_negtive_max_peak,first_negtive_max_peak_index] = max(abs(min_value));%第一个最大负峰
[first_zeros_before,first_zeros_after] = find_zeroscrossing(average_spectra_derivative,fre_9_16_downsample,diff2_min_index,first_negtive_max_peak_index);
min_value(abs(min_value)==first_negtive_max_peak) = 0;
[~,second_negtive_max_peak_index] = max(abs(min_value));%第二个最大负峰
[second_zeros_before,second_zeros_after] = find_zeroscrossing(average_spectra_derivative,fre_9_16_downsample,diff2_min_index,second_negtive_max_peak_index);
%避免快纺锤波频率太慢，慢纺锤波频率太快
if (first_zeros_after < 12.45 && second_zeros_after < 12.45) || (first_zeros_before > 11.96 && second_zeros_before > 11.96)
    if first_zeros_after < 12.45 && second_zeros_after < 12.45
        min_value_2 = average_spectra_derivative(diff2_min_index);
        freq_peak = fre_9_16_downsample(diff2_min_index);
        min_value_2(freq_peak < 12.45) = 0;
        min_value_2(min_value_2 > 0) = 0;
        [~,second_negtive_max_peak_index] = max(abs(min_value_2));
        [second_zeros_before,second_zeros_after] = find_zeroscrossing(average_spectra_derivative,fre_9_16_downsample,diff2_min_index,second_negtive_max_peak_index);
    elseif first_zeros_before > 11.96 && second_zeros_before > 11.96
        min_value_2 = average_spectra_derivative(diff2_min_index);
        freq_peak = fre_9_16_downsample(diff2_min_index);
        min_value_2(freq_peak > 11.96) = 0;
        min_value_2(min_value_2 > 0) = 0;
        [~,second_negtive_max_peak_index] = max(abs(min_value_2));
        [second_zeros_before,second_zeros_after] = find_zeroscrossing(average_spectra_derivative,fre_9_16_downsample,diff2_min_index,second_negtive_max_peak_index);
    end
end

%快慢纺锤波的频率边界
[~,index1a] = min(abs(fre_9_16-first_zeros_before)); %在高频率分辨率下计算频率边界，即未进行降采样前
boundary1a = fre_9_16(index1a);
[~,index1b] = min(abs(fre_9_16-first_zeros_after)); 
boundary1b = fre_9_16(index1b);
[~,index2a] = min(abs(fre_9_16-second_zeros_before));
boundary2a = fre_9_16(index2a);
[~,index2b] = min(abs(fre_9_16-second_zeros_after)); 
boundary2b = fre_9_16(index2b);
if boundary1a < boundary2a %第一个最大负峰在第二个最大负峰的前面
    slow_frequency_before = boundary1a; 
    slow_frequency_before_index = index1a;
    slow_frequency_after = boundary1b; 
    slow_frequency_after_index = index1b;
    fast_frequency_before = boundary2a; 
    fast_frequency_before_index = index2a;
    fast_frequency_after = boundary2b; 
    fast_frequency_after_index = index2b;
elseif boundary2a <= boundary1a %第一个最大负峰在第二个最大负峰的后面
    slow_frequency_before = boundary2a; 
    slow_frequency_before_index = index2a;
    slow_frequency_after = boundary2b; 
    slow_frequency_after_index = index2b;
    fast_frequency_before = boundary1a; 
    fast_frequency_before_index = index1a;
    fast_frequency_after = boundary1b; 
    fast_frequency_after_index = index1b;
% else
%     error('The slow and fast boundary is the same');
end
slow_spindle_frequency = [slow_frequency_before,slow_frequency_after];%慢纺锤波的频率范围
slow_spindle_frequency_index = [slow_frequency_before_index,slow_frequency_after_index];
fast_spindle_frequency = [fast_frequency_before,fast_frequency_after];%快纺锤波的频率范围
fast_spindle_frequency_index = [fast_frequency_before_index,fast_frequency_after_index];
end

%%
%得到负峰附近的零点
function [zeros_before,zeros_after] = find_zeroscrossing(average_spectra_derivative,fre_9_16_downsample,diff2_min_index,negtive_max_peak_index)
%average_spectra_derivative:平均振幅谱的二阶导；
%fre_9_16_downsample：9~16hz的频率，进行4降采样后的频率序列；
%diff2_min_index：波谷位置
%negtive_max_peak_index：最大负峰的位置
%zeros_before：该最大负峰左边的最近的零点；
%zeros_after：该最大负峰右边的最近的零点；
peak_index = diff2_min_index(negtive_max_peak_index);
k = peak_index;
while average_spectra_derivative(k) < 0
    k = k-1;
end
before_peak1 = k;
before_peak2 = k+1;
if average_spectra_derivative(before_peak1) == 0
    zeros_before = fre_9_16_downsample(before_peak1);%最大负峰对应的前一个零点
else
    gradient = (average_spectra_derivative(before_peak2) - average_spectra_derivative(before_peak1))...
               /(fre_9_16_downsample(before_peak2)-fre_9_16_downsample(before_peak1));%斜率
    %通过线性插值得到零点
    zeros_before = (-average_spectra_derivative(before_peak1))/gradient + fre_9_16_downsample(before_peak1);
end
k = peak_index;
while average_spectra_derivative(k) < 0
    k = k+1;
end
after_peak1 = k;
after_peak2 = k-1;
if average_spectra_derivative(after_peak1) == 0
    zeros_after = fre_9_16_downsample(after_peak1);%最大负峰对应的后一个零点
else
    gradient = (average_spectra_derivative(after_peak2) - average_spectra_derivative(after_peak1))...
               /(fre_9_16_downsample(after_peak2)-fre_9_16_downsample(after_peak1));%斜率
    zeros_after = (-average_spectra_derivative(after_peak1))/gradient + fre_9_16_downsample(after_peak1);
end
end

%%
function [detection_slow,detection_fast] = detection_spindle_envelope(data,slow_spindle_frequency,slow_amplitude_criteria,fast_spindle_frequency,fast_amplitude_criteria,fs,num_point)
%慢纺锤波的高斯带通滤波器
%resolution = fs/num_point;%频率分辨率
x = (1:num_point/2)*fs/num_point;
w_slow = slow_spindle_frequency(2) - slow_spindle_frequency(1);%慢纺锤波的频率带宽
xm_slow = (slow_spindle_frequency(2) + slow_spindle_frequency(1))/2;%慢纺锤波的中心频率
gauss_slow = exp(-abs(x-xm_slow)/(w_slow/2));%高斯滤波器，行向量
gauss_slow_filter = [gauss_slow,gauss_slow(end:-1:1)]';
%快纺锤波的高斯带通滤波器
w_fast = fast_spindle_frequency(2) - fast_spindle_frequency(1);%慢纺锤波的频率带宽
xm_fast = (fast_spindle_frequency(2) + fast_spindle_frequency(1))/2;%慢纺锤波的中心频率
gauss_fast = exp(-abs(x-xm_fast)/(w_fast/2));%高斯滤波器,行向量
gauss_fast_filter = [gauss_fast,gauss_fast(end:-1:1)]';
%对数据进行高斯滤波，得到时域滤波后的信号
fft_data = fft(data,num_point);
num_column = size(fft_data,2);
Gauss_filter_slow = repmat(gauss_slow_filter,1,num_column);
Gauss_filter_fast = repmat(gauss_fast_filter,1,num_column);
slow_band = ifft(fft_data.*Gauss_filter_slow,num_point,'symmetric');
slow_band_data = abs(slow_band(1:4*fs,:));
fast_band = ifft(fft_data.*Gauss_filter_fast,num_point,'symmetric'); 
fast_band_data = abs(fast_band(1:4*fs,:));
%hanning窗移动平均
hanning_window_44 = hann(44);%列向量
hanning_window_44_sum = sum(hanning_window_44);
slow_band_raw_data = reshape(slow_band_data,1,[]);
fast_band_raw_data = reshape(fast_band_data,1,[]);
length_data = size(slow_band_raw_data,2);
% hanning_slow_data = zeros(1,length_data);
% hanning_fast_data = zeros(1,length_data);
% for j = 11:length_data-11
%     hanning_slow_data(j) = sum(slow_band_raw_data(j-10:j+11).*(hanning_window_44'))/hanning_window_44_sum;
%     hanning_fast_data(j) = sum(fast_band_raw_data(j-10:j+11).*(hanning_window_44'))/hanning_window_44_sum;
% end
filter_b = hanning_window_44./hanning_window_44_sum;
hanning_slow_data = filtfilt(filter_b,1,slow_band_raw_data);
hanning_fast_data = filtfilt(filter_b,1,fast_band_raw_data);
hanning_slow_data = hanning_slow_data*(pi/2);
hanning_fast_data = hanning_fast_data*(pi/2);
%将振幅阈值一下的点赋值为0，以上的点赋值为1
detection_slow = zeros(1,length_data);
detection_fast = zeros(1,length_data);
detection_slow(hanning_slow_data>slow_amplitude_criteria) = 1;
detection_fast(hanning_fast_data>fast_amplitude_criteria) = 1;
end

%%
%判断纺锤波的持续时间是否在0.5~2s之间
function [detection_slow,start_position_slow,end_position_slow,detection_fast,start_position_fast,end_position_fast] = detection_duration(detection_slow,detection_fast,fs)
min_duration = 0.5;%纺锤波的最小持续时间
max_duration = 2;%纺锤波的最大持续时间
[start_position_slow,end_position_slow] = start_end(detection_slow);
[start_position_fast,end_position_fast] = start_end(detection_fast);
[detection_slow,start_position_slow,end_position_slow] = find_duration_min(detection_slow,start_position_slow,end_position_slow,min_duration,fs);
[detection_slow,start_position_slow,end_position_slow] = find_duration_max(detection_slow,start_position_slow,end_position_slow,max_duration,fs);
[detection_fast,start_position_fast,end_position_fast] = find_duration_min(detection_fast,start_position_fast,end_position_fast,min_duration,fs);
[detection_fast,start_position_fast,end_position_fast] = find_duration_max(detection_fast,start_position_fast,end_position_fast,max_duration,fs);
end

%%
%纺锤波的开始结束时间
function [start_position end_position] = start_end(detection)
[row,column] = size(detection);
if row > column
    detection = detection';
end
length_detection = length(detection);
each_diff = diff(detection);
start_position = find(each_diff == 1) + 1;
end_position = find(each_diff == -1);
if detection(1) == 1  
   %当detection第一个点是1，第二个点是0，那么第一个纺锤波的开始点设为1
    start_position = [1,start_position];
end
if detection(end) == 1 
    %当detection的最后一个点是1，倒数第二个点是0，那么最后一个纺锤波的结束点设为length_detection
    end_position = [end_position,length_detection];  
end
end

%%
function [detection,start_position,end_position] = find_duration_min(detection,start_position,end_position,min_duration,fs)
duration_slow = end_position - start_position +1;
detection_index = find(duration_slow < min_duration*fs);
for i = 1:length(detection_index)
    detection(start_position(detection_index(i)):end_position(detection_index(i))) = 0;
    start_position(detection_index(i)) = 0;
    end_position(detection_index(i)) = 0;
end
start_position = start_position(start_position ~= 0);
end_position = end_position(end_position ~= 0);
end

%%
function [detection,start_position,end_position] = find_duration_max(detection,start_position,end_position,max_duration,fs)
duration_slow = end_position - start_position +1;
detection_index = find(duration_slow > max_duration*fs);
for i = 1:length(detection_index)
    detection(start_position(detection_index(i)):end_position(detection_index(i))) = 0;
    start_position(detection_index(i)) = 0;
    end_position(detection_index(i)) = 0;
end
start_position = start_position(start_position ~= 0);
end_position = end_position(end_position ~= 0);
end
%
function Hd = kaiser_filter
%UNTITLED Returns a discrete-time filter object.

%
% MATLAB Code
% Generated by MATLAB(R) 7.14 and the Signal Processing Toolbox 6.17.
%
% Generated on: 14-Sep-2015 21:08:48
%

% FIR Window Bandpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 500;  % Sampling Frequency

N    = 830;      % Order
Fc1  = 10;       % First Cutoff Frequency
Fc2  = 17;       % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
Beta = 5;        % Window Parameter
% Create the window vector for the design algorithm.
win = kaiser(N+1, Beta);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);

% [EOF]
end