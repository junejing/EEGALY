function spindle_detection_MP_500
warning off all
prefile = spm_select(1, 'dir', 'Select imported EEG file','' ...
    ,pwd,'.*');

%%  ������ȡ
% num_subj = 30;                                                 %% ��ȡ����������
h=waitbar(0,'Please waiting...');
fs = 500;                         %% ����Ƶ�ʣ�
ds = 4;                              %% �²���������Ĭ��4����
d_fs = fs/ds;                                                               %% �����²�����Ĳ����ʣ�
N = 1024;                               %% ��ȡÿ�ηֽ���źŵ�����Ĭ��
load('GaborAtom_1024.mat');                    %% ��ȡԭ�ӿ⣻                                                                %% �ͷŲ���ʹ�õĴ洢�ռ䣻
ep = 0.05;                                                                  %% �ź��ع��в��ֹ��ֵ��
H_psd = 16;                            %% ��ȡ����spindle�����Ƶ�ʣ�
L_psd = 9;                             %% ��ȡ����spindle�����Ƶ�ʣ�
TH1 = 7.5;                                 %% ��ȡ�����spindle������ֵ������7.5����
S_duration = 0.5;                           %% ��ȡ����spindle����̳���ʱ�䣻
L_duration = 2;                           %% ��ȡ����spindle�������ʱ�䣻
Hd = kaiser_filter;
bbb = Hd.Numerator;
number_channel = 10;
%%  ���ݶ�ȡ�ͼ���
total_len = 0;
data_path=prefile;
data_dir=dir(prefile);
num_subj=length(data_dir);
number_segment = zeros(1,num_subj-2);
for subj_i = 3:num_subj
    subj_name = data_dir(subj_i).name; % ��subj_name����ǰ���Ե����֣�
    subj_dir_path = [data_path,subj_name]; % ��subj_dir_path����ǰ�����ļ��е�·����
    subj_dir = dir(subj_dir_path);
    number_segment(subj_i-2) = length(subj_dir)-2;
