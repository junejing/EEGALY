function   tmouse(action)
% TMOUSE ����չʾ�����Handle Graphics���趨�����¼�(Mouse
% Events)�ķ�Ӧָ��(Callbacks)

%������������ƶ��ǳ���ʱ��������ɻ������ߡ�
global x y x0 y0
if nargin == 0
    action = 'start'; 
end

switch(action)
    % ����ͼ���Ӵ�
    case 'start',
     axis([1 100 1 100]);% �趨ͼ�᷶Χ
     %axis on;
      box off;% ��ͼ�����ͼ��

    %title('Click and drag your mouse in this window!');
    % �趨����ť������ʱ�ķ�Ӧָ��Ϊ��tmouse down��
    set(gcf, 'WindowButtonDownFcn', 'tmouse down');
    % ����ť������ʱ�ķ�Ӧָ��
    case 'down',
    % �趨�����ƶ�ʱ�ķ�Ӧָ��Ϊ��tmouse move��
    set(gcf, 'WindowButtonMotionFcn', 'tmouse move');
    % �趨����ť���ͷ�ʱ�ķ�Ӧָ��Ϊ��tmouse up��
    set(gcf, 'WindowButtonUpFcn', 'tmouse up');
    currPt = get(gca, 'CurrentPoint');
     x0 = currPt(1,1);
     y0 = currPt(1,2);
    % ��ӡ��Mouse down!��ѶϢ
    %fprintf('Mouse down!\n');
    % �����ƶ�ʱ�ķ�Ӧָ��
    case 'move',
    currPt = get(gca, 'CurrentPoint');
    x = currPt(1,1);
    y = currPt(1,2);
     %line(x, y, 'marker', '.','markerSize',28, 'LineStyle','-','LineWidth',4,'Color','Red');
     line(x,y, 'marker', '.','markerSize',28, 'LineStyle','-','LineWidth',4,'Color','Red');
     %%������ƶ��ǳ���ʱ���ϱߵĳ���ֻ�ܻ�һЩ����ĵ㣬һ�³�����Ϊ�˰�ǰ�����ڵĵ���������
     %%������ѧ��y=kx+bֱ�߷���ʵ�֡�
      x_gap=0.1 ;%����x��������
      y_gap=0.1 ;%����y��������
      if x>x0
          step_x=x_gap;
      else
          step_x=-x_gap;
      end
      if y>y0
          step_y=y_gap;
      else
          step_y=-y_gap;
      end
     X=x0:step_x:x ;        %%����x�ı仯��Χ�Ͳ���
                                %%���¶���y�ı仯��Χ�Ͳ���
     if abs(x-x0)<0.01              %%ֱ��ƽ����y��
         Y=y0:step_y:y;     %%б�ʲ�����ʱ,yֵ�̶�
     else
        Y=(y-y0)*(X-x0)/(x-x0)+y0;   %��б�ʴ��ڣ�k=(y-y0)/(x-x0)~=0
     end
      line( X ,Y, 'marker', '.','markerSize',28, 'LineStyle','-','LineWidth',4,'Color','Red');%%��һ��ֱ�ߣ��������Ծ�ƶ�ʱ
           
  % end
     x0=x;                          %��ס��ǰ������
      y0=y;                         %��ס��ǰ������
    %plot(x,y, 'marker', '.');
        %'EraseMode', 'xor',
    % ��ӡ��Mouse is moving!��ѶϢ����������λ��
     %fprintf('Mouse is moving! Current location = (%g, %g)\n', currPt(1,1), currPt(1,2));
    % ����ť���ͷ�ʱ�ķ�Ӧָ��
    case 'up',
    % ��������ƶ�ʱ�ķ�Ӧָ��
    set(gcf, 'WindowButtonMotionFcn', '');
    % �������ť���ͷ�ʱ�ķ�Ӧָ��
    set(gcf, 'WindowButtonUpFcn', '');
    % ��ӡ��Mouse up!��ѶϢ
    %fprintf('Mouse up!\n');
end