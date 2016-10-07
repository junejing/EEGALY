function Auto_artifacts
Po = spm_select(Inf, 'any', 'Select any EEG file','' ,pwd, ...
    '\.[mMvVeErR][dDhHaA][fFDdTtwW]');%选择数据
[h,l]=size(Po);%需用到h表示选择的数据个数
%          hwait=waitbar(0,'waiting~~');%开始显示进度条
hwait=waitbar(0,'Please waiting...');
n = 0;
 for subject=1:h
    str=sprintf('正在处理第 %d 个人的数据.........................',subject);
    disp(str);
    P=Po(subject,:);%取每个人的数据名称
    Dmeg = crc_eeg_load(P);%取数据
    D = struct(Dmeg);
    data_path  = path(Dmeg);   
    % 开始判断
    Fs = fsample(Dmeg);
    epoch = 4;
    if Fs == 250
        data=D.data.y;%该被试一晚的数据
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
        for channel=1:size(data_all,1)
            n = n+1;
            dataii=data_all(channel,:);
            posi=artifact_detection(dataii,Fs,epoch);
            if channel < 16
                artifact_pos(channel) = struct('position',posi);
            elseif channel >=16
                artifact_pos(channel+2) = struct('position',posi);
            end
            if channel==1
                result=posi;
            else
                result= intersect(posi, result);
            end
            i = n/(h*size(data_all,1));
            waitbar(i,hwait,['已完成' num2str(i*100) '%']);
        end
        %result为第几个2s有伪迹（倍数为4），artifact_pos为对应电极的伪迹判断情况（也是第几个2s有伪迹）
        detection = zeros(1,size(data_all,2));
        detect_index = mod(size(data_all,2),4*Fs);
        if ~isempty(detect_index)
            detection_1 = detection(1:end-detect_index);
        end
        detection_2 = reshape(detection_1,4*Fs,[]);
        detection_2(:,result) = 1;
        detection_3 = [reshape(detection_2,1,[]),detection(end-detect_index+1:end)];
        name=D.fname;%找到对应文件的被试姓名
        name(end-3:end)=[];%把.mat去掉，取被试编号和姓名
        data_path_all = [data_path,'\',name];
        mkdir(data_path_all);%在存放被试数据的目录下创建被试文件夹
        filename=[data_path_all, '\'];
        savefile1=[filename,name,'_result.mat'];
        save(savefile1,'result','detection_2','detection_3');
        savefile2=[filename,name,'_artifact_pos.mat'];
        save(savefile2,'artifact_pos');
    elseif Fs == 500
        data=D.data.y;%该被试一晚的数据
        left_data = data(1:2:9,:);
        right_data = data(2:2:10,:);
        left_data = left_data-ones(size(left_data,1),1)*data(30,:);
        right_data = right_data-ones(size(right_data,1),1)*data(29,:);
        data_all = [left_data;right_data];
        data_all_medi = zeros(size(data_all,1),size(data_all,2));
        data_all_medi(1:2:9,:) = left_data(1:5,:);
        data_all_medi(2:2:10,:) = right_data(1:5,:);
        data_all = data_all_medi;        
        for channel=1:size(data_all,1)
            n = n+1;
            dataii=data_all(channel,:);
            posi=artifact_detection(dataii,Fs,epoch);
            if channel < 10
                artifact_pos(channel) = struct('position',posi);
            elseif channel >=10
                artifact_pos(channel+2) = struct('position',posi);
            end
            if channel==1
                result=posi;
            else
                result= intersect(posi, result);
            end
            i = n/(h*size(data_all,1));
            waitbar(i,hwait,['已完成' num2str(i*100) '%']);
        end
        %result为第几个2s有伪迹（倍数为4），artifact_pos为对应电极的伪迹判断情况（也是第几个2s有伪迹）
        detection = zeros(1,size(data_all,2));
        detect_index = mod(size(data_all,2),4*Fs);
        if ~isempty(detect_index)
            detection_1 = detection(1:end-detect_index);
        end
        detection_2 = reshape(detection_1,4*Fs,[]);
        detection_2(:,result) = 1;
        detection_3 = [reshape(detection_2,1,[]),detection(end-detect_index+1:end)];
        name=D.fname;%找到对应文件的被试姓名
        name(end-3:end)=[];%把.mat去掉，取被试编号和姓名
        data_path_all = [data_path,'\',name];
        mkdir(data_path_all);%在存放被试数据的目录下创建被试文件夹
        filename=[data_path_all, '\'];
        savefile1=[filename,name,'_result.mat'];
        save(savefile1,'result','detection_2','detection_3');
        savefile2=[filename,name,'_artifact_pos.mat'];
        save(savefile2,'artifact_pos');
    end
    disp('伪迹判断已完成！');
 end
 close(hwait);
end
%%%%%求采样率为250Hz每个通道的结果
function [posi]=artifact_detection(a1,fs,epoch)
% function artifact_detection_250
%name=['FP1','FP2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','FZ','CZ','PZ','A1','A2','T3','T4','T5','T6',```
% t1 = clock
% load('D:\sleep data\sleepdata\210-gongjie.mat');
N = epoch*fs;%4s一个epoch
factor = 4;%中数的倍数
len=length(a1);%数据长度
lie=floor(len/N);%共有多少个4s（向下取整）
a1(N*lie+1:end)=[];%最后不够4s的数据去掉
b1=reshape(a1,N,lie);%每一列都4s，共lie列
%每4s求fft
pow = abs(fft(b1)).^2./N;%每4s求功率谱密度
%取点,52bins
frequency = (1:N/2)*fs/N;%fs/N频率分辨率
index1 = find(frequency == 32);%找到频率为32的点
index2 = find(frequency == 26);%找到频率为26的点
d1=pow(index2:4:index1,:);
%取后6个点的均值26.5-32.5作为每4s高频活动的代表数值
q1=mean(d1,1);
%判断伪迹
len2=length(q1);%高频活动的数据的长度
results=zeros(1,len2);%存储每个4s的判断结果
%%判断该4s的左侧22个2s右侧22个4s的中值与该4s值比较
for i=1:len2
    if i<23
        M=q1(1:i+22);%左侧不够22个时需要判断的4s
        m=median(M);
    elseif i>len2-22
        M=q1(i-22:end);%右侧不够22个时需要判断的4s
        m=median(M);
    else
        m=median(q1((i-22):(i+22)));%左右都足够22个4s时需判断的4s
    end
    clear M；%这样如果这次M有45个值，但下次不够45个值时后边不会补0，而是有几个就算几个的中值
    if q1(i)<=factor*m     %%%m即为要比较的中值，factor为这个阈值的倍数，判断大小得出是否为伪迹
        results(i)=0;%%0表示不是伪迹，1表示伪迹
    else
        results(i)=1;
    end
end
posi=find(results~=0);%取出伪迹的那些2s的位置
% t2 = clock
end


