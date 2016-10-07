close all;
clear all;

name = '01';
ss_name = strcat(name,'.mat');
load(ss_name)
xdata = b(3,:)-b(30,:);%第3个通道 F3
fs = 500;%采样率
time = length(xdata)/500;
ss = strcat('时间总长为',num2str(time),'s');
disp(ss)
ra = 0.9;%第一个阈值
rb = 0.95;%第二个阈值
p = 16;%AR模型的阶数      %%%%%选择16  是不是为了保证 index_max能大等于2个
ss = strcat('AR模型阶数为',num2str(p));
disp(ss)

n=5;
w1 = 10/250;
w2 = 16/250;
wn = [w1,w2];
[b,a] = butter(n,wn,'bandpass');          %%%%% 确定10阶是可以的吗
xdata_filter = filtfilt(b,a,xdata);  %%%%% 暂时只是画图时显示用

for k = 1:time
    x_input1s = xdata((k-1)*fs+1:k*fs);%1s数据
    ar_coeffs = arburg(x_input1s,p);%使用burg方法对AR模型参数进行估计；
    ZK = roots(ar_coeffs);%求极点
    RK = abs(ZK);%极点的模
    angleK = angle(ZK);%极点的相位角
    [RK_all(k) index]= max(RK);
    if RK_all(k)>=ra
        lag(k) = 1;
        anglek(k) = angleK(index);%对应的最大相位角
        frequency(k) = anglek(k)*fs/(2*pi);%最大相位角对应的频率
    end 
end 

index1 = find(lag == 1);    %%%% 我认为应该是对 lag == 1 的那一秒进行进一步1/16的计算

%  frequency_2 = zeros(2,16,40);%每1秒数据的16个步长，每个步长对应的三个最大极点模的频率
%  RK_MAX2 = zeros(2,16,40);%每1秒数据的16个步长，每个步长对应的三个最大极点模

 n_index1=length(index1);    %%%%% 计算大于0.9的个数
 ss = strcat('大于ra=',num2str(ra),'的有',num2str(n_index1),'s');
 disp(ss)
 
if max(index1)>=floor(time)  %%%%% 判断大于0.9的最后一个1s是不是整个数据的最后1s，因为最后1s就不好后移了
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
            x_input1s = xdata((j-1)*fs+1+floor(i*fs):j*fs+floor(i*fs));%1s overlap 数据   
            [ar_coeffs2(:,k,j),NoiseVariance2] = arburg(x_input1s,p);%使用burg方法对AR模型参数进行估计；
                      
            ZK2(:,k,j) = roots(ar_coeffs2(:,k,j));%求极点
            RK2 = abs(ZK2(:,k,j));%极点的模
            angleK2 = angle(ZK2(:,k,j));%极点的相位角
            
            aa = 35;
            aa1 = 0.3;
            index_max = find(angleK2 >=aa1*2*pi/fs & angleK2 <=aa*2*pi/fs  );%只分析在0.3-35Hz之间                 %%% 基本上就只能得到两个
            angleK2_max = angleK2(index_max);%处于0.3-35Hz且小于35hz的有哪些相位角
            RK2_max = RK2(index_max);%这些相位角对应的模
            [RK2_MAX,INDEX] = sort(RK2_max,'descend');%对这些模进行降序排列
            
           if numel(index_max) >= 2       %%%% 当符合条件的极点个数大等于 2 个时
                RK_MAX2(:,k,j) = RK2_MAX(1:2);%分析前两个最大模                                         %%% 2*16*9
                frequency_2(:,k,j) = angleK2_max(INDEX(1:2))*fs/(2*pi);%前三个最大模对应的频率
                np_2 = np_2+1;             %%%% 统计符合条件的极点大于2的个数
                
           elseif numel(index_max) == 1      %%%% 当符合条件的极点个数等于 1 个时
                RK_MAX2(1,k,j) = RK2_MAX;
                RK_MAX2(2,k,j) = RK2_MAX;    %%%%  令两个相同
                frequency_2(1,k,j) = (angleK2_max(INDEX)*fs/(2*pi));
                frequency_2(2,k,j) = (angleK2_max(INDEX)*fs/(2*pi));
                np_1 = np_1+1;             %%%% 统计符合条件的极点等于1的个数
                
           else
               RK_MAX2(1,k,j) = 0;
               RK_MAX2(2,k,j) = 0;
               frequency_2(1,k,j) = 0;
               frequency_2(2,k,j) = 0;
               np_0 = np_0+1;             %%%% 统计符合条件的极点等于0的个数
                      
            end
        end
  end
ss = strcat('符合 ',num2str(aa1),'-',num2str(aa),'Hz 的极点数大等于2的有',num2str(np_2),'个； ','符合条件的极点数为1的有',num2str(np_1),'个； ','符合条件的极点数为0的有',num2str(np_0),'个');
disp(ss);

