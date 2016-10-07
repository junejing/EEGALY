function EEG_map
close all;
clear all;
%prefile = spm_select(1, 'dir', 'Select EEG-data of EEG file','' ...
%           ,pwd,'.*');
str = 'map';
figure('name',str);
axis([-0.6,0.6,-0.6,0.6]);
set(gca,'XTick',[-0.6:0.2:0.6],'YTick',[-0.6:0.2:0.6]);
text(-0.6,-0.6,...
    [int2str(19) 'electrode locations shown']);
tl = title('Channel locations');
set(tl, 'fontweight', 'bold');

%��ͷ������
CIRCGRID = 201;
circ = linspace(0,2*pi,CIRCGRID);
rx = sin(circ);
ry = cos(circ);
HEADCOLOR = [0 0 0];
HLINEWIDTH = 1.7;
hin = 0.5300;
hwidth = 0.0095;
headx = [[rx(:)' rx(1) ]*(hin+hwidth)  [rx(:)' rx(1)]*hin];
heady = [[ry(:)' ry(1) ]*(hin+hwidth)  [ry(:)' ry(1)]*hin];
ringh= patch(headx,heady,ones(size(headx)),HEADCOLOR,'edgecolor',HEADCOLOR);
hold on

%�����ӡ�����
rmax = 0.5;
base = rmax-.0046;
basex = 0.18*rmax;   %���ӿ��
tip = 1.15*rmax;
tiphw = .04*rmax; %���Ӷ��˿�ȵ�һ��
tipr = .01*rmax; %���Ӽ�round
q = .04; %���䳤��
headrad = 0.5;
plotrad = 0.5438;
EarX  = [.497-.005  .510  .518  .5299 .5419  .54    .547   .532   .510   .489-.005]; % rmax = 0.5
EarY  = [q+.0555 q+.0775 q+.0783 q+.0746 q+.0555 -.0055 -.0932 -.1313 -.1384 -.1199];
sf    = headrad/plotrad;                                          % squeeze the model ears and nose
plot3([basex;tiphw;0;-tiphw;-basex]*sf,[base;tip-tipr;tip;tip-tipr;base]*sf+0.065,...
    2*ones(size([basex;tiphw;0;-tiphw;-basex])),...
    'Color',HEADCOLOR,'LineWidth',HLINEWIDTH);                 % plot nose
plot3(EarX*sf+0.075,EarY*sf,2*ones(size(EarX)),'color',HEADCOLOR,'LineWidth',HLINEWIDTH)    % plot left ear
plot3(-EarX*sf-0.075,EarY*sf,2*ones(size(EarY)),'color',HEADCOLOR,'LineWidth',HLINEWIDTH)   % plot right ear

%�缫
plotax = gca; %���ص�ǰaxes����ľ��ֵ
axis square    %ʹplotax��������������
axis off %������ϵ��Ϊ���ɼ�����������ϵ��title��Ϊ�ɼ������ı������Ŀɼ���

ELECTRODE_HEIGHT = 2.1;
EMARKER = '.';
ECOLOR = [0 0 0];
x = [0.4662,0.4662,0.2484,0.2484,1.5008e-17,1.5008e-17,-0.2484,-0.2484,-0.4662,-0.4662,0.2881,0.2881,0.2451,0,-0.2451,-0.1500,-0.1500,3.0016e-17,3.0016e-17,-0.2881,-0.2881];
y = [-0.1515,0.1515,-0.2012,0.2012,-0.2451,0.2451,-0.2012,0.2012,-0.1515,0.1515,-0.3966,0.3966,0,0,3.0016e-17,-0.5400,0.5400,-0.4902,0.4902,-0.3966,0.3966];

% x = [0.4662,0.4662,0.2484,0.2484,1.5008e-17,1.5008e-17,-0.2484,-0.2484,-0.4662,-0.4662,0.2881,0.2881,0.2451,0,-0.2451,3.0016e-17,3.0016e-17,-0.2881,-0.2881];
% y = [-0.1515,0.1515,-0.2012,0.2012,-0.2451,0.2451,-0.2012,0.2012,-0.1515,0.1515,-0.3966,0.3966,0,0,3.0016e-17,-0.4902,0.4902,-0.3966,0.3966];
for i=1:19
    plot(y(i),x(i),EMARKER,'Color',ECOLOR,'linewidth',1);
    hold on
end
 
allchansind = 1:21;
EFSIZE = 10;
labels = char('FP1','FP2','F3','F4','C3','C4','P3','P4','O1','O2','F7','F8','Fz','Cz','Pz','A1','A2','T3','T4','T5','T6');
for i = 1:size(labels,1)
    hh(i) = text(double(y(i)+0.01),double(x(i)),...
        ELECTRODE_HEIGHT,labels(i,:),'HorizontalAlignment','left',...
        'VerticalAlignment','middle','Color', ECOLOR,'userdata', num2str(allchansind(i)), ...
        'FontSize',EFSIZE, 'buttondownfcn', ...
        ['tmpstr = get(gco, ''userdata'');'...  
        'set(gco, ''userdata'', get(gco, ''string''));' ...
        'set(gco, ''string'', tmpstr); clear tmpstr;'] );
end