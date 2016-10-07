close all;
clear all;

name = '01';
ss_name = strcat(name,'.mat');
load(ss_name)
xdata = b(3,:)-b(30,:);%��3��ͨ�� F3
fs = 500;%������
time = length(xdata)/500;
ss = strcat('ʱ���ܳ�Ϊ',num2str(time),'s');
disp(ss)
ra = 0.9;%��һ����ֵ
rb = 0.95;%�ڶ�����ֵ
p = 16;%ARģ�͵Ľ���      %%%%%ѡ��16  �ǲ���Ϊ�˱�֤ index_max�ܴ����2��
ss = strcat('ARģ�ͽ���Ϊ',num2str(p));
disp(ss)

n=5;
w1 = 10/250;
w2 = 16/250;
wn = [w1,w2];
[b,a] = butter(n,wn,'bandpass');          %%%%% ȷ��10���ǿ��Ե���
xdata_filter = filtfilt(b,a,xdata);  %%%%% ��ʱֻ�ǻ�ͼʱ��ʾ��

for k = 1:time
    x_input1s = xdata((k-1)*fs+1:k*fs);%1s����
    ar_coeffs = arburg(x_input1s,p);%ʹ��burg������ARģ�Ͳ������й��ƣ�
    ZK = roots(ar_coeffs);%�󼫵�
    RK = abs(ZK);%�����ģ
    angleK = angle(ZK);%�������λ��
    [RK_all(k) index]= max(RK);
    if RK_all(k)>=ra
        lag(k) = 1;
        anglek(k) = angleK(index);%��Ӧ�������λ��
        frequency(k) = anglek(k)*fs/(2*pi);%�����λ�Ƕ�Ӧ��Ƶ��
    end 
end 

index1 = find(lag == 1);    %%%% ����ΪӦ���Ƕ� lag == 1 ����һ����н�һ��1/16�ļ���

%  frequency_2 = zeros(2,16,40);%ÿ1�����ݵ�16��������ÿ��������Ӧ��������󼫵�ģ��Ƶ��
%  RK_MAX2 = zeros(2,16,40);%ÿ1�����ݵ�16��������ÿ��������Ӧ��������󼫵�ģ

 n_index1=length(index1);    %%%%% �������0.9�ĸ���
 ss = strcat('����ra=',num2str(ra),'����',num2str(n_index1),'s');
 disp(ss)
 
if max(index1)>=floor(time)  %%%%% �жϴ���0.9�����һ��1s�ǲ����������ݵ����1s����Ϊ���1s�Ͳ��ú�����
    rtime=n_index1-1;
else 
    rtime=n_index1;