end
total_step = sum(number_segment)*number_channel;
n = 0;
for subj_i = 3:num_subj    % �Ա��Ե�ѭ�� ����Ҫ��3��ʼ
    subj_name = data_dir(subj_i).name; % ��subj_name����ǰ���Ե����֣�
    subj_dir_path = [data_path,subj_name]; % ��subj_dir_path����ǰ�����ļ��е�·����
    subj_dir = dir(subj_dir_path);
    for sub_matj = 3:length( subj_dir)  %%��mat�ļ���ѭ��
        spindle_num = zeros(1,number_channel);
        data_len = 0; 
        load([subj_dir_path,'\',subj_dir(sub_matj).name]);
        detection = zeros(number_channel,size(b,2));
        data_matrix = b([1:10 29:32],:);  %% ��ȡ��ǰ���ݶε���Ч���ݣ�
        decimate_data = decimate(data_matrix(1,:),ds);
        data_dowsample = zeros(size(data_matrix,1),length(decimate_data));
        for channel = 1:size(data_matrix,1)
            data_dowsample(channel,:) = decimate(data_matrix(channel,:),ds);%������
        end
        data_matrix = data_dowsample;
        SigLen = size(data_matrix,2)-mod(size(data_matrix,2),N);  %% �������ݳ������ܱ����ݵ�Ԫ�����Ĳ��֣�
        data_matrix = data_matrix(:,1:SigLen);  %% ����ǰ���ݲ��ܱ����㵥Ԫ�����Ĳ��ִ����ȥ����
        data_10channels = zeros(number_channel,SigLen);  %% �������ڷ��������ݴ洢�ռ䣻
        data_10channels(1,:) = data_matrix(1,:) - data_matrix(12,:);  %% FP1�����A2���źţ�
        data_10channels(2,:) = data_matrix(2,:) - data_matrix(11,:);  %% FP2�����A1���źţ�
        data_10channels(3,:) = data_matrix(3,:) - data_matrix(12,:);  %% F3�����A2���źţ�
        data_10channels(4,:) = data_matrix(4,:) - data_matrix(11,:);  %% F4�����A1���źţ�
        data_10channels(5,:) = data_matrix(5,:) - data_matrix(12,:);  %% C3�����A2���źţ�
        data_10channels(6,:) = data_matrix(6,:) - data_matrix(11,:);  %% C4�����A1���źţ�
        data_10channels(7,:) = data_matrix(7,:) - data_matrix(12,:);  %% P3�����A2���źţ�
        data_10channels(8,:) = data_matrix(8,:) - data_matrix(11,:);  %% P4�����A1���źţ�
        data_10channels(9,:) = data_matrix(9,:) - data_matrix(12,:);  %% O1�����A2���źţ�
        data_10channels(10,:) = data_matrix(10,:) - data_matrix(11,:);      %% O2�����A1���źţ�
        clear data_matrix;                                                  %% �ͷŲ���ʹ�õĴ洢�ռ䣻
        num_cc = SigLen/N;
        data_len = data_len + num_cc;           %% ��ʼ��Ϊ��data_len = zeros(1,num_subj)��
        data_filter = filtfilt(bbb,1,data_10channels');                       %% �����ݽ���35Hz�ĵ�ͨ�˲���
        clear data_10channels;
        data_tran = reshape(data_filter,N,num_cc,[]);                  %% ������ת��Ϊ��ά��N��*num_cc��*10��
        clear data_filter;
        guan = 0;
        for chs = 1:number_channel
            n = n+1;
            spindle_frequency = [];
            spindle_amplitude = [];
            spindle_duration = [];
            spindle_data = zeros(1,N);
            spindle_atom = zeros(1,N);
            spindle_marker = zeros(1,N);
            for len = 1:num_cc
                guan = guan+1;
                x_xdata = data_tran(:,len,chs)';
                [g_atomCoe_totle,g_atom,a,x_error] = matchPursuit(x_xdata,g,ep);
                [N1,M1] = size(g_atom);                                     %% N����ֽ��ѡ��ԭ�ӵĸ�����M��ʾÿ��ԭ�ӵĳ���
                for i = 1:N1
                    g_atom(i,:) = g_atom(i,:)*g_atomCoe_totle(i);
                    [atom_peak,index_atom] = findpeaks(g_atom(i,:));
                    if numel(atom_peak) < 2
                        continue;
                    end
                    yu = abs(fftshift(fft(g_atom(i,:)))).^2;               %% ����ͼ����ԭ�������ף����������N/2���㣩��
                    yu1 = yu(N/2+1:end);                                   %% ֻҪ�������N/2���㣬��ӦƵ�ʣ�0Hz �� (N/2-1)/(N/d_fs) Hz;
                    [yu1_peak,index1] = findpeaks(yu1);                    %% ���������׵ķ�ֵ
                    if isempty(index1)                                     %% ����Ƿ��з�ֵ����û�з�ֵ��������һ��ԭ�ӣ�
                        continue;
                    end
                    [yu1_max,index2] = max(yu1_peak);                      %% ���������׵�����ֵ
                    index = index1(index2);
                    index_tran0 = ((0:N-1)-N/2)*(d_fs/N);
                    index_tran = index_tran0(N/2+1:end);
                    if (index_tran(index) >= L_psd) && (index_tran(index) <= H_psd)   %% ��������׵�����ֵ�Ƿ���spindleƵ����Χ��
                        B = find(g_atom(i,:) >= TH1);
                        if isempty(B)
                            continue;
                        end
                        duration = (B(end) - B(1))/d_fs;
                        if duration >= S_duration && duration <= L_duration
                            marker_s = zeros(1,N);
                            spindle_num(chs) = spindle_num(chs) +1;        %% ��ʼ��Ϊ��spindle_num = zeros(10,num_subj);
                            spindle_frequency(spindle_num(chs)) = index_tran(index);%�Ĵ���Ƶ��
                            spindle_amplitude(spindle_num(chs)) = 2*max(atom_peak);%�Ĵ������
                            spindle_duration(spindle_num(chs)) = duration;%�Ĵ�������ʱ��
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
            waitbar(i,h,['�����' num2str(i*100) '%']);
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
mkdir([mp_path,'MP_results_500']);
str_path = [mp_path,'MP_results_500\'];
save([str_path,'Spindle_result_MP_500.mat'],'spindle_result_all','-v7.3');    
close(h);
end
%% -----------------------------------------------------
function [g_atomCoe_totle,g_atom,a,x_error] = matchPursuit(x,g,ep)
%% ����ƥ��׷��
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
    inner_product = g*x_error';%�����ݺ�ԭ�����ڻ���ȡ��ֵ���
    [inner_max_abs,index] = max(abs(inner_product));
    g_atom(m,:) = g(index,:);%ÿ�ε�����õ���ԭ��
    g_atomCoe_totle(m) = inner_product(index);%ÿ�ε������ڻ�ϵ��
    x_error = x_error - inner_product(index).*g(index,:);%�в�
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
% Generated on: 15-Sep-2015 20:29:41
%

% FIR Window Bandpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 500;  % Sampling Frequency

N    = 1660;     % Order
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


