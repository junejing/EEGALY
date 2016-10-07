function Auto_artifacts
Po = spm_select(Inf, 'any', 'Select any EEG file','' ,pwd, ...
    '\.[mMvVeErR][dDhHaA][fFDdTtwW]');%ѡ������
[h,l]=size(Po);%���õ�h��ʾѡ������ݸ���
%          hwait=waitbar(0,'waiting~~');%��ʼ��ʾ������
hwait=waitbar(0,'Please waiting...');
n = 0;
 for subject=1:h
    str=sprintf('���ڴ���� %d ���˵�����.........................',subject);
    disp(str);
    P=Po(subject,:);%ȡÿ���˵���������
    Dmeg = crc_eeg_load(P);%ȡ����
    D = struct(Dmeg);
    data_path  = path(Dmeg);   
    % ��ʼ�ж�
    Fs = fsample(Dmeg);
    epoch = 4;
    if Fs == 250
        data=D.data.y;%�ñ���һ�������
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
            waitbar(i,hwait,['�����' num2str(i*100) '%']);
        end
        %resultΪ�ڼ���2s��α��������Ϊ4����artifact_posΪ��Ӧ�缫��α���ж������Ҳ�ǵڼ���2s��α����
        detection = zeros(1,size(data_all,2));
        detect_index = mod(size(data_all,2),4*Fs);
        if ~isempty(detect_index)
            detection_1 = detection(1:end-detect_index);
        end
        detection_2 = reshape(detection_1,4*Fs,[]);
        detection_2(:,result) = 1;
        detection_3 = [reshape(detection_2,1,[]),detection(end-detect_index+1:end)];
        name=D.fname;%�ҵ���Ӧ�ļ��ı�������
        name(end-3:end)=[];%��.matȥ����ȡ���Ա�ź�����
        data_path_all = [data_path,'\',name];
        mkdir(data_path_all);%�ڴ�ű������ݵ�Ŀ¼�´��������ļ���
        filename=[data_path_all, '\'];
        savefile1=[filename,name,'_result.mat'];
        save(savefile1,'result','detection_2','detection_3');
        savefile2=[filename,name,'_artifact_pos.mat'];
        save(savefile2,'artifact_pos');
    elseif Fs == 500
        data=D.data.y;%�ñ���һ�������
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
            waitbar(i,hwait,['�����' num2str(i*100) '%']);
        end
        %resultΪ�ڼ���2s��α��������Ϊ4����artifact_posΪ��Ӧ�缫��α���ж������Ҳ�ǵڼ���2s��α����
        detection = zeros(1,size(data_all,2));
        detect_index = mod(size(data_all,2),4*Fs);
        if ~isempty(detect_index)
            detection_1 = detection(1:end-detect_index);
        end
        detection_2 = reshape(detection_1,4*Fs,[]);
        detection_2(:,result) = 1;
        detection_3 = [reshape(detection_2,1,[]),detection(end-detect_index+1:end)];
        name=D.fname;%�ҵ���Ӧ�ļ��ı�������
        name(end-3:end)=[];%��.matȥ����ȡ���Ա�ź�����
        data_path_all = [data_path,'\',name];
        mkdir(data_path_all);%�ڴ�ű������ݵ�Ŀ¼�´��������ļ���
        filename=[data_path_all, '\'];
        savefile1=[filename,name,'_result.mat'];
        save(savefile1,'result','detection_2','detection_3');
        savefile2=[filename,name,'_artifact_pos.mat'];
        save(savefile2,'artifact_pos');
    end
    disp('α���ж�����ɣ�');
 end
 close(hwait);
end
%%%%%�������Ϊ250Hzÿ��ͨ���Ľ��
function [posi]=artifact_detection(a1,fs,epoch)
% function artifact_detection_250
%name=['FP1','FP2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','FZ','CZ','PZ','A1','A2','T3','T4','T5','T6',```
% t1 = clock
% load('D:\sleep data\sleepdata\210-gongjie.mat');
N = epoch*fs;%4sһ��epoch
factor = 4;%�����ı���
len=length(a1);%���ݳ���
lie=floor(len/N);%���ж��ٸ�4s������ȡ����
a1(N*lie+1:end)=[];%��󲻹�4s������ȥ��
b1=reshape(a1,N,lie);%ÿһ�ж�4s����lie��
%ÿ4s��fft
pow = abs(fft(b1)).^2./N;%ÿ4s�������ܶ�
%ȡ��,52bins
frequency = (1:N/2)*fs/N;%fs/NƵ�ʷֱ���
index1 = find(frequency == 32);%�ҵ�Ƶ��Ϊ32�ĵ�
index2 = find(frequency == 26);%�ҵ�Ƶ��Ϊ26�ĵ�
d1=pow(index2:4:index1,:);
%ȡ��6����ľ�ֵ26.5-32.5��Ϊÿ4s��Ƶ��Ĵ�����ֵ
q1=mean(d1,1);
%�ж�α��
len2=length(q1);%��Ƶ������ݵĳ���
results=zeros(1,len2);%�洢ÿ��4s���жϽ��
%%�жϸ�4s�����22��2s�Ҳ�22��4s����ֵ���4sֵ�Ƚ�
for i=1:len2
    if i<23
        M=q1(1:i+22);%��಻��22��ʱ��Ҫ�жϵ�4s
        m=median(M);
    elseif i>len2-22
        M=q1(i-22:end);%�Ҳ಻��22��ʱ��Ҫ�жϵ�4s
        m=median(M);
    else
        m=median(q1((i-22):(i+22)));%���Ҷ��㹻22��4sʱ���жϵ�4s
    end
    clear M��%����������M��45��ֵ�����´β���45��ֵʱ��߲��Ჹ0�������м������㼸������ֵ
    if q1(i)<=factor*m     %%%m��ΪҪ�Ƚϵ���ֵ��factorΪ�����ֵ�ı������жϴ�С�ó��Ƿ�Ϊα��
        results(i)=0;%%0��ʾ����α����1��ʾα��
    else
        results(i)=1;
    end
end
posi=find(results~=0);%ȡ��α������Щ2s��λ��
% t2 = clock
end