end
np_2 = 0;
np_1 = 0;
np_0 = 0;
  for jj = 1:rtime
      j = index1(jj);
        k = 0;
        for i = 0:1/16:1-1/16
            k = k +1;
            x_input1s = xdata((j-1)*fs+1+floor(i*fs):j*fs+floor(i*fs));%1s overlap ����   
            [ar_coeffs2(:,k,j),NoiseVariance2] = arburg(x_input1s,p);%ʹ��burg������ARģ�Ͳ������й��ƣ�
                      
            ZK2(:,k,j) = roots(ar_coeffs2(:,k,j));%�󼫵�
            RK2 = abs(ZK2(:,k,j));%�����ģ
            angleK2 = angle(ZK2(:,k,j));%�������λ��
            
            aa = 35;
            aa1 = 0.3;
            index_max = find(angleK2 >=aa1*2*pi/fs & angleK2 <=aa*2*pi/fs  );%ֻ������0.3-35Hz֮��                 %%% �����Ͼ�ֻ�ܵõ�����
            angleK2_max = angleK2(index_max);%����0.3-35Hz��С��35hz������Щ��λ��
            RK2_max = RK2(index_max);%��Щ��λ�Ƕ�Ӧ��ģ
            [RK2_MAX,INDEX] = sort(RK2_max,'descend');%����Щģ���н�������
            
           if numel(index_max) >= 2       %%%% �����������ļ����������� 2 ��ʱ
                RK_MAX2(:,k,j) = RK2_MAX(1:2);%����ǰ�������ģ                                         %%% 2*16*9
                frequency_2(:,k,j) = angleK2_max(INDEX(1:2))*fs/(2*pi);%ǰ�������ģ��Ӧ��Ƶ��
                np_2 = np_2+1;             %%%% ͳ�Ʒ��������ļ������2�ĸ���
                
           elseif numel(index_max) == 1      %%%% �����������ļ���������� 1 ��ʱ
                RK_MAX2(1,k,j) = RK2_MAX;
                RK_MAX2(2,k,j) = RK2_MAX;    %%%%  ��������ͬ
                frequency_2(1,k,j) = (angleK2_max(INDEX)*fs/(2*pi));
                frequency_2(2,k,j) = (angleK2_max(INDEX)*fs/(2*pi));
                np_1 = np_1+1;             %%%% ͳ�Ʒ��������ļ������1�ĸ���
                
           else
               RK_MAX2(1,k,j) = 0;
               RK_MAX2(2,k,j) = 0;
               frequency_2(1,k,j) = 0;
               frequency_2(2,k,j) = 0;
               np_0 = np_0+1;             %%%% ͳ�Ʒ��������ļ������0�ĸ���
                      
            end
        end
  end
ss = strcat('���� ',num2str(aa1),'-',num2str(aa),'Hz �ļ����������2����',num2str(np_2),'���� ','���������ļ�����Ϊ1����',num2str(np_1),'���� ','���������ļ�����Ϊ0����',num2str(np_0),'��');
disp(ss);

RK_MAX2_changed = reshape(RK_MAX2,2,[]);
frequency_2_changed = reshape(frequency_2,2,[]);

rk_data = RK_MAX2_changed(2,:);      %%%% ��һ���ñ�ǵı���

index_fre = find(rk_data>=0.95 & frequency_2_changed(2,:)>=10 & frequency_2_changed(2,:)<=16);   %%%%% �ڶ���ģֵ�д�0.9,��Ƶ����11.5-16Hz��index


%%%%%%%%%%%%%%%%%%%%%%%%%% ���Ĵ��� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ����ļ�������ǣ�������֮��ļ��С��3������Ϊ����������Ӱ������Ƶ�ʣ������Ǻϲ���һ�Σ���Ȼ���3ֻ����ʱ���ģ���û���������ݣ�
 len = length(rk_data);
 rk_data_1 = zeros(len,1);
 for m = 1:1:length(index_fre)
     rk_data_1(index_fre(m))=1;        %%%% �ڷ��ϷĴ������������ĵ��ϣ�ֵΪ1
 end
 
 for n2 = 2:1:len-1  
         if rk_data_1(n2-1)-rk_data_1(n2) == 1
             if(rk_data_1(n2)-rk_data_1(n2+1)==-1 || rk_data_1(n2)-rk_data_1(n2+2)==-1 || rk_data_1(n2)-rk_data_1(n2+3)==-1)     %%%% ��Ϊ����0��3�����ھ�Ӧ����Ϊ1
             rk_data_1(n2) = 1;
             end
         end
 end
 
lag_idxp = zeros(len,1);
n5=len;
 while n5>1                            
     a = rk_data_1(n5)-rk_data_1(n5-1);
     if a ~=0                         
         lag_idxp(n5) = 1;
     end
     n5 = n5-1;
 end
idx_1 = find(lag_idxp==1);     %%%% �ֶε��index

