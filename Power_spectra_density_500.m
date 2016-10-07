function Power_spectra_density_500
fs = 500;
unit_s = 4;   %�Զ���������ݽ��м��㣬Ĭ��4s
unit_num = fs*unit_s;  %%����ÿ��Ƶ�ʼ���ĵ�����Ĭ��500*4 = 2000��
prefile = spm_select(1, 'dir', 'Select imported EEG file','' ...
            ,pwd,'.*');
N2_dir_path = prefile; % ��N2_dir_path�����б��Ե�N2�����ļ��е�·����
N2_dir = dir(N2_dir_path);%�� N2_dir��N2�����ļ��е���Ϣ�Ľṹ�壩  Ϊʲô��5*1��
m = length(N2_dir);%m-2Ϊ���Ը�����
number_channel = 10;
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
        mat_orgn_data = b([1:10,29,30],:);% (mat_orgn_data:load����ԭʼ����)
        mat_orgn_length = size(mat_orgn_data,2); %(mat_orgn_length:mat_orgn_data�ĳ���)
        mat_length = mat_orgn_length-mod(mat_orgn_length,unit_num); %��mat_length: �������ݳ������ܱ�unit_num�����Ĳ��֣�
        mat_data_1 = mat_orgn_data(:,1:mat_length); %����ǰ���ݲ��ܱ�unit_num�����Ĳ��ִ����ȥ��
        mat_data_2 = zeros(10,mat_length); %Ĭ��Ϊ10���缫���ݲ�����˫������  ��mat_data_2: ��ȥ�ο���ѹ�����ݣ�10*6000��������mat_length��6000����       
        mat_data_2(1,:) = mat_data_1(1,:) - mat_data_1(12,:);  %%FP1�����A2���źţ�
        mat_data_2(2,:) = mat_data_1(2,:) - mat_data_1(11,:);  %%FP2�����A1���źţ�
        mat_data_2(3,:) = mat_data_1(3,:) - mat_data_1(12,:);  %%F3�����A2���źţ�
        mat_data_2(4,:) = mat_data_1(4,:) - mat_data_1(11,:);  %%F4�����A1���źţ�
        mat_data_2(5,:) = mat_data_1(5,:) - mat_data_1(12,:);  %%C3�����A2���źţ�
        mat_data_2(6,:) = mat_data_1(6,:) - mat_data_1(11,:);  %%C4�����A1���źţ�
        mat_data_2(7,:) = mat_data_1(7,:) - mat_data_1(12,:);  %%P3�����A2���źţ�
        mat_data_2(8,:) = mat_data_1(8,:) - mat_data_1(11,:);  %%P4�����A1���źţ�
        mat_data_2(9,:) = mat_data_1(9,:) - mat_data_1(12,:);  %%O1�����A2���źţ�
        mat_data_2(10,:) = mat_data_1(10,:) - mat_data_1(11,:);  %%O2�����A1���źţ�
        clear mat_orgn_data;
        clear mat_data_1;
        mat_data_3 = reshape( mat_data_2',unit_num,[],number_channel); %�����ݽ���ά��ת��������һ���Թ����׵ļ��㣨mat_data_3:(2000*10 | 2000*10 | 2000*10 .... ��7��)��
        clear mat_data_2;
        yn_fft = fft(mat_data_3,unit_num,1); %��fft  ��yn_fft����2000*10|2000*10|2000*10 .... ���߸�  complex double����
        psd_mat = abs(yn_fft).^2./(unit_num); %���㹦���ף�  ��2000*10|2000*10|2000*10 .... ���߸���
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
end
path_save = [N2_dir_path,'PSD_result_500'];
mkdir(path_save);
save([path_save,'\','all_psd.mat'],'all_mean_psd','all_psd_mat','each_mat_length','-v7.3');
close(h);
end





 