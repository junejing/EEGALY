function PSD_second_order_derivative_250
close all;
clear all;
prefile = spm_select(1, 'dir', 'Select imported EEG file','' ...
            ,pwd,'.*');
fs = 250;%������
raw_data = dir(prefile);
raw_path =prefile;
length_rawdata = length(raw_data);%length_rawdata-2�����Ե�����
h=waitbar(0,'Please waiting...');
number_channel = 19;
spectra_time = 4;%ÿ4s��һ��Ƶ��
num_point = 4096;%��fftʱ�ĵ���
hanning_window = hann(spectra_time*fs);%hanning��,��������
frequency = (1:num_point/2)*fs/num_point;%������
fre_9_16 = frequency(frequency >= 9 & frequency <= 16);%9~16hz��Ƶ��
fre_9_16_downsample = fre_9_16(1:2:end);%9~16hz��Ƶ��������2���н�����
min_duration = 0.5;%�Ĵ�������С����ʱ��
max_duration = 2;%�Ĵ�����������ʱ��
slow_spindle_frequency_all = zeros(number_channel,length_rawdata-2,2);
slow_amplitude_criteria_all = zeros(number_channel,length_rawdata-2);
fast_spindle_frequency_all = zeros(number_channel,length_rawdata-2,2);
fast_amplitude_criteria_all = zeros(number_channel,length_rawdata-2);
length_segment_all = zeros(1,length_rawdata-2);
Hd = kaiser_filter;
B =  Hd.Numerator;
for raw_file = 3:length_rawdata%����
    data_path = fullfile(raw_path,raw_data(raw_file).name);
    sub_file = dir(data_path);
    length_segment_all(raw_file-2) = length(sub_file);
