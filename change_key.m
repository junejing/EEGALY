function change_key(a,handles,ctshow)
INDEX = load('index_line.mat');
 x1=get(a(INDEX.i),'Xdata');%�õ����ǵ�ǰ�߶ε�λ����Ϣ
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
    end%%%��ȡ��ǰ�߶ε�һ�������һ����ĺ�����ֵ
    load('Datapath.mat');load('Arousal_data.mat');load('Arousalchan_data.mat');
    global totalpage
    global currentpage
    totalpage = ceil((nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/handles.winsize);
    currentpage=str2double(get(handles.currentpage,'string'));%��ǰ��ҳ��
    startpt = round(down_x*fsample(handles.Dmeg{1}));%�Ĵ�����ʼʱ��Ӧ�����ݵ�
    endpt = round(up_x*fsample(handles.Dmeg{1}));%�Ĵ�������ʱ����Ӧ�����ݵ�
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
                        (y1(1,1)==Arou.pos_Fp1(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.Fp1(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Fp1(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage+1,startpt)==0.5
                            Arou.Fp1(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.Fp1(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Fp1(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage+1,startpt)==0.5
                            Arou.Fp1(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_Fp1(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.Fp1(currentpage-1,startpt)==1
                            Arou.Fp1(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage-1,startpt)==0.5
                            Arou.Fp1(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.Fp1(currentpage-1,startpt)==1
                            Arou.Fp1(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage-1,startpt)==0.5
                            Arou.Fp1(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_Fp1(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Fp1(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.Fp1(currentpage,startpt)==1
                            Arou.Fp1(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage,startpt)==0.5
                            Arou.Fp1(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.Fp1(currentpage,startpt)==1
                            Arou.Fp1(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage,startpt)==0.5
                            Arou.Fp1(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.Fp1(currentpage,startpt)==1
                            Arou.Fp1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp1(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage,startpt)==0.5
                            Arou.Fp1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp1(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.Fp1(currentpage,endpt)==1
                            Arou.Fp1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp1(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage,endpt)==0.5
                            Arou.Fp1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp1(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.Fp1(currentpage,startpt)==1
                            Arou.Fp1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp1(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage,startpt)==0.5
                            Arou.Fp1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp1(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.Fp1(currentpage,endpt)==1
                            Arou.Fp1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp1(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp1(currentpage,endpt)==0.5
                            Arou.Fp1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_Fp2(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.Fp2(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Fp2(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage+1,startpt)==0.5
                            Arou.Fp2(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.Fp2(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Fp2(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage+1,startpt)==0.5
                            Arou.Fp2(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_Fp2(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.Fp2(currentpage-1,startpt)==1
                            Arou.Fp2(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage-1,startpt)==0.5
                            Arou.Fp2(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.Fp2(currentpage-1,startpt)==1
                            Arou.Fp2(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage-1,startpt)==0.5
                            Arou.Fp2(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_Fp2(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Fp2(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.Fp2(currentpage,startpt)==1
                            Arou.Fp2(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage,startpt)==0.5
                            Arou.Fp2(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.Fp2(currentpage,startpt)==1
                            Arou.Fp2(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage,startpt)==0.5
                            Arou.Fp2(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.Fp2(currentpage,startpt)==1
                            Arou.Fp2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp2(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage,startpt)==0.5
                            Arou.Fp2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp2(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.Fp2(currentpage,endpt)==1
                            Arou.Fp2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp2(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage,endpt)==0.5
                            Arou.Fp2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp2(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.Fp2(currentpage,startpt)==1
                            Arou.Fp2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp2(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage,startpt)==0.5
                            Arou.Fp2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp2(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.Fp2(currentpage,endpt)==1
                            Arou.Fp2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fp2(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fp2(currentpage,endpt)==0.5
                            Arou.Fp2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_F3(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.F3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F3(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage+1,startpt)==0.5
                            Arou.F3(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.F3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F3(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage+1,startpt)==0.5
                            Arou.F3(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_F3(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.F3(currentpage-1,startpt)==1
                            Arou.F3(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage-1,startpt)==0.5
                            Arou.F3(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.F3(currentpage-1,startpt)==1
                            Arou.F3(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage-1,startpt)==0.5
                            Arou.F3(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_F3(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_F3(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.F3(currentpage,startpt)==1
                            Arou.F3(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage,startpt)==0.5
                            Arou.F3(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.F3(currentpage,startpt)==1
                            Arou.F3(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage,startpt)==0.5
                            Arou.F3(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.F3(currentpage,startpt)==1
                            Arou.F3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F3(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage,startpt)==0.5
                            Arou.F3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F3(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.F3(currentpage,endpt)==1
                            Arou.F3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F3(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage,endpt)==0.5
                            Arou.F3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F3(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.F3(currentpage,startpt)==1
                            Arou.F3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F3(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage,startpt)==0.5
                            Arou.F3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F3(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.F3(currentpage,endpt)==1
                            Arou.F3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F3(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F3(currentpage,endpt)==0.5
                            Arou.F3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_F4(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.F4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F4(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage+1,startpt)==0.5
                            Arou.F4(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.F4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F4(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage+1,startpt)==0.5
                            Arou.F4(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_F4(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.F4(currentpage-1,startpt)==1
                            Arou.F4(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage-1,startpt)==0.5
                            Arou.F4(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.F4(currentpage-1,startpt)==1
                            Arou.F4(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage-1,startpt)==0.5
                            Arou.F4(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_F4(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_F4(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.F4(currentpage,startpt)==1
                            Arou.F4(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage,startpt)==0.5
                            Arou.F4(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.F4(currentpage,startpt)==1
                            Arou.F4(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage,startpt)==0.5
                            Arou.F4(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.F4(currentpage,startpt)==1
                            Arou.F4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F4(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage,startpt)==0.5
                            Arou.F4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F4(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.F4(currentpage,endpt)==1
                            Arou.F4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F4(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage,endpt)==0.5
                            Arou.F4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F4(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.F4(currentpage,startpt)==1
                            Arou.F4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F4(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage,startpt)==0.5
                            Arou.F4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F4(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.F4(currentpage,endpt)==1
                            Arou.F4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F4(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F4(currentpage,endpt)==0.5
                            Arou.F4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_C3(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.C3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.C3(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage+1,startpt)==0.5
                            Arou.C3(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.C3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.C3(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage+1,startpt)==0.5
                            Arou.C3(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_C3(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.C3(currentpage-1,startpt)==1
                            Arou.C3(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage-1,startpt)==0.5
                            Arou.C3(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.C3(currentpage-1,startpt)==1
                            Arou.C3(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage-1,startpt)==0.5
                            Arou.C3(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_C3(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_C3(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.C3(currentpage,startpt)==1
                            Arou.C3(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage,startpt)==0.5
                            Arou.C3(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.C3(currentpage,startpt)==1
                            Arou.C3(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage,startpt)==0.5
                            Arou.C3(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.C3(currentpage,startpt)==1
                            Arou.C3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C3(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage,startpt)==0.5
                            Arou.C3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C3(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.C3(currentpage,endpt)==1
                            Arou.C3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C3(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage,endpt)==0.5
                            Arou.C3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C3(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.C3(currentpage,startpt)==1
                            Arou.C3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C3(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage,startpt)==0.5
                            Arou.C3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C3(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.C3(currentpage,endpt)==1
                            Arou.C3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C3(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C3(currentpage,endpt)==0.5
                            Arou.C3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_C4(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.C4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.C4(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage+1,startpt)==0.5
                            Arou.C4(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.C4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.C4(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage+1,startpt)==0.5
                            Arou.C4(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_C4(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.C4(currentpage-1,startpt)==1
                            Arou.C4(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage-1,startpt)==0.5
                            Arou.C4(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.C4(currentpage-1,startpt)==1
                            Arou.C4(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage-1,startpt)==0.5
                            Arou.C4(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_C4(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_C4(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.C4(currentpage,startpt)==1
                            Arou.C4(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage,startpt)==0.5
                            Arou.C4(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.C4(currentpage,startpt)==1
                            Arou.C4(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage,startpt)==0.5
                            Arou.C4(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.C4(currentpage,startpt)==1
                            Arou.C4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C4(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage,startpt)==0.5
                            Arou.C4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C4(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.C4(currentpage,endpt)==1
                            Arou.C4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C4(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage,endpt)==0.5
                            Arou.C4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C4(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.C4(currentpage,startpt)==1
                            Arou.C4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C4(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage,startpt)==0.5
                            Arou.C4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C4(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.C4(currentpage,endpt)==1
                            Arou.C4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.C4(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.C4(currentpage,endpt)==0.5
                            Arou.C4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_P3(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.P3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.P3(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage+1,startpt)==0.5
                            Arou.P3(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.P3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.P3(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage+1,startpt)==0.5
                            Arou.P3(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_P3(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.P3(currentpage-1,startpt)==1
                            Arou.P3(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage-1,startpt)==0.5
                            Arou.P3(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.P3(currentpage-1,startpt)==1
                            Arou.P3(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage-1,startpt)==0.5
                            Arou.P3(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_P3(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_P3(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.P3(currentpage,startpt)==1
                            Arou.P3(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage,startpt)==0.5
                            Arou.P3(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.P3(currentpage,startpt)==1
                            Arou.P3(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage,startpt)==0.5
                            Arou.P3(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.P3(currentpage,startpt)==1
                            Arou.P3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P3(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage,startpt)==0.5
                            Arou.P3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P3(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.P3(currentpage,endpt)==1
                            Arou.P3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P3(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage,endpt)==0.5
                            Arou.P3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P3(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.P3(currentpage,startpt)==1
                            Arou.P3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P3(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage,startpt)==0.5
                            Arou.P3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P3(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.P3(currentpage,endpt)==1
                            Arou.P3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P3(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P3(currentpage,endpt)==0.5
                            Arou.P3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_P4(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.P4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.P4(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage+1,startpt)==0.5
                            Arou.P4(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.P4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.P4(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage+1,startpt)==0.5
                            Arou.P4(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_P4(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.P4(currentpage-1,startpt)==1
                            Arou.P4(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage-1,startpt)==0.5
                            Arou.P4(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.P4(currentpage-1,startpt)==1
                            Arou.P4(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage-1,startpt)==0.5
                            Arou.P4(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_P4(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_P4(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.P4(currentpage,startpt)==1
                            Arou.P4(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage,startpt)==0.5
                            Arou.P4(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.P4(currentpage,startpt)==1
                            Arou.P4(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage,startpt)==0.5
                            Arou.P4(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.P4(currentpage,startpt)==1
                            Arou.P4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P4(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage,startpt)==0.5
                            Arou.P4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P4(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.P4(currentpage,endpt)==1
                            Arou.P4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P4(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage,endpt)==0.5
                            Arou.P4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P4(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.P4(currentpage,startpt)==1
                            Arou.P4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P4(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage,startpt)==0.5
                            Arou.P4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P4(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.P4(currentpage,endpt)==1
                            Arou.P4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.P4(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.P4(currentpage,endpt)==0.5
                            Arou.P4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_O1(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.O1(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.O1(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage+1,startpt)==0.5
                            Arou.O1(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.O1(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.O1(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage+1,startpt)==0.5
                            Arou.O1(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_O1(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.O1(currentpage-1,startpt)==1
                            Arou.O1(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage-1,startpt)==0.5
                            Arou.O1(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.O1(currentpage-1,startpt)==1
                            Arou.O1(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage-1,startpt)==0.5
                            Arou.O1(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_O1(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_O1(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.O1(currentpage,startpt)==1
                            Arou.O1(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage,startpt)==0.5
                            Arou.O1(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.O1(currentpage,startpt)==1
                            Arou.O1(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage,startpt)==0.5
                            Arou.O1(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.O1(currentpage,startpt)==1
                            Arou.O1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O1(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage,startpt)==0.5
                            Arou.O1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O1(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.O1(currentpage,endpt)==1
                            Arou.O1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O1(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage,endpt)==0.5
                            Arou.O1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O1(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.O1(currentpage,startpt)==1
                            Arou.O1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O1(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage,startpt)==0.5
                            Arou.O1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O1(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.O1(currentpage,endpt)==1
                            Arou.O1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O1(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O1(currentpage,endpt)==0.5
                            Arou.O1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_O2(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.O2(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.O2(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage+1,startpt)==0.5
                            Arou.O2(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.O2(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.O2(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage+1,startpt)==0.5
                            Arou.O2(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_O2(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.O2(currentpage-1,startpt)==1
                            Arou.O2(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage-1,startpt)==0.5
                            Arou.O2(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.O2(currentpage-1,startpt)==1
                            Arou.O2(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage-1,startpt)==0.5
                            Arou.O2(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_O2(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_O2(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.O2(currentpage,startpt)==1
                            Arou.O2(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage,startpt)==0.5
                            Arou.O2(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.O2(currentpage,startpt)==1
                            Arou.O2(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage,startpt)==0.5
                            Arou.O2(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.O2(currentpage,startpt)==1
                            Arou.O2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O2(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage,startpt)==0.5
                            Arou.O2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O2(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.O2(currentpage,endpt)==1
                            Arou.O2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O2(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage,endpt)==0.5
                            Arou.O2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O2(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.O2(currentpage,startpt)==1
                            Arou.O2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O2(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage,startpt)==0.5
                            Arou.O2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O2(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.O2(currentpage,endpt)==1
                            Arou.O2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.O2(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.O2(currentpage,endpt)==0.5
                            Arou.O2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_F7(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.F7(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F7(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage+1,startpt)==0.5
                            Arou.F7(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.F7(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F7(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage+1,startpt)==0.5
                            Arou.F7(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_F7(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.F7(currentpage-1,startpt)==1
                            Arou.F7(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage-1,startpt)==0.5
                            Arou.F7(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.F7(currentpage-1,startpt)==1
                            Arou.F7(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage-1,startpt)==0.5
                            Arou.F7(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_F7(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_F7(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.F7(currentpage,startpt)==1
                            Arou.F7(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage,startpt)==0.5
                            Arou.F7(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.F7(currentpage,startpt)==1
                            Arou.F7(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage,startpt)==0.5
                            Arou.F7(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.F7(currentpage,startpt)==1
                            Arou.F7(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F7(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage,startpt)==0.5
                            Arou.F7(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F7(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.F7(currentpage,endpt)==1
                            Arou.F7(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F7(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage,endpt)==0.5
                            Arou.F7(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F7(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.F7(currentpage,startpt)==1
                            Arou.F7(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F7(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage,startpt)==0.5
                            Arou.F7(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F7(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.F7(currentpage,endpt)==1
                            Arou.F7(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F7(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F7(currentpage,endpt)==0.5
                            Arou.F7(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_F8(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.F8(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F8(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage+1,startpt)==0.5
                            Arou.F8(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.F8(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.F8(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage+1,startpt)==0.5
                            Arou.F8(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_F8(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.F8(currentpage-1,startpt)==1
                            Arou.F8(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage-1,startpt)==0.5
                            Arou.F8(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.F8(currentpage-1,startpt)==1
                            Arou.F8(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage-1,startpt)==0.5
                            Arou.F8(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_F8(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_F8(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.F8(currentpage,startpt)==1
                            Arou.F8(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage,startpt)==0.5
                            Arou.F8(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.F8(currentpage,startpt)==1
                            Arou.F8(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage,startpt)==0.5
                            Arou.F8(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.F8(currentpage,startpt)==1
                            Arou.F8(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F8(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage,startpt)==0.5
                            Arou.F8(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F8(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.F8(currentpage,endpt)==1
                            Arou.F8(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F8(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage,endpt)==0.5
                            Arou.F8(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F8(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.F8(currentpage,startpt)==1
                            Arou.F8(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F8(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage,startpt)==0.5
                            Arou.F8(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F8(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.F8(currentpage,endpt)==1
                            Arou.F8(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.F8(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.F8(currentpage,endpt)==0.5
                            Arou.F8(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_Fz(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.Fz(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Fz(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage+1,startpt)==0.5
                            Arou.Fz(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.Fz(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Fz(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage+1,startpt)==0.5
                            Arou.Fz(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_Fz(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.Fz(currentpage-1,startpt)==1
                            Arou.Fz(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage-1,startpt)==0.5
                            Arou.Fz(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.Fz(currentpage-1,startpt)==1
                            Arou.Fz(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage-1,startpt)==0.5
                            Arou.Fz(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_Fz(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Fz(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.Fz(currentpage,startpt)==1
                            Arou.Fz(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage,startpt)==0.5
                            Arou.Fz(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.Fz(currentpage,startpt)==1
                            Arou.Fz(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage,startpt)==0.5
                            Arou.Fz(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.Fz(currentpage,startpt)==1
                            Arou.Fz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fz(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage,startpt)==0.5
                            Arou.Fz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fz(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.Fz(currentpage,endpt)==1
                            Arou.Fz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fz(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage,endpt)==0.5
                            Arou.Fz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fz(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.Fz(currentpage,startpt)==1
                            Arou.Fz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fz(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage,startpt)==0.5
                            Arou.Fz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fz(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.Fz(currentpage,endpt)==1
                            Arou.Fz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Fz(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Fz(currentpage,endpt)==0.5
                            Arou.Fz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_Cz(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.Cz(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Cz(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage+1,startpt)==0.5
                            Arou.Cz(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.Cz(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Cz(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage+1,startpt)==0.5
                            Arou.Cz(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_Cz(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.Cz(currentpage-1,startpt)==1
                            Arou.Cz(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage-1,startpt)==0.5
                            Arou.Cz(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.Cz(currentpage-1,startpt)==1
                            Arou.Cz(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage-1,startpt)==0.5
                            Arou.Cz(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_Cz(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Cz(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.Cz(currentpage,startpt)==1
                            Arou.Cz(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage,startpt)==0.5
                            Arou.Cz(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.Cz(currentpage,startpt)==1
                            Arou.Cz(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage,startpt)==0.5
                            Arou.Cz(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.Cz(currentpage,startpt)==1
                            Arou.Cz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Cz(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage,startpt)==0.5
                            Arou.Cz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Cz(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.Cz(currentpage,endpt)==1
                            Arou.Cz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Cz(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage,endpt)==0.5
                            Arou.Cz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Cz(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.Cz(currentpage,startpt)==1
                            Arou.Cz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Cz(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage,startpt)==0.5
                            Arou.Cz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Cz(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.Cz(currentpage,endpt)==1
                            Arou.Cz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Cz(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Cz(currentpage,endpt)==0.5
                            Arou.Cz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_Pz(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.Pz(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Pz(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage+1,startpt)==0.5
                            Arou.Pz(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.Pz(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.Pz(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage+1,startpt)==0.5
                            Arou.Pz(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_Pz(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.Pz(currentpage-1,startpt)==1
                            Arou.Pz(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage-1,startpt)==0.5
                            Arou.Pz(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.Pz(currentpage-1,startpt)==1
                            Arou.Pz(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage-1,startpt)==0.5
                            Arou.Pz(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_Pz(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_Pz(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.Pz(currentpage,startpt)==1
                            Arou.Pz(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage,startpt)==0.5
                            Arou.Pz(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.Pz(currentpage,startpt)==1
                            Arou.Pz(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage,startpt)==0.5
                            Arou.Pz(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.Pz(currentpage,startpt)==1
                            Arou.Pz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Pz(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage,startpt)==0.5
                            Arou.Pz(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Pz(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.Pz(currentpage,endpt)==1
                            Arou.Pz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Pz(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage,endpt)==0.5
                            Arou.Pz(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Pz(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.Pz(currentpage,startpt)==1
                            Arou.Pz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Pz(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage,startpt)==0.5
                            Arou.Pz(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Pz(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.Pz(currentpage,endpt)==1
                            Arou.Pz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.Pz(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.Pz(currentpage,endpt)==0.5
                            Arou.Pz(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_A1(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.A1(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.A1(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage+1,startpt)==0.5
                            Arou.A1(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.A1(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.A1(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage+1,startpt)==0.5
                            Arou.A1(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_A1(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.A1(currentpage-1,startpt)==1
                            Arou.A1(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage-1,startpt)==0.5
                            Arou.A1(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.A1(currentpage-1,startpt)==1
                            Arou.A1(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage-1,startpt)==0.5
                            Arou.A1(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_A1(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_A1(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.A1(currentpage,startpt)==1
                            Arou.A1(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage,startpt)==0.5
                            Arou.A1(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.A1(currentpage,startpt)==1
                            Arou.A1(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage,startpt)==0.5
                            Arou.A1(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.A1(currentpage,startpt)==1
                            Arou.A1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A1(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage,startpt)==0.5
                            Arou.A1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A1(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.A1(currentpage,endpt)==1
                            Arou.A1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A1(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage,endpt)==0.5
                            Arou.A1(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A1(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.A1(currentpage,startpt)==1
                            Arou.A1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A1(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage,startpt)==0.5
                            Arou.A1(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A1(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.A1(currentpage,endpt)==1
                            Arou.A1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A1(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A1(currentpage,endpt)==0.5
                            Arou.A1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_A2(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.A2(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.A2(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage+1,startpt)==0.5
                            Arou.A2(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.A2(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.A2(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage+1,startpt)==0.5
                            Arou.A2(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_A2(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.A2(currentpage-1,startpt)==1
                            Arou.A2(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage-1,startpt)==0.5
                            Arou.A2(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.A2(currentpage-1,startpt)==1
                            Arou.A2(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage-1,startpt)==0.5
                            Arou.A2(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_A2(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_A2(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.A2(currentpage,startpt)==1
                            Arou.A2(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage,startpt)==0.5
                            Arou.A2(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.A2(currentpage,startpt)==1
                            Arou.A2(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage,startpt)==0.5
                            Arou.A2(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.A2(currentpage,startpt)==1
                            Arou.A2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A2(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage,startpt)==0.5
                            Arou.A2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A2(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.A2(currentpage,endpt)==1
                            Arou.A2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A2(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage,endpt)==0.5
                            Arou.A2(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A2(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.A2(currentpage,startpt)==1
                            Arou.A2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A2(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage,startpt)==0.5
                            Arou.A2(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A2(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.A2(currentpage,endpt)==1
                            Arou.A2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.A2(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.A2(currentpage,endpt)==0.5
                            Arou.A2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_T3(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.T3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T3(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage+1,startpt)==0.5
                            Arou.T3(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.T3(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T3(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage+1,startpt)==0.5
                            Arou.T3(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_T3(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.T3(currentpage-1,startpt)==1
                            Arou.T3(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage-1,startpt)==0.5
                            Arou.T3(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.T3(currentpage-1,startpt)==1
                            Arou.T3(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage-1,startpt)==0.5
                            Arou.T3(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_T3(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_T3(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.T3(currentpage,startpt)==1
                            Arou.T3(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage,startpt)==0.5
                            Arou.T3(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.T3(currentpage,startpt)==1
                            Arou.T3(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage,startpt)==0.5
                            Arou.T3(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.T3(currentpage,startpt)==1
                            Arou.T3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T3(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage,startpt)==0.5
                            Arou.T3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T3(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.T3(currentpage,endpt)==1
                            Arou.T3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T3(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage,endpt)==0.5
                            Arou.T3(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T3(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.T3(currentpage,startpt)==1
                            Arou.T3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T3(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage,startpt)==0.5
                            Arou.T3(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T3(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.T3(currentpage,endpt)==1
                            Arou.T3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T3(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T3(currentpage,endpt)==0.5
                            Arou.T3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_T4(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.T4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T4(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage+1,startpt)==0.5
                            Arou.T4(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.T4(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T4(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage+1,startpt)==0.5
                            Arou.T4(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_T4(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.T4(currentpage-1,startpt)==1
                            Arou.T4(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage-1,startpt)==0.5
                            Arou.T4(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.T4(currentpage-1,startpt)==1
                            Arou.T4(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage-1,startpt)==0.5
                            Arou.T4(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_T4(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_T4(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.T4(currentpage,startpt)==1
                            Arou.T4(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage,startpt)==0.5
                            Arou.T4(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.T4(currentpage,startpt)==1
                            Arou.T4(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage,startpt)==0.5
                            Arou.T4(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.T4(currentpage,startpt)==1
                            Arou.T4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T4(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage,startpt)==0.5
                            Arou.T4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T4(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.T4(currentpage,endpt)==1
                            Arou.T4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T4(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage,endpt)==0.5
                            Arou.T4(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T4(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.T4(currentpage,startpt)==1
                            Arou.T4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T4(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage,startpt)==0.5
                            Arou.T4(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T4(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.T4(currentpage,endpt)==1
                            Arou.T4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T4(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T4(currentpage,endpt)==0.5
                            Arou.T4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_T5(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.T5(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T5(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage+1,startpt)==0.5
                            Arou.T5(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.T5(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T5(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage+1,startpt)==0.5
                            Arou.T5(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_T5(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.T5(currentpage-1,startpt)==1
                            Arou.T5(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage-1,startpt)==0.5
                            Arou.T5(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.T5(currentpage-1,startpt)==1
                            Arou.T5(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage-1,startpt)==0.5
                            Arou.T5(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_T5(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_T5(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.T5(currentpage,startpt)==1
                            Arou.T5(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage,startpt)==0.5
                            Arou.T5(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.T5(currentpage,startpt)==1
                            Arou.T5(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage,startpt)==0.5
                            Arou.T5(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.T5(currentpage,startpt)==1
                            Arou.T5(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T5(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage,startpt)==0.5
                            Arou.T5(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T5(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.T5(currentpage,endpt)==1
                            Arou.T5(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T5(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage,endpt)==0.5
                            Arou.T5(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T5(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.T5(currentpage,startpt)==1
                            Arou.T5(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T5(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage,startpt)==0.5
                            Arou.T5(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T5(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.T5(currentpage,endpt)==1
                            Arou.T5(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T5(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T5(currentpage,endpt)==0.5
                            Arou.T5(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
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
                        (y1(1,1)==Arou.pos_T6(IDex,2,currentpage+1)) %���߶�������һҳ
                    if (startpt<endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.T6(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T6(currentpage+1,startpt:endpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage+1,startpt)==0.5
                            Arou.T6(currentpage+1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1>=currentpage*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ʼ����10s֮��,������
                        if Arou.T6(currentpage+1,startpt)==1
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            Arou.T6(currentpage+1,endpt:startpt)=0.5;
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage+1,startpt)==0.5
                            Arou.T6(currentpage+1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ,������
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
                    elseif (startpt<endpt)&& (min_x1<=currentpage*handles.winsize)&&(max_x1>=currentpage*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ��������
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
                        (y1(1,1)==Arou.pos_T6(IDex,2,currentpage-1)) %���߶�������һҳ
                    if (startpt<endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.T6(currentpage-1,startpt)==1
                            Arou.T6(currentpage-1,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage-1,startpt)==0.5
                            Arou.T6(currentpage-1,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<=(currentpage-1)*handles.winsize)%˵�����߶β�����ҳ֮�䣬������һҳ��Ҳ�����߶���ֹ����0s֮ǰ,������
                        if Arou.T6(currentpage-1,startpt)==1
                            Arou.T6(currentpage-1,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage-1,startpt)==0.5
                            Arou.T6(currentpage-1,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>=(currentpage-1)*handles.winsize)%˵�����߶�����ҳ֮�䣬�ұ����浽��һҳ ,������
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
                elseif (max_x1==Arou.pos_T6(IDex,3,currentpage))&&(y1(1,1)==Arou.pos_T6(IDex,2,currentpage))%���߶����ڵ�ǰҳ
                    if (startpt<endpt)&&(min_x1>=(currentpage-1)*handles.winsize)&&(max_x1<=currentpage*handles.winsize) %���߶��ڵ�ǰҳ�ڲ�0-10s֮��,������
                        if Arou.T6(currentpage,startpt)==1
                            Arou.T6(currentpage,startpt:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage,startpt)==0.5
                            Arou.T6(currentpage,startpt:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1<currentpage*handles.winsize)&&(min_x1>(currentpage-1)*handles.winsize)%�����֣���ǰҳ�ڲ�0-10s֮��
                        if Arou.T6(currentpage,startpt)==1
                            Arou.T6(currentpage,endpt:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage,startpt)==0.5
                            Arou.T6(currentpage,endpt:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.T6(currentpage,startpt)==1
                            Arou.T6(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T6(currentpage+1,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage,startpt)==0.5
                            Arou.T6(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T6(currentpage+1,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(max_x1>=currentpage*handles.winsize)&&(min_x1<currentpage*handles.winsize)%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮��,������
                        if Arou.T6(currentpage,endpt)==1
                            Arou.T6(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T6(currentpage+1,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage,endpt)==0.5
                            Arou.T6(currentpage,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T6(currentpage+1,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt<endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%��ǰҳ����һҳ֮�䣬������
                        if Arou.T6(currentpage,startpt)==1
                            Arou.T6(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T6(currentpage,1:startpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage,startpt)==0.5
                            Arou.T6(currentpage-1,endpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T6(currentpage,1:startpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    elseif (startpt>endpt)&&(min_x1<=(currentpage-1)*handles.winsize)&&(max_x1>(currentpage-1)*handles.winsize)%%%���ڵ�ǰҳ���߶��ڵ�ǰҳ����һҳ֮�䣬������
                        if Arou.T6(currentpage,endpt)==1
                            Arou.T6(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T6(currentpage,1:endpt)=0.5;
                            set(a(INDEX.i),'color',[1 0.5 0],'Tag','0');
                            sure_or_not(2) = 1;
                        elseif Arou.T6(currentpage,endpt)==0.5
                            Arou.T6(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;%%��ɾ�����߶ζ�Ӧ�����ݻָ���0
                            Arou.T6(currentpage,1:endpt)=1;
                            set(a(INDEX.i),'color',[0 0.6 0],'Tag','1');
                            sure_or_not(1) = 1;
                        end
                    end
                end
            end
            
    end
    prefix='aro';%�����ļ���ǰ׺Ϊaro
    datFile=strcat(prefix,'_',dataname(1:end-4));
    subname=datFile;%�����ļ���Ϊaro+������
    save('Arousal_data','Arou');%�����ݱ��浽Ĭ��Ŀ¼��
    save('sure_or_not','sure_or_not');
    datfile=strcat(subname,'.mat');
    save(datfile,'Arou');%��arou�ṹ�屣��Ϊ��aro+����������mat�ļ�
    delete('index_line.mat');
    set(gcf,'KeyPressFcn',@keypress);
    
    