function juice_two_derivative2
close all;
clear all;
prefile = spm_select(1, 'dir', 'Select imported EEG file','' ...
            ,pwd,'.*');
fs = 500;%采样率
%gold_standard = load('D:\zhaorui_2014\code\New_gold_standard.mat');%金标准
%raw_data = dir('D:\zhaorui_2014\data_change');
%raw_path = 'D:\zhaorui_2014\data_change\';
raw_data = dir(prefile);
raw_path =prefile;
length_rawdata = length(raw_data);%length_rawdata-2个被试的数据
h=waitbar(0,'开始绘图');
for raw_file = 3:length_rawdata%被试
    data_path = fullfile(raw_path,raw_data(raw_file).name);
    sub_file = dir(data_path);
    length_segment = length(sub_file);
%     for sub_file_num = 3:length_sub_file
%         sub_sub_file = dir([data_path,'\',sub_file(sub_file_num).name]);%该被试的N2，N3数据各自的文件夹位置
%         length_segment = length(sub_sub_file);%length_segment-2段数据
        for segment = 3:length_segment
            data_path = fullfile(raw_path,raw_data(raw_file).name,'\',sub_file(segment).name);
%             segment_path = fullfile(data_path,'\',sub_file(sub_file_num).name,'\',sub_sub_file(segment).name);
            segment_data = load(data_path);%load第segment-2段数据
            raw_NREM_data(segment-2).FP1 = segment_data.b(1,:) - segment_data.b(30,:);%FP1电极，以乳突为参考
            raw_NREM_data(segment-2).FP2 = segment_data.b(2,:) - segment_data.b(29,:);%FP2电极，以乳突为参考
            raw_NREM_data(segment-2).F3 = segment_data.b(3,:) - segment_data.b(30,:);%F3电极，以乳突为参考
            raw_NREM_data(segment-2).F4 = segment_data.b(4,:) - segment_data.b(29,:);%F4电极，以乳突为参考
            raw_NREM_data(segment-2).C3 = segment_data.b(5,:) - segment_data.b(30,:);%C3电极，以乳突为参考
            raw_NREM_data(segment-2).C4 = segment_data.b(6,:) - segment_data.b(29,:);%C4电极，以乳突为参考
            raw_NREM_data(segment-2).P3 = segment_data.b(7,:) - segment_data.b(30,:);%P3电极，以乳突为参考
            raw_NREM_data(segment-2).P4 = segment_data.b(8,:) - segment_data.b(29,:);%P4电极，以乳突为参考
            raw_NREM_data(segment-2).O1 = segment_data.b(9,:) - segment_data.b(30,:);%O1电极，以乳突为参考           
            raw_NREM_data(segment-2).O2 = segment_data.b(10,:) - segment_data.b(29,:);%O2电极，以乳突为参考
        end
        Nrem_data(raw_file-2) = struct('nrem_data',raw_NREM_data);%该被试10个电极减去参考的数据
%     end
    clear segment_data;
    clear raw_NREM_data;
    for channel = 1:4:5 %检测FP1和C3电极的数据
        switch channel
            case 1
                [detection_FP1,start_pos_FP1,end_pos_FP1] = spindle_detection(Nrem_data,fs,channel);
                detection_channel(raw_file - 2,channel) = struct('detection',detection_FP1,'start_position',start_pos_FP1,'end_position',end_pos_FP1);
            case 2
                [detection_FP2,start_pos_FP2,end_pos_FP2] = spindle_detection(Nrem_data,fs,channel);
                detection_channel(raw_file - 2,channel) = struct('detection',detection_FP2,'start_position',start_pos_FP2,'end_position',end_pos_FP2);
            case 3
                [detection_F3,start_pos_F3,end_pos_F3] = spindle_detection(Nrem_data,fs,channel);
                detection_channel(raw_file - 2,channel) = struct('detection',detection_F3,'start_position',start_pos_F3,'end_position',end_pos_F3);
            case 4
                [detection_F4,start_pos_F4,end_pos_F4] = spindle_detection(Nrem_data,fs,channel);
                detection_channel(raw_file - 2,channel) = struct('detection',detection_F4,'start_position',start_pos_F4,'end_position',end_pos_F4);
            case 5
                [detection_C3,start_pos_C3,end_pos_C3] = spindle_detection(Nrem_data,fs,channel);
                detection_channel(raw_file - 2,channel) = struct('detection',detection_C3,'start_position',start_pos_C3,'end_position',end_pos_C3);
            case 6
                [detection_C4,start_pos_C4,end_pos_C4] = spindle_detection(Nrem_data,fs,channel);
                detection_channel(raw_file - 2,channel) = struct('detection',detection_C4,'start_position',start_pos_C4,'end_position',end_pos_C4);
            case 7
                [detection_P3,start_pos_P3,end_pos_P3] = spindle_detection(Nrem_data,fs,channel);
                detection_channel(raw_file - 2,channel) = struct('detection',detection_P3,'start_position',start_pos_P3,'end_position',end_pos_P3);
            case 8
                [detection_P4,start_pos_P4,end_pos_P4] = spindle_detection(Nrem_data,fs,channel);
                detection_channel(raw_file - 2,channel) = struct('detection',detection_P4,'start_position',start_pos_P4,'end_position',end_pos_P4);
            case 9
                [detection_O1,start_pos_O1,end_pos_O1] = spindle_detection(Nrem_data,fs,channel);
                detection_channel(raw_file - 2,channel) = struct('detection',detection_O1,'start_position',start_pos_O1,'end_position',end_pos_O1);
            case 10
                [detection_O2,start_pos_O2,end_pos_O2] = spindle_detection(Nrem_data,fs,channel);
                detection_channel(raw_file - 2,channel) = struct('detection',detection_O2,'start_position',start_pos_O2,'end_position',end_pos_O2);
                break;
        end
    end
    
end
index = find(prefile,'\');
psd_path = prefile(1:index(end-1));
mkdir([psd_path,'PSD_results']);
str_path = [psd_path,'PSD_results\'];
save([str_path,'spindle_result_each_channel.mat'],'detection_channel');
end

%%
%检测纺锤波
function [detection,start_pos,end_pos] = spindle_detection(Nrem_data,fs,channel)
%Nrem_data:一个被试的所有N2、N3阶段的C3、O1电极的数据
%fs:采样率
%channel：哪个电极
%detection：该电极检测纺锤波后得到的0，1序列
%start_pos：检测到的纺锤波的开始点；
%end_pos：检测到的纺锤波的结束点；
spectra_time = 4;%每4s算一个频谱
num_point = 4096;%做fft时的点数
hanning_window = hann(spectra_time*fs);%hanning窗,是列向量
length_Nrem_data = length(Nrem_data);
FFT_spectra_FP1 = [];
FFT_spectra_FP2 = [];
FFT_spectra_F3 = [];
FFT_spectra_F4 = [];
FFT_spectra_C3 = [];
FFT_spectra_C4 = [];
FFT_spectra_P3 = [];
FFT_spectra_P4 = [];
FFT_spectra_O1 = [];
FFT_spectra_O2 = [];
frequency = (1:num_point/2)*fs/num_point;%行向量
%振幅谱；
for nrem = 1:length_Nrem_data
    length_segment = length(Nrem_data(nrem).nrem_data);%N2,N3阶段分别有多少段
    for segment = 1:length_segment
        switch channel
            case 1
                %FP1电极
                length_FP1 = length(Nrem_data(nrem).nrem_data(segment).FP1);%该段数据FP1电极的长度
                fact_length_FP1 = floor(length_FP1/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                FP1_data = reshape(Nrem_data(nrem).nrem_data(segment).FP1(1:fact_length_FP1),fs*spectra_time,[]);
                num_spectra_FP1 = size(FP1_data,2);
                FP1_correct = repmat(hanning_window,1,num_spectra_FP1).* FP1_data;%加hanning窗
                FFT_FP1 = 2*abs(fft(FP1_correct,num_point))/num_point;%振幅谱,标准化
                FFT_spectra_FP1 = [FFT_spectra_FP1,FFT_FP1(1:(num_point/2),:)];%只分析一半
            case 2
                %FP2电极
                length_FP2 = length(Nrem_data(nrem).nrem_data(segment).FP2);%该段数据FP2电极的长度
                fact_length_FP2 = floor(length_FP2/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                FP2_data = reshape(Nrem_data(nrem).nrem_data(segment).FP2(1:fact_length_FP2),fs*spectra_time,[]);
                 num_spectra_FP2 = size(FP2_data,2);
                FP2_correct = repmat(hanning_window,1,num_spectra_FP2).* FP2_data;%加hanning窗
                FFT_FP2 = 2*abs(fft(FP2_correct,num_point))/num_point;%振幅谱,标准化
                FFT_spectra_FP2 = [FFT_spectra_FP2,FFT_FP2(1:(num_point/2),:)];%只分析一半
            case 3
                %F3电极
                length_F3 = length(Nrem_data(nrem).nrem_data(segment).F3);%该段数据F3电极的长度
                fact_length_F3 = floor(length_F3/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                F3_data = reshape(Nrem_data(nrem).nrem_data(segment).F3(1:fact_length_F3),fs*spectra_time,[]);
                num_spectra_F3 = size(F3_data,2);
                F3_correct = repmat(hanning_window,1,num_spectra_F3).* F3_data;%加hanning窗
                FFT_F3 = 2*abs(fft(F3_correct,num_point))/num_point;%振幅谱,标准化
                FFT_spectra_F3 = [FFT_spectra_F3,FFT_F3(1:(num_point/2),:)];%只分析一半     
            case 4
                %F4电极
                length_F4 = length(Nrem_data(nrem).nrem_data(segment).F4);%该段数据F4电极的长度
                fact_length_F4 = floor(length_F4/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                F4_data = reshape(Nrem_data(nrem).nrem_data(segment).F4(1:fact_length_F4),fs*spectra_time,[]);
                num_spectra_F4 = size(F4_data,2);
                F4_correct = repmat(hanning_window,1,num_spectra_F4).* F4_data;%加hanning窗
                FFT_F4 = 2*abs(fft(F4_correct,num_point))/num_point;%振幅谱,标准化
                FFT_spectra_F4 = [FFT_spectra_F4,FFT_F4(1:(num_point/2),:)];%只分析一半
            case 5
                %C3电极
                length_C3 = length(Nrem_data(nrem).nrem_data(segment).C3);%该段数据C3电极的长度
                fact_length_C3 = floor(length_C3/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                C3_data = reshape(Nrem_data(nrem).nrem_data(segment).C3(1:fact_length_C3),fs*spectra_time,[]);
                num_spectra_C3 = size(C3_data,2);
                C3_correct = repmat(hanning_window,1,num_spectra_C3).* C3_data;%加hanning窗
                FFT_C3 = 2*abs(fft(C3_correct,num_point))/num_point;%振幅谱,标准化
                FFT_spectra_C3 = [FFT_spectra_C3,FFT_C3(1:(num_point/2),:)];%只分析一半
            case 6
                %C4电极
                length_C4 = length(Nrem_data(nrem).nrem_data(segment).C4);%该段数据C4电极的长度
                fact_length_C4 = floor(length_C4/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                C4_data = reshape(Nrem_data(nrem).nrem_data(segment).C4(1:fact_length_C4),fs*spectra_time,[]);
                num_spectra_C4 = size(C4_data,2);
                C4_correct = repmat(hanning_window,1,num_spectra_C4).* C4_data;%加hanning窗
                FFT_C4 = 2*abs(fft(C4_correct,num_point))/num_point;%振幅谱,标准化
                FFT_spectra_C4 = [FFT_spectra_C4,FFT_C4(1:(num_point/2),:)];%只分析一半
            case 7
                %P3电极
                length_P3 = length(Nrem_data(nrem).nrem_data(segment).P3);%该段数据P3电极的长度
                fact_length_P3 = floor(length_P3/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                P3_data = reshape(Nrem_data(nrem).nrem_data(segment).P3(1:fact_length_P3),fs*spectra_time,[]);
                num_spectra_P3 = size(P3_data,2);
                P3_correct = repmat(hanning_window,1,num_spectra_P3).* P3_data;%加hanning窗
                FFT_P3 = 2*abs(fft(P3_correct,num_point))/num_point;%振幅谱,标准化
                FFT_spectra_P3 = [FFT_spectra_P3,FFT_P3(1:(num_point/2),:)];%只分析一半
            case 8
                %P4电极
                length_P4 = length(Nrem_data(nrem).nrem_data(segment).P4);%该段数据P4电极的长度
                fact_length_P4 = floor(length_P4/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                P4_data = reshape(Nrem_data(nrem).nrem_data(segment).P4(1:fact_length_P4),fs*spectra_time,[]);
                num_spectra_P4 = size(P4_data,2);
                P4_correct = repmat(hanning_window,1,num_spectra_P4).* P4_data;%加hanning窗
                FFT_P4 = 2*abs(fft(P4_correct,num_point))/num_point;%振幅谱,标准化
                FFT_spectra_P4 = [FFT_spectra_P4,FFT_P4(1:(num_point/2),:)];%只分析一半
            case 9
                %o1电极
                length_O1 = length(Nrem_data(nrem).nrem_data(segment).O1);%该段数据O1电极的长度
                fact_length_O1 = floor(length_O1/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                O1_data = reshape(Nrem_data(nrem).nrem_data(segment).O1(1:fact_length_O1),fs*spectra_time,[]);
                num_spectra_O1 = size(O1_data,2);
                O1_correct = repmat(hanning_window,1,num_spectra_O1).* O1_data;%加hanning窗
                FFT_O1 = 2*abs(fft(O1_correct,num_point))/num_point;%振幅谱
                FFT_spectra_O1 = [FFT_spectra_O1,FFT_O1(1:(num_point/2),:)];
            case 10
                %o2电极
                length_O2 = length(Nrem_data(nrem).nrem_data(segment).O2);%该段数据O2电极的长度
                fact_length_O2 = floor(length_O2/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                O2_data = reshape(Nrem_data(nrem).nrem_data(segment).O2(1:fact_length_O2),fs*spectra_time,[]);
                num_spectra_O2 = size(O2_data,2);
                O2_correct = repmat(hanning_window,1,num_spectra_O2).* O2_data;%加hanning窗
                FFT_O2 = 2*abs(fft(O2_correct,num_point))/num_point;%振幅谱
                FFT_spectra_O2 = [FFT_spectra_O2,FFT_O2(1:(num_point/2),:)];
        end   
    end 
end
fre_9_16 = frequency(frequency >= 9 & frequency <= 16);%9~16hz的频率
fre_9_16_downsample = fre_9_16(1:2:end);%9~16hz的频率序列以2进行降采样
min_duration = 0.5;%纺锤波的最小持续时间
max_duration = 2;%纺锤波的最大持续时间
switch channel
    case 1
        mean_spectra_FP1 = mean(FFT_spectra_FP1,2);%平均振幅谱
        clear FFT_spectra_FP1;
        clear FFT_FP1;
        clear FP1_correct;
        clear FP1_data;
        spectra_FP1 = mean_spectra_FP1(frequency >= 9 & frequency <= 16);%只分析9~16hz内的频谱
        spectra_FP1_down = spectra_FP1(1:2:end);
        %二次方程拟合，求二阶导
        derivative_FP1 = polyfit_2_derivation(spectra_FP1_down,fre_9_16_downsample);
        %找两个最大负峰附近的零点,确定快慢纺锤波的频率边界以及振幅阈值
        [slow_spindle_frequency_FP1,slow_amplitude_criteria_FP1,fast_spindle_frequency_FP1,fast_amplitude_criteria_FP1] = freq_bound_amp(derivative_FP1,fre_9_16_downsample,fre_9_16,spectra_FP1);
        %得到快慢纺锤波的包络
        for stage = 1:length_Nrem_data
            length_segment = length(Nrem_data(stage).nrem_data);%N2,N3阶段分别有多少段
            for segment = 1:length_segment
                length_FP1 = length(Nrem_data(stage).nrem_data(segment).FP1);%该段数据FP1电极的长度
                fact_length_FP1 = floor(length_FP1/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                mod_length = mod(length_FP1,fs*spectra_time);
                FP1_data = reshape(Nrem_data(stage).nrem_data(segment).FP1(1:fact_length_FP1),fs*spectra_time,[]);
                [detection_slow_FP1,detection_fast_FP1] = detection_spindle_envelope(FP1_data,slow_spindle_frequency_FP1,...
                                                        slow_amplitude_criteria_FP1,fast_spindle_frequency_FP1,fast_amplitude_criteria_FP1,fs,num_point);
                [detection_slow_FP1,~,~,detection_fast_FP1,~,~] = detection_duration(detection_slow_FP1,detection_fast_FP1,fs);
                detection_FP1 = detection_slow_FP1 + detection_fast_FP1;
                detection_FP1(detection_FP1>=1) = 1;
                [start_position_FP1,end_position_FP1] = start_end(detection_FP1);
                [detection_FP1,start_position_FP1,end_position_FP1] = find_duration_min(detection_FP1,start_position_FP1,end_position_FP1,min_duration,fs);
                [detection_FP1,start_position_FP1,end_position_FP1] = find_duration_max(detection_FP1,start_position_FP1,end_position_FP1,max_duration,fs);
                detection_FP1 = [detection_FP1,zeros(1,mod_length)];
                detection(stage,segment).FP1 = detection_FP1;
                start_pos(stage,segment).FP1 = start_position_FP1;
                end_pos(stage,segment).FP1 = end_position_FP1;
            end
        end
    case 2
        mean_spectra_FP2 = mean(FFT_spectra_FP2,2);%平均振幅谱
        clear FFT_spectra_FP2;
        clear FFT_FP2;
        clear FP2_correct;
        clear FP2_data;
        spectra_FP2 = mean_spectra_FP2(frequency >= 9 & frequency <= 16);%只分析9~16hz内的频谱
        spectra_FP2_down = spectra_FP2(1:2:end);
        %二次方程拟合，求二阶导
        derivative_FP2 = polyfit_2_derivation(spectra_FP2_down,fre_9_16_downsample);
        %找两个最大负峰附近的零点,确定快慢纺锤波的频率边界以及振幅阈值
        [slow_spindle_frequency_FP2,slow_amplitude_criteria_FP2,fast_spindle_frequency_FP2,fast_amplitude_criteria_FP2] = freq_bound_amp(derivative_FP2,fre_9_16_downsample,fre_9_16,spectra_FP2);
        %得到快慢纺锤波的包络
        for stage = 1:length_Nrem_data
            length_segment = length(Nrem_data(stage).nrem_data);%N2,N3阶段分别有多少段
            for segment = 1:length_segment
                length_FP2 = length(Nrem_data(stage).nrem_data(segment).FP2);%该段数据FP2电极的长度
                fact_length_FP2 = floor(length_FP2/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                mod_length = mod(length_FP2,fs*spectra_time);
                FP2_data = reshape(Nrem_data(stage).nrem_data(segment).FP2(1:fact_length_FP2),fs*spectra_time,[]);
                [detection_slow_FP2,detection_fast_FP2] = detection_spindle_envelope(FP2_data,slow_spindle_frequency_FP2,...
                                                        slow_amplitude_criteria_FP2,fast_spindle_frequency_FP2,fast_amplitude_criteria_FP2,fs,num_point);
                [detection_slow_FP2,~,~,detection_fast_FP2,~,~] = detection_duration(detection_slow_FP2,detection_fast_FP2,fs);
                detection_FP2 = detection_slow_FP2 + detection_fast_FP2;
                detection_FP2(detection_FP2>=1) = 1;
                [start_position_FP2,end_position_FP2] = start_end(detection_FP2);
                [detection_FP2,start_position_FP2,end_position_FP2] = find_duration_min(detection_FP2,start_position_FP2,end_position_FP2,min_duration,fs);
                [detection_FP2,start_position_FP2,end_position_FP2] = find_duration_max(detection_FP2,start_position_FP2,end_position_FP2,max_duration,fs);
                detection_FP2 = [detection_FP2,zeros(1,mod_length)];
                detection(stage,segment).FP2 = detection_FP2;
                start_pos(stage,segment).FP2 = start_position_FP2;
                end_pos(stage,segment).FP2 = end_position_FP2;
            end
        end
    case 3
        mean_spectra_F3 = mean(FFT_spectra_F3,2);%平均振幅谱
        clear FFT_spectra_F3;
        clear FFT_F3;
        clear F3_correct;
        clear F3_data;
        spectra_F3 = mean_spectra_F3(frequency >= 9 & frequency <= 16);%只分析9~16hz内的频谱
        spectra_F3_down = spectra_F3(1:2:end);
        %二次方程拟合，求二阶导
        derivative_F3 = polyfit_2_derivation(spectra_F3_down,fre_9_16_downsample);
        %找两个最大负峰附近的零点,确定快慢纺锤波的频率边界以及振幅阈值
        [slow_spindle_frequency_F3,slow_amplitude_criteria_F3,fast_spindle_frequency_F3,fast_amplitude_criteria_F3] = freq_bound_amp(derivative_F3,fre_9_16_downsample,fre_9_16,spectra_F3);
        %得到快慢纺锤波的包络
        for stage = 1:length_Nrem_data
            length_segment = length(Nrem_data(stage).nrem_data);%N2,N3阶段分别有多少段
            for segment = 1:length_segment
                length_F3 = length(Nrem_data(stage).nrem_data(segment).F3);%该段数据F3电极的长度
                fact_length_F3 = floor(length_F3/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                mod_length = mod(length_F3,fs*spectra_time);
                F3_data = reshape(Nrem_data(stage).nrem_data(segment).F3(1:fact_length_F3),fs*spectra_time,[]);
                [detection_slow_F3,detection_fast_F3] = detection_spindle_envelope(F3_data,slow_spindle_frequency_F3,...
                                                        slow_amplitude_criteria_F3,fast_spindle_frequency_F3,fast_amplitude_criteria_F3,fs,num_point);
                [detection_slow_F3,~,~,detection_fast_F3,~,~] = detection_duration(detection_slow_F3,detection_fast_F3,fs);
                detection_F3 = detection_slow_F3 + detection_fast_F3;
                detection_F3(detection_F3>=1) = 1;
                [start_position_F3,end_position_F3] = start_end(detection_F3);
                [detection_F3,start_position_F3,end_position_F3] = find_duration_min(detection_F3,start_position_F3,end_position_F3,min_duration,fs);
                [detection_F3,start_position_F3,end_position_F3] = find_duration_max(detection_F3,start_position_F3,end_position_F3,max_duration,fs);
                detection_F3 = [detection_F3,zeros(1,mod_length)];
                detection(stage,segment).F3 = detection_F3;
                start_pos(stage,segment).F3 = start_position_F3;
                end_pos(stage,segment).F3 = end_position_F3;
            end
        end
    case 4
        mean_spectra_F4 = mean(FFT_spectra_F4,2);%平均振幅谱
        clear FFT_spectra_F4;
        clear FFT_F4;
        clear F4_correct;
        clear F4_data;
        spectra_F4 = mean_spectra_F4(frequency >= 9 & frequency <= 16);%只分析9~16hz内的频谱
        spectra_F4_down = spectra_F4(1:2:end);
        %二次方程拟合，求二阶导
        derivative_F4 = polyfit_2_derivation(spectra_F4_down,fre_9_16_downsample);
        %找两个最大负峰附近的零点,确定快慢纺锤波的频率边界以及振幅阈值
        [slow_spindle_frequency_F4,slow_amplitude_criteria_F4,fast_spindle_frequency_F4,fast_amplitude_criteria_F4] = freq_bound_amp(derivative_F4,fre_9_16_downsample,fre_9_16,spectra_F4);
        %得到快慢纺锤波的包络
        for stage = 1:length_Nrem_data
            length_segment = length(Nrem_data(stage).nrem_data);%N2,N3阶段分别有多少段
            for segment = 1:length_segment
                length_F4 = length(Nrem_data(stage).nrem_data(segment).F4);%该段数据F4电极的长度
                fact_length_F4 = floor(length_F4/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                mod_length = mod(length_F4,fs*spectra_time);
                F4_data = reshape(Nrem_data(stage).nrem_data(segment).F4(1:fact_length_F4),fs*spectra_time,[]);
                [detection_slow_F4,detection_fast_F4] = detection_spindle_envelope(F4_data,slow_spindle_frequency_F4,...
                                                        slow_amplitude_criteria_F4,fast_spindle_frequency_F4,fast_amplitude_criteria_F4,fs,num_point);
                [detection_slow_F4,~,~,detection_fast_F4,~,~] = detection_duration(detection_slow_F4,detection_fast_F4,fs);
                detection_F4 = detection_slow_F4 + detection_fast_F4;
                detection_F4(detection_F4>=1) = 1;
                [start_position_F4,end_position_F4] = start_end(detection_F4);
                [detection_F4,start_position_F4,end_position_F4] = find_duration_min(detection_F4,start_position_F4,end_position_F4,min_duration,fs);
                [detection_F4,start_position_F4,end_position_F4] = find_duration_max(detection_F4,start_position_F4,end_position_F4,max_duration,fs);
                detection_F4 = [detection_F4,zeros(1,mod_length)];
                detection(stage,segment).F4 = detection_F4;
                start_pos(stage,segment).F4 = start_position_F4;
                end_pos(stage,segment).F4 = end_position_F4;
            end
        end
    case 5
        mean_spectra_C3 = mean(FFT_spectra_C3,2);%平均振幅谱
        clear FFT_spectra_C3;
        clear FFT_C3;
        clear C3_correct;
        clear C3_data;
        spectra_C3 = mean_spectra_C3(frequency >= 9 & frequency <= 16);%只分析9~16hz内的频谱    
        spectra_C3_down = spectra_C3(1:2:end);
        %二次方程拟合，求二阶导
        derivative_C3 = polyfit_2_derivation(spectra_C3_down,fre_9_16_downsample);
        %找两个最大负峰附近的零点,确定快慢纺锤波的频率边界以及振幅阈值
        [slow_spindle_frequency_C3,slow_amplitude_criteria_C3,fast_spindle_frequency_C3,fast_amplitude_criteria_C3] = freq_bound_amp(derivative_C3,fre_9_16_downsample,fre_9_16,spectra_C3);
        %得到快慢纺锤波的包络
        for stage = 1:length_Nrem_data
            length_segment = length(Nrem_data(stage).nrem_data);%N2,N3阶段分别有多少段
            for segment = 1:length_segment
                length_C3 = length(Nrem_data(stage).nrem_data(segment).C3);%该段数据C3电极的长度
                fact_length_C3 = floor(length_C3/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                mod_length = mod(length_C3,fs*spectra_time);
                C3_data = reshape(Nrem_data(stage).nrem_data(segment).C3(1:fact_length_C3),fs*spectra_time,[]);
                [detection_slow_C3,detection_fast_C3] = detection_spindle_envelope(C3_data,slow_spindle_frequency_C3,...
                                                        slow_amplitude_criteria_C3,fast_spindle_frequency_C3,fast_amplitude_criteria_C3,fs,num_point);
                [detection_slow_C3,~,~,detection_fast_C3,~,~] = detection_duration(detection_slow_C3,detection_fast_C3,fs);
                detection_C3 = detection_slow_C3 + detection_fast_C3;
                detection_C3(detection_C3>=1) = 1;
                [start_position_C3,end_position_C3] = start_end(detection_C3);
                [detection_C3,start_position_C3,end_position_C3] = find_duration_min(detection_C3,start_position_C3,end_position_C3,min_duration,fs);
                [detection_C3,start_position_C3,end_position_C3] = find_duration_max(detection_C3,start_position_C3,end_position_C3,max_duration,fs);
                detection_C3 = [detection_C3,zeros(1,mod_length)];
                detection(stage,segment).C3 = detection_C3;
                start_pos(stage,segment).C3 = start_position_C3;
                end_pos(stage,segment).C3 = end_position_C3;
            end
        end
    case 6
        mean_spectra_C4 = mean(FFT_spectra_C4,2);%平均振幅谱
        clear FFT_spectra_C4;
        clear FFT_C4;
        clear C4_correct;
        clear C4_data;
        spectra_C4 = mean_spectra_C4(frequency >= 9 & frequency <= 16);%只分析9~16hz内的频谱
        spectra_C4_down = spectra_C4(1:2:end);
        %二次方程拟合，求二阶导
        derivative_C4 = polyfit_2_derivation(spectra_C4_down,fre_9_16_downsample);
        %找两个最大负峰附近的零点,确定快慢纺锤波的频率边界以及振幅阈值
        [slow_spindle_frequency_C4,slow_amplitude_criteria_C4,fast_spindle_frequency_C4,fast_amplitude_criteria_C4] = freq_bound_amp(derivative_C4,fre_9_16_downsample,fre_9_16,spectra_C4);
        %得到快慢纺锤波的包络
        for stage = 1:length_Nrem_data
            length_segment = length(Nrem_data(stage).nrem_data);%N2,N3阶段分别有多少段
            for segment = 1:length_segment
                length_C4 = length(Nrem_data(stage).nrem_data(segment).C4);%该段数据C4电极的长度
                fact_length_C4 = floor(length_C4/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                mod_length = mod(length_C4,fs*spectra_time);
                C4_data = reshape(Nrem_data(stage).nrem_data(segment).C4(1:fact_length_C4),fs*spectra_time,[]);
                [detection_slow_C4,detection_fast_C4] = detection_spindle_envelope(C4_data,slow_spindle_frequency_C4,...
                                                        slow_amplitude_criteria_C4,fast_spindle_frequency_C4,fast_amplitude_criteria_C4,fs,num_point);
                [detection_slow_C4,~,~,detection_fast_C4,~,~] = detection_duration(detection_slow_C4,detection_fast_C4,fs);
                detection_C4 = detection_slow_C4 + detection_fast_C4;
                detection_C4(detection_C4>=1) = 1;
                [start_position_C4,end_position_C4] = start_end(detection_C4);
                [detection_C4,start_position_C4,end_position_C4] = find_duration_min(detection_C4,start_position_C4,end_position_C4,min_duration,fs);
                [detection_C4,start_position_C4,end_position_C4] = find_duration_max(detection_C4,start_position_C4,end_position_C4,max_duration,fs);
                detection_C4 = [detection_C4,zeros(1,mod_length)];
                detection(stage,segment).C4 = detection_C4;
                start_pos(stage,segment).C4 = start_position_C4;
                end_pos(stage,segment).C4 = end_position_C4;
            end
        end
    case 7
        mean_spectra_P3 = mean(FFT_spectra_P3,2);%平均振幅谱
        clear FFT_spectra_P3;
        clear FFT_P3;
        clear P3_correct;
        clear P3_data;
        spectra_P3 = mean_spectra_P3(frequency >= 9 & frequency <= 16);%只分析9~16hz内的频谱
        spectra_P3_down = spectra_P3(1:2:end);
        %二次方程拟合，求二阶导
        derivative_P3 = polyfit_2_derivation(spectra_P3_down,fre_9_16_downsample);
        %找两个最大负峰附近的零点,确定快慢纺锤波的频率边界以及振幅阈值
        [slow_spindle_frequency_P3,slow_amplitude_criteria_P3,fast_spindle_frequency_P3,fast_amplitude_criteria_P3] = freq_bound_amp(derivative_P3,fre_9_16_downsample,fre_9_16,spectra_P3);
        %得到快慢纺锤波的包络
        for stage = 1:length_Nrem_data
            length_segment = length(Nrem_data(stage).nrem_data);%N2,N3阶段分别有多少段
            for segment = 1:length_segment
                length_P3 = length(Nrem_data(stage).nrem_data(segment).P3);%该段数据P3电极的长度
                fact_length_P3 = floor(length_P3/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                mod_length = mod(length_P3,fs*spectra_time);
                P3_data = reshape(Nrem_data(stage).nrem_data(segment).P3(1:fact_length_P3),fs*spectra_time,[]);
                [detection_slow_P3,detection_fast_P3] = detection_spindle_envelope(P3_data,slow_spindle_frequency_P3,...
                                                        slow_amplitude_criteria_P3,fast_spindle_frequency_P3,fast_amplitude_criteria_P3,fs,num_point);
                [detection_slow_P3,~,~,detection_fast_P3,~,~] = detection_duration(detection_slow_P3,detection_fast_P3,fs);
                detection_P3 = detection_slow_P3 + detection_fast_P3;
                detection_P3(detection_P3>=1) = 1;
                [start_position_P3,end_position_P3] = start_end(detection_P3);
                [detection_P3,start_position_P3,end_position_P3] = find_duration_min(detection_P3,start_position_P3,end_position_P3,min_duration,fs);
                [detection_P3,start_position_P3,end_position_P3] = find_duration_max(detection_P3,start_position_P3,end_position_P3,max_duration,fs);
                detection_P3 = [detection_P3,zeros(1,mod_length)];
                detection(stage,segment).P3 = detection_P3;
                start_pos(stage,segment).P3 = start_position_P3;
                end_pos(stage,segment).P3 = end_position_P3;
            end
        end
    case 8
        mean_spectra_P4 = mean(FFT_spectra_P4,2);%平均振幅谱
        clear FFT_spectra_P4;
        clear FFT_P4;
        clear P4_correct;
        clear P4_data;
        spectra_P4 = mean_spectra_P4(frequency >= 9 & frequency <= 16);%只分析9~16hz内的频谱
        spectra_P4_down = spectra_P4(1:2:end);
        %二次方程拟合，求二阶导
        derivative_P4 = polyfit_2_derivation(spectra_P4_down,fre_9_16_downsample);
        %找两个最大负峰附近的零点,确定快慢纺锤波的频率边界以及振幅阈值
        [slow_spindle_frequency_P4,slow_amplitude_criteria_P4,fast_spindle_frequency_P4,fast_amplitude_criteria_P4] = freq_bound_amp(derivative_P4,fre_9_16_downsample,fre_9_16,spectra_P4);
        %得到快慢纺锤波的包络
        for stage = 1:length_Nrem_data
            length_segment = length(Nrem_data(stage).nrem_data);%N2,N3阶段分别有多少段
            for segment = 1:length_segment
                length_P4 = length(Nrem_data(stage).nrem_data(segment).P4);%该段数据P4电极的长度
                fact_length_P4 = floor(length_P4/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                mod_length = mod(length_P4,fs*spectra_time);
                P4_data = reshape(Nrem_data(stage).nrem_data(segment).P4(1:fact_length_P4),fs*spectra_time,[]);
                [detection_slow_P4,detection_fast_P4] = detection_spindle_envelope(P4_data,slow_spindle_frequency_P4,...
                                                        slow_amplitude_criteria_P4,fast_spindle_frequency_P4,fast_amplitude_criteria_P4,fs,num_point);
                [detection_slow_P4,~,~,detection_fast_P4,~,~] = detection_duration(detection_slow_P4,detection_fast_P4,fs);
                detection_P4 = detection_slow_P4 + detection_fast_P4;
                detection_P4(detection_P4>=1) = 1;
                [start_position_P4,end_position_P4] = start_end(detection_P4);
                [detection_P4,start_position_P4,end_position_P4] = find_duration_min(detection_P4,start_position_P4,end_position_P4,min_duration,fs);
                [detection_P4,start_position_P4,end_position_P4] = find_duration_max(detection_P4,start_position_P4,end_position_P4,max_duration,fs);
                detection_P4 = [detection_P4,zeros(1,mod_length)];
                detection(stage,segment).P4 = detection_P4;
                start_pos(stage,segment).P4 = start_position_P4;
                end_pos(stage,segment).P4 = end_position_P4;
            end
        end
    case 9
        mean_spectra_O1 = mean(FFT_spectra_O1,2);
        clear FFT_spectra_O1;
        clear FFT_O1;
        clear O1_correct;
        clear O1_data;
        spectra_O1 = mean_spectra_O1(frequency >= 9 & frequency <= 16);
        spectra_O1_down = spectra_O1(1:2:end);
        %二次方程拟合，求二阶导
        derivative_O1 = polyfit_2_derivation(spectra_O1_down,fre_9_16_downsample);
        %找两个最大负峰附近的零点,确定快慢纺锤波的频率边界以及振幅阈值
        [slow_spindle_frequency_O1,slow_amplitude_criteria_O1,fast_spindle_frequency_O1,fast_amplitude_criteria_O1] = freq_bound_amp(derivative_O1,fre_9_16_downsample,fre_9_16,spectra_O1);
        %得到快慢纺锤波的包络
        for stage = 1:length_Nrem_data
            length_segment = length(Nrem_data(stage).nrem_data);%N2,N3阶段分别有多少段
            for segment = 1:length_segment
                length_O1 = length(Nrem_data(stage).nrem_data(segment).O1);%该段数据O1电极的长度
                fact_length_O1 = floor(length_O1/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                mod_length = mod(length_O1,fs*spectra_time);
                O1_data = reshape(Nrem_data(stage).nrem_data(segment).O1(1:fact_length_O1),fs*spectra_time,[]);
                [detection_slow_O1,detection_fast_O1] = detection_spindle_envelope(O1_data,slow_spindle_frequency_O1,...
                                                        slow_amplitude_criteria_O1,fast_spindle_frequency_O1,fast_amplitude_criteria_O1,fs,num_point);
                [detection_slow_O1,~,~,detection_fast_O1,~,~] = detection_duration(detection_slow_O1,detection_fast_O1,fs);
                detection_O1 = detection_slow_O1 + detection_fast_O1;
                detection_O1(detection_O1>=1) = 1;
                [start_position_O1,end_position_O1] = start_end(detection_O1);
                [detection_O1,start_position_O1,end_position_O1] = find_duration_min(detection_O1,start_position_O1,end_position_O1,min_duration,fs);
                [detection_O1,start_position_O1,end_position_O1] = find_duration_max(detection_O1,start_position_O1,end_position_O1,max_duration,fs);
                detection_O1 = [detection_O1,zeros(1,mod_length)];
                detection(stage,segment).O1 = detection_O1;
                start_pos(stage,segment).O1 = start_position_O1;
                end_pos(stage,segment).O1 = end_position_O1;
            end
        end
    case 10
        mean_spectra_O2 = mean(FFT_spectra_O2,2);
        clear FFT_spectra_O2;
        clear FFT_O2;
        clear O2_correct;
        clear O2_data;
        spectra_O2 = mean_spectra_O2(frequency >= 9 & frequency <= 16);
        spectra_O2_down = spectra_O2(1:2:end);
        %二次方程拟合，求二阶导
        derivative_O2 = polyfit_2_derivation(spectra_O2_down,fre_9_16_downsample);
        %找两个最大负峰附近的零点,确定快慢纺锤波的频率边界以及振幅阈值
        [slow_spindle_frequency_O2,slow_amplitude_criteria_O2,fast_spindle_frequency_O2,fast_amplitude_criteria_O2] = freq_bound_amp(derivative_O2,fre_9_16_downsample,fre_9_16,spectra_O2);
        %得到快慢纺锤波的包络
        for stage = 1:length_Nrem_data
            length_segment = length(Nrem_data(stage).nrem_data);%N2,N3阶段分别有多少段
            for segment = 1:length_segment
                length_O2 = length(Nrem_data(stage).nrem_data(segment).O2);%该段数据O2电极的长度
                fact_length_O2 = floor(length_O2/fs/spectra_time)*fs*spectra_time;%若该段数据不能整除4*500，那么向下取整，即最后不够整除的部分去掉
                mod_length = mod(length_O2,fs*spectra_time);
                O2_data = reshape(Nrem_data(stage).nrem_data(segment).O2(1:fact_length_O2),fs*spectra_time,[]);
                [detection_slow_O2,detection_fast_O2] = detection_spindle_envelope(O2_data,slow_spindle_frequency_O2,...
                                                        slow_amplitude_criteria_O2,fast_spindle_frequency_O2,fast_amplitude_criteria_O2,fs,num_point);
                [detection_slow_O2,~,~,detection_fast_O2,~,~] = detection_duration(detection_slow_O2,detection_fast_O2,fs);
                detection_O2 = detection_slow_O2 + detection_fast_O2;
                detection_O2(detection_O2>=1) = 1;
                [start_position_O2,end_position_O2] = start_end(detection_O2);
                [detection_O2,start_position_O2,end_position_O2] = find_duration_min(detection_O2,start_position_O2,end_position_O2,min_duration,fs);
                [detection_O2,start_position_O2,end_position_O2] = find_duration_max(detection_O2,start_position_O2,end_position_O2,max_duration,fs);
                detection_O2 = [detection_O2,zeros(1,mod_length)];
                detection(stage,segment).O2 = detection_O2;
                start_pos(stage,segment).O2 = start_position_O2;
                end_pos(stage,segment).O2 = end_position_O2;
            end
        end
end
%average_spectra_derivative = mean([derivative_C3,derivative_O1],2);%为什么是C3和O1两个电极的平均，不可以是各个电极是各自的嘛？？？？
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
if first_zeros_after < 12.45 && second_zeros_after < 12.45 || first_zeros_before > 11.96 && second_zeros_before > 11.96
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