end
total_step = sum(length_segment_all)*number_channel;
n = 0;
for raw_file = 3:length_rawdata%����
    data_path = fullfile(raw_path,raw_data(raw_file).name);
    sub_file = dir(data_path);
    length_segment = length(sub_file);
    for segment = 3:length_segment
        data_path = fullfile(raw_path,raw_data(raw_file).name,'\',sub_file(segment).name);
        segment_data = load(data_path);%load��segment-2������
        SigLen = size(segment_data.b,2);
        data = segment_data.b; % ����ǰ���ݲ��ܱ�unit_num�����Ĳ��ִ����ȥ��
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
        data_10channels = data_all;
        clear data_all_medi;  
        data_segment(segment-2) = struct('data_10channels',data_10channels);
    end
    Nrem_data(raw_file-2) = struct('nrem_data',data_segment);%�ñ���10���缫��ȥ�ο�������
    for channel = 1:number_channel
        FFT_spectra_channel = [];
        for segment = 1:length_segment-2
            length_channel = length(Nrem_data(raw_file-2).nrem_data(segment).data_10channels(channel,:));%�ö�����FP1�缫�ĳ���
            fact_length_channel = floor(length_channel/fs/spectra_time)*fs*spectra_time;%���ö����ݲ�������4*500����ô����ȡ��������󲻹������Ĳ���ȥ��
            channel_data = reshape(Nrem_data(raw_file-2).nrem_data(segment).data_10channels(channel,1:fact_length_channel),fs*spectra_time,[]);
            num_spectra_channel = size(channel_data,2);
            channel_correct = repmat(hanning_window,1,num_spectra_channel).* channel_data;%��hanning��
            FFT_channel = 2*abs(fft(channel_correct,num_point))/num_point;%�����,��׼��
            FFT_spectra_channel = [FFT_spectra_channel,FFT_channel(1:(num_point/2),:)];%ֻ����һ��
        end
        mean_spectra_channel = mean(FFT_spectra_channel,2);%ƽ�������
        clear FFT_spectra_channel;
        clear FFT_channel;
        clear channel_correct;
        clear channel_data;
        spectra_channel = mean_spectra_channel(frequency >= 9 & frequency <= 16);%ֻ����9~16hz�ڵ�Ƶ��
        spectra_channel_down = spectra_channel(1:2:end);
        %���η�����ϣ�����׵�
        derivative_channel = polyfit_2_derivation(spectra_channel_down,fre_9_16_downsample);
        %��������󸺷帽�������,ȷ�������Ĵ�����Ƶ�ʱ߽��Լ������ֵ
        [slow_spindle_frequency,slow_amplitude_criteria,fast_spindle_frequency,fast_amplitude_criteria] = freq_bound_amp(derivative_channel,fre_9_16_downsample,fre_9_16,spectra_channel);
        slow_spindle_frequency_all(channel,raw_file-2,:) = slow_spindle_frequency;
        slow_amplitude_criteria_all(channel,raw_file-2) = slow_amplitude_criteria;
        fast_spindle_frequency_all(channel,raw_file-2,:) = fast_spindle_frequency;
        fast_amplitude_criteria_all(channel,raw_file-2) = fast_amplitude_criteria;
    end
    %�õ������Ĵ����İ���
    for segment = 1:length_segment-2
        length_data = size(Nrem_data(raw_file-2).nrem_data(segment).data_10channels,2);
        detection = zeros(number_channel,length_data);
        for channel = 1:number_channel
            n = n+1;
            length_channel = length(Nrem_data(raw_file-2).nrem_data(segment).data_10channels(channel,:));%�ö�����FP1�缫�ĳ���
            fact_length_channel = floor(length_channel/fs/spectra_time)*fs*spectra_time;%���ö����ݲ�������4*500����ô����ȡ��������󲻹������Ĳ���ȥ��
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
            %%%%%%%%%%%%%%%%%%  ����Ƶ��  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     �����ֵ   %%%%%%%%%%%%%%%%%%%%%%%%%
            Spd_frequency = [];
            Spd_amplitude = [];
            data_raw = Nrem_data(raw_file-2).nrem_data(segment).data_10channels(channel,:);
            data_filtered = filtfilt(B,1,data_raw);
            if ~isempty(start_position_channel)
                for number_spindle = 1:length(start_position_channel)
                    N=4*fs;
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
            waitbar(i,h,['�����' num2str(i*100) '%']);
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
mkdir([psd_path,'PSD_2order_results_250']);
str_path = [psd_path,'PSD_2order_results_250\'];
save([str_path,'PSD_2order_spindle_result.mat'],'detection_segment','spindle_amplitude_segment','spindle_frequency_segment','spindle_duration_segment','spindle_pos_segment',...
    'slow_spindle_frequency_all','slow_amplitude_criteria_all','fast_spindle_frequency_all','fast_amplitude_criteria_all');
close(h);
end

%%
%���η�����ϣ�����׵�
function derivative = polyfit_2_derivation(spectra_downsample,fre_downsample)
%spectra_downsample:�������������ף�
%fre_downsample������׶�Ӧ��Ƶ�ʣ�
%derivative��������׵Ķ��׵���
[spec_row,spec_colum] = size(spectra_downsample);
[freq_row,freq_colum] = size(fre_downsample);
if (spec_colum - spec_row) * (freq_colum - freq_row) < 0 
    fre_downsample = fre_downsample';%ȷ��polyfit��x,y������ά����ȣ���ͬʱΪ����������ͬʱΪ������
end
length_spectra_down = length(spectra_downsample);
derivative = zeros(1,length_spectra_down);
for n = 2:length_spectra_down-1
    p = polyfit(fre_downsample(n-1:n+1),spectra_downsample(n-1:n+1),2);%���η������ a*x^2+b*x+c
    derivative(n) = 2*p(1);%2*p(1)Ϊ���׵�
end
end

%%
% %��������󸺷帽�������,ȷ�������Ĵ�����Ƶ�ʱ߽��Լ������ֵ
function [slow_spindle_frequency,slow_amplitude_criteria,fast_spindle_frequency,fast_amplitude_criteria] = freq_bound_amp(derivative,fre_downsample,fre,spectra)
%derivative:ƽ������׽�������Ķ��׵�
%fre_downsample�����������Ƶ������
%fre��������ǰ��Ƶ������
%spectra��ƽ������ף�û�н�����
%slow_spindle_frequency�����Ĵ�����Ƶ�ʷ�Χ��
%slow_amplitude_criteria:���Ĵ����������ֵ
%fast_spindle_frequency����Ĵ�����Ƶ�ʷ�Χ��
%fast_amplitude_criteria:��Ĵ����������ֵ
[slow_spindle_frequency,slow_spindle_frequency_index,fast_spindle_frequency,fast_spindle_frequency_index] = frequency_boundary(derivative,fre_downsample,fre);
%ȷ�������Ĵ������Ե������Χ
slow_spindle_bandwidth = slow_spindle_frequency_index(2) - slow_spindle_frequency_index(1) + 1;
slow_amplitude_criteria = slow_spindle_bandwidth * (spectra(slow_spindle_frequency_index(1))+spectra(slow_spindle_frequency_index(2)))/2;%���Ĵ����������ֵ
fast_spindle_bandwidth = fast_spindle_frequency_index(2) - fast_spindle_frequency_index(1) + 1;
fast_amplitude_criteria = fast_spindle_bandwidth * (spectra(fast_spindle_frequency_index(1))+spectra(fast_spindle_frequency_index(2)))/2;%��Ĵ����������ֵ
end

%%
function [slow_spindle_frequency,slow_spindle_frequency_index,fast_spindle_frequency,fast_spindle_frequency_index] = frequency_boundary(average_spectra_derivative,fre_9_16_downsample,fre_9_16)
%average_spectra_derivative��ƽ������׵Ķ��׵���
%fre_9_16��9~16hz��Ƶ�����У�
%fre_9_16_downsample��9~16hz��4���������Ƶ�����У�
%slow_spindle_frequency�����Ĵ�����Ƶ�ʷ�Χ��
%slow_spindle_frequency_index�����Ĵ�����Ƶ�ʱ߽��Ӧ��λ�����ꣻ
%fast_spindle_frequency����Ĵ�����Ƶ�ʷ�Χ��
%fast_spindle_frequency_index����Ĵ�����Ƶ�ʱ߽��Ӧ��λ�����ꣻ
%�����ҵ����ȣ�
%t = 0:0.5:4*pi;
% average_spectra_derivative = sin(t);%��������
% average_spectra_derivative(1:2) = average_spectra_derivative(2);
% average_spectra_derivative(4:5) = average_spectra_derivative(4);
% average_spectra_derivative(11:15) = average_spectra_derivative(14);
% average_spectra_derivative(20:21) = average_spectra_derivative(20);
% average_spectra_derivative(22:23) = average_spectra_derivative(23);
% average_spectra_derivative(24:26) = average_spectra_derivative(25);
% figure;
% plot(average_spectra_derivative);
% hpeaks = dsp.PeakFinder('PeakType','Minima','PeakIndicesOutputPort',true,'PeakValuesOutputPort',true,'MaximumPeakCount',100);
% [peak_num, peak_index, peak_value] = step(hpeaks, average_spectra_derivative);%���ִ�����ʾ��To find a peak the input must have three or more rows.
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
            %diff_aver_spec == 0ʱ���ҵ�һ��0λ�õ�������һ������0λ�õ��ұߵ�ֵ��ȣ���Ϊ1����Ϊ-1����
                %���Ҷ�����1��˵���ź���������Ȼ�󲻱䣬Ȼ���������
                %���Ҷ�����-1��˵���ź����ȼ�С��Ȼ�󲻱䣬Ȼ�������С��
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
%diff2_max_index = find(diff2_aver_spec < 0)+1;%����λ�á��������λ��
diff2_min_index = find(diff2_aver_spec > 0)+1;%��Сλ��,�����ȵ�λ��
% hold on;
% plot(diff2_max_index,average_spectra_derivative(diff2_max_index),'sr');
% hold on;
% plot(diff2_min_index,average_spectra_derivative(diff2_min_index),'sb');
%�����󸺷��Ӧ�����
min_value = average_spectra_derivative(diff2_min_index);
min_value(min_value > 0) = 0;
[first_negtive_max_peak,first_negtive_max_peak_index] = max(abs(min_value));%��һ����󸺷�
[first_zeros_before,first_zeros_after] = find_zeroscrossing(average_spectra_derivative,fre_9_16_downsample,diff2_min_index,first_negtive_max_peak_index);
min_value(abs(min_value)==first_negtive_max_peak) = 0;
[~,second_negtive_max_peak_index] = max(abs(min_value));%�ڶ�����󸺷�
[second_zeros_before,second_zeros_after] = find_zeroscrossing(average_spectra_derivative,fre_9_16_downsample,diff2_min_index,second_negtive_max_peak_index);
%�����Ĵ���Ƶ��̫�������Ĵ���Ƶ��̫��
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

%�����Ĵ�����Ƶ�ʱ߽�
[~,index1a] = min(abs(fre_9_16-first_zeros_before)); %�ڸ�Ƶ�ʷֱ����¼���Ƶ�ʱ߽磬��δ���н�����ǰ
boundary1a = fre_9_16(index1a);
[~,index1b] = min(abs(fre_9_16-first_zeros_after)); 
boundary1b = fre_9_16(index1b);
[~,index2a] = min(abs(fre_9_16-second_zeros_before));
boundary2a = fre_9_16(index2a);
[~,index2b] = min(abs(fre_9_16-second_zeros_after)); 
boundary2b = fre_9_16(index2b);
if boundary1a < boundary2a %��һ����󸺷��ڵڶ�����󸺷��ǰ��
    slow_frequency_before = boundary1a; 
    slow_frequency_before_index = index1a;
    slow_frequency_after = boundary1b; 
    slow_frequency_after_index = index1b;
    fast_frequency_before = boundary2a; 
    fast_frequency_before_index = index2a;
    fast_frequency_after = boundary2b; 
    fast_frequency_after_index = index2b;
elseif boundary2a <= boundary1a %��һ����󸺷��ڵڶ�����󸺷�ĺ���
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
slow_spindle_frequency = [slow_frequency_before,slow_frequency_after];%���Ĵ�����Ƶ�ʷ�Χ
slow_spindle_frequency_index = [slow_frequency_before_index,slow_frequency_after_index];
fast_spindle_frequency = [fast_frequency_before,fast_frequency_after];%��Ĵ�����Ƶ�ʷ�Χ
fast_spindle_frequency_index = [fast_frequency_before_index,fast_frequency_after_index];
end

%%
%�õ����帽�������
function [zeros_before,zeros_after] = find_zeroscrossing(average_spectra_derivative,fre_9_16_downsample,diff2_min_index,negtive_max_peak_index)
%average_spectra_derivative:ƽ������׵Ķ��׵���
%fre_9_16_downsample��9~16hz��Ƶ�ʣ�����4���������Ƶ�����У�
%diff2_min_index������λ��
%negtive_max_peak_index����󸺷��λ��
%zeros_before������󸺷���ߵ��������㣻
%zeros_after������󸺷��ұߵ��������㣻
peak_index = diff2_min_index(negtive_max_peak_index);
k = peak_index;
while average_spectra_derivative(k) < 0
    k = k-1;
end
before_peak1 = k;
before_peak2 = k+1;
if average_spectra_derivative(before_peak1) == 0
    zeros_before = fre_9_16_downsample(before_peak1);%��󸺷��Ӧ��ǰһ�����
else
    gradient = (average_spectra_derivative(before_peak2) - average_spectra_derivative(before_peak1))...
               /(fre_9_16_downsample(before_peak2)-fre_9_16_downsample(before_peak1));%б��
    %ͨ�����Բ�ֵ�õ����
    zeros_before = (-average_spectra_derivative(before_peak1))/gradient + fre_9_16_downsample(before_peak1);
end
k = peak_index;
while average_spectra_derivative(k) < 0
    k = k+1;
end
after_peak1 = k;
after_peak2 = k-1;
if average_spectra_derivative(after_peak1) == 0
    zeros_after = fre_9_16_downsample(after_peak1);%��󸺷��Ӧ�ĺ�һ�����
else
    gradient = (average_spectra_derivative(after_peak2) - average_spectra_derivative(after_peak1))...
               /(fre_9_16_downsample(after_peak2)-fre_9_16_downsample(after_peak1));%б��
    zeros_after = (-average_spectra_derivative(after_peak1))/gradient + fre_9_16_downsample(after_peak1);
end
end

%%
function [detection_slow,detection_fast] = detection_spindle_envelope(data,slow_spindle_frequency,slow_amplitude_criteria,fast_spindle_frequency,fast_amplitude_criteria,fs,num_point)
%���Ĵ����ĸ�˹��ͨ�˲���
%resolution = fs/num_point;%Ƶ�ʷֱ���
x = (1:num_point/2)*fs/num_point;
w_slow = slow_spindle_frequency(2) - slow_spindle_frequency(1);%���Ĵ�����Ƶ�ʴ���
xm_slow = (slow_spindle_frequency(2) + slow_spindle_frequency(1))/2;%���Ĵ���������Ƶ��
gauss_slow = exp(-abs(x-xm_slow)/(w_slow/2));%��˹�˲�����������
gauss_slow_filter = [gauss_slow,gauss_slow(end:-1:1)]';
%��Ĵ����ĸ�˹��ͨ�˲���
w_fast = fast_spindle_frequency(2) - fast_spindle_frequency(1);%���Ĵ�����Ƶ�ʴ���
xm_fast = (fast_spindle_frequency(2) + fast_spindle_frequency(1))/2;%���Ĵ���������Ƶ��
gauss_fast = exp(-abs(x-xm_fast)/(w_fast/2));%��˹�˲���,������
gauss_fast_filter = [gauss_fast,gauss_fast(end:-1:1)]';
%�����ݽ��и�˹�˲����õ�ʱ���˲�����ź�
fft_data = fft(data,num_point);
num_column = size(fft_data,2);
Gauss_filter_slow = repmat(gauss_slow_filter,1,num_column);
Gauss_filter_fast = repmat(gauss_fast_filter,1,num_column);
slow_band = ifft(fft_data.*Gauss_filter_slow,num_point,'symmetric');
slow_band_data = abs(slow_band(1:4*fs,:));
fast_band = ifft(fft_data.*Gauss_filter_fast,num_point,'symmetric'); 
fast_band_data = abs(fast_band(1:4*fs,:));
%hanning���ƶ�ƽ��
hanning_window_44 = hann(44);%������
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
%�������ֵһ�µĵ㸳ֵΪ0�����ϵĵ㸳ֵΪ1
detection_slow = zeros(1,length_data);
detection_fast = zeros(1,length_data);
detection_slow(hanning_slow_data>slow_amplitude_criteria) = 1;
detection_fast(hanning_fast_data>fast_amplitude_criteria) = 1;
end

%%
%�жϷĴ����ĳ���ʱ���Ƿ���0.5~2s֮��
function [detection_slow,start_position_slow,end_position_slow,detection_fast,start_position_fast,end_position_fast] = detection_duration(detection_slow,detection_fast,fs)
min_duration = 0.5;%�Ĵ�������С����ʱ��
max_duration = 2;%�Ĵ�����������ʱ��
[start_position_slow,end_position_slow] = start_end(detection_slow);
[start_position_fast,end_position_fast] = start_end(detection_fast);
[detection_slow,start_position_slow,end_position_slow] = find_duration_min(detection_slow,start_position_slow,end_position_slow,min_duration,fs);
[detection_slow,start_position_slow,end_position_slow] = find_duration_max(detection_slow,start_position_slow,end_position_slow,max_duration,fs);
[detection_fast,start_position_fast,end_position_fast] = find_duration_min(detection_fast,start_position_fast,end_position_fast,min_duration,fs);
[detection_fast,start_position_fast,end_position_fast] = find_duration_max(detection_fast,start_position_fast,end_position_fast,max_duration,fs);
end

%%
%�Ĵ����Ŀ�ʼ����ʱ��
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
   %��detection��һ������1���ڶ�������0����ô��һ���Ĵ����Ŀ�ʼ����Ϊ1
    start_position = [1,start_position];
end
if detection(end) == 1 
    %��detection�����һ������1�������ڶ�������0����ô���һ���Ĵ����Ľ�������Ϊlength_detection
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
Fs = 250;  % Sampling Frequency

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