RK_MAX2_changed = reshape(RK_MAX2,2,[]);
frequency_2_changed = reshape(frequency_2,2,[]);

rk_data = RK_MAX2_changed(2,:);      %%%% 找一个好标记的变量

index_fre = find(rk_data>=0.95 & frequency_2_changed(2,:)>=10 & frequency_2_changed(2,:)<=16);   %%%%% 第二大模值中大0.9,且频率在11.5-16Hz的index


%%%%%%%%%%%%%%%%%%%%%%%%%% 检测纺锤波 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 下面的检测条件是：当两段之间的间隔小于3个，认为有其他因素影响了其频率，把它们合并成一段（当然这个3只是临时定的，还没有理论依据）
 len = length(rk_data);
 rk_data_1 = zeros(len,1);
 for m = 1:1:length(index_fre)
     rk_data_1(index_fre(m))=1;        %%%% 在符合纺锤波两个条件的点上，值为1
 end
 
 for n2 = 2:1:len-1  
         if rk_data_1(n2-1)-rk_data_1(n2) == 1
             if(rk_data_1(n2)-rk_data_1(n2+1)==-1 || rk_data_1(n2)-rk_data_1(n2+2)==-1 || rk_data_1(n2)-rk_data_1(n2+3)==-1)     %%%% 认为连续0在3个以内就应该设为1
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
idx_1 = find(lag_idxp==1);     %%%% 分段点的index

if numel(idx_1) ~=0            %%%% 先判断一下是否有分段点
    nu_1 = ceil(length(idx_1)/2);    %%%% 一共有几段
    max_yp = zeros(1,nu_1);
    max_idx = zeros(1,nu_1);
    det_time = zeros(1,nu_1);
    det_nu = 0;
    det_ontime = zeros(1,nu_1);
    det_offtime = zeros(1,nu_1);
    for i2 = 0:1:nu_1-1                               
        ii=i2+1;
        if i2 == 0    %%%% 要分3中情况，开头的，中间的，结尾
            max_yp(1)=max(rk_data(idx_1(1):(idx_1(2)-1)));  %%%开头时的序号是固定的，且不适宜用i2，或ii表示
            %max_yp(1)=max(rk_data(idx_1(1):idx_1(2)));        
            max_idx(1)=find(rk_data==max_yp(1));        
            det_time(1)=((idx_1(2)-1)-(idx_1(1)))/16+1/16;
            %det_time(1)=(idx_1(2)-idx_1(1))/16;
            det_ontime(1) = idx_1(1)/16;
            %det_offtime(1) = (idx_1(2)-1)/16;
            det_offtime(1) = idx_1(2)/16;
            
            if ~(det_time(ii)>=0.5 && det_time(ii)<=2)
            max_yp(ii) = 0;                               %%%% 给持续时间不符合的的用0标记一下
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
            
        else                                                %%%%  结尾时要考虑是不是到数据的最后一个点
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
det_ontim = det_ontime(idx_2);   %%% 纺锤波开始时间
det_offtim = det_offtime(idx_2); %%% 纺锤波结束时间

for i = 0:1:length(idx_2)-1          %%% 把开始时间和阶数时间刚在一个变量里
    det_onoff(2*i+1) =det_ontim(i+1);
    det_onoff((i+1)*2)=det_offtim(i+1);
end

max_ang = frequency_2_changed(2,max_id);    %%%% 最大值对应的频率
max_time = max_id/16;  

s1=sprintf('%.2fHz  ',max_ang);
s2=sprintf('%.2fs  ',det_tim);
s_onoff=sprintf('%.2fs  ',det_onoff);

s3 = strcat('检测出的疑似纺锤波的个数为',num2str(det_nu),'个');   
s4 = strcat('频率分别是',s1);
s5 = strcat('持续时间分别是',s2);
disp(s3);
disp(s4);
disp(s5);
disp(s_onoff);


index_spd = find(rk_data_1 == 1);   %%%%% 第二大模值中大0.9,且频率在11.5-16Hz的index
mark_abs = RK_MAX2_changed(2,index_spd);              %%%%% 第二大模值 符合纺锤波两个条件的模值
mark_ang = frequency_2_changed(2,index_spd);          %%%%% 第二大模值 符合纺锤波两个条件的相角

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%% 肉眼确定的纺锤波位置 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% 01.mat 
%%%% 第一段纺锤波时间为1.7-2.4s，第二段纺锤波为15.5-16.3s，第三段纺锤波为24.5-25.1s，
%%%% 第四段纺锤波为28.6-29.3s（第二段比较勉强算纺锤波，但是在F4是明显的纺锤波）
%%%% [1.7 2.4 15.5 16.3 24.5 25.1 28.6 29.3]
%%%% 03.mat
%%%% 第一段纺锤波时间为8.8-9.4s，第二段纺锤波为13.5-14.5s，第三段纺锤波为21.5-22.3s，
%%%% 第四段纺锤波为27.4-28.1s，第五段纺锤波为31.8-32.4，第六段纺锤波为36.2-36.7
%%%% [8.8 9.4 13.5 14.5 21.5 22.3 27.4 28.1 31.8 32.4 36.2 36.7]
%%%% 04.mat
%%%% [3.4 3.9 10.4 11 23.8 24.4]  3.4-3.9是F4的
%%%% 05.mat
%%%% [2.1 3.2 15.3 16.2 27 28.6]   16.2-28.6是F4的
%%%% 06.mat
%%%% [1.5 2.1 5.4 6 12 12.8 23.2 23.7 31 31.7 34.9 35.5 46.6 47.1 53 54 55.7 56.2]

