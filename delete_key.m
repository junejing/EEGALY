function delete_key(a,handles,ctshow)
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
                i_fp1 = IDex;
                Arou.j_fp1(1,currentpage+1)=Arou.j_fp1(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.Fp1(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fp1(i_fp1:10,:,currentpage+1)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.Fp1(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fp1(i_fp1:10,:,currentpage+1)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.Fp1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Fp1(currentpage+1,1:endpt)=0;
                    Arou.pos_Fp1(i_fp1:10,:,currentpage+1)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.Fp1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Fp1(currentpage+1,1:startpt)=0;
                    Arou.pos_Fp1(i_fp1:10,:,currentpage+1)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_Fp1(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_Fp1(IDex,2,currentpage-1)) %该线段属于上一页
                i_fp1 = IDex;
                Arou.j_fp1(1,currentpage-1)=Arou.j_fp1(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.Fp1(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fp1(i_fp1:10,:,currentpage-1)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.Fp1(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fp1(i_fp1:10,:,currentpage-1)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.Fp1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Fp1(currentpage,1:endpt)=0;
                    Arou.pos_Fp1(i_fp1:10,:,currentpage-1)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.Fp1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Fp1(currentpage,1:startpt)=0;
                    Arou.pos_Fp1(i_fp1:10,:,currentpage-1)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_Fp1(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Fp1(IDex,2,currentpage))%该线段属于当前页
                i_fp1 = IDex;
                Arou.j_fp1(1,currentpage)=Arou.j_fp1(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.Fp1(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fp1(i_fp1:10,:,currentpage)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.Fp1(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fp1(i_fp1:10,:,currentpage)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.Fp1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Fp1(currentpage+1,1:endpt)=0;
                    Arou.pos_Fp1(i_fp1:10,:,currentpage)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.Fp1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Fp1(currentpage+1,1:startpt)=0;
                    Arou.pos_Fp1(i_fp1:10,:,currentpage)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.Fp1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Fp1(currentpage,1:endpt)=0;
                    Arou.pos_Fp1(i_fp1:10,:,currentpage)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.Fp1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Fp1(currentpage,1:startpt)=0;
                    Arou.pos_Fp1(i_fp1:10,:,currentpage)=[Arou.pos_Fp1((i_fp1+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'Fp2'
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
                i_fp2 = IDex;
                Arou.j_fp2(1,currentpage+1)=Arou.j_fp2(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.Fp2(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fp2(i_fp2:10,:,currentpage+1)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.Fp2(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fp2(i_fp2:10,:,currentpage+1)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.Fp2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Fp2(currentpage+1,1:endpt)=0;
                    Arou.pos_Fp2(i_fp2:10,:,currentpage+1)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.Fp2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Fp2(currentpage+1,1:startpt)=0;
                    Arou.pos_Fp2(i_fp2:10,:,currentpage+1)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_Fp2(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_Fp2(IDex,2,currentpage-1)) %该线段属于上一页
                i_fp2 = IDex;
                Arou.j_fp2(1,currentpage-1)=Arou.j_fp2(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.Fp2(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fp2(i_fp2:10,:,currentpage-1)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.Fp2(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fp2(i_fp2:10,:,currentpage-1)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.Fp2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Fp2(currentpage,1:endpt)=0;
                    Arou.pos_Fp2(i_fp2:10,:,currentpage-1)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.Fp2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Fp2(currentpage,1:startpt)=0;
                    Arou.pos_Fp2(i_fp2:10,:,currentpage-1)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_Fp2(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Fp2(IDex,2,currentpage))%该线段属于当前页
                i_fp2 = IDex;
                Arou.j_fp2(1,currentpage)=Arou.j_fp2(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.Fp2(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fp2(i_fp2:10,:,currentpage)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.Fp2(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fp2(i_fp2:10,:,currentpage)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.Fp2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Fp2(currentpage+1,1:endpt)=0;
                    Arou.pos_Fp2(i_fp2:10,:,currentpage)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.Fp2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Fp2(currentpage+1,1:startpt)=0;
                    Arou.pos_Fp2(i_fp2:10,:,currentpage)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.Fp2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Fp2(currentpage,1:endpt)=0;
                    Arou.pos_Fp2(i_fp2:10,:,currentpage)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.Fp2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Fp2(currentpage,1:startpt)=0;
                    Arou.pos_Fp2(i_fp2:10,:,currentpage)=[Arou.pos_Fp2((i_fp2+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'F3'
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
                i_f3 = IDex;
                Arou.j_f3(1,currentpage+1)=Arou.j_f3(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.F3(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F3(i_f3:10,:,currentpage+1)=[Arou.pos_F3((i_f3+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.F3(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F3(i_f3:10,:,currentpage+1)=[Arou.pos_F3((i_f3+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.F3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F3(currentpage+1,1:endpt)=0;
                    Arou.pos_F3(i_f3:10,:,currentpage+1)=[Arou.pos_F3((i_f3+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.F3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F3(currentpage+1,1:startpt)=0;
                    Arou.pos_F3(i_f3:10,:,currentpage+1)=[Arou.pos_F3((i_f3+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_F3(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_F3(IDex,2,currentpage-1)) %该线段属于上一页
                i_f3 = IDex;
                Arou.j_f3(1,currentpage-1)=Arou.j_f3(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.F3(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F3(i_f3:10,:,currentpage-1)=[Arou.pos_F3((i_f3+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.F3(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F3(i_f3:10,:,currentpage-1)=[Arou.pos_F3((i_f3+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.F3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F3(currentpage,1:endpt)=0;
                    Arou.pos_F3(i_f3:10,:,currentpage-1)=[Arou.pos_F3((i_f3+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.F3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F3(currentpage,1:startpt)=0;
                    Arou.pos_F3(i_f3:10,:,currentpage-1)=[Arou.pos_F3((i_f3+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_F3(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_F3(IDex,2,currentpage))%该线段属于当前页
                i_f3 = IDex;
                Arou.j_f3(1,currentpage)=Arou.j_f3(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.F3(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F3(i_f3:10,:,currentpage)=[Arou.pos_F3((i_f3+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.F3(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F3(i_f3:10,:,currentpage)=[Arou.pos_F3((i_f3+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.F3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F3(currentpage+1,1:endpt)=0;
                    Arou.pos_F3(i_f3:10,:,currentpage)=[Arou.pos_F3((i_f3+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.F3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F3(currentpage+1,1:startpt)=0;
                    Arou.pos_F3(i_f3:10,:,currentpage)=[Arou.pos_F3((i_f3+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.F3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F3(currentpage,1:endpt)=0;
                    Arou.pos_F3(i_f3:10,:,currentpage)=[Arou.pos_F3((i_f3+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.F3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F3(currentpage,1:startpt)=0;
                    Arou.pos_F3(i_f3:10,:,currentpage)=[Arou.pos_F3((i_f3+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'F4'
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
                i_f4 = IDex;
                Arou.j_f4(1,currentpage+1)=Arou.j_f4(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.F4(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F4(i_f4:10,:,currentpage+1)=[Arou.pos_F4((i_f4+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.F4(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F4(i_f4:10,:,currentpage+1)=[Arou.pos_F4((i_f4+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.F4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F4(currentpage+1,1:endpt)=0;
                    Arou.pos_F4(i_f4:10,:,currentpage+1)=[Arou.pos_F4((i_f4+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.F4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F4(currentpage+1,1:startpt)=0;
                    Arou.pos_F4(i_f4:10,:,currentpage+1)=[Arou.pos_F4((i_f4+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_F4(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_F4(IDex,2,currentpage-1)) %该线段属于上一页
                i_f4 = IDex;
                Arou.j_f4(1,currentpage-1)=Arou.j_f4(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.F4(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F4(i_f4:10,:,currentpage-1)=[Arou.pos_F4((i_f4+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.F4(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F4(i_f4:10,:,currentpage-1)=[Arou.pos_F4((i_f4+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.F4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F4(currentpage,1:endpt)=0;
                    Arou.pos_F4(i_f4:10,:,currentpage-1)=[Arou.pos_F4((i_f4+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.F4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F4(currentpage,1:startpt)=0;
                    Arou.pos_F4(i_f4:10,:,currentpage-1)=[Arou.pos_F4((i_f4+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_F4(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_F4(IDex,2,currentpage))%该线段属于当前页
                i_f4 = IDex;
                Arou.j_f4(1,currentpage)=Arou.j_f4(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.F4(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F4(i_f4:10,:,currentpage)=[Arou.pos_F4((i_f4+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.F4(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F4(i_f4:10,:,currentpage)=[Arou.pos_F4((i_f4+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.F4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F4(currentpage+1,1:endpt)=0;
                    Arou.pos_F4(i_f4:10,:,currentpage)=[Arou.pos_F4((i_f4+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.F4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F4(currentpage+1,1:startpt)=0;
                    Arou.pos_F4(i_f4:10,:,currentpage)=[Arou.pos_F4((i_f4+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.F4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F4(currentpage,1:endpt)=0;
                    Arou.pos_F4(i_f4:10,:,currentpage)=[Arou.pos_F4((i_f4+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.F4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F4(currentpage,1:startpt)=0;
                    Arou.pos_F4(i_f4:10,:,currentpage)=[Arou.pos_F4((i_f4+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'C3'
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
                i_c3 = IDex;
                Arou.j_c3(1,currentpage+1)=Arou.j_c3(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.C3(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_C3(i_c3:10,:,currentpage+1)=[Arou.pos_C3((i_c3+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.C3(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_C3(i_c3:10,:,currentpage+1)=[Arou.pos_C3((i_c3+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.C3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.C3(currentpage+1,1:endpt)=0;
                    Arou.pos_C3(i_c3:10,:,currentpage+1)=[Arou.pos_C3((i_c3+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.C3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.C3(currentpage+1,1:startpt)=0;
                    Arou.pos_C3(i_c3:10,:,currentpage+1)=[Arou.pos_C3((i_c3+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_C3(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_C3(IDex,2,currentpage-1)) %该线段属于上一页
                i_c3 = IDex;
                Arou.j_c3(1,currentpage-1)=Arou.j_c3(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.C3(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_C3(i_c3:10,:,currentpage-1)=[Arou.pos_C3((i_c3+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.C3(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_C3(i_c3:10,:,currentpage-1)=[Arou.pos_C3((i_c3+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.C3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.C3(currentpage,1:endpt)=0;
                    Arou.pos_C3(i_c3:10,:,currentpage-1)=[Arou.pos_C3((i_c3+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.C3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.C3(currentpage,1:startpt)=0;
                    Arou.pos_C3(i_c3:10,:,currentpage-1)=[Arou.pos_C3((i_c3+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_C3(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_C3(IDex,2,currentpage))%该线段属于当前页
                i_c3 = IDex;
                Arou.j_c3(1,currentpage)=Arou.j_c3(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.C3(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_C3(i_c3:10,:,currentpage)=[Arou.pos_C3((i_c3+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.C3(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_C3(i_c3:10,:,currentpage)=[Arou.pos_C3((i_c3+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.C3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.C3(currentpage+1,1:endpt)=0;
                    Arou.pos_C3(i_c3:10,:,currentpage)=[Arou.pos_C3((i_c3+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.C3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.C3(currentpage+1,1:startpt)=0;
                    Arou.pos_C3(i_c3:10,:,currentpage)=[Arou.pos_C3((i_c3+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.C3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.C3(currentpage,1:endpt)=0;
                    Arou.pos_C3(i_c3:10,:,currentpage)=[Arou.pos_C3((i_c3+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.C3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.C3(currentpage,1:startpt)=0;
                    Arou.pos_C3(i_c3:10,:,currentpage)=[Arou.pos_C3((i_c3+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'C4'
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
                i_c4 = IDex;
                Arou.j_c4(1,currentpage+1)=Arou.j_c4(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.C4(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_C4(i_c4:10,:,currentpage+1)=[Arou.pos_C4((i_c4+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.C4(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_C4(i_c4:10,:,currentpage+1)=[Arou.pos_C4((i_c4+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.C4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.C4(currentpage+1,1:endpt)=0;
                    Arou.pos_C4(i_c4:10,:,currentpage+1)=[Arou.pos_C4((i_c4+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.C4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.C4(currentpage+1,1:startpt)=0;
                    Arou.pos_C4(i_c4:10,:,currentpage+1)=[Arou.pos_C4((i_c4+1):10,:,currentpage+1);zeros(1,4,1)];
                    
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_C4(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_C4(IDex,2,currentpage-1)) %该线段属于上一页
                i_c4 = IDex;
                Arou.j_c4(1,currentpage-1)=Arou.j_c4(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.C4(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_C4(i_c4:10,:,currentpage-1)=[Arou.pos_C4((i_c4+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.C4(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_C4(i_c4:10,:,currentpage-1)=[Arou.pos_C4((i_c4+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.C4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.C4(currentpage,1:endpt)=0;
                    Arou.pos_C4(i_c4:10,:,currentpage-1)=[Arou.pos_C4((i_c4+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.C4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.C4(currentpage,1:startpt)=0;
                    Arou.pos_C4(i_c4:10,:,currentpage-1)=[Arou.pos_C4((i_c4+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_C4(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_C4(IDex,2,currentpage))%该线段属于当前页
                i_c4 = IDex;
                Arou.j_c4(1,currentpage)=Arou.j_c4(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.C4(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_C4(i_c4:10,:,currentpage)=[Arou.pos_C4((i_c4+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.C4(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_C4(i_c4:10,:,currentpage)=[Arou.pos_C4((i_c4+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.C4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.C4(currentpage+1,1:endpt)=0;
                    Arou.pos_C4(i_c4:10,:,currentpage)=[Arou.pos_C4((i_c4+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.C4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.C4(currentpage+1,1:startpt)=0;
                    Arou.pos_C4(i_c4:10,:,currentpage)=[Arou.pos_C4((i_c4+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.C4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.C4(currentpage,1:endpt)=0;
                    Arou.pos_C4(i_c4:10,:,currentpage)=[Arou.pos_C4((i_c4+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.C4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.C4(currentpage,1:startpt)=0;
                    Arou.pos_C4(i_c4:10,:,currentpage)=[Arou.pos_C4((i_c4+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'P3'
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
                i_p3 = IDex;
                Arou.j_p3(1,currentpage+1)=Arou.j_p3(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.P3(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_P3(i_p3:10,:,currentpage+1)=[Arou.pos_P3((i_p3+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.P3(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_P3(i_p3:10,:,currentpage+1)=[Arou.pos_P3((i_p3+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.P3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.P3(currentpage+1,1:endpt)=0;
                    Arou.pos_P3(i_p3:10,:,currentpage+1)=[Arou.pos_P3((i_p3+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.P3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.P3(currentpage+1,1:startpt)=0;
                    Arou.pos_P3(i_p3:10,:,currentpage+1)=[Arou.pos_P3((i_p3+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_P3(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_P3(IDex,2,currentpage-1)) %该线段属于上一页
                i_p3 = IDex;
                Arou.j_p3(1,currentpage-1)=Arou.j_p3(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.P3(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_P3(i_p3:10,:,currentpage-1)=[Arou.pos_P3((i_p3+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.P3(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_P3(i_p3:10,:,currentpage-1)=[Arou.pos_P3((i_p3+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.P3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.P3(currentpage,1:endpt)=0;
                    Arou.pos_P3(i_p3:10,:,currentpage-1)=[Arou.pos_P3((i_p3+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.P3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.P3(currentpage,1:startpt)=0;
                    Arou.pos_P3(i_p3:10,:,currentpage-1)=[Arou.pos_P3((i_p3+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_P3(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_P3(IDex,2,currentpage))%该线段属于当前页
                i_p3 = IDex;
                Arou.j_P3(1,currentpage)=Arou.j_P3(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.P3(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_P3(i_p3:10,:,currentpage)=[Arou.pos_P3((i_p3+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.P3(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_P3(i_p3:10,:,currentpage)=[Arou.pos_P3((i_p3+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.P3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.P3(currentpage+1,1:endpt)=0;
                    Arou.pos_P3(i_p3:10,:,currentpage)=[Arou.pos_P3((i_p3+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.P3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.P3(currentpage+1,1:startpt)=0;
                    Arou.pos_P3(i_p3:10,:,currentpage)=[Arou.pos_P3((i_p3+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.P3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.P3(currentpage,1:endpt)=0;
                    Arou.pos_P3(i_p3:10,:,currentpage)=[Arou.pos_P3((i_p3+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.P3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.P3(currentpage,1:startpt)=0;
                    Arou.pos_P3(i_p3:10,:,currentpage)=[Arou.pos_P3((i_p3+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'P4'
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
                i_p4 = IDex;
                Arou.j_p4(1,currentpage+1)=Arou.j_p4(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.P4(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_P4(i_p4:10,:,currentpage+1)=[Arou.pos_P4((i_p4+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.P4(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_P4(i_p4:10,:,currentpage+1)=[Arou.pos_P4((i_p4+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.P4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.P4(currentpage+1,1:endpt)=0;
                    Arou.pos_P4(i_p4:10,:,currentpage+1)=[Arou.pos_P4((i_p4+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.P4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.P4(currentpage+1,1:startpt)=0;
                    Arou.pos_P4(i_p4:10,:,currentpage+1)=[Arou.pos_P4((i_p4+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_P4(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_P4(IDex,2,currentpage-1)) %该线段属于上一页
                i_p4 = IDex;
                Arou.j_p4(1,currentpage-1)=Arou.j_p4(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.P4(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_P4(i_p4:10,:,currentpage-1)=[Arou.pos_P4((i_p4+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.P4(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_P4(i_p4:10,:,currentpage-1)=[Arou.pos_P4((i_p4+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.P4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.P4(currentpage,1:endpt)=0;
                    Arou.pos_P4(i_p4:10,:,currentpage-1)=[Arou.pos_P4((i_p4+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.P4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.P4(currentpage,1:startpt)=0;
                    Arou.pos_P4(i_p4:10,:,currentpage-1)=[Arou.pos_P4((i_p4+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_P4(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_P4(IDex,2,currentpage))%该线段属于当前页
                i_p4 = IDex;
                Arou.j_P4(1,currentpage)=Arou.j_P4(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.P4(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_P4(i_p4:10,:,currentpage)=[Arou.pos_P4((i_p4+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.P4(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_P4(i_p4:10,:,currentpage)=[Arou.pos_P4((i_p4+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.P4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.P4(currentpage+1,1:endpt)=0;
                    Arou.pos_P4(i_p4:10,:,currentpage)=[Arou.pos_P4((i_p4+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.P4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.P4(currentpage+1,1:startpt)=0;
                    Arou.pos_P4(i_p4:10,:,currentpage)=[Arou.pos_P4((i_p4+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.P4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.P4(currentpage,1:endpt)=0;
                    Arou.pos_P4(i_p4:10,:,currentpage)=[Arou.pos_P4((i_p4+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.P4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.P4(currentpage,1:startpt)=0;
                    Arou.pos_P4(i_p4:10,:,currentpage)=[Arou.pos_P4((i_p4+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'O1'
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
                i_o1 = IDex;
                Arou.j_o1(1,currentpage+1)=Arou.j_o1(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.O1(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_O1(i_o1:10,:,currentpage+1)=[Arou.pos_O1((i_o1+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.O1(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_O1(i_o1:10,:,currentpage+1)=[Arou.pos_O1((i_o1+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.O1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.O1(currentpage+1,1:endpt)=0;
                    Arou.pos_O1(i_o1:10,:,currentpage+1)=[Arou.pos_O1((i_o1+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.O1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.O1(currentpage+1,1:startpt)=0;
                    Arou.pos_O1(i_o1:10,:,currentpage+1)=[Arou.pos_O1((i_o1+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_O1(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_O1(IDex,2,currentpage-1)) %该线段属于上一页
                i_o1 = IDex;
                Arou.j_o1(1,currentpage-1)=Arou.j_o1(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.O1(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_O1(i_o1:10,:,currentpage-1)=[Arou.pos_O1((i_o1+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.O1(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_O1(i_o1:10,:,currentpage-1)=[Arou.pos_O1((i_o1+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.O1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.O1(currentpage,1:endpt)=0;
                    Arou.pos_O1(i_o1:10,:,currentpage-1)=[Arou.pos_O1((i_o1+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.O1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.O1(currentpage,1:startpt)=0;
                    Arou.pos_O1(i_o1:10,:,currentpage-1)=[Arou.pos_O1((i_o1+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_O1(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_O1(IDex,2,currentpage))%该线段属于当前页
                i_o1 = IDex;
                Arou.j_o1(1,currentpage)=Arou.j_o1(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.O1(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_O1(i_o1:10,:,currentpage)=[Arou.pos_O1((i_o1+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.O1(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_O1(i_o1:10,:,currentpage)=[Arou.pos_O1((i_o1+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.O1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.O1(currentpage+1,1:endpt)=0;
                    Arou.pos_O1(i_o1:10,:,currentpage)=[Arou.pos_O1((i_o1+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.O1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.O1(currentpage+1,1:startpt)=0;
                    Arou.pos_O1(i_o1:10,:,currentpage)=[Arou.pos_O1((i_o1+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.O1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.O1(currentpage,1:endpt)=0;
                    Arou.pos_O1(i_o1:10,:,currentpage)=[Arou.pos_O1((i_o1+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.O1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.O1(currentpage,1:startpt)=0;
                    Arou.pos_O1(i_o1:10,:,currentpage)=[Arou.pos_O1((i_o1+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'O2'
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
                i_o2 = IDex;
                Arou.j_o2(1,currentpage+1)=Arou.j_o2(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.O2(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_O2(i_o2:10,:,currentpage+1)=[Arou.pos_O2((i_o2+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.O2(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_O2(i_o2:10,:,currentpage+1)=[Arou.pos_O2((i_o2+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.O2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.O2(currentpage+1,1:endpt)=0;
                    Arou.pos_O2(i_o2:10,:,currentpage+1)=[Arou.pos_O2((i_o2+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.O2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.O2(currentpage+1,1:startpt)=0;
                    Arou.pos_O2(i_o2:10,:,currentpage+1)=[Arou.pos_O2((i_o2+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_O2(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_O2(IDex,2,currentpage-1)) %该线段属于上一页
                i_o2 = IDex;
                Arou.j_o2(1,currentpage-1)=Arou.j_o2(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.O2(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_O2(i_o2:10,:,currentpage-1)=[Arou.pos_O2((i_o2+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.O2(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_O2(i_o2:10,:,currentpage-1)=[Arou.pos_O2((i_o2+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.O2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.O2(currentpage,1:endpt)=0;
                    Arou.pos_O2(i_o2:10,:,currentpage-1)=[Arou.pos_O2((i_o2+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.O2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.O2(currentpage,1:startpt)=0;
                    Arou.pos_O2(i_o2:10,:,currentpage-1)=[Arou.pos_O2((i_o2+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_O2(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_O2(IDex,2,currentpage))%该线段属于当前页
                i_o2 = IDex;
                Arou.j_o2(1,currentpage)=Arou.j_o2(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.O2(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_O2(i_o2:10,:,currentpage)=[Arou.pos_O2((i_o2+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.O2(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_O2(i_o2:10,:,currentpage)=[Arou.pos_O2((i_o2+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.O2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.O2(currentpage+1,1:endpt)=0;
                    Arou.pos_O2(i_o2:10,:,currentpage)=[Arou.pos_O2((i_o2+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.O2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.O2(currentpage+1,1:startpt)=0;
                    Arou.pos_O2(i_o2:10,:,currentpage)=[Arou.pos_O2((i_o2+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.O2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.O2(currentpage,1:endpt)=0;
                    Arou.pos_O2(i_o2:10,:,currentpage)=[Arou.pos_O2((i_o2+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.O2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.O2(currentpage,1:startpt)=0;
                    Arou.pos_O2(i_o2:10,:,currentpage)=[Arou.pos_O2((i_o2+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'F7'
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
                i_f7 = IDex;
                Arou.j_f7(1,currentpage+1)=Arou.j_f7(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.F7(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F7(i_f7:10,:,currentpage+1)=[Arou.pos_F7((i_f7+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.F7(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F7(i_f7:10,:,currentpage+1)=[Arou.pos_F7((i_f7+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.F7(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F7(currentpage+1,1:endpt)=0;
                    Arou.pos_F7(i_f7:10,:,currentpage+1)=[Arou.pos_F7((i_f7+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.F7(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F7(currentpage+1,1:startpt)=0;
                    Arou.pos_F7(i_f7:10,:,currentpage+1)=[Arou.pos_F7((i_f7+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_F7(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_F7(IDex,2,currentpage-1)) %该线段属于上一页
                i_f7 = IDex;
                Arou.j_f7(1,currentpage-1)=Arou.j_f7(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.F7(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F7(i_f7:10,:,currentpage-1)=[Arou.pos_F7((i_f7+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.F7(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F7(i_f7:10,:,currentpage-1)=[Arou.pos_F7((i_f7+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.F7(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F7(currentpage,1:endpt)=0;
                    Arou.pos_F7(i_f7:10,:,currentpage-1)=[Arou.pos_F7((i_f7+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.F7(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F7(currentpage,1:startpt)=0;
                    Arou.pos_F7(i_f7:10,:,currentpage-1)=[Arou.pos_F7((i_f7+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_F7(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_F7(IDex,2,currentpage))%该线段属于当前页
                i_f7 = IDex;
                Arou.j_f7(1,currentpage)=Arou.j_f7(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.F7(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F7(i_f7:10,:,currentpage)=[Arou.pos_F7((i_f7+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.F7(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F7(i_f7:10,:,currentpage)=[Arou.pos_F7((i_f7+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.F7(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F7(currentpage+1,1:endpt)=0;
                    Arou.pos_F7(i_f7:10,:,currentpage)=[Arou.pos_F7((i_f7+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.F7(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F7(currentpage+1,1:startpt)=0;
                    Arou.pos_F7(i_f7:10,:,currentpage)=[Arou.pos_F7((i_f7+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.F7(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F7(currentpage,1:endpt)=0;
                    Arou.pos_F7(i_f7:10,:,currentpage)=[Arou.pos_F7((i_f7+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.F7(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F7(currentpage,1:startpt)=0;
                    Arou.pos_F7(i_f7:10,:,currentpage)=[Arou.pos_F7((i_f7+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'F8'
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
                i_f8 = IDex;
                Arou.j_f8(1,currentpage+1)=Arou.j_f8(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.F8(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F8(i_f8:10,:,currentpage+1)=[Arou.pos_F8((i_f8+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.F8(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F8(i_f8:10,:,currentpage+1)=[Arou.pos_F8((i_f8+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.F8(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F8(currentpage+1,1:endpt)=0;
                    Arou.pos_F8(i_f8:10,:,currentpage+1)=[Arou.pos_F8((i_f8+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.F8(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F8(currentpage+1,1:startpt)=0;
                    Arou.pos_F8(i_f8:10,:,currentpage+1)=[Arou.pos_F8((i_f8+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_F8(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_F8(IDex,2,currentpage-1)) %该线段属于上一页
                i_f8 = IDex;
                Arou.j_f8(1,currentpage-1)=Arou.j_f8(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.F8(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F8(i_f8:10,:,currentpage-1)=[Arou.pos_F8((i_f8+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.F8(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F8(i_f8:10,:,currentpage-1)=[Arou.pos_F8((i_f8+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.F8(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F8(currentpage,1:endpt)=0;
                    Arou.pos_F8(i_f8:10,:,currentpage-1)=[Arou.pos_F8((i_f8+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.F8(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.F8(currentpage,1:startpt)=0;
                    Arou.pos_F8(i_f8:10,:,currentpage-1)=[Arou.pos_F8((i_f8+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_F8(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_F8(IDex,2,currentpage))%该线段属于当前页
                i_f8 = IDex;
                Arou.j_f8(1,currentpage)=Arou.j_f8(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.F8(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F8(i_f8:10,:,currentpage)=[Arou.pos_F8((i_f8+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.F8(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_F8(i_f8:10,:,currentpage)=[Arou.pos_F8((i_f8+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.F8(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F8(currentpage+1,1:endpt)=0;
                    Arou.pos_F8(i_f8:10,:,currentpage)=[Arou.pos_F8((i_f8+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.F8(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F8(currentpage+1,1:startpt)=0;
                    Arou.pos_F8(i_f8:10,:,currentpage)=[Arou.pos_F8((i_f8+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.F8(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F8(currentpage,1:endpt)=0;
                    Arou.pos_F8(i_f8:10,:,currentpage)=[Arou.pos_F8((i_f8+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.F8(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.F8(currentpage,1:startpt)=0;
                    Arou.pos_F8(i_f8:10,:,currentpage)=[Arou.pos_F8((i_f8+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'Fz'
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
                i_Fz = IDex;
                Arou.j_Fz(1,currentpage+1)=Arou.j_Fz(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.Fz(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fz(i_Fz:10,:,currentpage+1)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.Fz(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fz(i_Fz:10,:,currentpage+1)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.Fz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Fz(currentpage+1,1:endpt)=0;
                    Arou.pos_Fz(i_Fz:10,:,currentpage+1)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.Fz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Fz(currentpage+1,1:startpt)=0;
                    Arou.pos_Fz(i_Fz:10,:,currentpage+1)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_Fz(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_Fz(IDex,2,currentpage-1)) %该线段属于上一页
                i_Fz = IDex;
                Arou.j_Fz(1,currentpage-1)=Arou.j_Fz(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.Fz(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fz(i_Fz:10,:,currentpage-1)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.Fz(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fz(i_Fz:10,:,currentpage-1)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.Fz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Fz(currentpage,1:endpt)=0;
                    Arou.pos_Fz(i_Fz:10,:,currentpage-1)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.Fz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Fz(currentpage,1:startpt)=0;
                    Arou.pos_Fz(i_Fz:10,:,currentpage-1)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_Fz(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Fz(IDex,2,currentpage))%该线段属于当前页
                i_Fz = IDex;
                Arou.j_Fz(1,currentpage)=Arou.j_Fz(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.Fz(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fz(i_Fz:10,:,currentpage)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.Fz(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Fz(i_Fz:10,:,currentpage)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.Fz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Fz(currentpage+1,1:endpt)=0;
                    Arou.pos_Fz(i_Fz:10,:,currentpage)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.Fz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Fz(currentpage+1,1:startpt)=0;
                    Arou.pos_Fz(i_Fz:10,:,currentpage)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.Fz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Fz(currentpage,1:endpt)=0;
                    Arou.pos_Fz(i_Fz:10,:,currentpage)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.Fz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Fz(currentpage,1:startpt)=0;
                    Arou.pos_Fz(i_Fz:10,:,currentpage)=[Arou.pos_Fz((i_Fz+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'Cz'
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
                i_Cz = IDex;
                Arou.j_Cz(1,currentpage+1)=Arou.j_Cz(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.Cz(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Cz(i_Cz:10,:,currentpage+1)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.Cz(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Cz(i_Cz:10,:,currentpage+1)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.Cz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Cz(currentpage+1,1:endpt)=0;
                    Arou.pos_Cz(i_Cz:10,:,currentpage+1)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.Cz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Cz(currentpage+1,1:startpt)=0;
                    Arou.pos_Cz(i_Cz:10,:,currentpage+1)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_Cz(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_Cz(IDex,2,currentpage-1)) %该线段属于上一页
                i_Cz = IDex;
                Arou.j_Cz(1,currentpage-1)=Arou.j_Cz(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.Cz(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Cz(i_Cz:10,:,currentpage-1)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.Cz(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Cz(i_Cz:10,:,currentpage-1)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.Cz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Cz(currentpage,1:endpt)=0;
                    Arou.pos_Cz(i_Cz:10,:,currentpage-1)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.Cz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Cz(currentpage,1:startpt)=0;
                    Arou.pos_Cz(i_Cz:10,:,currentpage-1)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_Cz(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Cz(IDex,2,currentpage))%该线段属于当前页
                i_Cz = IDex;
                Arou.j_Cz(1,currentpage)=Arou.j_Cz(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.Cz(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Cz(i_Cz:10,:,currentpage)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.Cz(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Cz(i_Cz:10,:,currentpage)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.Cz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Cz(currentpage+1,1:endpt)=0;
                    Arou.pos_Cz(i_Cz:10,:,currentpage)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.Cz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Cz(currentpage+1,1:startpt)=0;
                    Arou.pos_Cz(i_Cz:10,:,currentpage)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.Cz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Cz(currentpage,1:endpt)=0;
                    Arou.pos_Cz(i_Cz:10,:,currentpage)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.Cz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Cz(currentpage,1:startpt)=0;
                    Arou.pos_Cz(i_Cz:10,:,currentpage)=[Arou.pos_Cz((i_Cz+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'Pz'
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
                i_Pz = IDex;
                Arou.j_Pz(1,currentpage+1)=Arou.j_Pz(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.Pz(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Pz(i_Pz:10,:,currentpage+1)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.Pz(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Pz(i_Pz:10,:,currentpage+1)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.Pz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Pz(currentpage+1,1:endpt)=0;
                    Arou.pos_Pz(i_Pz:10,:,currentpage+1)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.Pz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Pz(currentpage+1,1:startpt)=0;
                    Arou.pos_Pz(i_Pz:10,:,currentpage+1)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_Pz(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_Pz(IDex,2,currentpage-1)) %该线段属于上一页
                i_Pz = IDex;
                Arou.j_Pz(1,currentpage-1)=Arou.j_Pz(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.Pz(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Pz(i_Pz:10,:,currentpage-1)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.Pz(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Pz(i_Pz:10,:,currentpage-1)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.Pz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Pz(currentpage,1:endpt)=0;
                    Arou.pos_Pz(i_Pz:10,:,currentpage-1)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.Pz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.Pz(currentpage,1:startpt)=0;
                    Arou.pos_Pz(i_Pz:10,:,currentpage-1)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_Pz(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Pz(IDex,2,currentpage))%该线段属于当前页
                i_Pz = IDex;
                Arou.j_Pz(1,currentpage)=Arou.j_Pz(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.Pz(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Pz(i_Pz:10,:,currentpage)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.Pz(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_Pz(i_Pz:10,:,currentpage)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.Pz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Pz(currentpage+1,1:endpt)=0;
                    Arou.pos_Pz(i_Pz:10,:,currentpage)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.Pz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Pz(currentpage+1,1:startpt)=0;
                    Arou.pos_Pz(i_Pz:10,:,currentpage)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.Pz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Pz(currentpage,1:endpt)=0;
                    Arou.pos_Pz(i_Pz:10,:,currentpage)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.Pz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.Pz(currentpage,1:startpt)=0;
                    Arou.pos_Pz(i_Pz:10,:,currentpage)=[Arou.pos_Pz((i_Pz+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'A1'
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
                i_A1 = IDex;
                Arou.j_A1(1,currentpage+1)=Arou.j_A1(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.A1(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_A1(i_A1:10,:,currentpage+1)=[Arou.pos_A1((i_A1+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.A1(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_A1(i_A1:10,:,currentpage+1)=[Arou.pos_A1((i_A1+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.A1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.A1(currentpage+1,1:endpt)=0;
                    Arou.pos_A1(i_A1:10,:,currentpage+1)=[Arou.pos_A1((i_A1+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.A1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.A1(currentpage+1,1:startpt)=0;
                    Arou.pos_A1(i_A1:10,:,currentpage+1)=[Arou.pos_A1((i_A1+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_A1(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_A1(IDex,2,currentpage-1)) %该线段属于上一页
                i_A1 = IDex;
                Arou.j_A1(1,currentpage-1)=Arou.j_A1(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.A1(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_A1(i_A1:10,:,currentpage-1)=[Arou.pos_A1((i_A1+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.A1(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_A1(i_A1:10,:,currentpage-1)=[Arou.pos_A1((i_A1+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.A1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.A1(currentpage,1:endpt)=0;
                    Arou.pos_A1(i_A1:10,:,currentpage-1)=[Arou.pos_A1((i_A1+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.A1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.A1(currentpage,1:startpt)=0;
                    Arou.pos_A1(i_A1:10,:,currentpage-1)=[Arou.pos_A1((i_A1+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_A1(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_A1(IDex,2,currentpage))%该线段属于当前页
                i_A1 = IDex;
                Arou.j_A1(1,currentpage)=Arou.j_A1(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.A1(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_A1(i_A1:10,:,currentpage)=[Arou.pos_A1((i_A1+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.A1(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_A1(i_A1:10,:,currentpage)=[Arou.pos_A1((i_A1+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.A1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.A1(currentpage+1,1:endpt)=0;
                    Arou.pos_A1(i_A1:10,:,currentpage)=[Arou.pos_A1((i_A1+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.A1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.A1(currentpage+1,1:startpt)=0;
                    Arou.pos_A1(i_A1:10,:,currentpage)=[Arou.pos_A1((i_A1+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.A1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.A1(currentpage,1:endpt)=0;
                    Arou.pos_A1(i_A1:10,:,currentpage)=[Arou.pos_A1((i_A1+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.A1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.A1(currentpage,1:startpt)=0;
                    Arou.pos_A1(i_A1:10,:,currentpage)=[Arou.pos_A1((i_A1+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'A2'
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
                i_A2 = IDex;
                Arou.j_A2(1,currentpage+1)=Arou.j_A2(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.A2(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_A2(i_A2:10,:,currentpage+1)=[Arou.pos_A2((i_A2+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.A2(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_A2(i_A2:10,:,currentpage+1)=[Arou.pos_A2((i_A2+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.A2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.A2(currentpage+1,1:endpt)=0;
                    Arou.pos_A2(i_A2:10,:,currentpage+1)=[Arou.pos_A2((i_A2+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.A2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.A2(currentpage+1,1:startpt)=0;
                    Arou.pos_A2(i_A2:10,:,currentpage+1)=[Arou.pos_A2((i_A2+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_A2(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_A2(IDex,2,currentpage-1)) %该线段属于上一页
                i_A2 = IDex;
                Arou.j_A2(1,currentpage-1)=Arou.j_A2(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.A2(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_A2(i_A2:10,:,currentpage-1)=[Arou.pos_A2((i_A2+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.A2(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_A2(i_A2:10,:,currentpage-1)=[Arou.pos_A2((i_A2+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.A2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.A2(currentpage,1:endpt)=0;
                    Arou.pos_A2(i_A2:10,:,currentpage-1)=[Arou.pos_A2((i_A2+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.A2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.A2(currentpage,1:startpt)=0;
                    Arou.pos_A2(i_A2:10,:,currentpage-1)=[Arou.pos_A2((i_A2+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_A2(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_A2(IDex,2,currentpage))%该线段属于当前页
                i_A2 = IDex;
                Arou.j_A2(1,currentpage)=Arou.j_A2(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.A2(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_A2(i_A2:10,:,currentpage)=[Arou.pos_A2((i_A2+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.A2(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_A2(i_A2:10,:,currentpage)=[Arou.pos_A2((i_A2+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.A2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.A2(currentpage+1,1:endpt)=0;
                    Arou.pos_A2(i_A2:10,:,currentpage)=[Arou.pos_A2((i_A2+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.A2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.A2(currentpage+1,1:startpt)=0;
                    Arou.pos_A2(i_A2:10,:,currentpage)=[Arou.pos_A2((i_A2+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.A2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.A2(currentpage,1:endpt)=0;
                    Arou.pos_A2(i_A2:10,:,currentpage)=[Arou.pos_A2((i_A2+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.A2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.A2(currentpage,1:startpt)=0;
                    Arou.pos_A2(i_A2:10,:,currentpage)=[Arou.pos_A2((i_A2+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'T3'
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
                i_T3 = IDex;
                Arou.j_T3(1,currentpage+1)=Arou.j_T3(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.T3(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T3(i_T3:10,:,currentpage+1)=[Arou.pos_T3((i_T3+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.T3(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T3(i_T3:10,:,currentpage+1)=[Arou.pos_T3((i_T3+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.T3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T3(currentpage+1,1:endpt)=0;
                    Arou.pos_T3(i_T3:10,:,currentpage+1)=[Arou.pos_T3((i_T3+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.T3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T3(currentpage+1,1:startpt)=0;
                    Arou.pos_T3(i_T3:10,:,currentpage+1)=[Arou.pos_T3((i_T3+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_T3(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_T3(IDex,2,currentpage-1)) %该线段属于上一页
                i_T3 = IDex;
                Arou.j_T3(1,currentpage-1)=Arou.j_T3(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.T3(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T3(i_T3:10,:,currentpage-1)=[Arou.pos_T3((i_T3+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.T3(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T3(i_T3:10,:,currentpage-1)=[Arou.pos_T3((i_T3+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.T3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T3(currentpage,1:endpt)=0;
                    Arou.pos_T3(i_T3:10,:,currentpage-1)=[Arou.pos_T3((i_T3+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.T3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T3(currentpage,1:startpt)=0;
                    Arou.pos_T3(i_T3:10,:,currentpage-1)=[Arou.pos_T3((i_T3+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_T3(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_T3(IDex,2,currentpage))%该线段属于当前页
                i_T3 = IDex;
                Arou.j_T3(1,currentpage)=Arou.j_T3(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.T3(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T3(i_T3:10,:,currentpage)=[Arou.pos_T3((i_T3+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.T3(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T3(i_T3:10,:,currentpage)=[Arou.pos_T3((i_T3+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.T3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T3(currentpage+1,1:endpt)=0;
                    Arou.pos_T3(i_T3:10,:,currentpage)=[Arou.pos_T3((i_T3+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.T3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T3(currentpage+1,1:startpt)=0;
                    Arou.pos_T3(i_T3:10,:,currentpage)=[Arou.pos_T3((i_T3+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.T3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T3(currentpage,1:endpt)=0;
                    Arou.pos_T3(i_T3:10,:,currentpage)=[Arou.pos_T3((i_T3+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.T3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T3(currentpage,1:startpt)=0;
                    Arou.pos_T3(i_T3:10,:,currentpage)=[Arou.pos_T3((i_T3+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'T4'
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
                i_T4 = IDex;
                Arou.j_T4(1,currentpage+1)=Arou.j_T4(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.T4(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T4(i_T4:10,:,currentpage+1)=[Arou.pos_T4((i_T4+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.T4(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T4(i_T4:10,:,currentpage+1)=[Arou.pos_T4((i_T4+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.T4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T4(currentpage+1,1:endpt)=0;
                    Arou.pos_T4(i_T4:10,:,currentpage+1)=[Arou.pos_T4((i_T4+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.T4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T4(currentpage+1,1:startpt)=0;
                    Arou.pos_T4(i_T4:10,:,currentpage+1)=[Arou.pos_T4((i_T4+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_T4(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_T4(IDex,2,currentpage-1)) %该线段属于上一页
                i_T4 = IDex;
                Arou.j_T4(1,currentpage-1)=Arou.j_T4(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.T4(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T4(i_T4:10,:,currentpage-1)=[Arou.pos_T4((i_T4+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.T4(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T4(i_T4:10,:,currentpage-1)=[Arou.pos_T4((i_T4+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.T4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T4(currentpage,1:endpt)=0;
                    Arou.pos_T4(i_T4:10,:,currentpage-1)=[Arou.pos_T4((i_T4+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.T4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T4(currentpage,1:startpt)=0;
                    Arou.pos_T4(i_T4:10,:,currentpage-1)=[Arou.pos_T4((i_T4+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_T4(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_T4(IDex,2,currentpage))%该线段属于当前页
                i_T4 = IDex;
                Arou.j_T4(1,currentpage)=Arou.j_T4(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.T4(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T4(i_T4:10,:,currentpage)=[Arou.pos_T4((i_T4+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.T4(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T4(i_T4:10,:,currentpage)=[Arou.pos_T4((i_T4+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.T4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T4(currentpage+1,1:endpt)=0;
                    Arou.pos_T4(i_T4:10,:,currentpage)=[Arou.pos_T4((i_T4+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.T4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T4(currentpage+1,1:startpt)=0;
                    Arou.pos_T4(i_T4:10,:,currentpage)=[Arou.pos_T4((i_T4+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.T4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T4(currentpage,1:endpt)=0;
                    Arou.pos_T4(i_T4:10,:,currentpage)=[Arou.pos_T4((i_T4+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.T4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T4(currentpage,1:startpt)=0;
                    Arou.pos_T4(i_T4:10,:,currentpage)=[Arou.pos_T4((i_T4+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'T5'
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
                i_T5 = IDex;
                Arou.j_T5(1,currentpage+1)=Arou.j_T5(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.T5(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T5(i_T5:10,:,currentpage+1)=[Arou.pos_T5((i_T5+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.T5(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T5(i_T5:10,:,currentpage+1)=[Arou.pos_T5((i_T5+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.T5(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T5(currentpage+1,1:endpt)=0;
                    Arou.pos_T5(i_T5:10,:,currentpage+1)=[Arou.pos_T5((i_T5+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.T5(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T5(currentpage+1,1:startpt)=0;
                    Arou.pos_T5(i_T5:10,:,currentpage+1)=[Arou.pos_T5((i_T5+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_T5(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_T5(IDex,2,currentpage-1)) %该线段属于上一页
                i_T5 = IDex;
                Arou.j_T5(1,currentpage-1)=Arou.j_T5(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.T5(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T5(i_T5:10,:,currentpage-1)=[Arou.pos_T5((i_T5+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.T5(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T5(i_T5:10,:,currentpage-1)=[Arou.pos_T5((i_T5+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.T5(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T5(currentpage,1:endpt)=0;
                    Arou.pos_T5(i_T5:10,:,currentpage-1)=[Arou.pos_T5((i_T5+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.T5(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T5(currentpage,1:startpt)=0;
                    Arou.pos_T5(i_T5:10,:,currentpage-1)=[Arou.pos_T5((i_T5+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_T5(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_T5(IDex,2,currentpage))%该线段属于当前页
                i_T5 = IDex;
                Arou.j_T5(1,currentpage)=Arou.j_T5(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.T5(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T5(i_T5:10,:,currentpage)=[Arou.pos_T5((i_T5+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.T5(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T5(i_T5:10,:,currentpage)=[Arou.pos_T5((i_T5+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.T5(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T5(currentpage+1,1:endpt)=0;
                    Arou.pos_T5(i_T5:10,:,currentpage)=[Arou.pos_T5((i_T5+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.T5(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T5(currentpage+1,1:startpt)=0;
                    Arou.pos_T5(i_T5:10,:,currentpage)=[Arou.pos_T5((i_T5+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.T5(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T5(currentpage,1:endpt)=0;
                    Arou.pos_T5(i_T5:10,:,currentpage)=[Arou.pos_T5((i_T5+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.T5(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T5(currentpage,1:startpt)=0;
                    Arou.pos_T5(i_T5:10,:,currentpage)=[Arou.pos_T5((i_T5+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
    case 'T6'
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
                i_T6 = IDex;
                Arou.j_T6(1,currentpage+1)=Arou.j_T6(1,currentpage+1)-1;%将下一页计数减1
                if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,右利手
                    Arou.T6(currentpage+1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T6(i_T6:10,:,currentpage+1)=[Arou.pos_T6((i_T6+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%说明该线段不在两页之间，且在下一页，也就是线段起始点在10s之后,左利手
                    Arou.T6(currentpage+1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T6(i_T6:10,:,currentpage+1)=[Arou.pos_T6((i_T6+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页,右利手
                    Arou.T6(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T6(currentpage+1,1:endpt)=0;
                    Arou.pos_T6(i_T6:10,:,currentpage+1)=[Arou.pos_T6((i_T6+1):10,:,currentpage+1);zeros(1,4,1)];
                elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%说明该线段在两页之间，且被保存到下一页，左利手
                    Arou.T6(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T6(currentpage+1,1:startpt)=0;
                    Arou.pos_T6(i_T6:10,:,currentpage+1)=[Arou.pos_T6((i_T6+1):10,:,currentpage+1);zeros(1,4,1)];
                end
            elseif (currentpage>1)&&(max_x1==Arou.pos_T6(IDex,3,currentpage-1))&&...
                    (y1(1,1)==Arou.pos_T6(IDex,2,currentpage-1)) %该线段属于上一页
                i_T6 = IDex;
                Arou.j_T6(1,currentpage-1)=Arou.j_T6(1,currentpage-1)-1;%将上一页计数减1
                if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,右利手
                    Arou.T6(currentpage-1,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T6(i_T6:10,:,currentpage-1)=[Arou.pos_T6((i_T6+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%说明该线段不在两页之间，且在上一页，也就是线段终止点在0s之前,左利手
                    Arou.T6(currentpage-1,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T6(i_T6:10,:,currentpage-1)=[Arou.pos_T6((i_T6+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,右利手
                    Arou.T6(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T6(currentpage,1:endpt)=0;
                    Arou.pos_T6(i_T6:10,:,currentpage-1)=[Arou.pos_T6((i_T6+1):10,:,currentpage-1);zeros(1,4,1)];
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%说明该线段在两页之间，且被保存到上一页 ,左利手
                    Arou.T6(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;
                    Arou.T6(currentpage,1:startpt)=0;
                    Arou.pos_T6(i_T6:10,:,currentpage-1)=[Arou.pos_T6((i_T6+1):10,:,currentpage-1);zeros(1,4,1)];
                end
            elseif (max_x1==Arou.pos_T6(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_T6(IDex,2,currentpage))%该线段属于当前页
                i_T6 = IDex;
                Arou.j_T6(1,currentpage)=Arou.j_T6(1,currentpage)-1;
                if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %该线段在当前页内部0-10s之内,右利手
                    Arou.T6(currentpage,startpt:endpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T6(i_T6:10,:,currentpage)=[Arou.pos_T6((i_T6+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%左利手，当前页内部0-10s之间
                    Arou.T6(currentpage,endpt:startpt)=0;%%将删除的线段对应的数据恢复成0
                    Arou.pos_T6(i_T6:10,:,currentpage)=[Arou.pos_T6((i_T6+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%属于当前页的线段在当前页和下一页之间,右利手
                    Arou.T6(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T6(currentpage+1,1:endpt)=0;
                    Arou.pos_T6(i_T6:10,:,currentpage)=[Arou.pos_T6((i_T6+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%属于当前页的线段在当前页和下一页之间,左利手
                    Arou.T6(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T6(currentpage+1,1:startpt)=0;
                    Arou.pos_T6(i_T6:10,:,currentpage)=[Arou.pos_T6((i_T6+1):10,:,currentpage);zeros(1,4,1)];
                elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)%%%属于当前页的线段在当前页和上一页之间,右利手
                    Arou.T6(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T6(currentpage,1:endpt)=0;
                    Arou.pos_T6(i_T6:10,:,currentpage)=[Arou.pos_T6((i_T6+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%属于当前页的线段在当前页和上一页之间,左利手
                    Arou.T6(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0;%%将删除的线段对应的数据恢复成0
                    Arou.T6(currentpage,1:startpt)=0;
                    Arou.pos_T6(i_T6:10,:,currentpage)=[Arou.pos_T6((i_T6+1):10,:,currentpage);zeros(1,4,1)];%将当坐标删除，然后将后面的坐标储存前进
                end
            end
        end
end
prefix='aro';%设置文件的前缀为aro
datFile=strcat(prefix,'_',dataname(1:end-4));
subname=datFile;%设置文件名为aro+数据名
save('Arousal_data','Arou');%将数据保存到默认目录下
datfile=strcat(subname,'.mat');
save(datfile,'Arou');%将arou结构体保存为“aro+数据名”的mat文件
delete(a(INDEX.i));
delete('index_line.mat');
set(gcf,'KeyPressFcn',@keypress);