if numel(idx_1) ~=0            %%%% ���ж�һ���Ƿ��зֶε�
    nu_1 = ceil(length(idx_1)/2);    %%%% һ���м���
    max_yp = zeros(1,nu_1);
    max_idx = zeros(1,nu_1);
    det_time = zeros(1,nu_1);
    det_nu = 0;
    det_ontime = zeros(1,nu_1);
    det_offtime = zeros(1,nu_1);
    for i2 = 0:1:nu_1-1                               
        ii=i2+1;
        if i2 == 0    %%%% Ҫ��3���������ͷ�ģ��м�ģ���β
            max_yp(1)=max(rk_data(idx_1(1):(idx_1(2)-1)));  %%%��ͷʱ������ǹ̶��ģ��Ҳ�������i2����ii��ʾ
            %max_yp(1)=max(rk_data(idx_1(1):idx_1(2)));        
            max_idx(1)=find(rk_data==max_yp(1));        
            det_time(1)=((idx_1(2)-1)-(idx_1(1)))/16+1/16;
            %det_time(1)=(idx_1(2)-idx_1(1))/16;
            det_ontime(1) = idx_1(1)/16;
            %det_offtime(1) = (idx_1(2)-1)/16;
            det_offtime(1) = idx_1(2)/16;
            
            if ~(det_time(ii)>=0.5 && det_time(ii)<=2)
            max_yp(ii) = 0;                               %%%% ������ʱ�䲻���ϵĵ���0���һ��
            rk_data_1(idx_1(1):(idx_1(2)-1)) = 0;
            end  
            
        elseif i2 ~= nu_1-1
            max_yp(ii)=max(rk_data(idx_1(2*i2+1):(idx_1(2*(i2+1))-1)));
            %max_yp(ii)=max(rk_data(idx_1(2*i2+1):idx_1(2*(i2+1))));
            max_idx(ii)=find(rk_data==max_yp(ii));        
            det_time(ii)=((idx_1(2*(i2+1))-1)-(idx_1(2*i2+1)))/16+1/16;
            %det_time(ii)=(idx_1(2*(i2+1))-(idx_1(2*i2+1)))/16;
            det_ontime(ii)=idx_1(2*i2+1)/16;
            %det_offtime(ii)=(idx_1(2*(i2+1))-1)/16;
            det_offtime(ii)=idx_1(2*(i2+1))/16;
            
            if ~(det_time(ii)>=0.5 && det_time(ii)<=2)
            max_yp(ii) = 0;
            rk_data_1(idx_1(2*i2+1):(idx_1(2*(i2+1))-1)) = 0;
            end  
            
        else                                                %%%%  ��βʱҪ�����ǲ��ǵ����ݵ����һ����
            if (mod(numel(idx_1),2) == 0)
                max_yp(ii)=max(rk_data(idx_1(2*i2+1):(idx_1(2*(i2+1))-1)));
                %max_yp(ii)=max(rk_data(idx_1(2*i2+1):idx_1(2*(i2+1))));
                max_idx(ii)=find(rk_data==max_yp(ii));        
                det_time(ii)=((idx_1(2*(i2+1))-1)-(idx_1(2*i2+1)))/16+1/16;
                %det_time(ii)=(idx_1(2*(i2+1))-(idx_1(2*i2+1)))/16+1/16;
                det_ontime(ii)=idx_1(2*i2+1)/16;
                %det_offtime(ii)=(idx_1(2*(i2+1))-1)/16;
                det_offtime(ii)=idx_1(2*(i2+1))/16;
                
                 if ~(det_time(ii)>=0.5 && det_time(ii)<=2)
                     max_yp(ii) = 0;
                     rk_data_1(idx_1(2*i2+1):(idx_1(2*(i2+1))-1)) = 0;
                 end  
            else
                max_yp(ii)=max(rk_data(idx_1(2*i2+1):end));
                max_idx(ii)=find(rk_data==max_yp(ii));        
                det_time(ii)=(len-(idx_1(2*i2+1)))/16+1/16;
                det_ontime(ii)=idx_1(2*i2+1)/16;
                det_offtime(ii)=time-15/16;
                
                 if ~(det_time(ii)>=0.5 && det_time(ii)<=2)
                     max_yp(ii) = 0;
                     rk_data_1(idx_1(2*i2+1):end) = 0;
                 end  
            end
           
        end
         
         if max_yp(ii) ~= 0
         det_nu = det_nu+1;
        end
    end 
