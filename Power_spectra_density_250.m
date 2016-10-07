function Power_spectra_density_250
fs = 250;
unit_s = 4;   %�Զ���������ݽ��м��㣬Ĭ��4s
unit_num = fs*unit_s;  %%����ÿ��Ƶ�ʼ���ĵ�����Ĭ��500*4 = 2000��
prefile = spm_select(1, 'dir', 'Select imported EEG file','' ...
            ,pwd,'.*');
N2_dir_path = prefile; % ��N2_dir_path�����б��Ե�N2�����ļ��е�·����
N2_dir = dir(N2_dir_path);%�� N2_dir��N2�����ļ��е���Ϣ�Ľṹ�壩  Ϊʲô��5*1��
m = length(N2_dir);%m-2Ϊ���Ը�����
number_channel = 19;
all_mean_psd = zeros(unit_num,number_channel,m-2);
h=waitbar(0,'Please waiting...');
num_subj_mat_all = zeros(1,m-2);
for subj_i = 3:m %�Ա��Ե�ѭ��
    subj_name = N2_dir(subj_i).name; %(subj_name:��ǰ���Ե�����)
    subj_dir_path = [N2_dir_path,'\',subj_name]; % ��subj_dir_path����ǰ�����ļ��е�·����
    subj_mat = dir([subj_dir_path,'\','*.mat']); % ���˺����ͨ�����*.mat�����Ͳ��õ��Ļ��е�ǰĿ¼���ϼ�Ŀ¼�� ��subj_mat����ǰ�����ļ��е���Ϣ�Ľṹ�壩
    num_subj_mat = length(subj_mat);%��num_subj_mat:��ǰ���Ե�mat������
    num_subj_mat_all(subj_i-2) = num_subj_mat; 
end
total_step = sum(num_subj_mat_all);
n = 0;
for subj_i = 3:m %�Ա��Ե�ѭ��
    subj_name = N2_dir(subj_i).name; %(subj_name:��ǰ���Ե�����)
    subj_dir_path = [N2_dir_path,'\',subj_name]; % ��subj_dir_path����ǰ�����ļ��е�·����
    subj_mat = dir([subj_dir_path,'\','*.mat']); % ���˺����ͨ�����*.mat�����Ͳ��õ��Ļ��е�ǰĿ¼���ϼ�Ŀ¼�� ��subj_mat����ǰ�����ļ��е���Ϣ�Ľṹ�壩
    num_subj_mat = length(subj_mat);%��num_subj_mat:��ǰ���Ե�mat������
    num_subj_mat_all(subj_i-2) = num_subj_mat;
    each_mat_length = zeros(1,num_subj_mat,'double');%�洢ÿһ��mat���nuit_num����
    each_mat_mean_psd = zeros(unit_num,num_subj_mat,number_channel,'double');%�洢ÿһ��mat���ƽ��������
    for N_subj_mat = 1:num_subj_mat %�Ե�ǰ���Ե�mat�ļ���ѭ��
        n = n+1;
        subj_mat_path = [subj_dir_path,'\',subj_mat(N_subj_mat).name];  %(subj_mat_path:��ǰ���Եĵ�N_subj_mat��mat�ļ�·��)
        load(subj_mat_path);
        mat_orgn_length = size(b,2);   % ��mat_length��mat_orgn_data�ĳ��ȣ�
        mat_length = mat_orgn_length-mod(mat_orgn_length,unit_num); % (mat_length:�������ݳ������ܱ�unit_num�����Ĳ���)
        data = b(:,1:mat_length); % ����ǰ���ݲ��ܱ�unit_num�����Ĳ��ִ����ȥ��
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
        mat_data_3 = reshape(data_all',unit_num,[],number_channel); %�����ݽ���ά��ת��������һ���Թ����׵ļ��㣨mat_data_3:(2000*10 | 2000*10 | 2000*10 .... ��7��)��
        clear data_all_medi;
        yn_fft = fft(mat_data_3,unit_num,1); %��fft  ��yn_fft����2000*10|2000*10|2000*10 .... ���߸�  complex double����
        psd_mat = (abs(yn_fft)).^2./(unit_num); %���㹦���ף�  ��2000*10|2000*10|2000*10 .... ���߸���
        each_mat_length(1,N_subj_mat) = size(mat_data_3,2); %�洢��ǰmat��unit_num������ ��each_mat_length����1*4�����������������4��mat����
        each_mat_mean_psd(:,N_subj_mat,:) = mean(psd_mat,2); %�洢��ǰ���ݶε�ƽ�������ף���each_mat_mean_psd����2000*4*10���� ��2000*4,2000*4,2000*4,...... 2000*4 ��10����
        all_psd_mat(subj_i-2,N_subj_mat) = struct('all_psd_mat',psd_mat);
        i = n/total_step;
        waitbar(i,h,['�����' num2str(i*100) '%']);
    end
    M_1 = reshape(each_mat_mean_psd,size(each_mat_mean_psd,1),[]);  %����ǰ���Եĸ����ݶ�ƽ�������׵���ά�洢Ϊ��ά��2000*4 | 2000*4 |2000*4 |...... ��10����
    M_1_L = repmat(each_mat_length,size(M_1,1),size(M_1,2)/num_subj_mat); %�������ݶεĳ��Ⱦ����Ƴ�����M_1�Ĵ�С  ( 2000*4 | 2000*4 |200*4 |...... ��10����
    M_2 = reshape(M_1.*M_1_L,size(M_1,1),num_subj_mat,[]); % �������ݶγ��ȳ��Ը����ݶε�ƽ�������ף��������Ȩ�صĹ�������Ϣ����Ϊ��ά (2000*4,2000*4,2000*4,...... ��10��)
    subj_unit_length = sum(each_mat_length); %���㵱ǰ����ȫ�����ݵ��ܳ��ȣ��ж���unit_num
    subj_mean_psd = reshape(sum(M_2,2)/subj_unit_length,size(M_2,1),[]); %���㵱ǰ���Ե�ȫ�����ݵ�ƽ�������ף���ά  2000*10
    all_mean_psd(:,:,subj_i-2) =subj_mean_psd;  %����ǰ����ƽ�������״���ȫ������ƽ�������״洢�ռ��� �������� 
    subj_mat_length(subj_i-2) = struct('each_mat_length',each_mat_length);
end
path_save = [N2_dir_path,'PSD_result_250'];
mkdir(path_save);
save([path_save,'\','all_psd.mat'],'all_mean_psd','all_psd_mat','subj_mat_length','-v7.3');
close(h);
end





 