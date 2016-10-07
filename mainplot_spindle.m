function mainplot_spindle(handles)
load('Arousal_data.mat');
global currentpage
global totalpage
currentpage=str2double(get(handles.currentpage,'string'));%��ǰ��ҳ��
totalpage = ceil((nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/handles.winsize);
%%%%%��ͨ��F1-O2�ı��
if (currentpage>1)&&any(((Arou.Fp1(currentpage-1,:))))&&(Arou.j_fp1(1,currentpage-1)>0)&&...
        any((Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.Fp1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_Fp1(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_Fp1(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.Fp1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_Fp1(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_Fp1(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.Fp1(currentpage+1,:))))&&(Arou.j_fp1(1,currentpage+1)>0)...
        &&any((Arou.pos_Fp1(1,1,currentpage+1)))%�����һҳ�濪ʼβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.Fp1(currentpage+1,1))==1)%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_Fp1(1:Arou.j_fp1(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_Fp1(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_Fp1(1:Arou.j_fp1(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_Fp1(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.Fp1(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_Fp1(1:Arou.j_fp1(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_Fp1(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_Fp1(1:Arou.j_fp1(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_Fp1(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.Fp1(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_Fp1(:,:,currentpage))))
        for num2=1:Arou.j_fp1(1,currentpage);
            %                 frontpage=currentpage-1;
            
            down_x=Arou.pos_Fp1(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_Fp1(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_Fp1(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_Fp1(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.Fp1(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.Fp1(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%fp2ͨ��
if (currentpage>1)&&any(((Arou.Fp2(currentpage-1,:))))&&(Arou.j_fp2(1,currentpage-1)>0)&&...
        any((Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.Fp2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_Fp2(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_Fp2(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.Fp2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_Fp2(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_Fp2(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.Fp2(currentpage+1,:))))&&(Arou.j_fp2(1,currentpage+1)>0)...
        &&any((Arou.pos_Fp2(1,1,currentpage+1)))%�����һҳ�濪ʼβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.Fp2(currentpage+1,1))==1)%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_Fp2(1:Arou.j_fp2(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_Fp2(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_Fp2(1:Arou.j_fp2(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_Fp2(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.Fp2(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_Fp2(1:Arou.j_fp2(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_Fp2(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_Fp2(1:Arou.j_fp2(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_Fp2(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.Fp2(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_Fp2(:,:,currentpage))))
        for num2=1:Arou.j_fp2(1,currentpage);
            down_x=Arou.pos_Fp2(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_Fp2(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_Fp2(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_Fp2(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.Fp2(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.Fp2(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%f3ͨ��
if (currentpage>1)&&any(((Arou.F3(currentpage-1,:))))&&(Arou.j_f3(1,currentpage-1)>0)&&...
        any((Arou.pos_F3(Arou.j_f3(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.F3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_F3(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_F3(Arou.j_f3(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_F3(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_F3(Arou.j_f3(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f3','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.F3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_F3(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_F3(Arou.j_f3(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_F3(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_F3(Arou.j_f3(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f3','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.F3(currentpage+1,:))))&&(Arou.j_f3(1,currentpage+1)>0)...
        &&any((Arou.pos_F3(1,1,currentpage+1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.F3(currentpage+1,1)==1))%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_F3(1:Arou.j_f3(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_F3(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_F3(1:Arou.j_f3(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_F3(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f3','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.F3(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_F3(1:Arou.j_f3(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_F3(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_F3(1:Arou.j_f3(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_F3(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f3','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.F3(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_F3(:,:,currentpage))))
        for num2=1:Arou.j_f3(1,currentpage);
            down_x=Arou.pos_F3(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_F3(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_F3(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_F3(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.F3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f3','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f3','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt =round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.F3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f3','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f3','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%f4ͨ��
if (currentpage>1)&&any(((Arou.F4(currentpage-1,:))))&&(Arou.j_f4(1,currentpage-1)>0)&&...
        any((Arou.pos_F4(Arou.j_f4(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.F4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_F4(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_F4(Arou.j_f4(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_F4(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_F4(Arou.j_f4(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f4','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.F4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_F4(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_F4(Arou.j_f4(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_F4(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_F4(Arou.j_f4(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f4','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.F4(currentpage+1,:))))&&(Arou.j_f4(1,currentpage+1)>0)...
        &&any((Arou.pos_F4(1,1,currentpage+1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.F4(currentpage+1,1)==1))%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_F4(1:Arou.j_f4(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_F4(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_F4(1:Arou.j_f4(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_F4(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f4','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.F4(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_F4(1:Arou.j_f4(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_F4(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_F4(1:Arou.j_f4(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_F4(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f4','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.F4(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_F4(:,:,currentpage))))
        for num2=1:Arou.j_f4(1,currentpage);
            down_x=Arou.pos_F4(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_F4(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_F4(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_F4(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.F4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f4','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f4','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.F4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f4','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f4','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%c3ͨ��
if (currentpage>1)&&any(((Arou.C3(currentpage-1,:))))&&(Arou.j_c3(1,currentpage-1)>0)&&...
        any((Arou.pos_C3(Arou.j_c3(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.C3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_C3(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_C3(Arou.j_c3(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_C3(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_C3(Arou.j_c3(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c3','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.C3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_C3(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_C3(Arou.j_c3(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_C3(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_C3(Arou.j_c3(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c3','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.C3(currentpage+1,:))))&&(Arou.j_c3(1,currentpage+1)>0)...
        &&any((Arou.pos_C3(1,1,currentpage+1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.C3(currentpage+1,1)==1))%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_C3(1:Arou.j_c3(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_C3(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_C3(1:Arou.j_c3(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_C3(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c3','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.C3(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_C3(1:Arou.j_c3(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_C3(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_C3(1:Arou.j_c3(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_C3(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c3','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.C3(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_C3(:,:,currentpage))))
        for num2=1:Arou.j_c3(1,currentpage);
            down_x=Arou.pos_C3(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_C3(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_C3(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_C3(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            %midpt=(downpt+uppt)/2;
            
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.C3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c3','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c3','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.C3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c3','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c3','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%c4ͨ��
if (currentpage>1)&&any(((Arou.C4(currentpage-1,:))))&&(Arou.j_c4(1,currentpage-1)>0)&&...
        any((Arou.pos_C4(Arou.j_c4(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.C4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_C4(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_C4(Arou.j_c4(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_C4(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_C4(Arou.j_c4(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c4','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.C4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_C4(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_C4(Arou.j_c4(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_C4(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_C4(Arou.j_c4(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c4','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.C4(currentpage+1,:))))&&(Arou.j_c4(1,currentpage+1)>0)...
        &&any((Arou.pos_C4(1,1,currentpage+1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.C4(currentpage+1,1)==1))%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_C4(1:Arou.j_c4(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_C4(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_C4(1:Arou.j_c4(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_C4(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c4','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.C4(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_C4(1:Arou.j_c4(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_C4(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_C4(1:Arou.j_c4(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_C4(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c4','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.C4(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_C4(:,:,currentpage))))
        for num2=1:Arou.j_c4(1,currentpage);
            down_x=Arou.pos_C4(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_C4(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_C4(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_C4(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.C4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c4','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c4','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.C4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c4','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c4','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%P3ͨ��
if (currentpage>1)&&any(((Arou.P3(currentpage-1,:))))&&(Arou.j_p3(1,currentpage-1)>0)&&...
        any((Arou.pos_P3(Arou.j_p3(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.P3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_P3(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_P3(Arou.j_p3(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_P3(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_P3(Arou.j_p3(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p3','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.P3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_P3(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_P3(Arou.j_p3(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_P3(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_P3(Arou.j_p3(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p3','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.P3(currentpage+1,:))))&&(Arou.j_p3(1,currentpage+1)>0)...
        &&any((Arou.pos_P3(1,1,currentpage+1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.P3(currentpage+1,1)==1))%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_P3(1:Arou.j_p3(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_P3(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_P3(1:Arou.j_p3(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_P3(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p3','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.P3(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_P3(1:Arou.j_p3(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_P3(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_P3(1:Arou.j_p3(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_P3(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p3','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.P3(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_P3(:,:,currentpage))))
        for num2=1:Arou.j_p3(1,currentpage);
            down_x=Arou.pos_P3(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_P3(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_P3(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_P3(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.P3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p3','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p3','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.P3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p3','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p3','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%P4ͨ��
if (currentpage>1)&&any(((Arou.P4(currentpage-1,:))))&&(Arou.j_p4(1,currentpage-1)>0)&&...
        any((Arou.pos_P4(Arou.j_p4(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.P4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_P4(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_P4(Arou.j_p4(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_P4(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_P4(Arou.j_p4(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p4','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.P4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_P4(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_P4(Arou.j_p4(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_P4(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_P4(Arou.j_p4(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p4','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.P4(currentpage+1,:))))&&(Arou.j_p4(1,currentpage+1)>0)...
        &&any((Arou.pos_P4(1,1,currentpage+1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.P4(currentpage+1,1)==1))%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_P4(1:Arou.j_p4(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_P4(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_xmin(Arou.pos_P4(1:Arou.j_p4(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_P4(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p4','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.P4(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_P4(1:Arou.j_p4(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_P4(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_P4(1:Arou.j_p4(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_P4(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p4','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.P4(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_P4(:,:,currentpage))))
        for num2=1:Arou.j_p4(1,currentpage);
            down_x=Arou.pos_P4(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_P4(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_P4(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_P4(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.P4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p4','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p4','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.P4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p4','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p4','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%O1ͨ��
if (currentpage>1)&&any(((Arou.O1(currentpage-1,:))))&&(Arou.j_o1(1,currentpage-1)>0)&&...
        any((Arou.pos_O1(Arou.j_o1(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.O1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_O1(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_O1(Arou.j_o1(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_O1(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_O1(Arou.j_o1(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o1','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.O1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_O1(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_O1(Arou.j_o1(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_O1(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_O1(Arou.j_o1(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o1','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.O1(currentpage+1,:))))&&(Arou.j_o1(1,currentpage+1)>0)...
        &&any((Arou.pos_O1(1,1,currentpage+1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.O1(currentpage+1,1)==1))%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_O1(1:Arou.j_o1(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_O1(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_O1(1:Arou.j_o1(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_O1(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o1','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.O1(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_O1(1:Arou.j_o1(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_O1(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_O1(1:Arou.j_o1(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_O1(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o1','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.O1(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_O1(:,:,currentpage))))
        for num2=1:Arou.j_o1(1,currentpage);
            down_x=Arou.pos_O1(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_O1(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_O1(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_O1(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.O1(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o1','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o1','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.O1(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o1','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o1','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%o2ͨ��
if (currentpage>1)&&any(((Arou.O2(currentpage-1,:))))&&(Arou.j_o2(1,currentpage-1)>0)&&...
        any((Arou.pos_O2(Arou.j_o2(1,currentpage-1),1,currentpage-1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.O2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_O2(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_O2(Arou.j_o2(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_O2(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_O2(Arou.j_o2(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o2','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.O1(currentpage-1,1)==0.5))
        down_x=max(Arou.pos_O2(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_O2(Arou.j_o2(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_O2(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_O2(Arou.j_o2(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o2','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.O2(currentpage+1,:))))&&(Arou.j_o2(1,currentpage+1)>0)...
        &&any((Arou.pos_O2(1,1,currentpage+1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.O2(currentpage+1,1)==1))%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_O2(1:Arou.j_o2(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_O2(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_O2(1:Arou.j_o2(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_O2(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o2','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.O1(currentpage+1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=min(Arou.pos_O2(1:Arou.j_o2(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_O2(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_O2(1:Arou.j_o2(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_O2(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o2','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.O2(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_O2(:,:,currentpage))))
        for num2=1:Arou.j_o2(1,currentpage);
            down_x=Arou.pos_O2(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_O2(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_O2(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_O2(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.O2(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o2','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o2','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.O2(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o2','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o2','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%F7ͨ��
if (currentpage>1)&&any(((Arou.F7(currentpage-1,:))))&&(Arou.j_f7(1,currentpage-1)>0)&&...
        any((Arou.pos_F7(Arou.j_f7(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.F7(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_F7(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_F7(Arou.j_f7(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_F7(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_F7(Arou.j_f7(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f7','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.F7(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_F7(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_F7(Arou.j_f7(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_F7(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_F7(Arou.j_f7(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f7','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.F7(currentpage+1,:))))&&(Arou.j_f7(1,currentpage+1)>0)...
        &&any((Arou.pos_F7(1,1,currentpage+1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.F7(currentpage+1,1)==1))%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_F7(1:Arou.j_f7(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_F7(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_F7(1:Arou.j_f7(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_F7(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f7','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.F7(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_F7(1:Arou.j_f7(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_F7(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_F7(1:Arou.j_f7(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_F7(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f7','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.F7(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_F7(:,:,currentpage))))
        for num2=1:Arou.j_f7(1,currentpage);
            down_x=Arou.pos_F7(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_F7(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_F7(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_F7(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.F7(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f7','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f7','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.F7(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f7','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f7','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%F8ͨ��
if (currentpage>1)&&any(((Arou.F8(currentpage-1,:))))&&(Arou.j_f8(1,currentpage-1)>0)&&...
        any((Arou.pos_F8(Arou.j_f8(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.F8(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_F8(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_F8(Arou.j_f8(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_F8(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_F8(Arou.j_f8(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f8','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.F8(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_F8(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_F8(Arou.j_f8(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_F8(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_F8(Arou.j_f8(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f8','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.F8(currentpage+1,:))))&&(Arou.j_f8(1,currentpage+1)>0)...
        &&any((Arou.pos_F8(1,1,currentpage+1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.F8(currentpage+1,1)==1))%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_F8(1:Arou.j_f8(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_F8(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_F8(1:Arou.j_f8(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_F8(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f8','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.F8(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_F8(1:Arou.j_f8(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_F8(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_F8(1:Arou.j_f8(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_F8(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f8','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.F8(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_F8(:,:,currentpage))))
        for num2=1:Arou.j_f8(1,currentpage);
            down_x=Arou.pos_F8(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_F8(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_F8(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_F8(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.F8(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f8','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f8','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.F8(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f8','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f8','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%Fzͨ��
if (currentpage>1)&&any(((Arou.Fz(currentpage-1,:))))&&(Arou.j_Fz(1,currentpage-1)>0)&&...
        any((Arou.pos_Fz(Arou.j_Fz(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.Fz(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_Fz(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_Fz(Arou.j_Fz(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_Fz(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_Fz(Arou.j_Fz(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.Fz(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_Fz(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_Fz(Arou.j_Fz(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_Fz(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_Fz(Arou.j_Fz(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.Fz(currentpage+1,:))))&&(Arou.j_Fz(1,currentpage+1)>0)...
        &&any((Arou.pos_Fz(1,1,currentpage+1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.Fz(currentpage+1,1)==1))%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_Fz(1:Arou.j_Fz(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_Fz(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_Fz(1:Arou.j_Fz(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_Fz(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.Fz(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_Fz(1:Arou.j_Fz(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_Fz(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_Fz(1:Arou.j_Fz(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_Fz(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.Fz(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_Fz(:,:,currentpage))))
        for num2=1:Arou.j_Fz(1,currentpage);
            down_x=Arou.pos_Fz(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_Fz(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_Fz(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_Fz(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.Fz(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.Fz(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%Czͨ��
if (currentpage>1)&&any(((Arou.Cz(currentpage-1,:))))&&(Arou.j_Cz(1,currentpage-1)>0)&&...
        any((Arou.pos_Cz(Arou.j_Cz(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.Cz(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_Cz(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_Cz(Arou.j_Cz(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_Cz(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_Cz(Arou.j_Cz(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.Cz(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_Cz(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_Cz(Arou.j_Cz(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_Cz(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_Cz(Arou.j_Cz(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.Cz(currentpage+1,:))))&&(Arou.j_Cz(1,currentpage+1)>0)...
        &&any((Arou.pos_Cz(1,1,currentpage+1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.Cz(currentpage+1,1)==1))%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_Cz(1:Arou.j_Cz(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_Cz(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_Cz(1:Arou.j_Cz(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_Cz(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.Cz(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_Cz(1:Arou.j_Cz(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_Cz(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_Cz(1:Arou.j_Cz(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_Cz(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.Cz(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_Cz(:,:,currentpage))))
        for num2=1:Arou.j_Cz(1,currentpage);
            down_x=Arou.pos_Cz(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_Cz(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_Cz(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_Cz(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.Cz(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.Cz(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%Pzͨ��
if (currentpage>1)&&any(((Arou.Pz(currentpage-1,:))))&&(Arou.j_Pz(1,currentpage-1)>0)&&...
        any((Arou.pos_Pz(Arou.j_Pz(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.Pz(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_Pz(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_Pz(Arou.j_Pz(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_Pz(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_Pz(Arou.j_Pz(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.Pz(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_Pz(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_Pz(Arou.j_Pz(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_Pz(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_Pz(Arou.j_Pz(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.Pz(currentpage+1,:))))&&(Arou.j_Pz(1,currentpage+1)>0)...
        &&any((Arou.pos_Pz(1,1,currentpage+1)))%�����һҳ���зĴ������
    load('Arousalchan_data.mat');
    if ((Arou.Pz(currentpage+1,1)==1))%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_Pz(1:Arou.j_Pz(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_Pz(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_Pz(1:Arou.j_Pz(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_Pz(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.Pz(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_Pz(1:Arou.j_Pz(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_Pz(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_Pz(1:Arou.j_Pz(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_Pz(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.Pz(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_Pz(:,:,currentpage))))
        for num2=1:Arou.j_Pz(1,currentpage);
            down_x=Arou.pos_Pz(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_Pz(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_Pz(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_Pz(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.Pz(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.Pz(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%%%��ͨ��A1�ı��
if (currentpage>1)&&any(((Arou.A1(currentpage-1,:))))&&(Arou.j_A1(1,currentpage-1)>0)&&...
        any((Arou.pos_A1(Arou.j_A1(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.A1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_A1(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_A1(Arou.j_A1(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_A1(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_A1(Arou.j_A1(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A1','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.A1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_A1(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_A1(Arou.j_A1(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_A1(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_A1(Arou.j_A1(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A1','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.A1(currentpage+1,:))))&&(Arou.j_A1(1,currentpage+1)>0)...
        &&any((Arou.pos_A1(1,1,currentpage+1)))%�����һҳ�濪ʼβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.A1(currentpage+1,1))==1)%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_A1(1:Arou.j_A1(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_A1(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_A1(1:Arou.j_A1(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_A1(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A1','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.A1(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_A1(1:Arou.j_A1(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_A1(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_A1(1:Arou.j_A1(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_A1(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A1','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.A1(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_A1(:,:,currentpage))))
        for num2=1:Arou.j_A1(1,currentpage);
            %                 frontpage=currentpage-1;
            
            down_x=Arou.pos_A1(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_A1(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_A1(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_A1(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.A1(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A1','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A1','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.A1(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A1','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A1','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%%%��ͨ��A2�ı��
if (currentpage>1)&&any(((Arou.A2(currentpage-1,:))))&&(Arou.j_A2(1,currentpage-1)>0)&&...
        any((Arou.pos_A2(Arou.j_A2(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.A2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_A2(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_A2(Arou.j_A2(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_A2(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_A2(Arou.j_A2(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A2','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.A2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_A2(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_A2(Arou.j_A2(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_A2(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_A2(Arou.j_A2(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A2','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.A2(currentpage+1,:))))&&(Arou.j_A2(1,currentpage+1)>0)...
        &&any((Arou.pos_A2(1,1,currentpage+1)))%�����һҳ�濪ʼβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.A2(currentpage+1,1))==1)%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_A2(1:Arou.j_A2(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_A2(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_A2(1:Arou.j_A2(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_A2(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A2','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.A2(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_A2(1:Arou.j_A2(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_A2(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_A2(1:Arou.j_A2(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_A2(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A2','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.A2(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_A2(:,:,currentpage))))
        for num2=1:Arou.j_A2(1,currentpage);
            %                 frontpage=currentpage-1;
            
            down_x=Arou.pos_A2(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_A2(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_A2(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_A2(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.A2(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A2','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A2','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.A2(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A2','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A2','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%%%��ͨ��T3�ı��
if (currentpage>1)&&any(((Arou.T3(currentpage-1,:))))&&(Arou.j_T3(1,currentpage-1)>0)&&...
        any((Arou.pos_T3(Arou.j_T3(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.T3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_T3(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_T3(Arou.j_T3(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_T3(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_T3(Arou.j_T3(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T3','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.T3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_T3(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_T3(Arou.j_T3(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_T3(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_T3(Arou.j_T3(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T3','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.T3(currentpage+1,:))))&&(Arou.j_T3(1,currentpage+1)>0)...
        &&any((Arou.pos_T3(1,1,currentpage+1)))%�����һҳ�濪ʼβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.T3(currentpage+1,1))==1)%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_T3(1:Arou.j_T3(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_T3(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_T3(1:Arou.j_T3(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_T3(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T3','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.T3(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_T3(1:Arou.j_T3(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_T3(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_T3(1:Arou.j_T3(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_T3(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T3','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.T3(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_T3(:,:,currentpage))))
        for num2=1:Arou.j_T3(1,currentpage);
            %                 frontpage=currentpage-1;
            
            down_x=Arou.pos_T3(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_T3(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_T3(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_T3(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.T3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T3','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T3','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.T3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T3','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T3','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%%%��ͨ��T4�ı��
if (currentpage>1)&&any(((Arou.T4(currentpage-1,:))))&&(Arou.j_T4(1,currentpage-1)>0)&&...
        any((Arou.pos_T4(Arou.j_T4(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.T4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_T4(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_T4(Arou.j_T4(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_T4(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_T4(Arou.j_T4(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T4','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.T4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_T4(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_T4(Arou.j_T4(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_T4(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_T4(Arou.j_T4(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T4','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.T4(currentpage+1,:))))&&(Arou.j_T4(1,currentpage+1)>0)...
        &&any((Arou.pos_T4(1,1,currentpage+1)))%�����һҳ�濪ʼβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.T4(currentpage+1,1))==1)%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_T4(1:Arou.j_T4(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_T4(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_T4(1:Arou.j_T4(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_T4(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T4','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.T4(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_T4(1:Arou.j_T4(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_T4(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_T4(1:Arou.j_T4(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_T4(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T4','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.T4(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_T4(:,:,currentpage))))
        for num2=1:Arou.j_T4(1,currentpage);
            %                 frontpage=currentpage-1;
            
            down_x=Arou.pos_T4(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_T4(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_T4(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_T4(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.T4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T4','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T4','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.T4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T4','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T4','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%%%��ͨ��T5�ı��
if (currentpage>1)&&any(((Arou.T5(currentpage-1,:))))&&(Arou.j_T5(1,currentpage-1)>0)&&...
        any((Arou.pos_T5(Arou.j_T5(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.T5(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_T5(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_T5(Arou.j_T5(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_T5(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_T5(Arou.j_T5(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T5','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.T5(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_T5(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_T5(Arou.j_T5(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_T5(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_T5(Arou.j_T5(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T5','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.T5(currentpage+1,:))))&&(Arou.j_T5(1,currentpage+1)>0)...
        &&any((Arou.pos_T5(1,1,currentpage+1)))%�����һҳ�濪ʼβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.T5(currentpage+1,1))==1)%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_T5(1:Arou.j_T5(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_T5(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_T5(1:Arou.j_T5(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_T5(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T5','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.T5(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_T5(1:Arou.j_T5(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_T5(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_T5(1:Arou.j_T5(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_T5(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T5','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.T5(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_T5(:,:,currentpage))))
        for num2=1:Arou.j_T5(1,currentpage);
            %                 frontpage=currentpage-1;
            
            down_x=Arou.pos_T5(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_T5(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_T5(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_T5(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.T5(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T5','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T5','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.T5(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T5','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T5','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end
%%%%%��ͨ��T6�ı��
if (currentpage>1)&&any(((Arou.T6(currentpage-1,:))))&&(Arou.j_T6(1,currentpage-1)>0)&&...
        any((Arou.pos_T6(Arou.j_T6(1,currentpage-1),1,currentpage-1)))%�����һҳ��ĩβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.T6(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%�����һҳ��������зĴ������ܿ�����һҳ�Ŀ�ͷҲ�����
        down_x=max(Arou.pos_T6(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_T6(Arou.j_T6(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_T6(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_T6(Arou.j_T6(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T6','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.T6(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_T6(:,1,currentpage-1));%��һҳ���һ������ʼ��ĺ�����
        down_y=Arou.pos_T6(Arou.j_T6(1,currentpage-1),2,currentpage-1);%��һҳ���һ������ʼ���������
        up_x=max(Arou.pos_T6(:,3,currentpage-1));%��һҳ���һ������ֹ��ĺ�����
        up_y=Arou.pos_T6(Arou.j_T6(1,currentpage-1),4,currentpage-1);%��һҳ���һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T6','Tag','0');%���������㣬��Ϊ���
    end
end
if (currentpage<totalpage)&&any(((Arou.T6(currentpage+1,:))))&&(Arou.j_T6(1,currentpage+1)>0)...
        &&any((Arou.pos_T6(1,1,currentpage+1)))%�����һҳ�濪ʼβ�зĴ������,�Ҷ�Ӧλ�ü�¼������ֵ
    load('Arousalchan_data.mat');
    if ((Arou.T6(currentpage+1,1))==1)%%�����һҳ�Ŀ�ʼ����зĴ������ܿ�����һҳ�Ľ���Ҳ�����
        down_x=min(Arou.pos_T6(1:Arou.j_T6(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_T6(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_T6(1:Arou.j_T6(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_T6(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T6','Tag','1');%���������㣬��Ϊ���
    elseif ((Arou.T6(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_T6(1:Arou.j_T6(currentpage+1),1,currentpage+1));%��һҳ��һ������ʼ��ĺ�����
        down_y=Arou.pos_T6(1,2,currentpage+1);%��һҳ��һ������ʼ���������
        up_x=min(Arou.pos_T6(1:Arou.j_T6(currentpage+1),3,currentpage+1));%��һҳ��һ������ֹ��ĺ�����
        up_y=Arou.pos_T6(1,4,currentpage+1);%��һҳ��һ������ֹ���������
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T6','Tag','0');%���������㣬��Ϊ���
    end
end
if any(((Arou.T6(currentpage,:))))%�����ǰҳ���зĴ������
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_T6(:,:,currentpage))))
        for num2=1:Arou.j_T6(1,currentpage);
            %                 frontpage=currentpage-1;
            
            down_x=Arou.pos_T6(num2,1,currentpage);%��num2������ʼ��ĺ�����
            down_y=Arou.pos_T6(num2,2,currentpage);%��num2������ʼ���������
            up_x=Arou.pos_T6(num2,3,currentpage);%��num2������ֹ��ĺ�����
            up_y=Arou.pos_T6(num2,4,currentpage);%��num2������ֹ���������
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.T6(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T6','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T6','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%������߶�С�ڸ�ҳ����С�����꣬˵���������ڸ�ҳ���ǰһҳ֮��
                    midpt = round(uppt/2);
                else %�߶��ڸ�ҳ�����һҳ֮��
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.T6(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T6','Tag','1');%���������㣬��Ϊ���
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T6','Tag','0');%���������㣬��Ϊ���
                    hold on;
                end
            end
        end
    end
end

