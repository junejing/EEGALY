function mainplotsec_spindle(handles)
load('Arousal_data.mat');
global currentpage
global totalpage
currentpage=str2double(get(handles.currentpage,'string'));%当前的页数
totalpage = ceil((nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/handles.winsize);
%%%%%画通道F1-O2的标记
if (currentpage>1)&&any(((Arou.Fp1(currentpage-1,:))))&&(Arou.j_fp1(1,currentpage-1)>0)&&...
        any((Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.Fp1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_Fp1(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_Fp1(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','1');%连接这两点，作为标记
    elseif ((Arou.Fp1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_Fp1(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_Fp1(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.Fp1(currentpage+1,:))))&&(Arou.j_fp1(1,currentpage+1)>0)...
        &&any((Arou.pos_Fp1(1,1,currentpage+1)))%如果下一页面开始尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.Fp1(currentpage+1,1))==1)%%如果下一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_Fp1(1:Arou.j_fp1(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_Fp1(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_Fp1(1:Arou.j_fp1(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_Fp1(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','1');%连接这两点，作为标记
    elseif ((Arou.Fp1(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_Fp1(1:Arou.j_fp1(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_Fp1(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_Fp1(1:Arou.j_fp1(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_Fp1(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.Fp1(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_Fp1(:,:,currentpage))))
        for num2=1:Arou.j_fp1(1,currentpage);
            %                 frontpage=currentpage-1;
            
            down_x=Arou.pos_Fp1(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_Fp1(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_Fp1(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_Fp1(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.Fp1(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.Fp1(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_Fp1(numnext,1,currentpage+1))<(curtime+handles.winsize/2))...
            &&((Arou.pos_Fp1(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_Fp1(numnext,1,currentpage+1);
        down_y=Arou.pos_Fp1(numnext,2,currentpage+1);
        up_x=Arou.pos_Fp1(numnext,3,currentpage+1);
        up_y=Arou.pos_Fp1(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.Fp1(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_Fp1(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_Fp1(numnext,1,currentpage-1);
        down_y=Arou.pos_Fp1(numnext,2,currentpage-1);
        up_x=Arou.pos_Fp1(numnext,3,currentpage-1);
        up_y=Arou.pos_Fp1(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.Fp1(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp1','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end

%%%fp2通道
if (currentpage>1)&&any(((Arou.Fp2(currentpage-1,:))))&&(Arou.j_fp2(1,currentpage-1)>0)&&...
        any((Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.Fp2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_Fp2(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_Fp2(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','1');%连接这两点，作为标记
    elseif ((Arou.Fp2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_Fp2(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_Fp2(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.Fp2(currentpage+1,:))))&&(Arou.j_fp2(1,currentpage+1)>0)...
        &&any((Arou.pos_Fp2(1,1,currentpage+1)))%如果下一页面开始尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.Fp2(currentpage+1,1))==1)%%如果下一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_Fp2(1:Arou.j_fp2(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_Fp2(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_Fp2(1:Arou.j_fp2(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_Fp2(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','1');%连接这两点，作为标记
    elseif ((Arou.Fp2(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_Fp2(1:Arou.j_fp2(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_Fp2(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_Fp2(1:Arou.j_fp2(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_Fp2(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.Fp2(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_Fp2(:,:,currentpage))))
        for num2=1:Arou.j_fp2(1,currentpage);
            down_x=Arou.pos_Fp2(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_Fp2(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_Fp2(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_Fp2(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.Fp2(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.Fp2(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_Fp2(numnext,1,currentpage+1))<(curtime+handles.winsize/2))&&((Arou.pos_Fp2(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_Fp2(numnext,1,currentpage+1);
        down_y=Arou.pos_Fp2(numnext,2,currentpage+1);
        up_x=Arou.pos_Fp2(numnext,3,currentpage+1);
        up_y=Arou.pos_Fp2(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.Fp2(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_Fp2(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_Fp2(numnext,1,currentpage-1);
        down_y=Arou.pos_Fp2(numnext,2,currentpage-1);
        up_x=Arou.pos_Fp2(numnext,3,currentpage-1);
        up_y=Arou.pos_Fp2(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.Fp2(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_fp2','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%f3通道
if (currentpage>1)&&any(((Arou.F3(currentpage-1,:))))&&(Arou.j_f3(1,currentpage-1)>0)&&...
        any((Arou.pos_F3(Arou.j_f3(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值%如果上一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.F3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_F3(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_F3(Arou.j_f3(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_F3(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_F3(Arou.j_f3(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f3','Tag','1');%连接这两点，作为标记
    elseif ((Arou.F3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_F3(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_F3(Arou.j_f3(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_F3(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_F3(Arou.j_f3(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f3','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.F3(currentpage+1,:))))&&(Arou.j_f3(1,currentpage+1)>0)...
        &&any((Arou.pos_F3(1,1,currentpage+1)))%如果下一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.F3(currentpage+1,1)==1))%%如果上一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_F3(1:Arou.j_f3(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_F3(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_F3(1:Arou.j_f3(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_F3(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f3','Tag','1');%连接这两点，作为标记
    elseif ((Arou.F3(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_F3(1:Arou.j_f3(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_F3(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_F3(1:Arou.j_f3(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_F3(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f3','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.F3(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_F3(:,:,currentpage))))
        for num2=1:Arou.j_f3(1,currentpage);
            down_x=Arou.pos_F3(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_F3(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_F3(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_F3(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.F3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f3','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f3','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt =round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.F3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f3','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f3','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_F3(numnext,1,currentpage+1))<(curtime+handles.winsize/2))&&((Arou.pos_F3(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_F3(numnext,1,currentpage+1);
        down_y=Arou.pos_F3(numnext,2,currentpage+1);
        up_x=Arou.pos_F3(numnext,3,currentpage+1);
        up_y=Arou.pos_F3(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.F3(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f3','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f3','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_F3(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_F3(numnext,1,currentpage-1);
        down_y=Arou.pos_F3(numnext,2,currentpage-1);
        up_x=Arou.pos_F3(numnext,3,currentpage-1);
        up_y=Arou.pos_F3(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.F3(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f3','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f3','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%f4通道
if (currentpage>1)&&any(((Arou.F4(currentpage-1,:))))&&(Arou.j_f4(1,currentpage-1)>0)&&...
        any((Arou.pos_F4(Arou.j_f4(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值%如果上一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.F4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_F4(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_F4(Arou.j_f4(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_F4(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_F4(Arou.j_f4(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f4','Tag','1');%连接这两点，作为标记
    elseif ((Arou.F4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_F4(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_F4(Arou.j_f4(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_F4(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_F4(Arou.j_f4(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f4','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.F4(currentpage+1,:))))&&(Arou.j_f4(1,currentpage+1)>0)...
        &&any((Arou.pos_F4(1,1,currentpage+1)))%如果下一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.F4(currentpage+1,1)==1))%%如果上一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_F4(1:Arou.j_f4(currentpage+1),1,currentpage+1));;%下一页第一条线起始点的横坐标
        down_y=Arou.pos_F4(1,2,currentpage+1);%上一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_F4(1:Arou.j_f4(currentpage+1),3,currentpage+1));;%下一页第一条线终止点的横坐标
        up_y=Arou.pos_F4(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f4','Tag','1');%连接这两点，作为标记
    elseif ((Arou.F4(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_F4(1:Arou.j_f4(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_F4(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_F4(1:Arou.j_f4(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_F4(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f4','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.F4(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_F4(:,:,currentpage))))
        for num2=1:Arou.j_f4(1,currentpage);
            down_x=Arou.pos_F4(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_F4(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_F4(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_F4(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.F4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f4','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f4','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.F4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f4','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f4','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_F4(numnext,1,currentpage+1))<(curtime+handles.winsize/2))&&((Arou.pos_F4(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_F4(numnext,1,currentpage+1);
        down_y=Arou.pos_F4(numnext,2,currentpage+1);
        up_x=Arou.pos_F4(numnext,3,currentpage+1);
        up_y=Arou.pos_F4(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.F4(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f4','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f4','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_F4(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_F4(numnext,1,currentpage-1);
        down_y=Arou.pos_F4(numnext,2,currentpage-1);
        up_x=Arou.pos_F4(numnext,3,currentpage-1);
        up_y=Arou.pos_F4(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.F4(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f4','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f4','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%c3通道
if (currentpage>1)&&any(((Arou.C3(currentpage-1,:))))&&(Arou.j_c3(1,currentpage-1)>0)&&...
        any((Arou.pos_C3(Arou.j_c3(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.C3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_C3(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_C3(Arou.j_c3(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_C3(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_C3(Arou.j_c3(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c3','Tag','1');%连接这两点，作为标记
    elseif ((Arou.C3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_C3(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_C3(Arou.j_c3(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_C3(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_C3(Arou.j_c3(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c3','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.C3(currentpage+1,:))))&&(Arou.j_c3(1,currentpage+1)>0)...
        &&any((Arou.pos_C3(1,1,currentpage+1)))%如果下一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.C3(currentpage+1,1)==1))%%如果上一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_C3(1:Arou.j_c3(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_C3(1,2,currentpage+1);%上一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_C3(1:Arou.j_c3(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_C3(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c3','Tag','1');%连接这两点，作为标记
    elseif ((Arou.C3(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_C3(1:Arou.j_c3(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_C3(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_C3(1:Arou.j_c3(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_C3(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c3','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.C3(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_C3(:,:,currentpage))))
        for num2=1:Arou.j_c3(1,currentpage);
            down_x=Arou.pos_C3(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_C3(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_C3(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_C3(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            %midpt=(downpt+uppt)/2;
            
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.C3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c3','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c3','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.C3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c3','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c3','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&((Arou.pos_C3(numnext,1,currentpage+1))<(curtime+handles.winsize/2))&&...
            ((Arou.pos_C3(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_C3(numnext,1,currentpage+1);
        down_y=Arou.pos_C3(numnext,2,currentpage+1);
        up_x=Arou.pos_C3(numnext,3,currentpage+1);
        up_y=Arou.pos_C3(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.C3(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c3','Tag','1');%连接这两点，作为标记
                hold on;
            elseif (Arou.C3(currentpage+1,midpt)==0.5)
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c3','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&((Arou.pos_C3(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_C3(numnext,1,currentpage-1);
        down_y=Arou.pos_C3(numnext,2,currentpage-1);
        up_x=Arou.pos_C3(numnext,3,currentpage-1);
        up_y=Arou.pos_C3(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x<(currentpage-1)*handles.winsize
            if (Arou.C3(currentpage-1,downpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c3','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c3','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%c4通道
if (currentpage>1)&&any(((Arou.C4(currentpage-1,:))))&&(Arou.j_c4(1,currentpage-1)>0)&&...
        any((Arou.pos_C4(Arou.j_c4(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值%如果上一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.C4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_C4(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_C4(Arou.j_c4(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_C4(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_C4(Arou.j_c4(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c4','Tag','1');%连接这两点，作为标记
    elseif ((Arou.C4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_C4(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_C4(Arou.j_c4(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_C4(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_C4(Arou.j_c4(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c4','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.C4(currentpage+1,:))))&&(Arou.j_c4(1,currentpage+1)>0)...
        &&any((Arou.pos_C4(1,1,currentpage+1)))%如果下一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.C4(currentpage+1,1)==1))%%如果上一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_C4(1:Arou.j_c4(currentpage+1),1,currentpage+1));;%下一页第一条线起始点的横坐标
        down_y=Arou.pos_C4(1,2,currentpage+1);%上一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_C4(1:Arou.j_c4(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_C4(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c4','Tag','1');%连接这两点，作为标记
    elseif ((Arou.C4(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_C4(1:Arou.j_c4(currentpage+1),1,currentpage+1));;%下一页第一条线起始点的横坐标
        down_y=Arou.pos_C4(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_C4(1:Arou.j_c4(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_C4(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c4','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.C4(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_C4(:,:,currentpage))))
        for num2=1:Arou.j_c4(1,currentpage);
            down_x=Arou.pos_C4(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_C4(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_C4(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_C4(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.C4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c4','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c4','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.C4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c4','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c4','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_C4(numnext,1,currentpage+1))<(curtime+handles.winsize/2))&&((Arou.pos_C4(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_C4(numnext,1,currentpage+1);
        down_y=Arou.pos_C4(numnext,2,currentpage+1);
        up_x=Arou.pos_C4(numnext,3,currentpage+1);
        up_y=Arou.pos_C4(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.C4(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c4','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c4','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_C4(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_C4(numnext,1,currentpage-1);
        down_y=Arou.pos_C4(numnext,2,currentpage-1);
        up_x=Arou.pos_C4(numnext,3,currentpage-1);
        up_y=Arou.pos_C4(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.C4(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c4','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_c4','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%P3通道
if (currentpage>1)&&any(((Arou.P3(currentpage-1,:))))&&(Arou.j_p3(1,currentpage-1)>0)&&...
        any((Arou.pos_P3(Arou.j_p3(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值%如果上一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.P3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_P3(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_P3(Arou.j_p3(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_P3(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_P3(Arou.j_p3(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p3','Tag','1');%连接这两点，作为标记
    elseif ((Arou.P3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_P3(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_P3(Arou.j_p3(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_P3(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_P3(Arou.j_p3(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p3','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.P3(currentpage+1,:))))&&(Arou.j_p3(1,currentpage+1)>0)...
        &&any((Arou.pos_P3(1,1,currentpage+1)))%如果下一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.P3(currentpage+1,1)==1))%%如果上一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_P3(1:Arou.j_p3(currentpage+1),1,currentpage+1));;%下一页第一条线起始点的横坐标
        down_y=Arou.pos_P3(1,2,currentpage+1);%上一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_P3(1:Arou.j_p3(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_P3(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p3','Tag','1');%连接这两点，作为标记
    elseif ((Arou.P3(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_P3(1:Arou.j_p3(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_P3(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_P3(1:Arou.j_p3(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_P3(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p3','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.P3(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_P3(:,:,currentpage))))
        for num2=1:Arou.j_p3(1,currentpage);
            down_x=Arou.pos_P3(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_P3(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_P3(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_P3(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.P3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p3','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p3','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.P3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p3','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p3','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_P3(numnext,1,currentpage+1))<(curtime+handles.winsize/2))&&((Arou.pos_P3(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_P3(numnext,1,currentpage+1);
        down_y=Arou.pos_P3(numnext,2,currentpage+1);
        up_x=Arou.pos_P3(numnext,3,currentpage+1);
        up_y=Arou.pos_P3(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.P3(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p3','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p3','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_P3(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_P3(numnext,1,currentpage-1);
        down_y=Arou.pos_P3(numnext,2,currentpage-1);
        up_x=Arou.pos_P3(numnext,3,currentpage-1);
        up_y=Arou.pos_P3(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.P3(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p3','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p3','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%P4通道
if (currentpage>1)&&any(((Arou.P4(currentpage-1,:))))&&(Arou.j_p4(1,currentpage-1)>0)&&...
        any((Arou.pos_P4(Arou.j_p4(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值%如果上一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.P4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_P4(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_P4(Arou.j_p4(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_P4(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_P4(Arou.j_p4(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p4','Tag','1');%连接这两点，作为标记
    elseif ((Arou.P4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_P4(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_P4(Arou.j_p4(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_P4(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_P4(Arou.j_p4(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p4','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.P4(currentpage+1,:))))&&(Arou.j_p4(1,currentpage+1)>0)...
        &&any((Arou.pos_P4(1,1,currentpage+1)))%如果下一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.P4(currentpage+1,1)==1))%%如果上一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_P4(1:Arou.j_p4(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_P4(1,2,currentpage+1);%上一页第一条线起始点的纵坐标
        up_xmin(Arou.pos_P4(1:Arou.j_p4(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_P4(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p4','Tag','1');%连接这两点，作为标记
    elseif ((Arou.P4(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_P4(1:Arou.j_p4(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_P4(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_P4(1:Arou.j_p4(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_P4(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p4','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.P4(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_P4(:,:,currentpage))))
        for num2=1:Arou.j_p4(1,currentpage);
            down_x=Arou.pos_P4(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_P4(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_P4(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_P4(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.P4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p4','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p4','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.P4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p4','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p4','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_P4(numnext,1,currentpage+1))<(curtime+handles.winsize/2))&&((Arou.pos_P4(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_P4(numnext,1,currentpage+1);
        down_y=Arou.pos_P4(numnext,2,currentpage+1);
        up_x=Arou.pos_P4(numnext,3,currentpage+1);
        up_y=Arou.pos_P4(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.P4(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p4','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p4','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_P4(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_P4(numnext,1,currentpage-1);
        down_y=Arou.pos_P4(numnext,2,currentpage-1);
        up_x=Arou.pos_P4(numnext,3,currentpage-1);
        up_y=Arou.pos_P4(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.P4(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_p4','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_p4','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%O1通道
if (currentpage>1)&&any(((Arou.O1(currentpage-1,:))))&&(Arou.j_o1(1,currentpage-1)>0)&&...
        any((Arou.pos_O1(Arou.j_o1(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值%如果上一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.O1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_O1(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_O1(Arou.j_o1(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_O1(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_O1(Arou.j_o1(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o1','Tag','1');%连接这两点，作为标记
    elseif ((Arou.O1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_O1(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_O1(Arou.j_o1(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_O1(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_O1(Arou.j_o1(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o1','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.O1(currentpage+1,:))))&&(Arou.j_o1(1,currentpage+1)>0)...
        &&any((Arou.pos_O1(1,1,currentpage+1)))%如果下一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.O1(currentpage+1,1)==1))%%如果上一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_O1(1:Arou.j_o1(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_O1(1,2,currentpage+1);%上一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_O1(1:Arou.j_o1(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_O1(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o1','Tag','1');%连接这两点，作为标记
    elseif ((Arou.O1(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_O1(1:Arou.j_o1(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_O1(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_O1(1:Arou.j_o1(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_O1(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o1','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.O1(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_O1(:,:,currentpage))))
        for num2=1:Arou.j_o1(1,currentpage);
            down_x=Arou.pos_O1(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_O1(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_O1(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_O1(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.O1(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o1','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o1','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.O1(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o1','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o1','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_O1(numnext,1,currentpage+1))<(curtime+handles.winsize/2))&&((Arou.pos_O1(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_O1(numnext,1,currentpage+1);
        down_y=Arou.pos_O1(numnext,2,currentpage+1);
        up_x=Arou.pos_O1(numnext,3,currentpage+1);
        up_y=Arou.pos_O1(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.O1(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o1','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o1','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_O1(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_O1(numnext,1,currentpage-1);
        down_y=Arou.pos_O1(numnext,2,currentpage-1);
        up_x=Arou.pos_O1(numnext,3,currentpage-1);
        up_y=Arou.pos_O1(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.O1(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o1','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o1','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%o2通道
if (currentpage>1)&&any(((Arou.O2(currentpage-1,:))))&&(Arou.j_o2(1,currentpage-1)>0)&&...
        any((Arou.pos_O2(Arou.j_o2(1,currentpage-1),1,currentpage-1)))%如果上一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.O2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_O2(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_O2(Arou.j_o2(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_O2(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_O2(Arou.j_o2(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o2','Tag','1');%连接这两点，作为标记
    elseif ((Arou.O1(currentpage-1,1)==0.5))
        down_x=max(Arou.pos_O2(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_O2(Arou.j_o2(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_O2(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_O2(Arou.j_o2(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o2','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.O2(currentpage+1,:))))&&(Arou.j_o2(1,currentpage+1)>0)...
        &&any((Arou.pos_O2(1,1,currentpage+1)))%如果下一页面有纺锤波标记
    load('Arousalchan_data.mat');
    if ((Arou.O2(currentpage+1,1)==1))%%如果上一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_O2(1:Arou.j_o2(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_O2(1,2,currentpage+1);%上一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_O2(1:Arou.j_o2(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_O2(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o2','Tag','1');%连接这两点，作为标记
    elseif ((Arou.O1(currentpage+1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=min(Arou.pos_O2(1:Arou.j_o2(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_O2(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_O2(1:Arou.j_o2(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_O2(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o2','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.O2(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_O2(:,:,currentpage))))
        for num2=1:Arou.j_o2(1,currentpage);
            down_x=Arou.pos_O2(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_O2(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_O2(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_O2(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.O2(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o2','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o2','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.O2(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o2','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o2','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_O2(numnext,1,currentpage+1))<(curtime+handles.winsize/2))&&((Arou.pos_O2(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_O2(numnext,1,currentpage+1);
        down_y=Arou.pos_O2(numnext,2,currentpage+1);
        up_x=Arou.pos_O2(numnext,3,currentpage+1);
        up_y=Arou.pos_O2(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.O2(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o2','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o2','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_O2(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_O2(numnext,1,currentpage-1);
        down_y=Arou.pos_O2(numnext,2,currentpage-1);
        up_x=Arou.pos_O2(numnext,3,currentpage-1);
        up_y=Arou.pos_O2(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.O2(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_o2','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_o2','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%%%画通道F7的标记
if (currentpage>1)&&any(((Arou.F7(currentpage-1,:))))&&(Arou.j_f7(1,currentpage-1)>0)&&...
        any((Arou.pos_F7(Arou.j_f7(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.F7(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_F7(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_F7(Arou.j_f7(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_F7(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_F7(Arou.j_f7(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f7','Tag','1');%连接这两点，作为标记
    elseif ((Arou.F7(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_F7(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_F7(Arou.j_f7(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_F7(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_F7(Arou.j_f7(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f7','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.F7(currentpage+1,:))))&&(Arou.j_f7(1,currentpage+1)>0)...
        &&any((Arou.pos_F7(1,1,currentpage+1)))%如果下一页面开始尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.F7(currentpage+1,1))==1)%%如果下一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_F7(1:Arou.j_f7(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_F7(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_F7(1:Arou.j_f7(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_F7(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f7','Tag','1');%连接这两点，作为标记
    elseif ((Arou.F7(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_F7(1:Arou.j_f7(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_F7(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_F7(1:Arou.j_f7(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_F7(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f7','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.F7(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_F7(:,:,currentpage))))
        for num2=1:Arou.j_f7(1,currentpage);
            %                 frontpage=currentpage-1;           
            down_x=Arou.pos_F7(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_F7(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_F7(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_F7(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.F7(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f7','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f7','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.F7(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f7','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f7','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_F7(numnext,1,currentpage+1))<(curtime+handles.winsize/2))...
            &&((Arou.pos_F7(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_F7(numnext,1,currentpage+1);
        down_y=Arou.pos_F7(numnext,2,currentpage+1);
        up_x=Arou.pos_F7(numnext,3,currentpage+1);
        up_y=Arou.pos_F7(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.F7(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f7','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f7','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_F7(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_F7(numnext,1,currentpage-1);
        down_y=Arou.pos_F7(numnext,2,currentpage-1);
        up_x=Arou.pos_F7(numnext,3,currentpage-1);
        up_y=Arou.pos_F7(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.F7(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f7','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f7','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%%%画通道F8的标记
if (currentpage>1)&&any(((Arou.F8(currentpage-1,:))))&&(Arou.j_f8(1,currentpage-1)>0)&&...
        any((Arou.pos_F8(Arou.j_f8(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.F8(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_F8(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_F8(Arou.j_f8(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_F8(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_F8(Arou.j_f8(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f8','Tag','1');%连接这两点，作为标记
    elseif ((Arou.F8(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_F8(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_F8(Arou.j_f8(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_F8(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_F8(Arou.j_f8(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f8','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.F8(currentpage+1,:))))&&(Arou.j_f8(1,currentpage+1)>0)...
        &&any((Arou.pos_F8(1,1,currentpage+1)))%如果下一页面开始尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.F8(currentpage+1,1))==1)%%如果下一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_F8(1:Arou.j_f8(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_F8(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_F8(1:Arou.j_f8(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_F8(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f8','Tag','1');%连接这两点，作为标记
    elseif ((Arou.F8(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_F8(1:Arou.j_f8(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_F8(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_F8(1:Arou.j_f8(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_F8(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f8','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.F8(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_F8(:,:,currentpage))))
        for num2=1:Arou.j_f8(1,currentpage);
            %                 frontpage=currentpage-1;            
            down_x=Arou.pos_F8(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_F8(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_F8(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_F8(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.F8(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f8','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f8','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.F8(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f8','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f8','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_F8(numnext,1,currentpage+1))<(curtime+handles.winsize/2))...
            &&((Arou.pos_F8(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_F8(numnext,1,currentpage+1);
        down_y=Arou.pos_F8(numnext,2,currentpage+1);
        up_x=Arou.pos_F8(numnext,3,currentpage+1);
        up_y=Arou.pos_F8(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.F8(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f8','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f8','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_F8(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_F8(numnext,1,currentpage-1);
        down_y=Arou.pos_F8(numnext,2,currentpage-1);
        up_x=Arou.pos_F8(numnext,3,currentpage-1);
        up_y=Arou.pos_F8(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.F8(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_f8','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_f8','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%%%画通道Fz的标记
if (currentpage>1)&&any(((Arou.Fz(currentpage-1,:))))&&(Arou.j_Fz(1,currentpage-1)>0)&&...
        any((Arou.pos_Fz(Arou.j_Fz(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.Fz(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_Fz(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_Fz(Arou.j_Fz(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_Fz(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_Fz(Arou.j_Fz(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','1');%连接这两点，作为标记
    elseif ((Arou.Fz(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_Fz(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_Fz(Arou.j_Fz(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_Fz(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_Fz(Arou.j_Fz(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.Fz(currentpage+1,:))))&&(Arou.j_Fz(1,currentpage+1)>0)...
        &&any((Arou.pos_Fz(1,1,currentpage+1)))%如果下一页面开始尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.Fz(currentpage+1,1))==1)%%如果下一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_Fz(1:Arou.j_Fz(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_Fz(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_Fz(1:Arou.j_Fz(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_Fz(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','1');%连接这两点，作为标记
    elseif ((Arou.Fz(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_Fz(1:Arou.j_Fz(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_Fz(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_Fz(1:Arou.j_Fz(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_Fz(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.Fz(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_Fz(:,:,currentpage))))
        for num2=1:Arou.j_Fz(1,currentpage);
            %                 frontpage=currentpage-1;            
            down_x=Arou.pos_Fz(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_Fz(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_Fz(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_Fz(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.Fz(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.Fz(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_Fz(numnext,1,currentpage+1))<(curtime+handles.winsize/2))...
            &&((Arou.pos_Fz(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_Fz(numnext,1,currentpage+1);
        down_y=Arou.pos_Fz(numnext,2,currentpage+1);
        up_x=Arou.pos_Fz(numnext,3,currentpage+1);
        up_y=Arou.pos_Fz(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.Fz(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_Fz(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_Fz(numnext,1,currentpage-1);
        down_y=Arou.pos_Fz(numnext,2,currentpage-1);
        up_x=Arou.pos_Fz(numnext,3,currentpage-1);
        up_y=Arou.pos_Fz(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.Fz(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Fz','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%%%画通道Cz的标记
if (currentpage>1)&&any(((Arou.Cz(currentpage-1,:))))&&(Arou.j_Cz(1,currentpage-1)>0)&&...
        any((Arou.pos_Cz(Arou.j_Cz(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.Cz(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_Cz(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_Cz(Arou.j_Cz(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_Cz(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_Cz(Arou.j_Cz(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','1');%连接这两点，作为标记
    elseif ((Arou.Cz(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_Cz(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_Cz(Arou.j_Cz(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_Cz(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_Cz(Arou.j_Cz(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.Cz(currentpage+1,:))))&&(Arou.j_Cz(1,currentpage+1)>0)...
        &&any((Arou.pos_Cz(1,1,currentpage+1)))%如果下一页面开始尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.Cz(currentpage+1,1))==1)%%如果下一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_Cz(1:Arou.j_Cz(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_Cz(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_Cz(1:Arou.j_Cz(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_Cz(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','1');%连接这两点，作为标记
    elseif ((Arou.Cz(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_Cz(1:Arou.j_Cz(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_Cz(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_Cz(1:Arou.j_Cz(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_Cz(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.Cz(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_Cz(:,:,currentpage))))
        for num2=1:Arou.j_Cz(1,currentpage);
            %                 frontpage=currentpage-1;           
            down_x=Arou.pos_Cz(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_Cz(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_Cz(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_Cz(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.Cz(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.Cz(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_Cz(numnext,1,currentpage+1))<(curtime+handles.winsize/2))...
            &&((Arou.pos_Cz(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_Cz(numnext,1,currentpage+1);
        down_y=Arou.pos_Cz(numnext,2,currentpage+1);
        up_x=Arou.pos_Cz(numnext,3,currentpage+1);
        up_y=Arou.pos_Cz(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.Cz(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_Cz(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_Cz(numnext,1,currentpage-1);
        down_y=Arou.pos_Cz(numnext,2,currentpage-1);
        up_x=Arou.pos_Cz(numnext,3,currentpage-1);
        up_y=Arou.pos_Cz(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.Cz(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Cz','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%%%画通道Pz的标记
if (currentpage>1)&&any(((Arou.Pz(currentpage-1,:))))&&(Arou.j_Pz(1,currentpage-1)>0)&&...
        any((Arou.pos_Pz(Arou.j_Pz(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.Pz(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_Pz(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_Pz(Arou.j_Pz(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_Pz(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_Pz(Arou.j_Pz(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','1');%连接这两点，作为标记
    elseif ((Arou.Pz(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_Pz(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_Pz(Arou.j_Pz(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_Pz(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_Pz(Arou.j_Pz(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.Pz(currentpage+1,:))))&&(Arou.j_Pz(1,currentpage+1)>0)...
        &&any((Arou.pos_Pz(1,1,currentpage+1)))%如果下一页面开始尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.Pz(currentpage+1,1))==1)%%如果下一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_Pz(1:Arou.j_Pz(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_Pz(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_Pz(1:Arou.j_Pz(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_Pz(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','1');%连接这两点，作为标记
    elseif ((Arou.Pz(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_Pz(1:Arou.j_Pz(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_Pz(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_Pz(1:Arou.j_Pz(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_Pz(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.Pz(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_Pz(:,:,currentpage))))
        for num2=1:Arou.j_Pz(1,currentpage);
            %                 frontpage=currentpage-1;           
            down_x=Arou.pos_Pz(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_Pz(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_Pz(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_Pz(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.Pz(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.Pz(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_Pz(numnext,1,currentpage+1))<(curtime+handles.winsize/2))...
            &&((Arou.pos_Pz(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_Pz(numnext,1,currentpage+1);
        down_y=Arou.pos_Pz(numnext,2,currentpage+1);
        up_x=Arou.pos_Pz(numnext,3,currentpage+1);
        up_y=Arou.pos_Pz(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.Pz(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_Pz(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_Pz(numnext,1,currentpage-1);
        down_y=Arou.pos_Pz(numnext,2,currentpage-1);
        up_x=Arou.pos_Pz(numnext,3,currentpage-1);
        up_y=Arou.pos_Pz(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.Pz(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_Pz','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%%%画通道A1的标记
if (currentpage>1)&&any(((Arou.A1(currentpage-1,:))))&&(Arou.j_A1(1,currentpage-1)>0)&&...
        any((Arou.pos_A1(Arou.j_A1(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.A1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_A1(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_A1(Arou.j_A1(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_A1(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_A1(Arou.j_A1(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A1','Tag','1');%连接这两点，作为标记
    elseif ((Arou.A1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_A1(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_A1(Arou.j_A1(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_A1(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_A1(Arou.j_A1(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A1','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.A1(currentpage+1,:))))&&(Arou.j_A1(1,currentpage+1)>0)...
        &&any((Arou.pos_A1(1,1,currentpage+1)))%如果下一页面开始尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.A1(currentpage+1,1))==1)%%如果下一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_A1(1:Arou.j_A1(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_A1(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_A1(1:Arou.j_A1(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_A1(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A1','Tag','1');%连接这两点，作为标记
    elseif ((Arou.A1(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_A1(1:Arou.j_A1(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_A1(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_A1(1:Arou.j_A1(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_A1(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A1','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.A1(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_A1(:,:,currentpage))))
        for num2=1:Arou.j_A1(1,currentpage);
            %                 frontpage=currentpage-1;           
            down_x=Arou.pos_A1(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_A1(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_A1(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_A1(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.A1(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A1','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A1','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.A1(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A1','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A1','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_A1(numnext,1,currentpage+1))<(curtime+handles.winsize/2))...
            &&((Arou.pos_A1(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_A1(numnext,1,currentpage+1);
        down_y=Arou.pos_A1(numnext,2,currentpage+1);
        up_x=Arou.pos_A1(numnext,3,currentpage+1);
        up_y=Arou.pos_A1(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.A1(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A1','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A1','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_A1(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_A1(numnext,1,currentpage-1);
        down_y=Arou.pos_A1(numnext,2,currentpage-1);
        up_x=Arou.pos_A1(numnext,3,currentpage-1);
        up_y=Arou.pos_A1(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.A1(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A1','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A1','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%%%画通道A2的标记
if (currentpage>1)&&any(((Arou.A2(currentpage-1,:))))&&(Arou.j_A2(1,currentpage-1)>0)&&...
        any((Arou.pos_A2(Arou.j_A2(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.A2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_A2(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_A2(Arou.j_A2(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_A2(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_A2(Arou.j_A2(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A2','Tag','1');%连接这两点，作为标记
    elseif ((Arou.A2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_A2(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_A2(Arou.j_A2(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_A2(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_A2(Arou.j_A2(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A2','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.A2(currentpage+1,:))))&&(Arou.j_A2(1,currentpage+1)>0)...
        &&any((Arou.pos_A2(1,1,currentpage+1)))%如果下一页面开始尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.A2(currentpage+1,1))==1)%%如果下一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_A2(1:Arou.j_A2(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_A2(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_A2(1:Arou.j_A2(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_A2(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A2','Tag','1');%连接这两点，作为标记
    elseif ((Arou.A2(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_A2(1:Arou.j_A2(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_A2(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_A2(1:Arou.j_A2(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_A2(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A2','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.A2(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_A2(:,:,currentpage))))
        for num2=1:Arou.j_A2(1,currentpage);
            %                 frontpage=currentpage-1;          
            down_x=Arou.pos_A2(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_A2(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_A2(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_A2(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.A2(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A2','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A2','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.A2(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A2','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A2','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_A2(numnext,1,currentpage+1))<(curtime+handles.winsize/2))...
            &&((Arou.pos_A2(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_A2(numnext,1,currentpage+1);
        down_y=Arou.pos_A2(numnext,2,currentpage+1);
        up_x=Arou.pos_A2(numnext,3,currentpage+1);
        up_y=Arou.pos_A2(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.A2(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A2','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A2','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_A2(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_A2(numnext,1,currentpage-1);
        down_y=Arou.pos_A2(numnext,2,currentpage-1);
        up_x=Arou.pos_A2(numnext,3,currentpage-1);
        up_y=Arou.pos_A2(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.A2(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_A2','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_A2','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%%%画通道T3的标记
if (currentpage>1)&&any(((Arou.T3(currentpage-1,:))))&&(Arou.j_T3(1,currentpage-1)>0)&&...
        any((Arou.pos_T3(Arou.j_T3(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.T3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_T3(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_T3(Arou.j_T3(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_T3(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_T3(Arou.j_T3(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T3','Tag','1');%连接这两点，作为标记
    elseif ((Arou.T3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_T3(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_T3(Arou.j_T3(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_T3(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_T3(Arou.j_T3(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T3','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.T3(currentpage+1,:))))&&(Arou.j_T3(1,currentpage+1)>0)...
        &&any((Arou.pos_T3(1,1,currentpage+1)))%如果下一页面开始尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.T3(currentpage+1,1))==1)%%如果下一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_T3(1:Arou.j_T3(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_T3(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_T3(1:Arou.j_T3(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_T3(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T3','Tag','1');%连接这两点，作为标记
    elseif ((Arou.T3(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_T3(1:Arou.j_T3(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_T3(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_T3(1:Arou.j_T3(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_T3(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T3','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.T3(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_T3(:,:,currentpage))))
        for num2=1:Arou.j_T3(1,currentpage);
            %                 frontpage=currentpage-1;
            down_x=Arou.pos_T3(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_T3(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_T3(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_T3(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.T3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T3','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T3','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.T3(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T3','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T3','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_T3(numnext,1,currentpage+1))<(curtime+handles.winsize/2))...
            &&((Arou.pos_T3(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_T3(numnext,1,currentpage+1);
        down_y=Arou.pos_T3(numnext,2,currentpage+1);
        up_x=Arou.pos_T3(numnext,3,currentpage+1);
        up_y=Arou.pos_T3(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.T3(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T3','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T3','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_T3(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_T3(numnext,1,currentpage-1);
        down_y=Arou.pos_T3(numnext,2,currentpage-1);
        up_x=Arou.pos_T3(numnext,3,currentpage-1);
        up_y=Arou.pos_T3(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.T3(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T3','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T3','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%%%画通道T4的标记
if (currentpage>1)&&any(((Arou.T4(currentpage-1,:))))&&(Arou.j_T4(1,currentpage-1)>0)&&...
        any((Arou.pos_T4(Arou.j_T4(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.T4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_T4(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_T4(Arou.j_T4(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_T4(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_T4(Arou.j_T4(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T4','Tag','1');%连接这两点，作为标记
    elseif ((Arou.T4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_T4(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_T4(Arou.j_T4(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_T4(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_T4(Arou.j_T4(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T4','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.T4(currentpage+1,:))))&&(Arou.j_T4(1,currentpage+1)>0)...
        &&any((Arou.pos_T4(1,1,currentpage+1)))%如果下一页面开始尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.T4(currentpage+1,1))==1)%%如果下一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_T4(1:Arou.j_T4(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_T4(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_T4(1:Arou.j_T4(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_T4(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T4','Tag','1');%连接这两点，作为标记
    elseif ((Arou.T4(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_T4(1:Arou.j_T4(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_T4(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_T4(1:Arou.j_T4(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_T4(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T4','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.T4(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_T4(:,:,currentpage))))
        for num2=1:Arou.j_T4(1,currentpage);
            %                 frontpage=currentpage-1;            
            down_x=Arou.pos_T4(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_T4(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_T4(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_T4(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.T4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T4','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T4','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.T4(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T4','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T4','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_T4(numnext,1,currentpage+1))<(curtime+handles.winsize/2))...
            &&((Arou.pos_T4(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_T4(numnext,1,currentpage+1);
        down_y=Arou.pos_T4(numnext,2,currentpage+1);
        up_x=Arou.pos_T4(numnext,3,currentpage+1);
        up_y=Arou.pos_T4(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.T4(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T4','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T4','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_T4(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_T4(numnext,1,currentpage-1);
        down_y=Arou.pos_T4(numnext,2,currentpage-1);
        up_x=Arou.pos_T4(numnext,3,currentpage-1);
        up_y=Arou.pos_T4(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.T4(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T4','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T4','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%%%画通道T5的标记
if (currentpage>1)&&any(((Arou.T5(currentpage-1,:))))&&(Arou.j_T5(1,currentpage-1)>0)&&...
        any((Arou.pos_T5(Arou.j_T5(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.T5(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_T5(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_T5(Arou.j_T5(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_T5(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_T5(Arou.j_T5(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T5','Tag','1');%连接这两点，作为标记
    elseif ((Arou.T5(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_T5(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_T5(Arou.j_T5(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_T5(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_T5(Arou.j_T5(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T5','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.T5(currentpage+1,:))))&&(Arou.j_T5(1,currentpage+1)>0)...
        &&any((Arou.pos_T5(1,1,currentpage+1)))%如果下一页面开始尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.T5(currentpage+1,1))==1)%%如果下一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_T5(1:Arou.j_T5(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_T5(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_T5(1:Arou.j_T5(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_T5(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T5','Tag','1');%连接这两点，作为标记
    elseif ((Arou.T5(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_T5(1:Arou.j_T5(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_T5(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_T5(1:Arou.j_T5(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_T5(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T5','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.T5(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_T5(:,:,currentpage))))
        for num2=1:Arou.j_T5(1,currentpage);
            %                 frontpage=currentpage-1;            
            down_x=Arou.pos_T5(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_T5(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_T5(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_T5(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.T5(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T5','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T5','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.T5(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T5','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T5','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_T5(numnext,1,currentpage+1))<(curtime+handles.winsize/2))...
            &&((Arou.pos_T5(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_T5(numnext,1,currentpage+1);
        down_y=Arou.pos_T5(numnext,2,currentpage+1);
        up_x=Arou.pos_T5(numnext,3,currentpage+1);
        up_y=Arou.pos_T5(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.T5(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T5','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T5','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_T5(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_T5(numnext,1,currentpage-1);
        down_y=Arou.pos_T5(numnext,2,currentpage-1);
        up_x=Arou.pos_T5(numnext,3,currentpage-1);
        up_y=Arou.pos_T5(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.T5(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T5','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T5','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end
%%%%%画通道T6的标记
if (currentpage>1)&&any(((Arou.T6(currentpage-1,:))))&&(Arou.j_T6(1,currentpage-1)>0)&&...
        any((Arou.pos_T6(Arou.j_T6(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.T6(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==1))%%如果上一页的最后标记有纺锤波，很可能这一页的开头也标记有
        down_x=max(Arou.pos_T6(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_T6(Arou.j_T6(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_T6(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_T6(Arou.j_T6(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T6','Tag','1');%连接这两点，作为标记
    elseif ((Arou.T6(currentpage-1,handles.winsize*fsample(handles.Dmeg{1}))==0.5))
        down_x=max(Arou.pos_T6(:,1,currentpage-1));%上一页最后一条线起始点的横坐标
        down_y=Arou.pos_T6(Arou.j_T6(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
        up_x=max(Arou.pos_T6(:,3,currentpage-1));%上一页最后一条线终止点的横坐标
        up_y=Arou.pos_T6(Arou.j_T6(1,currentpage-1),4,currentpage-1);%上一页最后一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T6','Tag','0');%连接这两点，作为标记
    end
end
if (currentpage<totalpage)&&any(((Arou.T6(currentpage+1,:))))&&(Arou.j_T6(1,currentpage+1)>0)...
        &&any((Arou.pos_T6(1,1,currentpage+1)))%如果下一页面开始尾有纺锤波标记,且对应位置记录了坐标值
    load('Arousalchan_data.mat');
    if ((Arou.T6(currentpage+1,1))==1)%%如果下一页的开始标记有纺锤波，很可能这一页的结束也标记有
        down_x=min(Arou.pos_T6(1:Arou.j_T6(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_T6(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_T6(1:Arou.j_T6(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_T6(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T6','Tag','1');%连接这两点，作为标记
    elseif ((Arou.T6(currentpage+1,1)==0.5))
        down_x=min(Arou.pos_T6(1:Arou.j_T6(currentpage+1),1,currentpage+1));%下一页第一条线起始点的横坐标
        down_y=Arou.pos_T6(1,2,currentpage+1);%下一页第一条线起始点的纵坐标
        up_x=min(Arou.pos_T6(1:Arou.j_T6(currentpage+1),3,currentpage+1));%下一页第一条线终止点的横坐标
        up_y=Arou.pos_T6(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
        plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T6','Tag','0');%连接这两点，作为标记
    end
end
if any(((Arou.T6(currentpage,:))))%如果当前页面有纺锤波标记
    load('Arousalchan_data.mat');
    if (any(any(Arou.pos_T6(:,:,currentpage))))
        for num2=1:Arou.j_T6(1,currentpage);
            %                 frontpage=currentpage-1;       
            down_x=Arou.pos_T6(num2,1,currentpage);%第num2条线起始点的横坐标
            down_y=Arou.pos_T6(num2,2,currentpage);%第num2条线起始点的纵坐标
            up_x=Arou.pos_T6(num2,3,currentpage);%第num2条线终止点的横坐标
            up_y=Arou.pos_T6(num2,4,currentpage);%第num2条线终止点的纵坐标
            downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
            uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
            if downpt<uppt
                midpt=round((downpt+uppt)/2);
                if (Arou.T6(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T6','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T6','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            else
                if down_x<handles.winsize*(currentpage-1) %%如果该线段小于该页面最小横坐标，说明这条线在该页面和前一页之间
                    midpt = round(uppt/2);
                else %线段在该页面和下一页之间
                    midpt=round((downpt+handles.winsize*fsample(handles.Dmeg{1}))/2);
                end
                if (Arou.T6(currentpage,midpt)==1)
                    plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T6','Tag','1');%连接这两点，作为标记
                    hold on;
                else
                    plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T6','Tag','0');%连接这两点，作为标记
                    hold on;
                end
            end
        end
    end
end
for numnext=1:10
    if (currentpage<totalpage)&&(down_x==0)&&((Arou.pos_T6(numnext,1,currentpage+1))<(curtime+handles.winsize/2))...
            &&((Arou.pos_T6(numnext,1,currentpage+1))>(curtime-handles.winsize/2))%如果下一页的一部分在当前页面
        down_x=Arou.pos_T6(numnext,1,currentpage+1);
        down_y=Arou.pos_T6(numnext,2,currentpage+1);
        up_x=Arou.pos_T6(numnext,3,currentpage+1);
        up_y=Arou.pos_T6(numnext,4,currentpage+1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if down_x>currentpage*handles.winsize
            if (Arou.T6(currentpage+1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T6','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T6','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    elseif (currentpage>1)&&(down_x==0)&&((Arou.pos_T6(numnext,3,currentpage-1))>curtime-handles.winsize/2)%如果上一页的一部分在当前页面
        down_x=Arou.pos_T6(numnext,1,currentpage-1);
        down_y=Arou.pos_T6(numnext,2,currentpage-1);
        up_x=Arou.pos_T6(numnext,3,currentpage-1);
        up_y=Arou.pos_T6(numnext,4,currentpage-1);
        downpt=round(mod(down_x,10)*fsample(handles.Dmeg{1}));
        uppt=round(mod(up_x,10)*fsample(handles.Dmeg{1}));
        midpt=round((downpt+uppt)/2);
        if up_x>(currentpage-1)*handles.winsize
            if (Arou.T6(currentpage-1,midpt)==1)
                plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_T6','Tag','1');%连接这两点，作为标记
                hold on;
            else
                plot([down_x,up_x],[down_y,up_y],'Color',[1 0.5 0],'LineWidth',4,'DisplayName','plot_T6','Tag','0');%连接这两点，作为标记
                hold on;
            end
        end
    end
end

