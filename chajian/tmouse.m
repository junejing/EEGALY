function   tmouse(action)
% TMOUSE 本例展示如何以Handle Graphics来设定滑鼠事件(Mouse
% Events)的反应指令(Callbacks)

%本程序在鼠标移动非常快时，不会造成画“断线”
global x y x0 y0
if nargin == 0
    action = 'start'; 
end

switch(action)
    % 开启图形视窗
    case 'start',
     axis([1 100 1 100]);% 设定图轴范围
     %axis on;
      box off;% 将图轴加上图框

    %title('Click and drag your mouse in this window!');
    % 设定滑鼠按钮被按下时的反应指令为「tmouse down」
    set(gcf, 'WindowButtonDownFcn', 'tmouse down');
    % 滑鼠按钮被按下时的反应指令
    case 'down',
    % 设定滑鼠移动时的反应指令为「tmouse move」
    set(gcf, 'WindowButtonMotionFcn', 'tmouse move');
    % 设定滑鼠按钮被释放时的反应指令为「tmouse up」
    set(gcf, 'WindowButtonUpFcn', 'tmouse up');
    currPt = get(gca, 'CurrentPoint');
     x0 = currPt(1,1);
     y0 = currPt(1,2);
    % 列印「Mouse down!」讯息
    %fprintf('Mouse down!\n');
    % 滑鼠移动时的反应指令
    case 'move',
    currPt = get(gca, 'CurrentPoint');
    x = currPt(1,1);
    y = currPt(1,2);
     %line(x, y, 'marker', '.','markerSize',28, 'LineStyle','-','LineWidth',4,'Color','Red');
     line(x,y, 'marker', '.','markerSize',28, 'LineStyle','-','LineWidth',4,'Color','Red');
     %%当鼠标移动非常快时，上边的程序只能画一些分离的点，一下程序是为了把前后相邻的点连起来。
     %%利用中学的y=kx+b直线方程实现。
      x_gap=0.1 ;%定义x方向增量
      y_gap=0.1 ;%定义y方向增量
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
     X=x0:step_x:x ;        %%定义x的变化范围和步长
                                %%以下定义y的变化范围和步长
     if abs(x-x0)<0.01              %%直线平行于y轴
         Y=y0:step_y:y;     %%斜率不存在时,y值固定
     else
        Y=(y-y0)*(X-x0)/(x-x0)+y0;   %当斜率存在，k=(y-y0)/(x-x0)~=0
     end
      line( X ,Y, 'marker', '.','markerSize',28, 'LineStyle','-','LineWidth',4,'Color','Red');%%补一条直线，当鼠标跳跃移动时
           
  % end
     x0=x;                          %记住当前点坐标
      y0=y;                         %记住当前点坐标
    %plot(x,y, 'marker', '.');
        %'EraseMode', 'xor',
    % 列印「Mouse is moving!」讯息及滑鼠现在位置
     %fprintf('Mouse is moving! Current location = (%g, %g)\n', currPt(1,1), currPt(1,2));
    % 滑鼠按钮被释放时的反应指令
    case 'up',
    % 清除滑鼠移动时的反应指令
    set(gcf, 'WindowButtonMotionFcn', '');
    % 清除滑鼠按钮被释放时的反应指令
    set(gcf, 'WindowButtonUpFcn', '');
    % 列印「Mouse up!」讯息
    %fprintf('Mouse up!\n');
end