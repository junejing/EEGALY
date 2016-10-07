function Power_spectra_density_250
fs = 250;
unit_s = 4;   %对多少秒的数据进行计算，默认4s
unit_num = fs*unit_s;  %%计算每次频率计算的点数，默认500*4 = 2000个
prefile = spm_select(1, 'dir', 'Select imported EEG file','' ...
            ,pwd,'.*');
N2_dir_path = prefile; % （N2_dir_path：所有被试的N2数据文件夹的路径）
N2_dir = dir(N2_dir_path);%（ N2_dir：N2数据文件夹的信息的结构体）  为什么是5*1？
m = length(N2_dir);%m-2为被试个数？
number_channel = 19;
all_mean_psd = zeros(unit_num,number_channel,m-2);
h=waitbar(0,'Please waiting...');
num_subj_mat_all = zeros(1,m-2);
for subj_i = 3:m %对被试的循环
    subj_name = N2_dir(subj_i).name; %(subj_name:当前被试的名字)
    subj_dir_path = [N2_dir_path,'\',subj_name]; % （subj_dir_path：当前被试文件夹的路径）
    subj_mat = dir([subj_dir_path,'\','*.mat']); % 用了后面的通配符‘*.mat’，就不用担心还有当前目录和上级目录了 （subj_mat：当前被试文件夹的信息的结构体）
    num_subj_mat = length(subj_mat);%（num_subj_mat:当前被试的mat个数）
    num_subj_mat_all(subj_i-2) = num_subj_mat; 
end
total_step = sum(num_subj_mat_all);
n = 0;
for subj_i = 3:m %对被试的循环
    subj_name = N2_dir(subj_i).name; %(subj_name:当前被试的名字)
    subj_dir_path = [N2_dir_path,'\',subj_name]; % （subj_dir_path：当前被试文件夹的路径）
    subj_mat = dir([subj_dir_path,'\','*.mat']); % 用了后面的通配符‘*.mat’，就不用担心还有当前目录和上级目录了 （subj_mat：当前被试文件夹的信息的结构体）
    num_subj_mat = length(subj_mat);%（num_subj_mat:当前被试的mat个数）
    num_subj_mat_all(subj_i-2) = num_subj_mat;
    each_mat_length = zeros(1,num_subj_mat,'double');%存储每一个mat里的nuit_num个数
    each_mat_mean_psd = zeros(unit_num,num_subj_mat,number_channel,'double');%存储每一个mat里的平均功率谱
    for N_subj_mat = 1:num_subj_mat %对当前被试的mat文件的循环
        n = n+1;
        subj_mat_path = [subj_dir_path,'\',subj_mat(N_subj_mat).name];  %(subj_mat_path:当前被试的第N_subj_mat个mat文件路径)
        load(subj_mat_path);
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
        mat_data_3 = reshape(data_all',unit_num,[],number_channel); %对数据进行维度转换，便于一次性功率谱的计算（mat_data_3:(2000*10 | 2000*10 | 2000*10 .... 有7个)）
        clear data_all_medi;
        yn_fft = fft(mat_data_3,unit_num,1); %求fft  （yn_fft：（2000*10|2000*10|2000*10 .... 有七个  complex double））
        psd_mat = (abs(yn_fft)).^2./(unit_num); %计算功率谱；  （2000*10|2000*10|2000*10 .... 有七个）
        each_mat_length(1,N_subj_mat) = size(mat_data_3,2); %存储当前mat的unit_num个数； （each_mat_length：（1*4）（假设这个被试有4个mat））
        each_mat_mean_psd(:,N_subj_mat,:) = mean(psd_mat,2); %存储当前数据段的平均功率谱；（each_mat_mean_psd：（2000*4*10）） （2000*4,2000*4,2000*4,...... 2000*4 有10个）
        all_psd_mat(subj_i-2,N_subj_mat) = struct('all_psd_mat',psd_mat);
        i = n/total_step;
        waitbar(i,h,['已完成' num2str(i*100) '%']);
    end
    M_1 = reshape(each_mat_mean_psd,size(each_mat_mean_psd,1),[]);  %将当前被试的各数据段平均功率谱的三维存储为二维（2000*4 | 2000*4 |2000*4 |...... 有10个）
    M_1_L = repmat(each_mat_length,size(M_1,1),size(M_1,2)/num_subj_mat); %将各数据段的长度矩阵复制成上面M_1的大小  ( 2000*4 | 2000*4 |200*4 |...... 有10个）
    M_2 = reshape(M_1.*M_1_L,size(M_1,1),num_subj_mat,[]); % 将各数据段长度乘以各数据段的平均功率谱，构造带有权重的功率谱信息，存为三维 (2000*4,2000*4,2000*4,...... 有10个)
    subj_unit_length = sum(each_mat_length); %计算当前被试全部数据的总长度，有多少unit_num
    subj_mean_psd = reshape(sum(M_2,2)/subj_unit_length,size(M_2,1),[]); %计算当前被试的全部数据的平均功率谱，二维  2000*10
    all_mean_psd(:,:,subj_i-2) =subj_mean_psd;  %将当前被试平均功率谱存入全部被试平均功率谱存储空间中 ？！！！ 
    subj_mat_length(subj_i-2) = struct('each_mat_length',each_mat_length);
end
path_save = [N2_dir_path,'PSD_result_250'];
mkdir(path_save);
save([path_save,'\','all_psd.mat'],'all_mean_psd','all_psd_mat','subj_mat_length','-v7.3');
close(h);
end





 