end

idx_2 = find(max_yp ~=0 );
%max_y = zeros(det_nu,1);
%max_id = zeros(det_nu,1);
%det_tim = zeros(det_nu,1);    
max_y = max_yp(idx_2);
max_id = max_idx(idx_2);
det_tim = det_time(idx_2);
det_ontim = det_ontime(idx_2);   %%% �Ĵ�����ʼʱ��
det_offtim = det_offtime(idx_2); %%% �Ĵ�������ʱ��

for i = 0:1:length(idx_2)-1          %%% �ѿ�ʼʱ��ͽ���ʱ�����һ��������
    det_onoff(2*i+1) =det_ontim(i+1);
    det_onoff((i+1)*2)=det_offtim(i+1);
end

max_ang = frequency_2_changed(2,max_id);    %%%% ���ֵ��Ӧ��Ƶ��
max_time = max_id/16;  

s1=sprintf('%.2fHz  ',max_ang);
s2=sprintf('%.2fs  ',det_tim);
s_onoff=sprintf('%.2fs  ',det_onoff);

s3 = strcat('���������ƷĴ����ĸ���Ϊ',num2str(det_nu),'��');   
s4 = strcat('Ƶ�ʷֱ���',s1);
s5 = strcat('����ʱ��ֱ���',s2);
disp(s3);
disp(s4);
disp(s5);
disp(s_onoff);


index_spd = find(rk_data_1 == 1);   %%%%% �ڶ���ģֵ�д�0.9,��Ƶ����11.5-16Hz��index
mark_abs = RK_MAX2_changed(2,index_spd);              %%%%% �ڶ���ģֵ ���ϷĴ�������������ģֵ
mark_ang = frequency_2_changed(2,index_spd);          %%%%% �ڶ���ģֵ ���ϷĴ����������������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%% ����ȷ���ķĴ���λ�� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% 01.mat 
%%%% ��һ�ηĴ���ʱ��Ϊ1.7-2.4s���ڶ��ηĴ���Ϊ15.5-16.3s�������ηĴ���Ϊ24.5-25.1s��
%%%% ���ĶηĴ���Ϊ28.6-29.3s���ڶ��αȽ���ǿ��Ĵ�����������F4�����ԵķĴ�����
%%%% [1.7 2.4 15.5 16.3 24.5 25.1 28.6 29.3]
%%%% 03.mat
%%%% ��һ�ηĴ���ʱ��Ϊ8.8-9.4s���ڶ��ηĴ���Ϊ13.5-14.5s�������ηĴ���Ϊ21.5-22.3s��
%%%% ���ĶηĴ���Ϊ27.4-28.1s������ηĴ���Ϊ31.8-32.4�������ηĴ���Ϊ36.2-36.7
%%%% [8.8 9.4 13.5 14.5 21.5 22.3 27.4 28.1 31.8 32.4 36.2 36.7]
%%%% 04.mat
%%%% [3.4 3.9 10.4 11 23.8 24.4]  3.4-3.9��F4��
%%%% 05.mat
%%%% [2.1 3.2 15.3 16.2 27 28.6]   16.2-28.6��F4��
%%%% 06.mat
%%%% [1.5 2.1 5.4 6 12 12.8 23.2 23.7 31 31.7 34.9 35.5 46.6 47.1 53 54 55.7 56.2]

spdt = input('�������ۼ��ķĴ���ʱ��\n');   %%%% ע�������Ӧ��Ϊ[......]��������;������Ҫ�������ֱ������[]


nu_spd = length(spdt)/2;   %%%% �Ĵ�������
spd_time=zeros(nu_spd,1);
for i1=1:1:nu_spd
    spd_time(i1) =[spdt(i1*2)-spdt(i1*2-1)];