spdt = input('输入肉眼检测的纺锤波时间\n');   %%%% 注意输入的应该为[......]，行向量;若不需要这个，则直接输入[]


nu_spd = length(spdt)/2;   %%%% 纺锤波个数
spd_time=zeros(nu_spd,1);
for i1=1:1:nu_spd
    spd_time(i1) =[spdt(i1*2)-spdt(i1*2-1)];
end
ss=sprintf('%.2fs  ',spd_time);
ss = strcat('肉眼检测出',num2str(nu_spd),'个纺锤波','  时间分别是',ss);

disp(ss);
spd=cell(nu_spd,1);
spd_d=cell(nu_spd,1);
for i1=1:1:nu_spd
    spd{i1,1} =[spdt(i1*2-1)*fs:spdt(i1*2)*fs];
    spd_d{i1,1}=xdata_filter(spd{i1,1});
end
ss = strcat('肉眼检测和自动检测相差',num2str(abs(det_nu-nu_spd)),'个');
disp(ss);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 画图 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
subplot(3,1,1);
plot((1:500*time)/500,xdata_filter(1:time*fs),'g');
axis tight;
hold on;
for i2 = 1:1:nu_spd
plot(spd{i2,1}/500,spd_d{i2,1},'b');
end
title('滤波后信号');


subplot(3,1,2);
plot((1:16*rtime)/16,RK_MAX2_changed(1,:),'r',(1:16*rtime)/16,RK_MAX2_changed(2,:),'g');
ylim([0.7 1.1]);
hold on;
plot((1:16*rtime)/16,0.95,'b--');
legend('最大模','第二个最大模','Location', 'SouthEast');
hold on;
plot(index_spd/16,mark_abs,'b.');
hold on;

plot(max_id/16,max_y,'ro');   %%% 画出每段内的最大值
hold on;
quiver(max_id/16,0.9*ones(1,det_nu),zeros(1,det_nu),max_y-0.9,0.004,'r*');  %%%%  没画出箭头




subplot(3,1,3);
plot((1:16*rtime)/16,frequency_2_changed(1,:),'r.',(1:16*rtime)/16,frequency_2_changed(2,:),'g.');   %%%%% 因为有些点重复的话会覆盖掉，所以用不同的标注
legend('最大模对应的频率','第二个最大模对应的频率','Location', 'SouthEast');
hold on;
plot(index_spd/16,mark_ang,'b.');
hold on;
plot(max_id/16,max_ang,'ro');
hold on;
plot((1:16*rtime)/16,10,'b--');
plot((1:16*rtime)/16,16,'b--');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%% 保存纺锤波频率和时间 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fid = fopen('纺锤波信息1.txt','wt+');
% fprintf(fid,'纺锤波个数为 %d\n',det_nu);
% fprintf(fid,'纺锤波频率分别为 %s\n',s1);
% fprintf(fid,'纺锤波时间分别为 %s\n',s2);
% fclose(fid);

ts1 = strcat('the number of the spindles:  ',num2str(det_nu));
ts2 = strcat('the frequency of the spindles：',num2str(max_ang));
ts3 = strcat('time of occurrence of the spindles: ',num2str(max_time));
ts4 = strcat('the duration of the spindles:  ',num2str(det_tim));

dlmwrite('纺锤波信息.txt',ss_name,'-append','delimiter','');
dlmwrite('纺锤波信息.txt',ts1,'-append','delimiter','');
dlmwrite('纺锤波信息.txt',ts2,'-append','delimiter','','precision','%.2f');  %%%第一行  纺锤波频率
dlmwrite('纺锤波信息.txt',ts3,'-append','delimiter','','precision','%.2f'); %%%第二行  纺锤波发生时间

dlmwrite('纺锤波信息.txt',ts4,'-append','delimiter','','precision','%.2f','newline','pc','newline','pc');   %%%第三行 纺锤波持续时间
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 解释 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%% 纺锤波的条件：
% % % 1.rk>0.95,频率在11.5-16Hz，在间断不超过3个点是连一起
