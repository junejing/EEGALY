function change_key(a,handles,ctshow)
INDEX = load('index_line.mat');
 x1=get(a(INDEX.i),'Xdata');%得到的是当前线段的位置信息
    n1 = length(x1);
    y1=get(a(INDEX.i),'Ydata') ;
    X = [x1;y1];
    Y = X;
    if ~isempty(Y)
        if n1 == 2
           down_x = mod(Y(1,1),10);
           up_x = mod(Y(1,n1),10);
        elseif n1 > 2
            up_x =mod(Y(1,1),10);
            down_x = mod(Y(1,n1),10);
        end
    end%%%获取当前线段第一个和最后一个点的横坐标值
    load('Datapath.mat');load('Arousal_data.mat');load('Arousalchan_data.mat');
    global totalpage
    global currentpage
    totalpage = ceil((nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/handles.winsize);
    currentpage=str2double(get(handles.currentpage,'string'));%当前的页数
    startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
    endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
    if endpt == 0
        endpt = fsample(handles.Dmeg{1})*handles.winsize;
    end
    switch SelChan
        case 'Fp1'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_Fp1(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_Fp1(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.Fp1(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Fp1(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage+1,startpt)==0.5
                            Arou.Fp1(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.Fp1(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Fp1(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage+1,startpt)==0.5
                            Arou.Fp1(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.Fp1(currentpage+1,endpt)==1
                            Arou.Fp1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Fp1(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage+1,endpt)==0.5
                            Arou.Fp1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Fp1(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.Fp1(currentpage+1,startpt)==1
                            Arou.Fp1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Fp1(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage+1,startpt)==0.5
                            Arou.Fp1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Fp1(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_Fp1(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_Fp1(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.Fp1(currentpage-1,startpt)==1
                            Arou.Fp1(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage-1,startpt)==0.5
                            Arou.Fp1(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.Fp1(currentpage-1,startpt)==1
                            Arou.Fp1(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage-1,startpt)==0.5
                            Arou.Fp1(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.Fp1(currentpage-1,startpt)==1
                            Arou.Fp1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Fp1(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage-1,startpt)==0.5
                            Arou.Fp1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Fp1(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.Fp1(currentpage-1,endtpt)==1
                            Arou.Fp1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Fp1(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage-1,endpt)==0.5
                            Arou.Fp1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Fp1(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_Fp1(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Fp1(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.Fp1(currentpage,startpt)==1
                            Arou.Fp1(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage,startpt)==0.5
                            Arou.Fp1(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.Fp1(currentpage,startpt)==1
                            Arou.Fp1(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage,startpt)==0.5
                            Arou.Fp1(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.Fp1(currentpage,startpt)==1
                            Arou.Fp1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Fp1(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage,startpt)==0.5
                            Arou.Fp1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Fp1(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.Fp1(currentpage,endpt)==1
                            Arou.Fp1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Fp1(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage,endpt)==0.5
                            Arou.Fp1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Fp1(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.Fp1(currentpage,startpt)==1
                            Arou.Fp1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Fp1(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage,startpt)==0.5
                            Arou.Fp1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Fp1(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.Fp1(currentpage,endpt)==1
                            Arou.Fp1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Fp1(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage,endpt)==0.5
                            Arou.Fp1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Fp1(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'Fp2'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_Fp2(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_Fp2(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.Fp2(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Fp2(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage+1,startpt)==0.5
                            Arou.Fp2(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.Fp2(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Fp2(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage+1,startpt)==0.5
                            Arou.Fp2(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.Fp2(currentpage+1,endpt)==1
                            Arou.Fp2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Fp2(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage+1,endpt)==0.5
                            Arou.Fp2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Fp2(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.Fp2(currentpage+1,startpt)==1
                            Arou.Fp2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Fp2(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage+1,startpt)==0.5
                            Arou.Fp2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Fp2(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_Fp2(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_Fp2(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.Fp2(currentpage-1,startpt)==1
                            Arou.Fp2(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage-1,startpt)==0.5
                            Arou.Fp2(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.Fp2(currentpage-1,startpt)==1
                            Arou.Fp2(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage-1,startpt)==0.5
                            Arou.Fp2(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.Fp2(currentpage-1,startpt)==1
                            Arou.Fp2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Fp2(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage-1,startpt)==0.5
                            Arou.Fp2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Fp2(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.Fp2(currentpage-1,endtpt)==1
                            Arou.Fp2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Fp2(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage-1,endpt)==0.5
                            Arou.Fp2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Fp2(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_Fp2(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Fp2(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.Fp2(currentpage,startpt)==1
                            Arou.Fp2(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage,startpt)==0.5
                            Arou.Fp2(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.Fp2(currentpage,startpt)==1
                            Arou.Fp2(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage,startpt)==0.5
                            Arou.Fp2(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.Fp2(currentpage,startpt)==1
                            Arou.Fp2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Fp2(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage,startpt)==0.5
                            Arou.Fp2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Fp2(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.Fp2(currentpage,endpt)==1
                            Arou.Fp2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Fp2(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage,endpt)==0.5
                            Arou.Fp2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Fp2(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.Fp2(currentpage,startpt)==1
                            Arou.Fp2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Fp2(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage,startpt)==0.5
                            Arou.Fp2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Fp2(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.Fp2(currentpage,endpt)==1
                            Arou.Fp2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Fp2(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage,endpt)==0.5
                            Arou.Fp2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Fp2(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'F3'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_F3(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_F3(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.F3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F3(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage+1,startpt)==0.5
                            Arou.F3(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.F3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F3(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage+1,startpt)==0.5
                            Arou.F3(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.F3(currentpage+1,endpt)==1
                            Arou.F3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F3(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage+1,endpt)==0.5
                            Arou.F3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F3(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.F3(currentpage+1,startpt)==1
                            Arou.F3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F3(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage+1,startpt)==0.5
                            Arou.F3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F3(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_F3(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_F3(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.F3(currentpage-1,startpt)==1
                            Arou.F3(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage-1,startpt)==0.5
                            Arou.F3(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.F3(currentpage-1,startpt)==1
                            Arou.F3(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage-1,startpt)==0.5
                            Arou.F3(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.F3(currentpage-1,startpt)==1
                            Arou.F3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F3(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage-1,startpt)==0.5
                            Arou.F3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F3(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.F3(currentpage-1,endtpt)==1
                            Arou.F3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F3(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage-1,endpt)==0.5
                            Arou.F3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F3(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_F3(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_F3(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.F3(currentpage,startpt)==1
                            Arou.F3(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage,startpt)==0.5
                            Arou.F3(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.F3(currentpage,startpt)==1
                            Arou.F3(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage,startpt)==0.5
                            Arou.F3(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.F3(currentpage,startpt)==1
                            Arou.F3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F3(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage,startpt)==0.5
                            Arou.F3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F3(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.F3(currentpage,endpt)==1
                            Arou.F3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F3(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage,endpt)==0.5
                            Arou.F3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F3(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.F3(currentpage,startpt)==1
                            Arou.F3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F3(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage,startpt)==0.5
                            Arou.F3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F3(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.F3(currentpage,endpt)==1
                            Arou.F3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F3(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage,endpt)==0.5
                            Arou.F3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F3(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'F4'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_F4(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_F4(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.F4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F4(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage+1,startpt)==0.5
                            Arou.F4(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.F4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F4(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage+1,startpt)==0.5
                            Arou.F4(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.F4(currentpage+1,endpt)==1
                            Arou.F4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F4(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage+1,endpt)==0.5
                            Arou.F4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F4(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.F4(currentpage+1,startpt)==1
                            Arou.F4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F4(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage+1,startpt)==0.5
                            Arou.F4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F4(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_F4(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_F4(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.F4(currentpage-1,startpt)==1
                            Arou.F4(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage-1,startpt)==0.5
                            Arou.F4(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.F4(currentpage-1,startpt)==1
                            Arou.F4(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage-1,startpt)==0.5
                            Arou.F4(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.F4(currentpage-1,startpt)==1
                            Arou.F4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F4(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage-1,startpt)==0.5
                            Arou.F4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F4(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.F4(currentpage-1,endtpt)==1
                            Arou.F4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F4(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage-1,endpt)==0.5
                            Arou.F4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F4(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_F4(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_F4(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.F4(currentpage,startpt)==1
                            Arou.F4(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage,startpt)==0.5
                            Arou.F4(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.F4(currentpage,startpt)==1
                            Arou.F4(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage,startpt)==0.5
                            Arou.F4(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.F4(currentpage,startpt)==1
                            Arou.F4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F4(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage,startpt)==0.5
                            Arou.F4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F4(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.F4(currentpage,endpt)==1
                            Arou.F4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F4(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage,endpt)==0.5
                            Arou.F4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F4(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.F4(currentpage,startpt)==1
                            Arou.F4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F4(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage,startpt)==0.5
                            Arou.F4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F4(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.F4(currentpage,endpt)==1
                            Arou.F4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F4(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage,endpt)==0.5
                            Arou.F4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F4(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'C3'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                
                if (currentpage<totalpage)&&(max_x1==Arou.pos_C3(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_C3(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.C3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.C3(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage+1,startpt)==0.5
                            Arou.C3(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.C3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.C3(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage+1,startpt)==0.5
                            Arou.C3(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.C3(currentpage+1,endpt)==1
                            Arou.C3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.C3(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage+1,endpt)==0.5
                            Arou.C3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.C3(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.C3(currentpage+1,startpt)==1
                            Arou.C3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.C3(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage+1,startpt)==0.5
                            Arou.C3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.C3(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_C3(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_C3(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.C3(currentpage-1,startpt)==1
                            Arou.C3(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage-1,startpt)==0.5
                            Arou.C3(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.C3(currentpage-1,startpt)==1
                            Arou.C3(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage-1,startpt)==0.5
                            Arou.C3(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.C3(currentpage-1,startpt)==1
                            Arou.C3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.C3(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage-1,startpt)==0.5
                            Arou.C3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.C3(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.C3(currentpage-1,endtpt)==1
                            Arou.C3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.C3(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage-1,endpt)==0.5
                            Arou.C3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.C3(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_C3(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_C3(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.C3(currentpage,startpt)==1
                            Arou.C3(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage,startpt)==0.5
                            Arou.C3(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.C3(currentpage,startpt)==1
                            Arou.C3(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage,startpt)==0.5
                            Arou.C3(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.C3(currentpage,startpt)==1
                            Arou.C3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.C3(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage,startpt)==0.5
                            Arou.C3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.C3(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.C3(currentpage,endpt)==1
                            Arou.C3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.C3(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage,endpt)==0.5
                            Arou.C3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.C3(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.C3(currentpage,startpt)==1
                            Arou.C3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.C3(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage,startpt)==0.5
                            Arou.C3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.C3(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.C3(currentpage,endpt)==1
                            Arou.C3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.C3(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage,endpt)==0.5
                            Arou.C3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.C3(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'C4'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_C4(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_C4(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.C4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.C4(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage+1,startpt)==0.5
                            Arou.C4(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.C4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.C4(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage+1,startpt)==0.5
                            Arou.C4(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.C4(currentpage+1,endpt)==1
                            Arou.C4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.C4(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage+1,endpt)==0.5
                            Arou.C4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.C4(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.C4(currentpage+1,startpt)==1
                            Arou.C4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.C4(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage+1,startpt)==0.5
                            Arou.C4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.C4(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_C4(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_C4(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.C4(currentpage-1,startpt)==1
                            Arou.C4(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage-1,startpt)==0.5
                            Arou.C4(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.C4(currentpage-1,startpt)==1
                            Arou.C4(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage-1,startpt)==0.5
                            Arou.C4(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.C4(currentpage-1,startpt)==1
                            Arou.C4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.C4(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage-1,startpt)==0.5
                            Arou.C4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.C4(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.C4(currentpage-1,endtpt)==1
                            Arou.C4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.C4(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage-1,endpt)==0.5
                            Arou.C4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.C4(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_C4(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_C4(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.C4(currentpage,startpt)==1
                            Arou.C4(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage,startpt)==0.5
                            Arou.C4(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.C4(currentpage,startpt)==1
                            Arou.C4(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage,startpt)==0.5
                            Arou.C4(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.C4(currentpage,startpt)==1
                            Arou.C4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.C4(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage,startpt)==0.5
                            Arou.C4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.C4(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.C4(currentpage,endpt)==1
                            Arou.C4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.C4(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage,endpt)==0.5
                            Arou.C4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.C4(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.C4(currentpage,startpt)==1
                            Arou.C4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.C4(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage,startpt)==0.5
                            Arou.C4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.C4(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.C4(currentpage,endpt)==1
                            Arou.C4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.C4(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage,endpt)==0.5
                            Arou.C4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.C4(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'P3'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_P3(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_P3(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.P3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.P3(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage+1,startpt)==0.5
                            Arou.P3(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.P3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.P3(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage+1,startpt)==0.5
                            Arou.P3(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.P3(currentpage+1,endpt)==1
                            Arou.P3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.P3(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage+1,endpt)==0.5
                            Arou.P3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.P3(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.P3(currentpage+1,startpt)==1
                            Arou.P3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.P3(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage+1,startpt)==0.5
                            Arou.P3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.P3(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_P3(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_P3(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.P3(currentpage-1,startpt)==1
                            Arou.P3(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage-1,startpt)==0.5
                            Arou.P3(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.P3(currentpage-1,startpt)==1
                            Arou.P3(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage-1,startpt)==0.5
                            Arou.P3(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.P3(currentpage-1,startpt)==1
                            Arou.P3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.P3(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage-1,startpt)==0.5
                            Arou.P3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.P3(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.P3(currentpage-1,endtpt)==1
                            Arou.P3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.P3(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage-1,endpt)==0.5
                            Arou.P3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.P3(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_P3(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_P3(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.P3(currentpage,startpt)==1
                            Arou.P3(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage,startpt)==0.5
                            Arou.P3(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.P3(currentpage,startpt)==1
                            Arou.P3(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage,startpt)==0.5
                            Arou.P3(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.P3(currentpage,startpt)==1
                            Arou.P3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.P3(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage,startpt)==0.5
                            Arou.P3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.P3(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.P3(currentpage,endpt)==1
                            Arou.P3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.P3(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage,endpt)==0.5
                            Arou.P3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.P3(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.P3(currentpage,startpt)==1
                            Arou.P3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.P3(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage,startpt)==0.5
                            Arou.P3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.P3(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.P3(currentpage,endpt)==1
                            Arou.P3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.P3(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage,endpt)==0.5
                            Arou.P3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.P3(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'P4'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_P4(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_P4(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.P4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.P4(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage+1,startpt)==0.5
                            Arou.P4(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.P4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.P4(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage+1,startpt)==0.5
                            Arou.P4(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.P4(currentpage+1,endpt)==1
                            Arou.P4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.P4(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage+1,endpt)==0.5
                            Arou.P4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.P4(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.P4(currentpage+1,startpt)==1
                            Arou.P4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.P4(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage+1,startpt)==0.5
                            Arou.P4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.P4(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_P4(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_P4(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.P4(currentpage-1,startpt)==1
                            Arou.P4(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage-1,startpt)==0.5
                            Arou.P4(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.P4(currentpage-1,startpt)==1
                            Arou.P4(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage-1,startpt)==0.5
                            Arou.P4(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.P4(currentpage-1,startpt)==1
                            Arou.P4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.P4(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage-1,startpt)==0.5
                            Arou.P4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.P4(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.P4(currentpage-1,endtpt)==1
                            Arou.P4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.P4(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage-1,endpt)==0.5
                            Arou.P4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.P4(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_P4(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_P4(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.P4(currentpage,startpt)==1
                            Arou.P4(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage,startpt)==0.5
                            Arou.P4(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.P4(currentpage,startpt)==1
                            Arou.P4(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage,startpt)==0.5
                            Arou.P4(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.P4(currentpage,startpt)==1
                            Arou.P4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.P4(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage,startpt)==0.5
                            Arou.P4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.P4(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.P4(currentpage,endpt)==1
                            Arou.P4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.P4(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage,endpt)==0.5
                            Arou.P4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.P4(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.P4(currentpage,startpt)==1
                            Arou.P4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.P4(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage,startpt)==0.5
                            Arou.P4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.P4(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.P4(currentpage,endpt)==1
                            Arou.P4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.P4(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage,endpt)==0.5
                            Arou.P4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.P4(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'O1'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_O1(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_O1(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.O1(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.O1(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage+1,startpt)==0.5
                            Arou.O1(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.O1(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.O1(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage+1,startpt)==0.5
                            Arou.O1(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.O1(currentpage+1,endpt)==1
                            Arou.O1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.O1(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage+1,endpt)==0.5
                            Arou.O1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.O1(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.O1(currentpage+1,startpt)==1
                            Arou.O1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.O1(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage+1,startpt)==0.5
                            Arou.O1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.O1(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_O1(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_O1(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.O1(currentpage-1,startpt)==1
                            Arou.O1(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage-1,startpt)==0.5
                            Arou.O1(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.O1(currentpage-1,startpt)==1
                            Arou.O1(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage-1,startpt)==0.5
                            Arou.O1(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.O1(currentpage-1,startpt)==1
                            Arou.O1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.O1(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage-1,startpt)==0.5
                            Arou.O1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.O1(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.O1(currentpage-1,endtpt)==1
                            Arou.O1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.O1(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage-1,endpt)==0.5
                            Arou.O1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.O1(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_O1(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_O1(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.O1(currentpage,startpt)==1
                            Arou.O1(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage,startpt)==0.5
                            Arou.O1(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.O1(currentpage,startpt)==1
                            Arou.O1(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage,startpt)==0.5
                            Arou.O1(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.O1(currentpage,startpt)==1
                            Arou.O1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.O1(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage,startpt)==0.5
                            Arou.O1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.O1(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.O1(currentpage,endpt)==1
                            Arou.O1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.O1(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage,endpt)==0.5
                            Arou.O1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.O1(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.O1(currentpage,startpt)==1
                            Arou.O1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.O1(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage,startpt)==0.5
                            Arou.O1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.O1(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.O1(currentpage,endpt)==1
                            Arou.O1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.O1(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage,endpt)==0.5
                            Arou.O1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.O1(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'O2'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_O2(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_O2(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.O2(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.O2(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage+1,startpt)==0.5
                            Arou.O2(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.O2(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.O2(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage+1,startpt)==0.5
                            Arou.O2(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.O2(currentpage+1,endpt)==1
                            Arou.O2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.O2(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage+1,endpt)==0.5
                            Arou.O2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.O2(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.O2(currentpage+1,startpt)==1
                            Arou.O2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.O2(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage+1,startpt)==0.5
                            Arou.O2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.O2(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_O2(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_O2(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.O2(currentpage-1,startpt)==1
                            Arou.O2(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage-1,startpt)==0.5
                            Arou.O2(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.O2(currentpage-1,startpt)==1
                            Arou.O2(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage-1,startpt)==0.5
                            Arou.O2(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.O2(currentpage-1,startpt)==1
                            Arou.O2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.O2(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage-1,startpt)==0.5
                            Arou.O2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.O2(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.O2(currentpage-1,endtpt)==1
                            Arou.O2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.O2(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage-1,endpt)==0.5
                            Arou.O2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.O2(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_O2(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_O2(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.O2(currentpage,startpt)==1
                            Arou.O2(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage,startpt)==0.5
                            Arou.O2(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.O2(currentpage,startpt)==1
                            Arou.O2(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage,startpt)==0.5
                            Arou.O2(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.O2(currentpage,startpt)==1
                            Arou.O2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.O2(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage,startpt)==0.5
                            Arou.O2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.O2(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.O2(currentpage,endpt)==1
                            Arou.O2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.O2(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage,endpt)==0.5
                            Arou.O2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.O2(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.O2(currentpage,startpt)==1
                            Arou.O2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.O2(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage,startpt)==0.5
                            Arou.O2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.O2(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.O2(currentpage,endpt)==1
                            Arou.O2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.O2(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage,endpt)==0.5
                            Arou.O2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.O2(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'F7'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_F7(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_F7(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.F7(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F7(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage+1,startpt)==0.5
                            Arou.F7(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.F7(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F7(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage+1,startpt)==0.5
                            Arou.F7(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.F7(currentpage+1,endpt)==1
                            Arou.F7(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F7(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage+1,endpt)==0.5
                            Arou.F7(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F7(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.F7(currentpage+1,startpt)==1
                            Arou.F7(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F7(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage+1,startpt)==0.5
                            Arou.F7(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F7(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_F7(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_F7(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.F7(currentpage-1,startpt)==1
                            Arou.F7(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage-1,startpt)==0.5
                            Arou.F7(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.F7(currentpage-1,startpt)==1
                            Arou.F7(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage-1,startpt)==0.5
                            Arou.F7(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.F7(currentpage-1,startpt)==1
                            Arou.F7(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F7(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage-1,startpt)==0.5
                            Arou.F7(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F7(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.F7(currentpage-1,endtpt)==1
                            Arou.F7(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F7(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage-1,endpt)==0.5
                            Arou.F7(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F7(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_F7(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_F7(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.F7(currentpage,startpt)==1
                            Arou.F7(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage,startpt)==0.5
                            Arou.F7(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.F7(currentpage,startpt)==1
                            Arou.F7(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage,startpt)==0.5
                            Arou.F7(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.F7(currentpage,startpt)==1
                            Arou.F7(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F7(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage,startpt)==0.5
                            Arou.F7(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F7(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.F7(currentpage,endpt)==1
                            Arou.F7(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F7(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage,endpt)==0.5
                            Arou.F7(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F7(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.F7(currentpage,startpt)==1
                            Arou.F7(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F7(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage,startpt)==0.5
                            Arou.F7(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F7(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.F7(currentpage,endpt)==1
                            Arou.F7(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F7(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage,endpt)==0.5
                            Arou.F7(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F7(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'F8'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_F8(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_F8(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.F8(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F8(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage+1,startpt)==0.5
                            Arou.F8(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.F8(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F8(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage+1,startpt)==0.5
                            Arou.F8(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.F8(currentpage+1,endpt)==1
                            Arou.F8(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F8(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage+1,endpt)==0.5
                            Arou.F8(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F8(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.F8(currentpage+1,startpt)==1
                            Arou.F8(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F8(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage+1,startpt)==0.5
                            Arou.F8(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F8(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_F8(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_F8(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.F8(currentpage-1,startpt)==1
                            Arou.F8(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage-1,startpt)==0.5
                            Arou.F8(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.F8(currentpage-1,startpt)==1
                            Arou.F8(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage-1,startpt)==0.5
                            Arou.F8(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.F8(currentpage-1,startpt)==1
                            Arou.F8(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F8(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage-1,startpt)==0.5
                            Arou.F8(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F8(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.F8(currentpage-1,endtpt)==1
                            Arou.F8(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.F8(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage-1,endpt)==0.5
                            Arou.F8(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.F8(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_F8(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_F8(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.F8(currentpage,startpt)==1
                            Arou.F8(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage,startpt)==0.5
                            Arou.F8(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.F8(currentpage,startpt)==1
                            Arou.F8(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage,startpt)==0.5
                            Arou.F8(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.F8(currentpage,startpt)==1
                            Arou.F8(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F8(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage,startpt)==0.5
                            Arou.F8(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F8(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.F8(currentpage,endpt)==1
                            Arou.F8(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F8(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage,endpt)==0.5
                            Arou.F8(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F8(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.F8(currentpage,startpt)==1
                            Arou.F8(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F8(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage,startpt)==0.5
                            Arou.F8(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F8(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.F8(currentpage,endpt)==1
                            Arou.F8(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.F8(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage,endpt)==0.5
                            Arou.F8(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.F8(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'Fz'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_Fz(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_Fz(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.Fz(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Fz(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage+1,startpt)==0.5
                            Arou.Fz(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.Fz(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Fz(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage+1,startpt)==0.5
                            Arou.Fz(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.Fz(currentpage+1,endpt)==1
                            Arou.Fz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Fz(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage+1,endpt)==0.5
                            Arou.Fz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Fz(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.Fz(currentpage+1,startpt)==1
                            Arou.Fz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Fz(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage+1,startpt)==0.5
                            Arou.Fz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Fz(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_Fz(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_Fz(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.Fz(currentpage-1,startpt)==1
                            Arou.Fz(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage-1,startpt)==0.5
                            Arou.Fz(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.Fz(currentpage-1,startpt)==1
                            Arou.Fz(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage-1,startpt)==0.5
                            Arou.Fz(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.Fz(currentpage-1,startpt)==1
                            Arou.Fz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Fz(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage-1,startpt)==0.5
                            Arou.Fz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Fz(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.Fz(currentpage-1,endtpt)==1
                            Arou.Fz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Fz(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage-1,endpt)==0.5
                            Arou.Fz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Fz(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_Fz(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Fz(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.Fz(currentpage,startpt)==1
                            Arou.Fz(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage,startpt)==0.5
                            Arou.Fz(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.Fz(currentpage,startpt)==1
                            Arou.Fz(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage,startpt)==0.5
                            Arou.Fz(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.Fz(currentpage,startpt)==1
                            Arou.Fz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Fz(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage,startpt)==0.5
                            Arou.Fz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Fz(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.Fz(currentpage,endpt)==1
                            Arou.Fz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Fz(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage,endpt)==0.5
                            Arou.Fz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Fz(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.Fz(currentpage,startpt)==1
                            Arou.Fz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Fz(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage,startpt)==0.5
                            Arou.Fz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Fz(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.Fz(currentpage,endpt)==1
                            Arou.Fz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Fz(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage,endpt)==0.5
                            Arou.Fz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Fz(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'Cz'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_Cz(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_Cz(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.Cz(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Cz(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage+1,startpt)==0.5
                            Arou.Cz(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.Cz(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Cz(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage+1,startpt)==0.5
                            Arou.Cz(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.Cz(currentpage+1,endpt)==1
                            Arou.Cz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Cz(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage+1,endpt)==0.5
                            Arou.Cz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Cz(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.Cz(currentpage+1,startpt)==1
                            Arou.Cz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Cz(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage+1,startpt)==0.5
                            Arou.Cz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Cz(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_Cz(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_Cz(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.Cz(currentpage-1,startpt)==1
                            Arou.Cz(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage-1,startpt)==0.5
                            Arou.Cz(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.Cz(currentpage-1,startpt)==1
                            Arou.Cz(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage-1,startpt)==0.5
                            Arou.Cz(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.Cz(currentpage-1,startpt)==1
                            Arou.Cz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Cz(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage-1,startpt)==0.5
                            Arou.Cz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Cz(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.Cz(currentpage-1,endtpt)==1
                            Arou.Cz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Cz(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage-1,endpt)==0.5
                            Arou.Cz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Cz(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_Cz(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Cz(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.Cz(currentpage,startpt)==1
                            Arou.Cz(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage,startpt)==0.5
                            Arou.Cz(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.Cz(currentpage,startpt)==1
                            Arou.Cz(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage,startpt)==0.5
                            Arou.Cz(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.Cz(currentpage,startpt)==1
                            Arou.Cz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Cz(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage,startpt)==0.5
                            Arou.Cz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Cz(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.Cz(currentpage,endpt)==1
                            Arou.Cz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Cz(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage,endpt)==0.5
                            Arou.Cz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Cz(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.Cz(currentpage,startpt)==1
                            Arou.Cz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Cz(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage,startpt)==0.5
                            Arou.Cz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Cz(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.Cz(currentpage,endpt)==1
                            Arou.Cz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Cz(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage,endpt)==0.5
                            Arou.Cz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Cz(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'Pz'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_Pz(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_Pz(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.Pz(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Pz(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage+1,startpt)==0.5
                            Arou.Pz(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.Pz(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Pz(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage+1,startpt)==0.5
                            Arou.Pz(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.Pz(currentpage+1,endpt)==1
                            Arou.Pz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Pz(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage+1,endpt)==0.5
                            Arou.Pz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Pz(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.Pz(currentpage+1,startpt)==1
                            Arou.Pz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Pz(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage+1,startpt)==0.5
                            Arou.Pz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Pz(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_Pz(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_Pz(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.Pz(currentpage-1,startpt)==1
                            Arou.Pz(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage-1,startpt)==0.5
                            Arou.Pz(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.Pz(currentpage-1,startpt)==1
                            Arou.Pz(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage-1,startpt)==0.5
                            Arou.Pz(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.Pz(currentpage-1,startpt)==1
                            Arou.Pz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Pz(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage-1,startpt)==0.5
                            Arou.Pz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Pz(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.Pz(currentpage-1,endtpt)==1
                            Arou.Pz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.Pz(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage-1,endpt)==0.5
                            Arou.Pz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.Pz(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_Pz(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Pz(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.Pz(currentpage,startpt)==1
                            Arou.Pz(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage,startpt)==0.5
                            Arou.Pz(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.Pz(currentpage,startpt)==1
                            Arou.Pz(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage,startpt)==0.5
                            Arou.Pz(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.Pz(currentpage,startpt)==1
                            Arou.Pz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Pz(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage,startpt)==0.5
                            Arou.Pz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Pz(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.Pz(currentpage,endpt)==1
                            Arou.Pz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Pz(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage,endpt)==0.5
                            Arou.Pz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Pz(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.Pz(currentpage,startpt)==1
                            Arou.Pz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Pz(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage,startpt)==0.5
                            Arou.Pz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Pz(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.Pz(currentpage,endpt)==1
                            Arou.Pz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.Pz(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage,endpt)==0.5
                            Arou.Pz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.Pz(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'A1'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_A1(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_A1(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.A1(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.A1(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage+1,startpt)==0.5
                            Arou.A1(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.A1(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.A1(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage+1,startpt)==0.5
                            Arou.A1(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.A1(currentpage+1,endpt)==1
                            Arou.A1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.A1(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage+1,endpt)==0.5
                            Arou.A1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.A1(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.A1(currentpage+1,startpt)==1
                            Arou.A1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.A1(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage+1,startpt)==0.5
                            Arou.A1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.A1(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_A1(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_A1(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.A1(currentpage-1,startpt)==1
                            Arou.A1(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage-1,startpt)==0.5
                            Arou.A1(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.A1(currentpage-1,startpt)==1
                            Arou.A1(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage-1,startpt)==0.5
                            Arou.A1(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.A1(currentpage-1,startpt)==1
                            Arou.A1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.A1(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage-1,startpt)==0.5
                            Arou.A1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.A1(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.A1(currentpage-1,endtpt)==1
                            Arou.A1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.A1(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage-1,endpt)==0.5
                            Arou.A1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.A1(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_A1(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_A1(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.A1(currentpage,startpt)==1
                            Arou.A1(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage,startpt)==0.5
                            Arou.A1(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.A1(currentpage,startpt)==1
                            Arou.A1(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage,startpt)==0.5
                            Arou.A1(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.A1(currentpage,startpt)==1
                            Arou.A1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.A1(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage,startpt)==0.5
                            Arou.A1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.A1(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.A1(currentpage,endpt)==1
                            Arou.A1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.A1(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage,endpt)==0.5
                            Arou.A1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.A1(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.A1(currentpage,startpt)==1
                            Arou.A1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.A1(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage,startpt)==0.5
                            Arou.A1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.A1(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.A1(currentpage,endpt)==1
                            Arou.A1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.A1(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage,endpt)==0.5
                            Arou.A1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.A1(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'A2'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_A2(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_A2(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.A2(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.A2(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage+1,startpt)==0.5
                            Arou.A2(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.A2(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.A2(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage+1,startpt)==0.5
                            Arou.A2(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.A2(currentpage+1,endpt)==1
                            Arou.A2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.A2(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage+1,endpt)==0.5
                            Arou.A2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.A2(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.A2(currentpage+1,startpt)==1
                            Arou.A2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.A2(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage+1,startpt)==0.5
                            Arou.A2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.A2(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_A2(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_A2(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.A2(currentpage-1,startpt)==1
                            Arou.A2(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage-1,startpt)==0.5
                            Arou.A2(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.A2(currentpage-1,startpt)==1
                            Arou.A2(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage-1,startpt)==0.5
                            Arou.A2(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.A2(currentpage-1,startpt)==1
                            Arou.A2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.A2(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage-1,startpt)==0.5
                            Arou.A2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.A2(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.A2(currentpage-1,endtpt)==1
                            Arou.A2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.A2(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage-1,endpt)==0.5
                            Arou.A2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.A2(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_A2(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_A2(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.A2(currentpage,startpt)==1
                            Arou.A2(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage,startpt)==0.5
                            Arou.A2(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.A2(currentpage,startpt)==1
                            Arou.A2(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage,startpt)==0.5
                            Arou.A2(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.A2(currentpage,startpt)==1
                            Arou.A2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.A2(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage,startpt)==0.5
                            Arou.A2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.A2(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.A2(currentpage,endpt)==1
                            Arou.A2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.A2(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage,endpt)==0.5
                            Arou.A2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.A2(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.A2(currentpage,startpt)==1
                            Arou.A2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.A2(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage,startpt)==0.5
                            Arou.A2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.A2(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.A2(currentpage,endpt)==1
                            Arou.A2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.A2(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage,endpt)==0.5
                            Arou.A2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.A2(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'T3'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_T3(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_T3(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.T3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T3(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage+1,startpt)==0.5
                            Arou.T3(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.T3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T3(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage+1,startpt)==0.5
                            Arou.T3(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.T3(currentpage+1,endpt)==1
                            Arou.T3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T3(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage+1,endpt)==0.5
                            Arou.T3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T3(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.T3(currentpage+1,startpt)==1
                            Arou.T3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T3(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage+1,startpt)==0.5
                            Arou.T3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T3(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_T3(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_T3(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.T3(currentpage-1,startpt)==1
                            Arou.T3(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage-1,startpt)==0.5
                            Arou.T3(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.T3(currentpage-1,startpt)==1
                            Arou.T3(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage-1,startpt)==0.5
                            Arou.T3(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.T3(currentpage-1,startpt)==1
                            Arou.T3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T3(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage-1,startpt)==0.5
                            Arou.T3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T3(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.T3(currentpage-1,endtpt)==1
                            Arou.T3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T3(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage-1,endpt)==0.5
                            Arou.T3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T3(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_T3(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_T3(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.T3(currentpage,startpt)==1
                            Arou.T3(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage,startpt)==0.5
                            Arou.T3(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.T3(currentpage,startpt)==1
                            Arou.T3(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage,startpt)==0.5
                            Arou.T3(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.T3(currentpage,startpt)==1
                            Arou.T3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T3(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage,startpt)==0.5
                            Arou.T3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T3(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.T3(currentpage,endpt)==1
                            Arou.T3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T3(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage,endpt)==0.5
                            Arou.T3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T3(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.T3(currentpage,startpt)==1
                            Arou.T3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T3(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage,startpt)==0.5
                            Arou.T3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T3(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.T3(currentpage,endpt)==1
                            Arou.T3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T3(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage,endpt)==0.5
                            Arou.T3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T3(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'T4'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_T4(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_T4(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.T4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T4(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage+1,startpt)==0.5
                            Arou.T4(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.T4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T4(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage+1,startpt)==0.5
                            Arou.T4(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.T4(currentpage+1,endpt)==1
                            Arou.T4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T4(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage+1,endpt)==0.5
                            Arou.T4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T4(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.T4(currentpage+1,startpt)==1
                            Arou.T4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T4(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage+1,startpt)==0.5
                            Arou.T4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T4(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_T4(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_T4(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.T4(currentpage-1,startpt)==1
                            Arou.T4(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage-1,startpt)==0.5
                            Arou.T4(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.T4(currentpage-1,startpt)==1
                            Arou.T4(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage-1,startpt)==0.5
                            Arou.T4(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.T4(currentpage-1,startpt)==1
                            Arou.T4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T4(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage-1,startpt)==0.5
                            Arou.T4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T4(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.T4(currentpage-1,endtpt)==1
                            Arou.T4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T4(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage-1,endpt)==0.5
                            Arou.T4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T4(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_T4(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_T4(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.T4(currentpage,startpt)==1
                            Arou.T4(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage,startpt)==0.5
                            Arou.T4(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.T4(currentpage,startpt)==1
                            Arou.T4(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage,startpt)==0.5
                            Arou.T4(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.T4(currentpage,startpt)==1
                            Arou.T4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T4(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage,startpt)==0.5
                            Arou.T4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T4(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.T4(currentpage,endpt)==1
                            Arou.T4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T4(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage,endpt)==0.5
                            Arou.T4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T4(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.T4(currentpage,startpt)==1
                            Arou.T4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T4(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage,startpt)==0.5
                            Arou.T4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T4(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.T4(currentpage,endpt)==1
                            Arou.T4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T4(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage,endpt)==0.5
                            Arou.T4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T4(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'T5'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_T5(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_T5(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.T5(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T5(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage+1,startpt)==0.5
                            Arou.T5(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.T5(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T5(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage+1,startpt)==0.5
                            Arou.T5(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.T5(currentpage+1,endpt)==1
                            Arou.T5(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T5(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage+1,endpt)==0.5
                            Arou.T5(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T5(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.T5(currentpage+1,startpt)==1
                            Arou.T5(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T5(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage+1,startpt)==0.5
                            Arou.T5(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T5(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_T5(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_T5(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.T5(currentpage-1,startpt)==1
                            Arou.T5(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage-1,startpt)==0.5
                            Arou.T5(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.T5(currentpage-1,startpt)==1
                            Arou.T5(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage-1,startpt)==0.5
                            Arou.T5(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.T5(currentpage-1,startpt)==1
                            Arou.T5(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T5(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage-1,startpt)==0.5
                            Arou.T5(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T5(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.T5(currentpage-1,endtpt)==1
                            Arou.T5(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T5(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage-1,endpt)==0.5
                            Arou.T5(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T5(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_T5(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_T5(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.T5(currentpage,startpt)==1
                            Arou.T5(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage,startpt)==0.5
                            Arou.T5(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.T5(currentpage,startpt)==1
                            Arou.T5(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage,startpt)==0.5
                            Arou.T5(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.T5(currentpage,startpt)==1
                            Arou.T5(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T5(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage,startpt)==0.5
                            Arou.T5(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T5(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.T5(currentpage,endpt)==1
                            Arou.T5(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T5(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage,endpt)==0.5
                            Arou.T5(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T5(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.T5(currentpage,startpt)==1
                            Arou.T5(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T5(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage,startpt)==0.5
                            Arou.T5(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T5(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.T5(currentpage,endpt)==1
                            Arou.T5(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T5(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage,endpt)==0.5
                            Arou.T5(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T5(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
        case 'T6'
            load('sure_or_not.mat');
            if (max(x1)>=ctshow+handles.winsize/2)
                max_x1=ctshow+handles.winsize/2;
                min_x1=min(x1);
                endpt=fsample(handles.Dmeg{1})*handles.winsize;
            elseif (min(x1)<ctshow-handles.winsize/2)
                min_x1=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                max_x1=max(x1);
                startpt=1;
            else
                max_x1=max(x1);
                min_x1=min(x1);
            end
            for IDex=1:10
                if (currentpage<totalpage)&&(max_x1==Arou.pos_T6(IDex,3,currentpage+1))&&...
                        (y1(1,1)==Arou.pos_T6(IDex,2,currentpage+1)) %该线段属于下一页
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                        if Arou.T6(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T6(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage+1,startpt)==0.5
                            Arou.T6(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                        if Arou.T6(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T6(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage+1,startpt)==0.5
                            Arou.T6(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                        if Arou.T6(currentpage+1,endpt)==1
                            Arou.T6(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T6(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage+1,endpt)==0.5
                            Arou.T6(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T6(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                        if Arou.T6(currentpage+1,startpt)==1
                            Arou.T6(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T6(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage+1,startpt)==0.5
                            Arou.T6(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T6(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (currentpage>1)&&(max_x1==Arou.pos_T6(IDex,3,currentpage-1))&&...
                        (y1(1,1)==Arou.pos_T6(IDex,2,currentpage-1)) %该线段属于上一页
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                        if Arou.T6(currentpage-1,startpt)==1
                            Arou.T6(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage-1,startpt)==0.5
                            Arou.T6(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                        if Arou.T6(currentpage-1,startpt)==1
                            Arou.T6(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage-1,startpt)==0.5
                            Arou.T6(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                        if Arou.T6(currentpage-1,startpt)==1
                            Arou.T6(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T6(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage-1,startpt)==0.5
                            Arou.T6(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T6(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                        if Arou.T6(currentpage-1,endtpt)==1
                            Arou.T6(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                            Arou.T6(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage-1,endpt)==0.5
                            Arou.T6(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                            Arou.T6(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                elseif (max_x1==Arou.pos_T6(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_T6(IDex,2,currentpage))%该线段属于当前页
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                        if Arou.T6(currentpage,startpt)==1
                            Arou.T6(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage,startpt)==0.5
                            Arou.T6(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%左利手，当前页内部0-10s之间
                        if Arou.T6(currentpage,startpt)==1
                            Arou.T6(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage,startpt)==0.5
                            Arou.T6(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                        if Arou.T6(currentpage,startpt)==1
                            Arou.T6(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T6(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage,startpt)==0.5
                            Arou.T6(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T6(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                        if Arou.T6(currentpage,endpt)==1
                            Arou.T6(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T6(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage,endpt)==0.5
                            Arou.T6(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T6(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%当前页和上一页之间，左利手
                        if Arou.T6(currentpage,startpt)==1
                            Arou.T6(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T6(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage,startpt)==0.5
                            Arou.T6(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T6(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间，右利手
                        if Arou.T6(currentpage,endpt)==1
                            Arou.T6(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%将删除的线段对应的数据恢复成0
                            Arou.T6(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage,endpt)==0.5
                            Arou.T6(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%将删除的线段对应的数据恢复成0
                            Arou.T6(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
            
    end
    prefix='aro';%设置文件的前缀为aro
    datFile=strcat(prefix,'_',dataname(1:end-4));
    subname=datFile;%设置文件名为aro+数据名
    save('Arousal_data','Arou');%将数据保存到默认目录下
    save('sure_or_not','sure_or_not');
    datfile=strcat(subname,'.mat');
    save(datfile,'Arou');%将arou结构体保存为“aro+数据名”的mat文件
    delete('index_line.mat');
    set(gcf,'KeyPressFcn',@keypress);
    
    