end
ss=sprintf('%.2fs  ',spd_time);
ss = strcat('���ۼ���',num2str(nu_spd),'���Ĵ���','  ʱ��ֱ���',ss);

disp(ss);
spd=cell(nu_spd,1);
spd_d=cell(nu_spd,1);
for i1=1:1:nu_spd
    spd{i1,1} =[spdt(i1*2-1)*fs:spdt(i1*2)*fs];
    spd_d{i1,1}=xdata_filter(spd{i1,1});
end
ss = strcat('���ۼ����Զ�������',num2str(abs(det_nu-nu_spd)),'��');
disp(ss);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ��ͼ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
subplot(3,1,1);
plot((1:500*time)/500,xdata_filter(1:time*fs),'g');
axis tight;
hold on;
for i2 = 1:1:nu_spd
plot(spd{i2,1}/500,spd_d{i2,1},'b');
end
title('�˲����ź�');


subplot(3,1,2);
plot((1:16*rtime)/16,RK_MAX2_changed(1,:),'r',(1:16*rtime)/16,RK_MAX2_changed(2,:),'g');
ylim([0.7 1.1]);
hold on;
plot((1:16*rtime)/16,0.95,'b--');
legend('���ģ','�ڶ������ģ','Location', 'SouthEast');
hold on;
plot(index_spd/16,mark_abs,'b.');
hold on;

plot(max_id/16,max_y,'ro');   %%% ����ÿ���ڵ����ֵ
hold on;
quiver(max_id/16,0.9*ones(1,det_nu),zeros(1,det_nu),max_y-0.9,0.004,'r*');  %%%%  û������ͷ




subplot(3,1,3);
plot((1:16*rtime)/16,frequency_2_changed(1,:),'r.',(1:16*rtime)/16,frequency_2_changed(2,:),'g.');   %%%%% ��Ϊ��Щ���ظ��Ļ��Ḳ�ǵ��������ò�ͬ�ı�ע
legend('���ģ��Ӧ��Ƶ��','�ڶ������ģ��Ӧ��Ƶ��','Location', 'SouthEast');
hold on;
plot(index_spd/16,mark_ang,'b.');
hold on;
plot(max_id/16,max_ang,'ro');
hold on;
plot((1:16*rtime)/16,10,'b--');
plot((1:16*rtime)/16,16,'b--');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%% ����Ĵ���Ƶ�ʺ�ʱ�� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fid = fopen('�Ĵ�����Ϣ1.txt','wt+');
% fprintf(fid,'�Ĵ�������Ϊ %d\n',det_nu);
% fprintf(fid,'�Ĵ���Ƶ�ʷֱ�Ϊ %s\n',s1);
% fprintf(fid,'�Ĵ���ʱ��ֱ�Ϊ %s\n',s2);
% fclose(fid);

ts1 = strcat('the number of the spindles:  ',num2str(det_nu));
ts2 = strcat('the frequency of the spindles��',num2str(max_ang));
ts3 = strcat('time of occurrence of the spindles: ',num2str(max_time));
ts4 = strcat('the duration of the spindles:  ',num2str(det_tim));

dlmwrite('�Ĵ�����Ϣ.txt',ss_name,'-append','delimiter','');
dlmwrite('�Ĵ�����Ϣ.txt',ts1,'-append','delimiter','');
dlmwrite('�Ĵ�����Ϣ.txt',ts2,'-append','delimiter','','precision','%.2f');  %%%��һ��  �Ĵ���Ƶ��
dlmwrite('�Ĵ�����Ϣ.txt',ts3,'-append','delimiter','','precision','%.2f'); %%%�ڶ���  �Ĵ�������ʱ��

dlmwrite('�Ĵ�����Ϣ.txt',ts4,'-append','delimiter','','precision','%.2f','newline','pc','newline','pc');   %%%������ �Ĵ�������ʱ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%% �Ĵ�����������
% % % 1.rk>0.95,Ƶ����11.5-16Hz���ڼ�ϲ�����3��������һ��
