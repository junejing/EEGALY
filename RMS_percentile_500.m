function RMS_percentile_500

%%%%%%%%%%%%%%%%%%%%       �˲�������    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = 500;  % Sampling Frequency    
%%% filter_design(Fs,Fstop1,Fpass1,Fpass2,Fstop2)    % �˲���ϵ���ļ��㣬���洢ϵ�� B
Hd = kasier_filter;
% load('B.mat'); 
B = Hd.Numerator;
prefile = spm_select(1, 'dir', 'Select imported EEG file','' ...
            ,pwd,'.*');

%%%%%%%%%%%%%%%%%%%%        ����       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
unit_num = 125;    %���ٸ�����һ��rms
N2_dir_path = prefile;  % ��N2_dir_path�����б��Ե������ļ��е�·����
N2_dir = dir(N2_dir_path); %�� N2_dir��N2�����ļ��е���Ϣ�Ľṹ�壩
m = length(N2_dir); % m-2 Ϊ���Ը���
percentile = 95;
%%%%%%%%%%%%%%%%%%%   rms, threshold   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h=waitbar(0,'Please waiting...');
number_segment = zeros(1,m-2);
for subj_i = 3:m
    subj_name = N2_dir(subj_i).name; % ��subj_name����ǰ���Ե����֣�
    subj_dir_path = [N2_dir_path,subj_name]; % ��subj_dir_path����ǰ�����ļ��е�·����
    subj_dir = dir(subj_dir_path);
    number_segment(subj_i-2) = length(subj_dir)-2;
end
total_step = sum(number_segment)*10;
n = 0;
for subj_i = 3:m     % �Ա��Ե�ѭ�� (��ΪN2_dir��ǰ�����ǵ�ǰ�ļ��к��ϲ��ļ��У�����Ҫ��3��ʼ)
    subj_name = N2_dir(subj_i).name; % ��subj_name����ǰ���Ե����֣�
    subj_dir_path = [N2_dir_path,subj_name]; % ��subj_dir_path����ǰ�����ļ��е�·����
    subj_dir = dir(subj_dir_path);
    for segment = 3:length(subj_dir)
        subj_dir_name = subj_dir(segment).name;
        load([subj_dir_path,'\',subj_dir_name]);
        mat_orgn_length = size(b,2);   % ��mat_length��mat_orgn_data�ĳ��ȣ�
        mat_length = mat_orgn_length-mod(mat_orgn_length,unit_num); % (mat_length:�������ݳ������ܱ�unit_num�����Ĳ���)
        b_1 = b(:,1:mat_length); % ����ǰ���ݲ��ܱ�unit_num�����Ĳ��ִ����ȥ��
        left_data = b_1(1:2:9,:);
        right_data = b_1(2:2:10,:);
        left_data = left_data-ones(size(left_data,1),1)*b_1(30,:);
        right_data = right_data-ones(size(right_data,1),1)*b_1(29,:);
        data_all = [left_data;right_data];
        data_all_medi = zeros(size(data_all,1),size(data_all,2));
        data_all_medi(1:2:9,:) = left_data(1:5,:);
        data_all_medi(2:2:10,:) = right_data(1:5,:);
        data_all = data_all_medi;
        mat_data_2 = data_all';
        mat_data_3 = filtfilt(B,1,mat_data_2); % ��mat_data_2�����˲����õ�10�����ݣ���Ҫ�ϳ�ʱ�䣬����save  mat_data_3��
        mat_data_4 = reshape(mat_data_3,unit_num,[],size(data_all,1)); % �����ݽ���ά��ת��������һ����rms���㡣
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
            res = lianxu_1(rms_data_1,unit_num,Fs);    % ��������1��λ�ú͸���   
            if isempty(res)
                continue;
            else
                [spd_num,~] = size(res);%�Ĵ�������    
                spindle_position=zeros(spd_num,2);%�Ĵ����Ŀ�ʼʱ��ͽ���ʱ��
                for spd_i = 1:spd_num
                    st = res(spd_i,1);  % ����rms�Ĵ��������index
                    ed =res(spd_i,1)+res(spd_i,2)-1;  % ����rms�Ĵ����Ľ���index
                    st = (st-1)*unit_num+1;   % ����Ĵ��������index
                    ed = ed*unit_num;     % ����Ĵ����Ľ���index
                    detection(st:ed,channel)=1;
                    spindle_position(spd_i,:)=[st ed];
                    spd_data = mat_data_3(st:ed,channel);  %�õ��Ĵ�������
                    [pks_p,locs_p] = findpeaks(spd_data);  % �õ�����ֵ
                    [pks_n,locs_n] = findpeaks(-spd_data);  %�õ���Сֵ
                    locs_p = st-1+locs_p;  %�õ�����ֵ��mat_data_3 �ľ���index
                    locs_n = st-1+locs_n;  %�õ���Сֵ��mat_data_3 �ľ���index
                    %%%%%%%%%%%%%%%     �����ֵ   %%%%%%%%%%%%%%%%%%%%%%%%%
                    length_p = length(locs_p);
                    length_n = length(locs_n);
                    length_union = length_p+length_n;
                    pks_union = zeros(1,length_union);                    
                    if (locs_p(1)<locs_n(1))  % ����ֵ��ǰ��
                        pks_union(1:2:end) = pks_p;
                        pks_union(2:2:end) = pks_n;    % ���з�ֵ�Ĳ��ƴ�ӣ����ڼ���pks-to-pks
                        pks_union_1 = [pks_union(2:end),0];   % �ӵڶ�����ʼȡ
                        pks_union_2 = pks_union+pks_union_1;  %  ���� pks-to-pks
                        pks_union = pks_union_2(1:end-1);   % ȡ��ʵ�ʵ�pks-to-pks
                        [amplitude,index_1] = max(pks_union);  % �õ�����peak-to-peak                                               
                    else
                        pks_union(1:2:end) = pks_n;
                        pks_union(2:2:end) = pks_p;
                        pks_union_1 = [pks_union(2:end),0];
                        pks_union_2 = pks_union+pks_union_1;  %  ���� pks-to-pks
                        pks_union = pks_union_2(1:end-1);
                        [amplitude,index_1] = max(pks_union);  % �õ�����peak-to-peak
                    end
                    Spd_amplitude = [Spd_amplitude,amplitude];
                    %%%%%%%%%%%%%%%%%%  ����Ƶ��  %%%%%%%%%%%%%%%%%
                    N=2*Fs;
                    FFT_data=abs(fft(spd_data,N)); 
                    freqs=(1:N/2)*Fs/N;
                    index_freq1 = find(freqs <= 11);
                    index_freq2 = find(freqs <= 16);
                    [pks,locs]=findpeaks(FFT_data(index_freq1(end):index_freq2(end)));
                    [~,pks_pos] = max(pks);
                    frequency = freqs(locs(pks_pos)+index_freq1(end)-1);
                    Spd_frequency = [Spd_frequency,frequency];
                    %%%%%%%%%%%%%%%%%  �������ʱ��   %%%%%%%%%%%%%%%%%%%%%%%%%
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
            waitbar(i,h,['�����' num2str(i*100) '%']);
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
%KASIER-FILTER Returns a discrete-time filter object.

%
% MATLAB Code
% Generated by MATLAB(R) 7.14 and the Signal Processing Toolbox 6.17.
%
% Generated on: 06-Jul-2015 16:02:17
%

% FIR Window Bandpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 500;  % Sampling Frequency

Fstop1 = 10.5;            % First Stopband Frequency
Fpass1 = 11;              % First Passband Frequency
Fpass2 = 15;              % Second Passband Frequency
Fstop2 = 15.5;            % Second Stopband Frequency
Dstop1 = 0.001;           % First Stopband Attenuation
Dpass  = 0.057501127785;  % Passband Ripple
Dstop2 = 0.0001;          % Second Stopband Attenuation
flag   = 'scale';         % Sampling Flag

% Calculate the order from the parameters using KAISERORD.
[N,Wn,BETA,TYPE] = kaiserord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 ...
                             1 0], [Dstop1 Dpass Dstop2]);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
Hd = dfilt.dffir(b);

% [EOF]
end

%%%%%%%%%%%%%%%%%%%%%%%     lianxu_1    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = lianxu_1(a,Num,Fs)
%a = [0 ones(1,5)  0 0 1 0 ones(1,10) 0] ;
b = find(a) ; %�ҳ�rms�������д�����ֵ����ֵΪ1��λ��
res = [] ;
n = 1 ; 
i = 1 ;
while i < length(b)
    j = i+1 ;
    while j <= length(b) &&  b(j)==b(j-1)+1 %�����������Ϊ1
        n = n + 1 ;%����Ϊ1�ĸ���
        j = j + 1 ;
    end
    if n >= ((0.5*Fs)/Num) && n <= ((2*Fs)/Num)    % ����Ϊ1�ĸ�����Χ�ڴ�֮�ڣ�������Ĵ����ĳ���ʱ�䣬�ͽ����ֵ��¼����
        res = [res ; b(i),n] ;
   
    end
    n = 1 ;
    i = j ;
end
end

 
