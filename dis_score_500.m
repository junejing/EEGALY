function varargout = dis_score_500(varargin)
% DIS_SCORE_500 MATLAB code for dis_score_500.fig
%      DIS_SCORE_500, by itself, creates a new DIS_SCORE_500 or raises the existing
%      singleton*.
%
%      H = DIS_SCORE_500 returns the handle to a new DIS_SCORE_500 or the handle to
%      the existing singleton*.
%
%      DIS_SCORE_500('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIS_SCORE_500.M with the given input arguments.
%
%      DIS_SCORE_500('Property','Value',...) creates a new DIS_SCORE_500 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dis_score_500_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dis_score_500_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dis_score_500

% Last Modified by GUIDE v2.5 02-Sep-2015 16:05:43

% Begin initialization code - DO NOT EDIT
%disp(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dis_score_500_OpeningFcn, ...
                   'gui_OutputFcn',  @dis_score_500_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before dis_score_500 is made visible.
function dis_score_500_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dis_score_500 (see VARARGIN)
crcdef = crc_get_defaults('one');
set(0,'CurrentFigure',handles.figure1);
warning('off');


% Choose default command line output for dis_score_500
handles.output = hObject;
handles.file    =   varargin{1}.file;
handles.figz    =   0;
handles.Dmeg    =   varargin{1}.Dmeg;

for i=1:numel(handles.Dmeg)
    handles.Dmeg{i} =   meeg(handles.Dmeg{i});
end
D = handles.Dmeg{1};
% distinct index to make easier to select data by type
handles.index   =   varargin{1}.index;
handles.indexMEEG   =   fliplr(intersect(meegchannels(handles.Dmeg{1}),handles.index));
handles.indnomeeg   =   setdiff(handles.index, handles.indexMEEG);
handles.inddis    =   [handles.indnomeeg handles.indexMEEG];
handles.indeeg = [meegchannels(D,'EEG') meegchannels(D,'LFP')];
% Default values

set(handles.normalize,'Value',0);

% Take the window size used to score
if isfield (handles.Dmeg{1},'CRC')
  if isfield (handles.Dmeg{1}.CRC,'score')
      handles.winsize   =   handles.Dmeg{1}.CRC.score{3,1};
  else 
      handles.winsize   =   crcdef.winsize;
  end 
else 
    handles.winsize     =   crcdef.winsize;
end 

handles.scale       =   crcdef.scale;
handles.eegscale    =   [];
handles.eogscale    =   [];
handles.emgscale    =   [];
handles.ecgscale    =   [];
handles.otherscale  =   [];
handles.lfpscale    =   [];
handles.megmagscale =   [];
handles.megplanarscale  =   [];
handles.chan        =   [];

%si ca revient de la d閠ection automatique
handles.artefacteeg = [];
if isfield(handles.Dmeg{1},'CRC')
    if isfield (handles.Dmeg{1}.CRC,'artefacteeg')
        handles.artefacteeg = handles.Dmeg{1}.CRC.artefacteeg; 
    end 
end  

%Spike detection
%---------------
handles.move = 0;
if  isfield(varargin{1},'type') % We come back from the "Event_menu"
    handles.type = varargin{1}.type;
else       % It's the begining
    D      = handles.Dmeg{1};
    handles.type = {};
    
    if isfield(D,'CRC')  %%不知道这个CRC到底是什么
       
        if isfield(D.CRC,'Event')&& ~isempty(events(D)) %changes made
            type_sauv = D.CRC.Event;
            tp = events(D);
            tpt = {tp(:).type};
            [goodev int_tpt int_sauv] = intersect(tpt,type_sauv(:,1));
            handles.type = type_sauv(int_sauv,:);
        else    
            evs    = events(D);
          
            if ~isempty(evs)
                valev  = {evs(:).value};
                type = cell(0);
                evm = 1;
                if isfield(D.CRC,'score')
                    nsc    = size(D.CRC.score,2);
                    type = cell(0);
                    for insc = 1 : nsc
                        for vv = 1 : length(valev)
                            if any(strcmpi( {(D.CRC.score{2,insc})},valev{vv}))||strcmpi('Newuser',valev{vv})
                                type(evm) = {evs(vv).type};
                                evm = evm + 1;
                            end
                        end
                    end
                else          
                    for vv = 1 : length(valev)
                        if any(strcmpi('Newuser',valev{vv}))
                            type(evm) = {evs(vv).type};
                            evm = evm + 1;
                        end
                    end
                end      
                tevm = cellstr(unique(char(type(:)),'rows'));
                ntevm = size(tevm,1);
                if ~isempty(type(:))
                    handles.type(1:ntevm,1)  = tevm;
                    handles.type(1:ntevm,2)  = cellstr('red');  
                end
            end
        end
    end 
end

delete(get(handles.manevent,'Children'));
for itp = 1:size(handles.type,1)
    uimenu(handles.manevent,'Label', char(handles.type(itp,1)),'Callback',@Define_event)
end

uimenu(handles.manevent,'Label', ...
    'New Type','Callback', @newtype_Callback,...
    'Separator','on') ;
%--------------------------------------------
%coming back from "detection" or "Event_menu"

if isfield(varargin{1},'scoresleep')
    handles.scoring     =   1;
else
    handles.scoring     =   0;
end

%-------------------------------------------

if isfield(varargin{1},'base')
   
    handles.base     =   varargin{1}.base;
    
else
    handles.base     =   {};
end

%---------------------------------------------
%if isfield(varargin{1},'delmap')
   % set(handles.delaymap,'visible','on'); 
   % set(handles.delaymap,'Value',1);
   % if isfield(varargin{1}.delmap,'elpos')
   %    handles.delmap.elpos    =   varargin{1}.delmap.elpos;
   % end
   % if isfield(varargin{1}.delmap,'zebris_name')
%        handles.delmap.zebris_name	=   varargin{1}.delmap.zebris_name;
  % end
   % if isfield(varargin{1}.delmap,'cas')
   %    handles.delmap.cas  =   varargin{1}.delmap.cas;
   % end
%else
  %  set(handles.delaymap,'visible','off');
   % set(handles.text25,'visible','off');
   % set(handles.delaymap,'Value',0);
   % handles.delmap  =   [];
%end

if isfield(varargin{1},'multcomp') %if comparing multiple files
     %%不知道这里面的'multcomp'对应的是什么
    handles.multcomp    =   1;
    handles.displevt    =   0;
    handles.export      =   0;  %%这几个后面的mainplot有用到，不知道到底是代表什么的
    handles.hor_grid    =   0;
    handles.vert_grid   =   0;
    set(handles.figure1, 'windowbuttonmotionfcn', '') 
    %函数windowbuttonmotionfcn，当鼠标在窗口上运动的时候就会相应此函数，
    %于是在此函数中可以设置运动时想要的代码,在这里没有输入函数，即没有响应
    %Handles date and hour and slider
    handles.date        =   varargin{1}.dates;
    handles.chanset     =   varargin{1}.chanset;
    maxdate     = max(max(handles.date));
    handles.maxdate     =   maxdate;
    mindate     =   min(min(handles.date));
    handles.mindate     =   mindate;
    mindatevec	=   datevec(min(min(handles.date)));
    diffe        =   maxdate-mindate;
    diffvec     =   datevec(diffe);
    if diffvec(3)+(diffvec(2)-1)*30+(diffvec(1)-1)*365 > 2
        handles.offset  =   0;
    else
        handles.offset  =   mindatevec(4) * 60^2 + mindatevec(5)*60 + mindatevec(6);
    end
    handles.maxx    =   diffvec(4)*60^2+diffvec(5)*60+diffvec(6);
    set(handles.slider1,'Value',1/handles.winsize);
    set(handles.slider1,'Max',handles.maxx-handles.winsize);
    set(handles.slider1,'Min',1/handles.winsize);
    set(handles.slider1,'SliderStep',[handles.winsize/(handles.maxx) 0.1]);
    set(handles.totaltime,'String',['/ ' num2str(handles.maxx)]);
    set(handles.currenttime,'String',num2str(round(handles.winsize/2)));
    set(handles.totalpage,'String',['/ ' num2str(ceil(handles.maxx/handles.winsize))]);
    set(handles.currentpage,'String',num2str(1));
    
    %disables channel slider
    set(handles.Chanslider,'enable','off');
    
    %handles popupmenustring using common channels
    popupmenustring = handles.chanset;%%在GUI界面上没找到chanset对应的对象
    if sum(strcmp(handles.chanset,'REF2'))
        popupmenustring     =   [popupmenustring 'MEAN OF REF'];
    end
    
    %handles visibility of different options
    set(handles.NbreChan,'enable','off','visible','off')
    set(handles.NbrechanTxt,'visible','off')
    set(handles.NbreChan,'Value',1)
    set(handles.Cmp_Pwr_Sp_All,'enable','on','visible','on')
    set(handles.axes2,'visible','off')
    set(handles.addundefart,'visible','off') 
    set(handles.addspecart,'visible','off')
    set(handles.addaro,'visible','off')
    set(handles.addeoi,'visible','off')
    set(handles.FPL,'visible','off')
    set(handles.OPL,'visible','off')
    set(handles.Delart,'visible','off')
    set(handles.Delaro,'visible','off')
    set(handles.Del_eoi,'visible','off')
    set(handles.Delartonlyone,'visible','off')
	set(handles.Detection,'visible','off')
    set(handles.addonlyone,'visible','off')	
    set(handles.others,'enable','off','visible','off')
    set(handles.com,'enable','off','visible','off')
	set(handles.manevent,'enable','off','visible','off')
    set(handles.event_menu,'enable','off')
    set(handles.counterspect,'enable','off','visible','off')	
   	
	for ii  =   1   :   size(handles.chanset,2)
        handles.multchanlab{ii}     =   uimenu(handles.multchan,'Label',...
            char(handles.chanset{ii}),'Callback',...
            {@Chantodisp});
        if ii   ==  handles.index
            set(handles.multchanlab{ii},'Checked','on')
            handles.Chantodis   =   ii;
        end
    end
    set(handles.figure1,'name','Multiple files comparison')

else %if only one file to display
    %set(handles.Detection,'visible','off') %Not ready yet
    handles.multcomp=0;
    set(handles.axes5,'visible','on');
    set(handles.axes4,'visible','on');

    %handles date and hour and slider

    if isfield(handles.Dmeg{1},'info')
        if isfield(handles.Dmeg{1}.info,'hour')
            handles.offset = handles.Dmeg{1}.info.hour(1) * 60^2 + ...
                handles.Dmeg{1}.info.hour(2)*60 + ...
                handles.Dmeg{1}.info.hour(3);
        end
    end

    set(handles.slider1,...
        'Max', nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2,...
        'Value',0,...
        'Min',0)%%%设置滚动条
    try
        set(handles.slider1,'SliderStep',[(handles.winsize)/(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2) 0.1])
    end
    set(handles.totaltime,'String',['/ ' ...
        num2str(round(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})))]);
    set(handles.currenttime,'String',num2str(round(handles.winsize/2)));
         %设置滚动条属性
%new index for page   设置页数显示
    set(handles.totalpage,'String',['/ ' ...
        num2str(ceil((nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/handles.winsize))]);
    set(handles.currentpage,'String',num2str(1));
   % Number of channels displayed
  
    Nchdisp     =   str2double(get(handles.NbreChan,'String'));
    set(handles.NbreChan,'String', num2str(min(Nchdisp, length(handles.indexMEEG) + length(handles.indnomeeg))))
    Nchdisp     =   str2double(get(handles.NbreChan,'String'));
    totind      =   length(handles.index); %length(handles.indexMEEG) + length(handles.indnomeeg);
    set(handles.Chanslider,...
        'Min',1,...
        'Max',totind - Nchdisp+1,...
        'Value',1,...
        'SliderStep', [Nchdisp/totind Nchdisp/totind]) 

    popupmenustring     =   chanlabels(handles.Dmeg{1}) ;
    if sum(strcmp(chanlabels(handles.Dmeg{1}),'REF2'))
        popupmenustring =   [popupmenustring 'MEAN OF REF'];
    end
    if and(sum(strcmp(chanlabels(handles.Dmeg{1}),'M1')), ...
            sum(strcmp(chanlabels(handles.Dmeg{1}),'M2')))
        popupmenustring =   [popupmenustring 'M1-M2'];
    end
    set(handles.figure1,'name',handles.file{1})
end
set(handles.Bsec,'value',0);
set(handles.Fsec,'value',0);
Fvalue = (get(handles.Fsec,'value'));
Bvalue = (get(handles.Bsec,'value'));
datapoints = 5000;%列数
totalpages=ceil((nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/handles.winsize);
load('datapath.mat');
save('datapath','MarValue','datapath','dataname','Fvalue','Bvalue');
if (MarValue==1)
    infoldername=strcat(datapath,'\');
    infilename=[infoldername,'Arousal_data.mat'];
    AroExist = exist(infilename,'file');%判断是否存在标记文件，如果不存在返回0，创建一个该文件
    set(handles.Chans,'Enable','on');
 %   set(handles.Aromark,'Enable','on');
   set(handles.togglebutton,'Enable','on');
    if (AroExist==0)
        Arousal_point = zeros(totalpages,datapoints);%建立一个数组，存放的数据都为0
        Mouse_pos = zeros(10,4,totalpages);
        save('Arousal_data','Arousal_point','Mouse_pos');
        Arou=load('Arousal_data');
        Arou.Fp1 = zeros(totalpages,datapoints);
        Arou.Fp2 = zeros(totalpages,datapoints);
        Arou.F3 = zeros(totalpages,datapoints);
        Arou.F4 = zeros(totalpages,datapoints);
        Arou.C3 = zeros(totalpages,datapoints);
        Arou.C4 = zeros(totalpages,datapoints);
        Arou.P3 = zeros(totalpages,datapoints);
        Arou.P4 = zeros(totalpages,datapoints);
        Arou.O1 = zeros(totalpages,datapoints);
        Arou.O2 = zeros(totalpages,datapoints);
        Arou.pos_Fp1 = zeros(10,4,totalpages);
        Arou.pos_Fp2 = zeros(10,4,totalpages);
        Arou.pos_F3 = zeros(10,4,totalpages);
        Arou.pos_F4 = zeros(10,4,totalpages);
        Arou.pos_C3 = zeros(10,4,totalpages);
        Arou.pos_C4 = zeros(10,4,totalpages);
        Arou.pos_P3 = zeros(10,4,totalpages);
        Arou.pos_P4 = zeros(10,4,totalpages);
        Arou.pos_O1 = zeros(10,4,totalpages);
        Arou.pos_O2 = zeros(10,4,totalpages); 
        Arou.j_fp1 = zeros(1,totalpages);
        Arou.j_fp2 = zeros(1,totalpages);
        Arou.j_f3 = zeros(1,totalpages);
        Arou.j_f4 = zeros(1,totalpages);
        Arou.j_c3 = zeros(1,totalpages);
        Arou.j_c4 = zeros(1,totalpages);
        Arou.j_p3 = zeros(1,totalpages);
        Arou.j_p4 = zeros(1,totalpages);
        Arou.j_o1 = zeros(1,totalpages);
        Arou.j_o2 = zeros(1,totalpages);
        save('Arousal_data','Arou')
    else
        load('Arousal_data.mat');
    end
else
    set(handles.Chans,'Enable','off');
 %    set(handles.Aromark,'Enable','off');
    set(handles.togglebutton,'Enable','off');
end

% Define filter according to the smallest sampling frequency
handles.filter.other    =   crcdef.filtEEG;
filt=zeros(size(handles.Dmeg,2),1);
for i=1:size(handles.Dmeg,2)
    filt(i)     =   fsample(handles.Dmeg{i})/2;
end
[filt,posf] = max(filt);
% Adjust filter order to sampling rate, low at 5kHz (EEG-fMRI data)
if filt>2000
    forder = 1;
else
    forder = 3;
end
handles.minsamp     =   posf;
handles.filter.EMG  =   [crcdef.filtEMG(1) ...
    min(crcdef.filtEMG(2),filt/2)];
handles.filter.EOG = crcdef.filtEOG;
[B,A] = butter(forder,[handles.filter.EOG(1)/(fsample(handles.Dmeg{posf})/2),...
    handles.filter.EOG(2)/(fsample(handles.Dmeg{posf})/2)],'bandpass');
handles.filter.coeffEOG=[B;A];
[B,A] = butter(forder,[handles.filter.EMG(1)/(fsample(handles.Dmeg{posf})/2),...
    handles.filter.EMG(2)/(fsample(handles.Dmeg{posf})/2)],'bandpass');
handles.filter.coeffEMG=[B;A];
[B,A] = butter(forder,[handles.filter.other(1)/(fsample(handles.Dmeg{posf})/2),...
    handles.filter.other(2)/(fsample(handles.Dmeg{posf})/2)],'bandpass');
handles.filter.coeffother=[B;A];
% set(handles.frqabv,'String',num2str(handles.filter.other(2)));
set(handles.upemg,'String',num2str(handles.filter.EMG(2)));

% popupmenu setting
popupmenustring	=   [popupmenustring 'REF1'];
set(handles.EEGpopmenu,...
    'String',popupmenustring,...
    'Value',length(popupmenustring))
set(handles.otherpopmenu,...
    'String',popupmenustring,...
    'Value',length(popupmenustring))
popupmenustring = [popupmenustring 'BIPOLAR'];
set(handles.EOGpopmenu,...
    'String',popupmenustring,...
    'Value',length(popupmenustring))
set(handles.EMGpopmenu,...
    'String',popupmenustring,...
    'Value',length(popupmenustring))

% Menu to display FFT for each window according to the channel selected
popmenustring   =   chanlabels(handles.Dmeg{1}, handles.inddis);
set(handles.fftchan, 'String', popmenustring,'Value', 1,'Visible','off');
load('data_int.mat');
%这部分要解决的是当标记时，只选一个电极时，出错，（Index exceeds matrix dimensions，SelChan=AllChan(Index);%所选通道的名字）
set(handles.Chans,'String',popmenustring,'Visible','on');
AllChan = get(handles.Chans,'string');%所有通道的名字
if length(base) == 1 %base 只有一个值
    set(handles.Chans,'Value',1);
    Index = 1;
else
    for i = 1:length(AllChan)
        is_C3 = strcmp(AllChan(i,1),'C3');
        if is_C3
            break;
        end
    end
    Index= i;
    set(handles.Chans,'Value',Index);
end

load('CRC_electrodes.mat');

%AllChan = get(handles.Chans,'string');%所有通道的名字
%Index=get(handles.Chans,'value');
SelChan=AllChan(Index);%所选通道的名字
SelChan=cell2mat(SelChan);
switch  SelChan
    case 'Fp1'
        ChanIndex=1;
    case 'Fp2'
        ChanIndex=2;
    case 'F3'
        ChanIndex=3;
    case 'F4'
        ChanIndex=4;
    case 'C3'
        ChanIndex=5;
    case 'C4'
        ChanIndex=6;
    case 'P3'
        ChanIndex=7;
    case 'P4'
        ChanIndex=8;
    case 'O1'
        ChanIndex=9;
    case 'O2'
        ChanIndex=10;%这样就能得到所选通道对应电极帽的位置
end
% set(handles.Chans,'String',popmenustring,'Value',5,'Visible','on');
if MarValue==1
    save('Arousalchan_data','AllChan','ChanIndex','SelChan')%将这些在之后的纺锤波标记需要用到的数据保存
end
handles.names       =   names;
handles.crc_types   =   crc_types;
handles.pos         =   pos';
%events display, only if one file

if ~handles.multcomp
    handles.displevt    =   0;
   
    pmstring    =   [{'All'}];
    evt         =   events(handles.Dmeg{1});
    evt = evt(:);
    if iscell(evt)
        evt     =   cell2mat(evt);
        disp(['Warning: data not continuous (trials of 1s), only first epoch showed'])
    end
    if ~isempty(evt)
        for i = 1:max(size(evt,2),size(evt,1))
            if ~isempty(evt(i)) && ~any(strcmpi(evt(i).type, pmstring)) &&...
                     ~isempty(evt(i).time)
                pmstring    =   [pmstring, {evt(i).type}];
            end
        end
    end

    if ~isempty(evt)
        for i = 1:size(evt,2)
            if ~isempty(evt(i)) && isnumeric(evt(i).value)
                evt(i).value    =   num2str(evt(i).value);
            end
            if ~isempty(evt(i)) && ~any(strcmpi(evt(i).value, pmstring)) &&...
                    ~isempty(evt(i).time)
                pmstring    =   [pmstring, {evt(i).value}];
            end
        end
    end
  %set(handles.popupmenu10,...
   %     'String',pmstring,...
    %    'Value',length(pmstring))
    pmstring=[{'All'}, {'Number of event'}];
    if ~isempty(evt)
        for i = 1:size(evt,2)
            if ~isempty(evt(i)) && isnumeric(evt(i).value)
                evt(i).value    =   num2str(evt(i).value);
            end
            if ~isempty(evt(i)) && ~any(strcmpi(evt(i).value, pmstring)) &&...
                    ~isempty(evt(i).time)
                pmstring    =   [pmstring, {evt(i).value}];
            end
        end
    end
    %set(handles.popupmenu11,...
     %   'String',pmstring,...
      %  'Value',length(pmstring))
    handles.evt     =   evt;
    handles.chostype    =   1:max(size(evt,2),size(evt,1));
    handles.chosevt     =   1:max(size(evt,2),size(evt,1));
    if isfield(handles.Dmeg{1},'CRC') && ...
            isfield(handles.Dmeg{1}.CRC,'lastdisp')
        slidval=handles.Dmeg{1}.CRC.lastdisp;
        set(handles.slider1,'Value',slidval)
    end
    set(handles.figure1,'MenuBar','figure')

    %Scoring information if only one file
    handles.vert_grid   =   0;
    handles.hor_grid    =   0;
    handles.export      =   0;
    
    set(handles.figure1, 'windowbuttonmotionfcn', @update_powerspect)
    %%鼠标移动时调用函数update_powerspect
    %%%%调用主界面montage的score
    
    if handles.scoring
        
        Score_Callback(hObject,eventdata,handles)
        handles         =   guidata(hObject);
    else
        handles.score   =   cell(8,1);
        handles.score{4,1}  =   [1/fsample(handles.Dmeg{1}) ...
                                nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})];
        handles.score{2,1}  =   'Newuser';
        handles.score{1,1}  =   [0/0, 0/0];
        set(handles.figure1,'CurrentAxes',handles.axes4)
        %Select the scorer according to the last used
		if isfield(varargin{1},'user')
            handles.currentscore = varargin{1}.user;
        else 
            handles.currentscore    =   1;
        end 
 
         crc_plothypno(handles.axes4,handles.score{4,handles.currentscore},handles,handles.winsize)
      
        set(handles.figure1,'CurrentAxes',handles.axes1)
        set(handles.addundefart,'visible','off')        
		set(handles.addonlyone,'visible','off')
        set(handles.addspecart,'visible','off')
        set(handles.addaro,'visible','off')
        set(handles.addeoi,'visible','off')
        set(handles.FPL,'visible','off')
        set(handles.OPL,'visible','off')
        set(handles.Delart,'visible','off')
        set(handles.Delartonlyone,'visible','off')
        set(handles.Delaro,'visible','off')
        set(handles.Del_eoi,'visible','off')
        set(handles.manevent,'visible','off') %To make visible to put events manually
        set(handles.Detection,'visible','on')
    end
end
%handles.Dmeg    =   varargin{1}.Dmeg;
D   =   handles.Dmeg{1};

if ~isfield(D,'info')
    D.info  =   [];     %in case field other empty set info to allow
end                        %further dot name structure assignments

if ~isfield (D,'CRC')
    D.CRC   =   [];
end

% initalize the field 'goodevents' in D.CRC and, if spindle or slow wave
% detection was performed, retrieve which events were marked as bad.
aevt = events(D);
D.CRC.goodevents    =   ones(1,numel(aevt));

if iscell(aevt)
    aevt   =   cell2mat(aevt);
end

if ~isempty(aevt)
    evtype  =   [{aevt(:).type}];
    if isfield(D.CRC,'SW')
        indsw   =   [];
        for j   =   1   :   size(evtype,2)
            if ~isempty(strfind(evtype{j},'SW'))|| ~isempty(strfind(evtype{j},'delta'))
                indsw	=   [indsw,j];
            end
        end
        for i   =  1    :   size(D.CRC.SW.SW,2)       
            a   =   [aevt(indsw).time];
            [d1,b]  =   sort(abs(round(a)-round([D.CRC.SW.SW(i).negmax]/1000)));
            if ~isfield(D.CRC.SW.SW(i),'good')
                D.CRC.SW.SW(i).good=1;
            end
            D.CRC.goodevents(indsw(b(1)))   =   D.CRC.SW.SW(i).good;
        end
    end
    if isfield(D.CRC,'spindles')
        indsp   =   [];
        for j   =   1   :   size(evtype,2)
            if ~isempty(strfind(evtype{j},'SP'))
                indsp   =  [indsp,j];
            end
        end
        for i   =   1   :   size(D.CRC.spindles.bounds,1)
            a   =   [aevt(indsp).time];
            [d1,b]  =   sort(abs(round(a*10)-round(D.CRC.spindles.bounds(i,1)/fsample(handles.Dmeg{1})*10)));
            if ~isfield(D.CRC.spindles,'good')
                D.CRC.spindles.good(i)=1;
            end
            D.CRC.goodevents(indsp(b(1)))   =   D.CRC.spindles.good(i);
        end
    end
end

handles.Dmeg{1}     =   D;
save(D);

% to display the main plot
mainplot(handles)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dis_score_500 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dis_score_500_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.displevt=0;
%removed and then readd%%%%%%%%
if isfield(handles,'scoring') & handles.scoring
    set(handles.figure1,'CurrentAxes',handles.axes4)
    crc_hypnoplot(handles.axes4, ...
        handles,handles.score{3,handles.currentscore})
    set(handles.figure1,'CurrentAxes',handles.axes1)
end
%%%%%%%%%%%%%%%%%
mainplot(handles);
% Update handles structure
guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
if handles.multcomp
    handles.winsize = min(str2double(get(hObject,'String')),handles.maxx);
    maxiwin         = handles.maxx-handles.winsize;
    miniwin         = 1/handles.winsize;
else
    handles.winsize = min(str2double(get(hObject,'String')), ...
        round(nsamples(handles.Dmeg{1})/(2*fsample(handles.Dmeg{1}))));
    maxiwin         = nsamples(handles.Dmeg{1})/ ...
        fsample(handles.Dmeg{1})-handles.winsize;
    miniwin         = 1/fsample(handles.Dmeg{1});
end
set(handles.edit1,'String',num2str(handles.winsize));
set(handles.slider1,'Max',maxiwin);
set(handles.slider1,'Min',miniwin);
set(handles.slider1,'SliderStep',[handles.winsize/maxiwin 0.1]);
set(handles.totalpage,'String',['/ ' ...
        num2str(ceil((nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/handles.winsize))]);
mainplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
if not(str2double(get(hObject,'String'))>0)&& not(str2double(get(hObject,'String'))<0)
    set(handles.edit2,'String',num2str(handles.scale));
else
    handles.scale=str2double(get(hObject,'String'));
end

% Update handles structure
guidata(hObject, handles);

mainplot(handles);

if handles.multcomp
    i   =   length(handles.Dmeg);
else
    Chanslidval =   get(handles.Chanslider,'Value');
    slidpos     =   Chanslidval-rem(Chanslidval,1);
    NbreChandisp    =   str2double(get(handles.NbreChan,'String'));
    i   =   min(length(handles.indexMEEG) + length(handles.indnomeeg),NbreChandisp); 
end
ylim([0 handles.scale*(i+1)]);
set(handles.axes1,'YTick',[handles.scale/2:handles.scale/2:i*handles.scale+handles.scale/2]);
ylabels=[num2str(round(handles.scale/2))];
for j=1:i
    if handles.multcomp
        ylabels=[ylabels {num2str(j)}];
    else
        ylabels=[ylabels chanlabels(handles.Dmeg{1},handles.index(j))];
    end
    ylabels=[ylabels num2str(round(handles.scale/2))];
end
set(handles.axes1,'YTickLabel',ylabels);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%pushbutton1返回重新选择电极
%pushbutton2____view another file


function currenttime_Callback(hObject, eventdata, handles)
% hObject    handle to currenttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i=handles.minsamp;
slidval = str2double(get(hObject,'String')); % str2double is faster than str2num
slidval = max(slidval - handles.winsize/2,1/fsample(handles.Dmeg{i}));

if handles.multcomp
    maxiwin=handles.maxx-handles.winsize;
else
    maxiwin=nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize;
end
slidval = min(slidval,maxiwin);
set(handles.slider1,'Value',slidval)

%Remove and then readd...to be checked
if handles.scoring
    set(handles.figure1,'CurrentAxes',handles.axes4)
    crc_hypnoplot(handles.axes4, ...
        handles,handles.score{3,handles.currentscore})
    set(handles.figure1,'CurrentAxes',handles.axes1)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mainplot(handles);
% Hints: get(hObject,'String') returns contents of currenttime as text
%        str2double(get(hObject,'String')) returns contents of currenttime as a double


% --- Executes during object creation, after setting all properties.
function currenttime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currenttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function currentpage_Callback(hObject, eventdata, handles)
% hObject    handle to currentpage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentpage as text
%        str2double(get(hObject,'String')) returns contents of currentpage as a double
i=handles.minsamp;
pageval = floor(str2double(get(hObject,'String'))); % str2double is faster than str2num
pageval = max(pageval,1);

if handles.multcomp
    maxiwin=floor((handles.maxx-handles.winsize)/handles.winsize);
else
    maxiwin=ceil((nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/handles.winsize);
end
pageval = min(pageval,maxiwin);
slidval = max((pageval-1)*handles.winsize,handles.winsize/2);
set(handles.slider1,'Value',slidval)
if handles.scoring
    set(handles.figure1,'CurrentAxes',handles.axes4)
    crc_hypnoplot(handles.axes4, ...
        handles,handles.score{3,handles.currentscore})
    set(handles.figure1,'CurrentAxes',handles.axes1)
end
mainplot(handles);

% --- Executes during object creation, after setting all properties.
function currentpage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentpage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function frqabv_Callback(hObject, eventdata, handles)
% hObject    handle to frqabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frqabv as text
%        str2double(get(hObject,'String')) returns contents of frqabv as a double
frbe = str2double(get(hObject,'String'));
i = handles.minsamp;
if not(isnan(frbe)) && length(frbe)==1
    if frbe>fsample(handles.Dmeg{i})/2*.99
        handles.filter.other(2) = fsample(handles.Dmeg{i})/2*.99;
        set(hObject,'String',num2str(fsample(handles.Dmeg{i})/2));
    else
        handles.filter.other(2) = frbe;
    end
else
    beep
    set(hObject,'String',num2str(handles.filter.other(2)));
    return
end
if fsample(handles.Dmeg{i})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[handles.filter.other(1)/(fsample(handles.Dmeg{i})/2),...
    handles.filter.other(2)/(fsample(handles.Dmeg{i})/2)],'bandpass');
handles.filter.coeffother=[B;A];

% Plot 
mainplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function frqabv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frqabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function frqblw_Callback(hObject, eventdata, handles)
% hObject    handle to frqblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frqblw as text
%        str2double(get(hObject,'String')) returns contents of frqblw as a double
frbe    =   str2double(get(hObject,'String'));
i       =   handles.minsamp;
if not(isnan(frbe)) && length(frbe)==1
    if frbe<0.0001
        handles.filter.other(1)=0.0001;
        set(hObject,'String',num2str(0.0001));
    else
        handles.filter.other(1) = frbe;
    end
else
    beep
    set(hObject,'String',num2str(handles.frqbelow));
    return
end
if fsample(handles.Dmeg{i})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[handles.filter.other(1)/(fsample(handles.Dmeg{i})/2),...
    handles.filter.other(2)/(fsample(handles.Dmeg{i})/2)],'bandpass');
handles.filter.coeffother=[B;A];
%guidata(hObject, handles);

mainplot(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function frqblw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frqblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function downemg_Callback(hObject, eventdata, handles)
% hObject    handle to downemg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of downemg as text
%        str2double(get(hObject,'String')) returns contents of downemg as a double
frbe=str2double(get(hObject,'String'));
i=handles.minsamp;
if not(isnan(frbe)) && length(frbe)==1
    if frbe<0.0001
        handles.filter.EMG(1)=0.0001;
        set(hObject,'String',num2str(0.0001));
    else
        handles.filter.EMG(1) = frbe;
    end
else
    beep
    set(hObject,'String',num2str(handles.filter.EMG(1)));
    return
end
if fsample(handles.Dmeg{i})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[handles.filter.EMG(1)/(fsample(handles.Dmeg{i})/2),...
    handles.filter.EMG(2)/(fsample(handles.Dmeg{i})/2)],'bandpass');
handles.filter.coeffEMG=[B;A];
guidata(hObject, handles);
mainplot(handles);
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function downemg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to downemg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upemg_Callback(hObject, eventdata, handles)
% hObject    handle to upemg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upemg as text
%        str2double(get(hObject,'String')) returns contents of upemg as a double
frbe	=   str2double(get(hObject,'String'));
i   =   handles.minsamp;
if not(isnan(frbe)) && length(frbe)==1
    if frbe>fsample(handles.Dmeg{i})/2*.99
        handles.filter.EMG(2)=fsample(handles.Dmeg{i})/2*.99;
        set(hObject,'String',num2str(fsample(handles.Dmeg{i})/2));
    else
        handles.filter.EMG(2) = frbe;
    end
else
    beep
    set(hObject,'String',num2str(handles.filter.EMG(2)));
    return
end
if fsample(handles.Dmeg{i})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[handles.filter.EMG(1)/(fsample(handles.Dmeg{i})/2),...
    handles.filter.EMG(2)/(fsample(handles.Dmeg{i})/2)],'bandpass');
handles.filter.coeffEMG=[B;A];
guidata(hObject, handles);
% Main plot  
mainplot(handles);
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function upemg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upemg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function downeog_Callback(hObject, eventdata, handles)
% hObject    handle to downeog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of downeog as text
%        str2double(get(hObject,'String')) returns contents of downeog as a double
frbe=str2double(get(hObject,'String'));
i=handles.minsamp;
if not(isnan(frbe)) && length(frbe)==1
    if frbe<0.0001
        handles.filter.EOG(1)=0.0001;
        set(hObject,'String',num2str(0.0001));
    else
        handles.filter.EOG(1) = frbe;
    end
else
    beep
    set(hObject,'String',num2str(handles.filter.EOG(1)));
    return
end
if fsample(handles.Dmeg{i})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[handles.filter.EOG(1)/(fsample(handles.Dmeg{i})/2),...
    handles.filter.EOG(2)/(fsample(handles.Dmeg{i})/2)],'bandpass');
handles.filter.coeffEOG=[B;A];
guidata(hObject, handles);
mainplot(handles);
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function downeog_CreateFcn(hObject, eventdata, handles)
% hObject    handle to downeog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upeog_Callback(hObject, eventdata, handles)
% hObject    handle to upeog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upeog as text
%        str2double(get(hObject,'String')) returns contents of upeog as a double
frbe = str2double(get(hObject,'String'));
i = handles.minsamp;
if not(isnan(frbe)) && length(frbe)==1
    if frbe>fsample(handles.Dmeg{i})/2*.99
        handles.filter.EOG(2) = fsample(handles.Dmeg{i})/2*.99;
        set(hObject,'String',num2str(fsample(handles.Dmeg{i})/2));
    else
        handles.filter.EOG(2) = frbe;
    end
else
    beep
    set(hObject,'String',num2str(handles.filter.EOG(2)));
    return
end
if fsample(handles.Dmeg{i})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[handles.filter.EOG(1)/(fsample(handles.Dmeg{i})/2),...
    handles.filter.EOG(2)/(fsample(handles.Dmeg{i})/2)],'bandpass');
handles.filter.coeffEOG=[B;A];
guidata(hObject, handles);
mainplot(handles);
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function upeog_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upeog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in EEGpopmenu.
function EEGpopmenu_Callback(hObject, eventdata, handles)
% hObject    handle to EEGpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EEGpopmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EEGpopmenu
mainplot(handles);

% --- Executes during object creation, after setting all properties.
function EEGpopmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EEGpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in EOGpopmenu.
function EOGpopmenu_Callback(hObject, eventdata, handles)
% hObject    handle to EOGpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EOGpopmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EOGpopmenu
mainplot(handles);

% --- Executes during object creation, after setting all properties.
function EOGpopmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EOGpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in EMGpopmenu.
function EMGpopmenu_Callback(hObject, eventdata, handles)
% hObject    handle to EMGpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EMGpopmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EMGpopmenu
mainplot(handles);

% --- Executes during object creation, after setting all properties.
function EMGpopmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EMGpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in otherpopmenu.
function otherpopmenu_Callback(hObject, eventdata, handles)
% hObject    handle to otherpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns otherpopmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from otherpopmenu
mainplot(handles);

% --- Executes during object creation, after setting all properties.
function otherpopmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to otherpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------
%Compute the power spectrum on one or all channels when right click--------
%--------------------------------------------------------------------------

% --------------------------------------------------------------------
function Pwr_spect_Callback(hObject, eventdata, handles)

% hObject    handle to Pwr_spect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function Cmp_Pwr_Sp_Callback(hObject, eventdata, handles)
% hObject    handle to Cmp_Pwr_Sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hand    =   get(handles.axes1,'Children');
Mouse   =   get(handles.axes1,'CurrentPoint');
Chan    =   ceil((Mouse(1,2)-handles.scale/2)/handles.scale);
slidval =   get(handles.slider1,'Value');

if handles.figz~=0
    z   =   handles.figz;
else
    z   =   figure;
end
figure(z);
axs     =   get(handles.figz,'Children');
cleargraph(handles.figz) %change made

if handles.multcomp
    fil     =   min(max(1,Chan),length(handles.Dmeg));
    Ctodis  =	handles.Chantodis;
    [dumb1,dumb2,Chan]  =   intersect(handles.chanset{Ctodis}, ...
                            upper(chanlabels(handles.Dmeg{fil})));
    start   =   datevec(handles.date(fil,1)-handles.mindate);
    start   =   start(4)*60^2+start(5)*60+start(6);
    beg     =   slidval - start;
    tdeb    =   round(beg*fsample(handles.Dmeg{fil}));
    temps   =   tdeb:1:min(tdeb+(fsample(handles.Dmeg{fil})*handles.winsize), ...
                nsamples(handles.Dmeg{fil}));
    toshow  =   temps;
    cmap 	=   hsv(length(handles.Dmeg));
    Col     =   fil;
else
    fil     =   1;
    Chan    =   min(max(1,Chan),length(handles.indexMEEG) + length(handles.indnomeeg));
    NbreChandisp    =   str2double(get(handles.NbreChan,'String'));
    Chanslidval     =   get(handles.Chanslider,'Value');
    slidpos         =   Chanslidval-rem(Chanslidval,1);
	index           =   [handles.indnomeeg handles.indexMEEG];
	handles.inddis  =   index(slidpos : 1 : slidpos + NbreChandisp -1);
    Chan            =   index(Chan);
    chandis         =   chanlabels(handles.Dmeg{fil},Chan);
    fs              =   fsample(handles.Dmeg{fil});
    tdeb            =   round(slidval*fs);
    temps           =   tdeb:1:min(tdeb+(fs*handles.winsize), ...
                        nsamples(handles.Dmeg{fil}));
    toshow          =   temps;
    cmap            =   [0.2 0.9 0.5; 1 0 0; 0 0 1 ];
end

tdeb_w = round(slidval*fs);
tend_w = min(tdeb+(fs*handles.winsize), ...
                        nsamples(handles.Dmeg{fil}));
tohid_all = [];
if ~isempty(handles.score{5,handles.currentscore}) 
    tdebs   =   str2double(get(handles.currenttime,'String')) - handles.winsize/2;
    tfins   =   str2double(get(handles.currenttime,'String')) + handles.winsize/2;
    art     =   find(and((or(and(handles.score{5,handles.currentscore}(:,2)>tdebs,handles.score{5,handles.currentscore}(:,2)<tfins),...
                and(handles.score{5,handles.currentscore}(:,1)<tfins,handles.score{5,handles.currentscore}(:,1)>tdebs))),...
                or(handles.score{5,handles.currentscore}(:,3) == 0,handles.score{5,handles.currentscore}(:,3) == Chan)));
    art_concerned   =   handles.score{5,handles.currentscore}(art,1:2);
    if ~isempty(art_concerned)
        a=1;
        while a <= size(art_concerned,1)
            art_concerned(a);
            begart      =   max(tdeb_w,round(art_concerned(a,1)*fs));
            endart      =   min(tend_w,round(art_concerned(a,2)*fs)); 
            tohid2   	=   begart : endart;
            tohid_all   =   union(tohid_all,tohid2);
            tdeb_w      =   endart;
            a   =  a+1;
        end 
        toshow 	=   setdiff(toshow,tohid_all);
    end 
end
if length(toshow)<(handles.winsize/2)*fs        %More than 50% of artefacts
    h = msgbox('There is too much artefact on this channel');
    close(figure(z))
else
    fs      =   fsample(handles.Dmeg{fil});
    leg     =   cell(0);
    hold on;
    [dumb1,dumb2,index2] = ...
        intersect(upper(chanlabels(handles.Dmeg{fil},Chan)),handles.names);
    if abs(handles.crc_types(index2))>1
        if handles.crc_types(index2)>0
            [dumb1,index1,dumb2] = ...
                intersect(upper(chanlabels(handles.Dmeg{fil})), ...
                upper(handles.names(handles.crc_types(index2))));
            try
                X   =   handles.Dmeg{fil}(Chan,toshow) - ...
                        handles.Dmeg{fil}(index1,toshow);
                Col	= 1;
            catch
                X   = 0;
            end
        else
            range   =   max(handles.Dmeg{fil}(Chan,toshow)) - ...
                        min(handles.Dmeg{fil}(Chan,toshow));
            try
                X   = 	(handles.scale)*handles.Dmeg{fil}(Chan,toshow)/range;
                Col =   2;
            catch
                X   =   0;
            end
        end
    else
        try
            X   =   handles.Dmeg{fil}(Chan,toshow);
            Col	=   3;
        catch
            X   =   0;
        end
    end
    if length(X) == 1
        text(0.75,1, 'No Signal here');
        xlim([0 2]);
        ylim([0 2]);
        grid off;
    else
        X       =   filterforspect(handles,X,[0.001 fs/3],fil);
        [P,F]   =   pwelch(X,[],[],[],fs);
        P       =   log(P);
        plot(F,P,'Color',cmap(Col,:))
        grid on;
        titre   =   chandis;
        title(titre);
        ylabel('Log of power');
        xlabel('Frequency in Hz');
        [dumb name]     =   fileparts(handles.Dmeg{fil}.fname);
        under           =   find(name=='_');
        name(under)     =   ' ';
        leg{length(leg)+1}  =	name;
        legend(leg);
        axis auto
        xlim([0 20])
    end
end

handles.figz=z;

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function Cmp_Pwr_Sp_All_Callback(hObject, eventdata, handles)
% hObject    handle to Cmp_Pwr_Sp_All (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cmap = hsv(length(handles.Dmeg));

if handles.figz~=0
    z=handles.figz;
else
    z=figure;
end
figure(z)
axs=get(handles.figz,'Children');
cleargraph(z)

leg=cell(0);
for ii=1:size(cmap,1)
    fs=fsample(handles.Dmeg{ii});
    slidval = get(handles.slider1,'Value');
    start = datevec(handles.date(ii,1)-handles.mindate);
    start = start(4)*60^2+start(5)*60+start(6);
    beg = slidval - start;
    tdeb=round(beg*fsample(handles.Dmeg{ii}));
    temps=tdeb:1:min(tdeb+(fs*handles.winsize), ...
        nsamples(handles.Dmeg{ii}));
    toshow=temps;
    temps=(temps)/fsample(handles.Dmeg{ii})+start;
    Ctodis = handles.Chantodis;
    [dumb1,dumb2,index] = intersect(handles.chanset{Ctodis}, ...
                                    upper(chanlabels(handles.Dmeg{ii})));
    hold on;
    [dumb1,dumb2,index2] = ...
        intersect(upper(chanlabels(handles.Dmeg{ii},index)),handles.names);
    if abs(handles.crc_types(index2))>1
        if handles.crc_types(index2)>0
            [dumb1,index1,dumb2] = ...
                intersect(upper(chanlabels(handles.Dmeg{ii})), ...
                upper(handles.names(handles.crc_types(index2))));
            try
                X = handles.Dmeg{ii}(index,toshow)- ...
                    handles.Dmeg{ii}(index1,toshow);
            catch
                X = 0;
            end
        else
            range = max(handles.Dmeg{ii}(index,toshow))- ...
                min(handles.Dmeg{ii}(index,toshow));
            try
                X =(handles.scale)*handles.Dmeg{ii}(index,toshow)/range;
            catch
                X = 0;
            end
        end
    else
        try
            X = handles.Dmeg{ii}(index,toshow);
        catch
            X = 0;
        end
    end

    if length(X) == 1
    else
        [P,F] = pwelch(X,[],[],[],fs);
        P = log(P);
        hold on
        plot(F,P,'Color',cmap(ii,:))
        [dumb name] = fileparts(handles.Dmeg{ii}.fname);
        under=find(name=='_');
        name(under)=' ';
        leg{length(leg)+1}=name;
    end
end
grid on;
titre = char(handles.chanset{Ctodis});
title(titre);
legend(leg);
ylabel('Log of power');
xlabel('Frequency in Hz');
xlim([0 20]);

handles.figz=z;

% Update handles structure
guidata(hObject, handles);


%--------------------------------------------------------------------------
% Export in a matlab figure------------------------------------------------
%--------------------------------------------------------------------------
function Export_Callback(hObject, eventdata, handles)

% hObject    handle to Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.export=1;
z=figure;
axs=axes;
set(z,'CurrentAxes',axs)
handles.currentfigure=z;
mainplot(handles)
ha=get(handles.currentfigure,'CurrentAxes');
%display y-labels
if handles.multcomp
    i=length(handles.Dmeg);
else
    Chanslidval     =   get(handles.Chanslider,'Value');
    slidpos         =   Chanslidval-rem(Chanslidval,1);
    NbreChandisp    =   str2double(get(handles.NbreChan,'String'));
    index           =   handles.index(slidpos:1:slidpos+NbreChandisp-1);
    i   =   length(index);
end
ylim([0 handles.scale*(i+1)])
set(ha,'YTick',[handles.scale/2:handles.scale/2:i*handles.scale+handles.scale/2]);
ylabels     =   [num2str(round(handles.scale/2))];
for j=1:i
    if handles.multcomp
        ylabels=[ylabels num2str(j)];
    else
        ylabels=[ylabels chanlabels(handles.Dmeg{1},index(j))];
    end
    ylabels=[ylabels num2str(round(handles.scale/2))];
end
set(ha,'YTickLabel',ylabels);

%display x-labels
slidval=get(handles.slider1,'Value');
xlim([slidval slidval+handles.winsize])
xtick = get(handles.axes1,'XTick');
if isfield(handles,'offset')
    xtick = mod(xtick + handles.offset,24*60^2);
end
[time string] = crc_time_converts(xtick);
set(ha,'XTickLabel',string)

handles.figz=z;
handles.export=0;

% Update handles structure
guidata(hObject, handles);

return

%--------------------------------------------------------------------------
%Management of number of channels and slider-------------------------------
%--------------------------------------------------------------------------

%Slider for the channels when only one file
% --- Executes on slider movement.
function Chanslider_Callback(hObject, eventdata, handles)
% hObject    handle to Chanslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slidval = get(handles.Chanslider,'Value');
set(handles.Chanslider,'Value',slidval-rem(slidval,1))
mainplot(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Chanslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Chanslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function NbreChan_Callback(hObject, eventdata, handles)
% hObject    handle to NbreChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NbreChan as text
%        str2double(get(hObject,'String')) returns contents of NbreChan as a double
Nchdispmeeg = str2double(get(handles.NbreChan,'String'));
if ~isnan(Nchdispmeeg) && length(Nchdispmeeg)==1
    set(handles.NbreChan,'String', num2str(min(Nchdispmeeg, length(handles.indexMEEG) + length(handles.indnomeeg))));
    Nchdisp = str2double(get(handles.NbreChan,'String'));
    totind  = length(handles.indnomeeg) + length(handles.indexMEEG);
    set(handles.Chanslider,...
        'Min',1,...
        'Max', totind - Nchdisp+1,...
        'Value',1,...
        'SliderStep', [Nchdisp/totind Nchdisp/totind]);   
else
    beep
    set(handles.NbreChan,'String', num2str(10))
end
mainplot(handles);
guidata(hObject,handles);

% --- Executes on button press in normalize.
function normalize_Callback(hObject, eventdata, handles)
% hObject    handle to normalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normalize

norm = get(handles.normalize,'Value');
indexMEGPLAN = intersect(meegchannels(handles.Dmeg{1}, 'MEGPLANAR'), handles.index);
if norm
    n = 0;
    S = struct(handles.Dmeg{1});
    handles.indexnorm = [];
    handles.nind = [];
    while n <=length(indexMEGPLAN)-1
        n = n+1;
        while (n<=length(indexMEGPLAN)-1)&&(S.channels(indexMEGPLAN(n)).X_plot2D == S.channels(indexMEGPLAN(n+1)).X_plot2D)&(S.channels(indexMEGPLAN(n)).Y_plot2D == S.channels(indexMEGPLAN(n+1)).Y_plot2D)
                handles.indexnorm = [handles.indexnorm indexMEGPLAN(n)];
                handles.nind = [handles.nind indexMEGPLAN(n+1)];
                n = n+2;
        end 
        if n<=length(indexMEGPLAN)
            handles.nind = [handles.nind indexMEGPLAN(n)];
        end
        
    end
    [name ind] = intersect(handles.indexMEEG, handles.nind);
    while ~isempty(ind)
        handles.indexMEEG = [handles.indexMEEG(1:ind(1)-1) handles.indexMEEG(ind(1) + 1 : length(handles.indexMEEG))];
        ind = ind(2:end);
    end
else 
    handles.indexMEEG = handles.index(length(handles.indnomeeg)+1:length(handles.index));
end
%Update the number of channels available
NbreChan    =   length(handles.indexMEEG) + length(handles.indnomeeg);   
Nchdisp     =   min(str2double(get(handles.NbreChan,'String')),NbreChan);
handles.inddis = [handles.indnomeeg handles.indexMEEG];

set(handles.NbreChan,'String',Nchdisp);
totind  =   length(handles.indexMEEG)+length(handles.indnomeeg);
set(handles.Chanslider,...
        'Min',1,...
        'Max',totind - Nchdisp+1,...
        'Value',1,...
        'SliderStep', [Nchdisp/totind Nchdisp/totind]);
guidata(hObject,handles);
mainplot(handles);

%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%end to be checked%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
% --- Executes during object creation, after setting all properties.
% --- Executes during object creation, after setting all properties.
function NbreChan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NbreChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------
%Management of the scales -------------------------------------------------
%--------------------------------------------------------------------------

%Menu of scales
% --- Executes on selection change in menu scales.
function scales_Callback(hObject, eventdata, handles)
% hObject    handle to scales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%EEG scale
function scale_eeg_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eegsc=spm_input('EEG scale?',1,'s','1');
close gcf
try
    handles.eegscale=eval(eegsc);
catch
    if strcmpi(eegsc,'V')
        handles.eegscale=10^-6;
    elseif strcmpi(eegsc,'礦')
        handles.eegscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or 礦')
        handles.eegscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

%EOG scale
% --- Executes on selection change in menu scales.
function scale_eog_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eogsc=spm_input('EOG scale?',1,'s','1');
close gcf
try
    handles.eogscale=eval(eogsc);
catch
    if strcmpi(eogsc,'V')
        handles.eogscale=10^-6;
    elseif strcmpi(eogsc,'礦')
        handles.eogscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or 礦')
        handles.eogscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

%EMG scale
% --- Executes on selection change in menu scales.
function scale_emg_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
emgsc=spm_input('EMG scale?',1,'s','1');
close gcf
try
    handles.emgscale=eval(emgsc);
catch
    if strcmpi(emgsc,'V')
        handles.emgscale=10^-6;
    elseif strcmpi(emgsc,'礦')
        handles.emgscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or 礦')
        handles.emgscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

%ECG scale
% --- Executes on selection change in menu scales.
function scale_ecg_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecgsc=spm_input('ECG scale?',1,'s','1');
close gcf
try
    handles.ecgscale=eval(ecgsc);
catch
    if strcmpi(ecgsc,'V')
        handles.ecgscale=10^-6;
    elseif strcmpi(ecgsc,'礦')
        handles.ecgscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or 礦')
        handles.ecgscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

%LFP scale
% --- Executes on selection change in menu scales.
function scale_lfp_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecgsc=spm_input('LFP scale?',1,'s','1');
close gcf
try
    handles.lfpscale=eval(ecgsc);
catch
    if strcmpi(ecgsc,'V')
        handles.lfpscale=10^-6;
    elseif strcmpi(ecgsc,'礦')
        handles.lfpscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or 礦')
        handles.lfpscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

%Other scale
% --- Executes on selection change in menu scales.
function scale_other_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecgsc=spm_input('Other scale?',1,'s','1');
close gcf
try
    handles.otherscale=eval(ecgsc);
catch
    beep
    disp('Enter scale in 10^-x format')
    handles.otherscale=[];
    return
end
mainplot(handles)
guidata(hObject, handles);


%Menu of MEG scales
% --- Executes on selection change in menu scales.
function scale_meg_Callback(hObject, eventdata, handles)
% hObject    handle to scales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%ECG scale
% --- Executes on selection change in menu scales.
function scale_megmag_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecgsc=spm_input('Magnometers scale?',1,'s','1');
close gcf
try
    handles.megmagscale=eval(ecgsc);
catch
    if strcmpi(ecgsc,'T')
        handles.megmagscale=10^-12;
    elseif strcmpi(ecgsc,'fT')
        handles.megmagscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or T or fT')
        handles.megmagscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);
%ECG scale
% --- Executes on selection change in menu scales.
function scale_megplanar_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecgsc=spm_input('Gradiometers scale?',1,'s','1');
close gcf
try
    handles.megplanarscale=eval(ecgsc);
catch
    if strcmpi(ecgsc,'T/m')
        handles.megplanarscale=10^-11;
    elseif strcmpi(ecgsc,'fT/m')
        handles.megplanarscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or T/m or fT/m')
        handles.megplanarscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

%--------------------------------------------------------------------------
%Display of events and travel in the data using types of events------------
%--------------------------------------------------------------------------

%%%Select the type of event
%popupmenu10

%Goes to the previous event
% --- Executes on button press in pushbutton5.
%Goes to next event
% --- Executes on button press in pushbutton6.
%Check to say if event is good (1) or bad (0)
% --- Executes on button press in radiobutton1.
%Create the delay map of a SW if asked and when scrolling through events
% --- Executes on button press in delaymap.
%Menu to chose the value of the event within a selected type
% --- Executes on selection change in popupmenu11.
%Save the position of the slider in the data-------------------------------
% --- Executes on button press in pushbutton7.

%--------------------------------------------------------------------------
%----------------------- Scoring options ----------------------------------
%--------------------------------------------------------------------------

% --- Executes on button press in Score.
function Score_Callback(hObject, eventdata, handles)
% hObject    handle to Score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Handling score, arousal, artefact, opl/fpl information, window size & events of interest info
handles.scoring=1;
try
    if size(handles.Dmeg{1}.CRC.score,1)<7
        % Meaning it is an old cell array

        handles.score = cell(8,size(handles.Dmeg{1}.CRC.score,2));

        %Taking the score & username from the old cell array
        handles.score(1:2,:)=handles.Dmeg{1}.CRC.score(1:2,:);

        for ii=1:size(handles.Dmeg{1}.CRC.score,2)
            % Old cell array had a 20 seconds windows size
            handles.score{3,ii} = 20;
            % Updating OPL & FPL
            try
                handles.score{4,ii} = handles.Dmeg{1}.CRC.pl;
            catch
                handles.score{4,ii} = [1/fsample(handles.Dmeg{1}) ...
                    nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})];
            end
            % Updating Artefact info
            try
                handles.score{5,ii}= handles.Dmeg{1}.CRC.art;
            catch
                handles.score{5,ii}=[];
            end
            % Updating Arousal info
            try
                handles.score{6,ii}=handles.Dmeg{1}.CRC.art;
            catch
                handles.score{6,ii}=[];
            end

            % Creating event of interest vector
            handles.score{7,ii}=[];
            %vector for names of artefacts
            handles.score{8,ii}=[];
        end
    else
        handles.score = handles.Dmeg{1}.CRC.score;
        if size(handles.score,1)==7
            for isc=1:size(handles.score,2)
                handles.score{8,isc}=cell(size(handles.score{5,isc},1),1);
            end
        end
            
    end
    handles.Dmeg{1}.CRC.score = handles.score;
    handles.currentscore = 1;
    if ~isempty (handles.score{5,handles.currentscore})&&size(handles.score{5,handles.currentscore},2)<3
        handles.score{5,1}(:,3)=0;
    end
catch
    %Creating from scratch the right structure
    handles.score=cell(8,1);
    %%%%%%%%%%%%%%%%
    % From 1 to 7: %
    %%%%%%%%%%%%%%%%
    % 1: Score
    % 2: Name of scorer
    % 3: window size chosen to score
    % 4: OPL&FPL
    % 5: Artefacts
    % 6: Arousals
    % 7: Events of Interests
    % 8: Labels of the artefacts (empty if unspecified)

    %Defining user Name
    prompt = {'Please enter your name'};
    def= {'Newuser'};
    num_lines = 1;
    dlg_title = 'Name of the new scorer';
    handles.score(2,1) = inputdlg(prompt,dlg_title,num_lines,def);

    %Choosing size of window to score
    prompt = {'Please choose the size of the scoring windows'};
    def= {'10'};        %%%%%%%%%%%%窗口长度默认为10
    num_lines = 1;
    dlg_title = 'Size of the scoring windows (in sec)';
    handles.score(3,1) = inputdlg(prompt,dlg_title,num_lines,def);
    handles.score{3,1} = str2double(handles.score{3});

    % Creating FPL & OPL
    handles.score{4,1} = [1/fsample(handles.Dmeg{1}) ...
        nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})];

    % Creating artefacts
    handles.score{5,1} = [];

    % Creating arousals
    handles.score{6,1} = [];

    % Creating event of interest
    handles.score{7,1} = [];
   
    % Creating labels associated with artefacts
    handles.score{8,1} = [];

    % Putting NaN in the score
    handles.score{1,1} = ...
        0/0*ones(1,ceil(nsamples(handles.Dmeg{1}) / ...
        (handles.score{3,1}*fsample(handles.Dmeg{1}))));
    if isfield(handles.Dmeg{1}, 'CRC')
        handles.Dmeg{1}.CRC.score=handles.score;
    else
        handles.Dmeg{1}.CRC=struct('score',[]);
        handles.Dmeg{1}.CRC.score=handles.score;
    end
    handles.currentscore=1;
end
if ~isempty (handles.score{5,1})&&size(handles.score{5,1},2)<3
    handles.score{5,1}(:,3)=0;
end
%check that last page has a score, if not put nan
sc=handles.Dmeg{1}.CRC.score;
for i=1:size(sc,2)
    theosz=ceil(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})/sc{3,i}); % Theosz contents the number of windows
    if theosz>size(sc{1,i},2)
        handles.Dmeg{1}.CRC.score{1,i}=[handles.Dmeg{1}.CRC.score{1,i}, 0/0];
    end
    save(handles.Dmeg{1});
end

% Setting up the add artefact/arousal/event of interest.
handles.adddeb = ones(1,size(handles.score,2));
handles.addardeb = ones(1,size(handles.score,2));
handles.add_eoi = ones(1,size(handles.score,2));
% Defining window size according the current scorer
handles.winsize=handles.score{3,handles.currentscore};

%Changing the visibility of axes and scoring menu
set(handles.axes4,'Visible','on')
set(handles.fftchan,'Visible','off') %to plot fft
set(handles.score_menu,'enable','on')
set(handles.score_stats,'enable','on')
set(handles.score_import,'enable','on')
set(handles.score_compare,'enable','on')
set(handles.score_check,'enable','on')
set(handles.score_user,'enable','on')
set(handles.vertgrid,'enable','on')
set(handles.horgrid,'enable','on')
set(handles.grid_menu,'enable','on')
set(handles.addundefart,'enable','on','visible','on')
set(handles.addonlyone,'enable','on','visible','on') %artifact on single channel
set(handles.addspecart,'enable','on','visible','on')
set(handles.addaro,'enable','on','visible','on')
set(handles.addeoi,'enable','on','visible','on')
set(handles.FPL,'enable','on','visible','on')
set(handles.OPL,'enable','on','visible','on')
set(handles.Delart,'enable','on','visible','on')
set(handles.Delartonlyone,'enable','on','visible','on') %delete artifact on single channel
set(handles.Delaro,'enable','on','visible','on')
set(handles.Del_eoi,'enable','on','visible','on')
set(handles.manevent,'enable','on','visible','on'); %To put manual event



handles.namesc = [];
delete(get(handles.score_user,'Children'));
for isc=1:size(handles.score,2)
    handles.scorers{isc} = uimenu(handles.score_user,'Label', ...
        char(handles.score(2,isc)),'Callback',@defined_scorer) ;
    handles.namesc{isc}=char(handles.score(2,isc));
end

handles.num_scorers=isc;
handles.scorers{isc+1}=uimenu(handles.score_user,'Label', ...
    'New scorer','Callback',@new_scorer,...
    'Separator', 'on') ;
set(handles.scorers{handles.currentscore},'Checked','on');
delete(get(handles.addspecart,'Children'));   
crcdef = crc_get_defaults('score');
for iart=1:size(crcdef.lab_art,2)
    uimenu(handles.addspecart,'Label', ...
        char(crcdef.lab_art{iart}),'Callback',{@addtypeart,handles}) ;
end

delete(get(handles.axes4,'Children'));
set(handles.figure1,'CurrentAxes',handles.axes4);
crc_hypnoplot(handles.axes4, ...
    handles,handles.score{3,handles.currentscore});
set(handles.figure1,'CurrentAxes',handles.axes1);
delete(get(handles.addonlyone,'Children'));
uimenu(handles.addonlyone,'Label', ...
        ('Start an undefined artefact on this channel'),'Callback',{@addstart,handles}) ;
set(handles.edit1,'String',num2str(handles.winsize)); % To update the size of the window according to the scorer used
% Update handles structure
guidata(hObject, handles);


function event_menu_Callback (hObject,eventdata,handles)
% hObject    handle to event_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function Properties_Callback (hObject,eventdata,handles)
% hObject    handle to Properties (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.figure1, 'windowbuttonmotionfcn', '')

slidval=get(handles.slider1,'Value');
D = handles.Dmeg{1};
if isfield(handles.Dmeg{1},'CRC')
    D.CRC.lastdisp=slidval;
else
    D.CRC = struct('lastdisp',[]);
    D.CRC.lastdisp = slidval;
end
handles.Dmeg{1} = D;
save(D);

flags.Dmeg  =   handles.Dmeg;
flags.type  =   handles.type;
flags.file  =   handles.file;
flags.index =   handles.index;
flags.user  =   handles.currentscore;

crc_modif_events(flags);

% --------------------------------------------------------------------
function score_menu_Callback(hObject, eventdata, handles)
% hObject    handle to score_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function score_stats_Callback(hObject, eventdata, handles)
% hObject    handle to score_stats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

crcdef = crc_get_defaults('score');
legendm=cell(0);

% Define colormap
cmapref = [0.2 0.75 0.6; 0 0.8 1; 0.1 0.5 0.9; 0.1 0.2 0.8; 0.1 0.15 0.5; 0.5 0.5 0.9; 0.9 0.4 0.4; 0.9 0.6 0.3]; %the 8 colors for all sleep stages
cmap=[];

FPL = handles.score{4,handles.currentscore}(1);
OPL = handles.score{4,handles.currentscore}(2);

%Time allowed to sleep
TRS = OPL - FPL;
[TRStime TRSstring] = crc_time_converts(TRS);

%Invalidation
adapted=1:length(handles.Dmeg{1}.CRC.score{1,handles.currentscore});
nottobescored = find(adapted <...
    handles.score{4,handles.currentscore}(1)/handles.score{3,handles.currentscore} | ...
    adapted > ...
    handles.score{4,handles.currentscore}(2)/handles.score{3,handles.currentscore});

stat = cell(0);
iisc = handles.Dmeg{1}.CRC.score{1,handles.currentscore};

iisc(nottobescored)=-1;

Zero = find(iisc==0);   % awake
One = find(iisc==1);    % Stage 1
Two = find(iisc==2);    % Stage 2
Three = find(iisc==3);  % Stage 3
Four = find(iisc==4);   % Stage 4
Five = find(iisc==5);   % REM
Six = find(iisc==6);    % MT
Seven=find(iisc==7);    % Awake

%Time of the sleeping period
TPS = (max([Two Three Four Five])-1)*handles.score{3,handles.currentscore}...
    - (min([Two Three Four Five])-1)*handles.score{3,handles.currentscore};

[TPStime TPSstring] = crc_time_converts(TPS);

%Total Sleep Time
TST = length([Two Three Four Five])*handles.score{3,handles.currentscore};

[TSTtime TSTstring] = crc_time_converts(TST);

%Sleep Efficiency
SEff = TST/TRS;

%Latency St1
if isempty(One)
    LatS1string = ['No ',crcdef.stnames_L{2},' Scored'];
else
    LatS1 = (One(1)-1)*handles.score{3,handles.currentscore} - FPL;
    [LatS1time LatS1string] = crc_time_converts(LatS1);
end
%Lantency St2
if isempty(Two)
    LatS2string = ['No ',crcdef.stnames_L{3},' Scored'];
else
    LatS2 = (Two(1)-1)*handles.score{3,handles.currentscore} - FPL;
    [LatS2time LatS2string] = crc_time_converts(LatS2);
end

%Lantency REM
if isempty(Five)
    LatREMstring = ['No ',crcdef.stnames_L{6},' Scored'];
else
    LatREM = (Five(1)-1)*handles.score{3,handles.currentscore} - FPL;
    [LatREMtime LatREMstring] = crc_time_converts(LatREM);
end

%Min & Percentage of W
W = length([Zero])*handles.score{3,handles.currentscore};
[Wtime Wstring] = crc_time_converts(W);

PW = W/TST;
% if (PW ~= 0)
legendm = [legendm crcdef.stnames_S{1}]
cmap=[cmap;cmapref(1,:)];
% end

%Min & Percentage of S1
S1 = length([One])*handles.score{3,handles.currentscore};
[S1time S1string] = crc_time_converts(S1);
PS1 = S1/TST;
% if (PS1 ~= 0)
legendm = [legendm crcdef.stnames_S{2}];
cmap=[cmap;cmapref(2,:)];
% end

%Min & Percentage of S2
S2 = length([Two])*handles.score{3,handles.currentscore};
[S2time S2string] = crc_time_converts(S2);
PS2 = S2/TST;
% if (PS2 ~= 0)
legendm = [legendm crcdef.stnames_S{3}];
cmap=[cmap;cmapref(3,:)];
% end

%Min & Percentage of S3
S3 = length([Three])*handles.score{3,handles.currentscore};
[S3time S3string] = crc_time_converts(S3);
PS3 = S3/TST;
% if (PS3 ~= 0)
legendm = [legendm crcdef.stnames_S{4}];
cmap=[cmap;cmapref(4,:)];
% end

%Min & Percentage of S4
S4 = length([Four])*handles.score{3,handles.currentscore};
[S4time S4string] = crc_time_converts(S4);
PS4 = S4/TST;
% if (PS4 ~= 0)
legendm = [legendm crcdef.stnames_S{5}];
cmap=[cmap;cmapref(5,:)];
% end

%Min & Percentage of SWS
SWS = length([Three Four])*handles.score{3,handles.currentscore};
[SWStime SWSstring] = crc_time_converts(SWS);

PSWS = SWS/TST;

%Min & Percentage of REM
REM = length([Five])*handles.score{3,handles.currentscore};
[REMtime REMstring] = crc_time_converts(REM);
PREM = REM/TST;
% if (PREM ~= 0)
legendm = [legendm crcdef.stnames_S{6}];
cmap=[cmap;cmapref(6,:)];
% end

%Min & Percentage of MT
MT = length([Six])*handles.score{3,handles.currentscore};
[MTtime MTstring] = crc_time_converts(MT);
PMT = MT/TST;
%if (PMT ~= 0)
legendm = [legendm crcdef.stnames_S{7}];
cmap=[cmap;cmapref(7,:)];
%end

%percentage of 'unscorable'
Unsc = length([Seven])*handles.score{3,handles.currentscore};
[Unsctime Unscstring] = crc_time_converts(Unsc);
legendm = [legendm crcdef.stnames_S{8}];
cmap=[cmap;cmapref(8,:)];
PUnsc = Unsc/TST;

%Begining display

if handles.figz~=0
    fig_z = handles.figz;
else
    fig_z = 0;
end
% call stat & display routine
[out_V,fig_z] = crc_statgen(handles.Dmeg{1},handles.currentscore,fig_z);
handles.figz = fig_z;
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function score_import_Callback(hObject, eventdata, handles)
% hObject    handle to score_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

impfile = spm_select(1, 'any', 'Select mat file with other score','' ...
    ,pwd,'\.[mM][aA][Tt]');

D = crc_eeg_load(impfile);

try
    D.CRC.score;
    okscore = 1;
catch
    okscore = 0;
end

oksamples = D.nsamples==handles.Dmeg{1}.nsamples;
okchannels = length(chanlabels(D))==length(chanlabels(handles.Dmeg{1}));

dlg={};
if ~okscore
    if isempty(dlg);
        dlg = {'No score found in the selected file'};
    else
        dlg = {dlg{:} 'No score found in the selected file'};
    end
end

if ~oksamples
    if isempty(dlg)
        dlg = {'The selected file does not have the same amount of samples than the viewed one'};
    else
        dlg ={ dlg{:} 'The selected file does not have the same amount of samples than the viewed one'};
    end
end

if ~okchannels
    if isempty(dlg)
        dlg = {'The selected file does not have the same amount of channels than the viewed one'};
    else
        dlg = {dlg{:} 'The selected file does not have the same amount of channels than the viewed one'};
    end
end

if oksamples && okchannels && okscore
    %Check that the imported scores have the correct dimensions
    if size(D.CRC.score,2)==7
        for i=1:size(D.CRC.score,2)
            D.CRC.score{8,i}=[];
        end
    end
    % Create new menu without Guide

    if handles.figz~=0
        z = handles.figz;
    else
        z = figure;
    end

    figure(z)
    handles.figz = z;
    clf(z);

    set(z,...% The main GUI figure
        'MenuBar','none', ...
        'Toolbar','none', ...
        'HandleVisibility','callback', ...
        'Color', get(0,...
        'defaultuicontrolbackgroundcolor'));
    set(z,'FileName',impfile);
    set(z,'Position',[218 210 990 632])

    hPlotAxes = axes(...    % Axes for plotting the selected plot
        'Parent', z, ...
        'Units', 'normalized', ...
        'HandleVisibility','callback', ...
        'Position',[0.11 0.13 0.80 0.67]);

    Mainhandle = gcbo;
    
    sc=[];
    for i=1:size(D.CRC.score,2)
        sc=[sc, {D.CRC.score{2,i}}];
    end
    sc=[sc {'All'}];
    hPlotsPopupmenu = uicontrol(... % List of available types of plot
        'Parent', z, ...
        'Units','normalized',...
        'Position',[0.11 0.85 0.45 0.1],...
        'HandleVisibility','callback', ...
        'String',sc,...
        'Callback', {@plothypnoimport,handles,Mainhandle},...
        'Style','popupmenu');

    hUpdateButton = uicontrol(... % Button for updating selected plot
        'Parent', z, ...
        'Units','normalized',...
        'HandleVisibility','callback', ...
        'Position',[0.6 0.85 0.3 0.1],...
        'String','Import score',...
        'Callback', {@saveimportscore,handles,Mainhandle});

    crc_hypnoplot(hPlotAxes,handles,D.CRC.score{3,1}, ...
        D.CRC.score{1,1})

else
    errordlg(dlg, 'Error');
end

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function saveimportscore(hObject, eventdata, handles, gcbo)

handles = guidata(gcbo);

fig=get(hObject,'Parent');
Child = get(fig, 'Children');

for ii = 1:length(Child)
    if  strcmp(get(Child(ii),'Type'),'axes')
        axesidx = Child(ii);
    elseif strcmp(get(Child(ii),'Type'),'uicontrol')
        if strcmp(get(Child(ii),'Style'),'popupmenu')
            popidx = Child(ii);
        end
    end
end

impfile=get(fig,'FileName');
D=crc_eeg_load(impfile);

popVal=get(popidx,'Value');
if size(D.CRC.score,2)>=popVal

    D.CRC.score(:,popVal)
    if size(handles.Dmeg{1}.CRC.score,1) == size(D.CRC.score(:,popVal),1)
        handles.Dmeg{1}.CRC.score=[handles.Dmeg{1}.CRC.score D.CRC.score(:,popVal)];
    else
        errordlg('Scores do not have the same sizes', 'Error');
    end

    handles.addardeb=[handles.addardeb 1];
    handles.adddeb = [handles.adddeb 1];
    handles.add_eoi = [handles.add_eoi 1];
else
    for ii=1:size(D.CRC.score,2)
        if size(handles.Dmeg{1}.CRC.score,1) == size(D.CRC.score(:,ii),1)
            handles.Dmeg{1}.CRC.score=[handles.Dmeg{1}.CRC.score D.CRC.score(:,ii)];
        else
            errordlg('Scores do not have the same sizes', 'Error');
        end    
        handles.addardeb=[handles.addardeb 1];
        handles.adddeb = [handles.adddeb 1];
        handles.add_eoi = [handles.add_eoi 1];
    end
end

handles.score=handles.Dmeg{1}.CRC.score;
D=handles.Dmeg{1};
save(D);

close(fig)

guidata(gcbo, handles);

% --------------------------------------------------------------------
function plothypnoimport(hObject, eventdata, handles, gcbo)

handles = guidata(gcbo);

fig=get(hObject,'Parent');
Child = get(fig, 'Children');

for ii = 1:length(Child)
    if  strcmp(get(Child(ii),'Type'),'axes')
        axesidx = Child(ii);
    end
end

impfile=get(fig,'FileName');
D=crc_eeg_load(impfile);
Valpop=get(hObject,'Value');

if size(D.CRC.score,2)>=Valpop
    crc_hypnoplot(axesidx, handles,...
        D.CRC.score{3,Valpop},D.CRC.score{1,Valpop},D.CRC.score{2,Valpop})
end

guidata(gcbo, handles);

% --------------------------------------------------------------------
function score_compare_Callback(hObject, eventdata, handles)
% hObject    handle to score_compare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.figz~=0
    z = handles.figz;
else
    z = figure;
end

if size(handles.Dmeg{1}.CRC.score,2)<2
    disp('Only one score in the file, can not be compared')
    close(z)
    return
end

% figure(z)
% close(z)
figure(z)
handles.figz = z;
clf(z);

set(z,...% The main GUI figure
    'MenuBar','none', ...
    'Toolbar','none', ...
    'HandleVisibility','callback', ...
    'Color', get(0,...
    'defaultuicontrolbackgroundcolor'));
set(z,'Position',[218 210 990 632])

Mainhandle = gcbo;

handles.popcmp(1) = uicontrol(... % List of available types of plot
    'Parent', z, ...
    'Units','normalized',...
    'Position',[0.125 0.485 0.2 0.5],...
    'HandleVisibility','callback', ...
    'String',handles.score(2,:),...
    'Callback', {@update_hypnocomp,handles,Mainhandle},...
    'Style','popupmenu');

handles.popcmp(2) = uicontrol(... % List of available types of plot
    'Parent', z, ...
    'Units','normalized',...
    'Position',[0.675 0.485 0.2 0.5],...
    'HandleVisibility','callback', ...
    'String',handles.score(2,:),...
    'Callback', {@update_hypnocomp,handles,Mainhandle},...
    'Style','popupmenu');
set(handles.popcmp(2),'Value',2);

hUpdateButton = uicontrol(... % Button for updating selected plot
    'Parent', z, ...
    'Units','normalized',...
    'HandleVisibility','callback', ...
    'Position',[0.35 0.025 0.3 0.05],...
    'String','Merge Score',...
    'Callback', {@crc_hypnomerge,handles,Mainhandle});

handles.subcmp(1) = subplot(311);
handles.subcmp(2) = subplot(312);
handles.subcmp(3) = subplot(313);

% Plot subaxes
set(z,'CurrentAxes',handles.subcmp(1))
crc_hypnoplot(handles.subcmp(1),...
    handles,...
    handles.Dmeg{1}.CRC.score{3,1},...
    handles.Dmeg{1}.CRC.score{1,1},handles.Dmeg{1}.CRC.score{2,1})

set(z,'CurrentAxes',handles.subcmp(2))
crc_hypnoplot(handles.subcmp(2),...
    handles,...
    handles.Dmeg{1}.CRC.score{3,2},...
    handles.Dmeg{1}.CRC.score{1,2},handles.Dmeg{1}.CRC.score{2,2})

[mtch,perc_match] = crc_hypnocompare([handles.subcmp(3) z], [1 2], ...
                                handles.Dmeg{1}.CRC.score, handles);
handles.match = mtch;
handles.perc_match = perc_match;

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visual comparison of hypnograms
%New Function : To be checked %%%%%%%%%%%%%%%%%%%%%%
function update_hypnocomp(hObject, kk1, kk2, gcbo)

handles = guidata(gcbo);

fig = get(hObject,'Parent');

Valpop=get(hObject,'Value');

if handles.popcmp(1)==hObject
    cla(handles.subcmp(1))
    set(fig,'CurrentAxes',handles.subcmp(1))
    crc_hypnoplot(handles.subcmp(1),...
        handles,...
        handles.Dmeg{1}.CRC.score{3,Valpop},...
        handles.Dmeg{1}.CRC.score{1,Valpop},...
        handles.Dmeg{1}.CRC.score{2,Valpop})

elseif handles.popcmp(2)==hObject
    cla(handles.subcmp(2))
    set(fig,'CurrentAxes',handles.subcmp(2))
    crc_hypnoplot(handles.subcmp(2),...
        handles,...
        handles.Dmeg{1}.CRC.score{3,Valpop},...
        handles.Dmeg{1}.CRC.score{1,Valpop},...
        handles.Dmeg{1}.CRC.score{2,Valpop})
end

Val1 = get(handles.popcmp(1),'Value');
Val2 = get(handles.popcmp(2),'Value');

[mtch,perc_match] = crc_hypnocompare([handles.subcmp(3) fig], ...
                                [Val1 Val2], ...
                                handles.Dmeg{1}.CRC.score, handles);
handles.match = mtch;
handles.perc_match = perc_match;

guidata(gcbo, handles);


%% Merging of hypnograms

function crc_hypnomerge(hObject, kk1, handles, gcbo)
% FORMAT crc_mergehypno(hand,pl,handles,windowsize,score,scorer)
% Merging 2 hypnograms into 1.

handles = guidata(gcbo);

fig = get(hObject,'Parent');

notmatchidx = find(handles.match~=0);

Val1 = get(handles.popcmp(1),'Value');
Val2 = get(handles.popcmp(2),'Value');

% create a third column for artefact on single channel if there are only
% column
if size(handles.Dmeg{1}.CRC.score{5,Val1},2)<3
    handles.Dmeg{1}.CRC.score{5,Val1}(:,3) = 0;
end
if size(handles.Dmeg{1}.CRC.score{5,Val2},2)<3
	handles.Dmeg{1}.CRC.score{5,Val2}(:,3) = 0;
end
        
if handles.Dmeg{1}.CRC.score{3,Val1}==handles.Dmeg{1}.CRC.score{3,Val2}

    tmpscore = handles.Dmeg{1}.CRC.score{1,Val1};
    tmpscore(notmatchidx) = NaN; %#ok<*FNDSB> % put a NaN where there are mismatch

    handles.Dmeg{1}.CRC.score=...
        [handles.Dmeg{1}.CRC.score handles.Dmeg{1}.CRC.score(:,Val1)];

    handles.Dmeg{1}.CRC.score{1,end} = tmpscore;
    handles.Dmeg{1}.CRC.score{2,end} = ...
        ['Merge ' handles.Dmeg{1}.CRC.score{2,Val1} '-', ...
            handles.Dmeg{1}.CRC.score{2,Val2} ];
    handles.Dmeg{1}.CRC.score{4,end}(1) = ...
        min(handles.Dmeg{1}.CRC.score{4,Val1}(1), ...
            handles.Dmeg{1}.CRC.score{4,Val2}(1));
    handles.Dmeg{1}.CRC.score{4,end}(2) = ...
        max(handles.Dmeg{1}.CRC.score{4,Val1}(2), ...
            handles.Dmeg{1}.CRC.score{4,Val2}(2));
    handles.Dmeg{1}.CRC.score{5,end} = ...
        [handles.Dmeg{1}.CRC.score{5,Val1}; ...
         handles.Dmeg{1}.CRC.score{5,Val2}];
    handles.Dmeg{1}.CRC.score{6,end} = ...
        [handles.Dmeg{1}.CRC.score{6,Val1} ; ...
         handles.Dmeg{1}.CRC.score{6,Val2}];
    handles.Dmeg{1}.CRC.score{7,end} = ...
        [handles.Dmeg{1}.CRC.score{7,Val1} ; ...
         handles.Dmeg{1}.CRC.score{7,Val2}];

     if isfield(handles.Dmeg{1}.CRC,'sc_merge')
         Nmerge = size(handles.Dmeg{1}.CRC.sc_merge,1);
         handles.Dmeg{1}.CRC.sc_merge{Nmerge+1,1} = handles.Dmeg{1}.CRC.score{2,end};
         handles.Dmeg{1}.CRC.sc_merge{Nmerge+1,2} = handles.perc_match;
     else
         handles.Dmeg{1}.CRC.sc_merge{1,1} = handles.Dmeg{1}.CRC.score{2,end};
         handles.Dmeg{1}.CRC.sc_merge{1,2} = handles.perc_match;
     end
     
    handles.addardeb = [handles.addardeb 1];
    handles.adddeb   = [handles.adddeb 1];
    handles.add_eoi  = [handles.add_eoi 1];

    handles.score = handles.Dmeg{1}.CRC.score;
    D = handles.Dmeg{1};
    save(D);

    delete(get(handles.score_user,'Children'));
    for isc=1:size(handles.score,2)
        handles.scorers{isc} = uimenu(handles.score_user,'Label', ...
            char(handles.score(2,isc)),'Callback',@defined_scorer) ;
        handles.namesc{isc} = char(handles.score(2,isc));
    end
    handles.num_scorers = isc;
    handles.scorers{isc+1} = uimenu(handles.score_user,'Label', ...
        'New scorer','Callback',@new_scorer,...
        'Separator', 'on') ;
    set(handles.scorers{handles.currentscore},'Checked','on');
    delete(get(handles.axes4,'Children'));
    set(handles.figure1,'CurrentAxes',handles.axes4);
    crc_hypnoplot(handles.axes4, handles, ...
        handles.score{3,handles.currentscore}, ...
        handles.score{1,handles.currentscore}, ...
        handles.score{2,handles.currentscore})
    set(handles.figure1,'CurrentAxes',handles.axes1);
    close(fig);
else
    errordlg({'The window size of the score are not the same. The scores cannot be merged'}, 'Error');
end

guidata(gcbo, handles);

function score_check_Callback(hObject, eventdata, handles)
% hObject    handle to score_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get stuff out
score  = handles.score;
scorer = handles.currentscore;
i_win  = str2double(get(handles.currentpage,'string'));
n_disp = crc_get_defaults('score.check_disnum');

% Do the check
[n_empty,l_empty] = crc_check_hypno(score, scorer, i_win, n_disp);

% jumpt to next empty window or not
if crc_get_defaults('score.check_jump') && ~isempty(n_empty)
    set(handles.slider1,'val',(n_empty-1)*handles.winsize)
    mainplot(handles)
end

% % Update handles structure
% guidata(hObject, handles);

%--------------------------------------------------------------------------
% menu on right click
%--------------------------------------------------------------------------

function ArtefactMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ArtefactMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Mouse = get(handles.axes1,'CurrentPoint');
guidata(hObject,handles)

function Delar_Callback(hObject, eventdata, handles)
% hObject    handle to Delar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function Deleoi_Callback(hObject, eventdata, handles)
% hObject    handle to Deleoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
% --------------------------------------------------------------------
% --------------------------------------------------------------------
function Delart_Callback(hObject, eventdata, handles)
% hObject    handle to Delart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Mouse=get(handles.axes1,'CurrentPoint');
minimum=min(min(abs(handles.score{5,handles.currentscore}-Mouse(1,1))));
[row,col]=find((abs(handles.score{5,handles.currentscore}-Mouse(1,1))-minimum)==0);

if length(row)==2
    handles.adddeb(handles.currentscore) = 1;
    if handles.unspecart
       set(handles.addundefart,'Label','Add "start undefined Artefact"');
    else
        set(handles.addspecart,'Label','Add "start specified Artefact"');
    end
end

handles.score{5,handles.currentscore} = ...
    [handles.score{5,handles.currentscore}(1:row-1,:) ; ...
    handles.score{5,handles.currentscore}(row+1:size(handles.score{5,handles.currentscore},1),:)];

handles.score{8,handles.currentscore} = ...
    [handles.score{8,handles.currentscore}(1:row-1) ; ...
    handles.score{8,handles.currentscore}(row+1:size(handles.score{8,handles.currentscore},1))];

set(handles.axes1,'Color',[1 1 1]);
% Save the changes
handles.Dmeg{1}.CRC.score  =handles.score;
D = handles.Dmeg{1};
save(D);

set(handles.figure1,'CurrentAxes',handles.axes4)
crc_hypnoplot(handles.axes4, ...
    handles,handles.score{3,handles.currentscore})
set(handles.figure1,'CurrentAxes',handles.axes1)

mainplot(handles)

% Update handles structure
guidata(hObject, handles);

function Delaro_Callback(hObject, eventdata, handles)
% hObject    handle to Delaro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Mouse=get(handles.axes1,'CurrentPoint');
minimum=min(min(abs(handles.score{6,handles.currentscore}-Mouse(1,1))));
[row,col]=find((abs(handles.score{6,handles.currentscore}-Mouse(1,1))-minimum)==0);

if length(row)==2
    handles.addardeb(handles.currentscore) = 1;
    set(handles.addaro,'Label','Add "start Arousal" point');
end

handles.score{6,handles.currentscore} = ...
    [handles.score{6,handles.currentscore}(1:row-1,:) ;...
    handles.score{6,handles.currentscore}(row+1:size(handles.score{6,handles.currentscore},1),:)];
set(handles.axes1,'Color',[1 1 1]);
%Save the changes
handles.Dmeg{1}.CRC.score=handles.score;
D=handles.Dmeg{1};
save(D);

set(handles.figure1,'CurrentAxes',handles.axes4)
crc_hypnoplot(handles.axes4, ...
    handles,handles.score{3,handles.currentscore})
set(handles.figure1,'CurrentAxes',handles.axes1)

mainplot(handles)

% Update handles structure
guidata(hObject, handles);

function Del_eoi_Callback(hObject, eventdata, handles)
% hObject    handle to Del_eoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Mouse=get(handles.axes1,'CurrentPoint');
minimum=min(min(abs(handles.score{7,handles.currentscore}-Mouse(1,1))));
[row,col]=find((abs(handles.score{7,handles.currentscore}-Mouse(1,1))-minimum)==0);

if length(row)==2
    handles.add_eoi(handles.currentscore) = 1;
    set(handles.addeoi,'Label','Add "start Event of interest" point');
end

handles.score{7,handles.currentscore} = ...
    [handles.score{7,handles.currentscore}(1:row-1,:) ;...
    handles.score{7,handles.currentscore}(row+1:size(handles.score{7,handles.currentscore},1),:)];

%Save the changes
handles.Dmeg{1}.CRC.score=handles.score;
D=handles.Dmeg{1};
save(D);

set(handles.figure1,'CurrentAxes',handles.axes4)
crc_hypnoplot(handles.axes4, ...
    handles,handles.score{3,handles.currentscore})
set(handles.figure1,'CurrentAxes',handles.axes1)

mainplot(handles)

% Update handles structure
guidata(hObject, handles);

function Delartonlyone_Callback(hObject, eventdata, handles)
% hObject    handle to Delartonlyone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Mouse   =   get(handles.axes1,'CurrentPoint');
chan    =   ceil((Mouse(1,2)-handles.scale/2)/handles.scale);
channel =   handles.inddis(chan);
art_concerned   =   find(handles.score{5,handles.currentscore}(:,3) == channel);
minimum =   min(min(abs(handles.score{5,handles.currentscore}(art_concerned,:)-Mouse(1,1))));
[row,col]   =   find((abs(handles.score{5,handles.currentscore}-Mouse(1,1))-minimum)==0);
handles.score{5,handles.currentscore} = ...
    [handles.score{5,handles.currentscore}(1:row-1,:) ; ...
    handles.score{5,handles.currentscore}(row+1:size(handles.score{5,handles.currentscore},1),:)];

handles.score{8,handles.currentscore} = ...
    [handles.score{8,handles.currentscore}(1:row-1) ; ...
    handles.score{8,handles.currentscore}(row+1:size(handles.score{8,handles.currentscore},1))];
[dum1,r,dum] = intersect(handles.chan, channel);
handles.chan = [handles.chan(1:r-1) handles.chan(r+1:length(handles.chan))];
set(handles.axes1,'Color',[1 1 1]);

%Save the changes
handles.Dmeg{1}.CRC.score   =   handles.score;
D   =   handles.Dmeg{1};
save(D);

set(handles.figure1,'CurrentAxes',handles.axes4)
crc_hypnoplot(handles.axes4, ...
    handles,handles.score{3,handles.currentscore})
set(handles.figure1,'CurrentAxes',handles.axes1)

mainplot(handles)
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------

% --------------------------------------------------------------------
function addundefart_Callback(hObject, eventdata, handles)
% hObject    handle to addundefart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.figure1,'CurrentAxes',handles.axes1)
Mouse   =   handles.Mouse;
timedbtart  =   Mouse(1,1);
handles.unspecart   =   1;
lab     =   'unspecified';

% add the eighth line
if size(handles.score,1)<8
    for isc=1:size(handles.score,2)
        handles.score{8,isc}=cell(size(handles.score{5,isc},1),1);
    end
end

% add the zeros on the last column (to adapt with configuration for artifacts on single channel
if size(handles.score{5,handles.currentscore},2)<3
    for ii = 1 : size(handles.score{5,handles.currentscore},1)
        handles.score{5,handles.currentscore}(:,3)  =   0;
    end 
end 

if handles.adddeb(handles.currentscore) == 1
    if ~isempty(handles.score{5,handles.currentscore})
        if sum(and(and(timedbtart>handles.score{5,handles.currentscore}(:,1),...
                timedbtart<handles.score{5,handles.currentscore}(:,2)),handles.score{5,handles.currentscore}(:,3)==0))
            beep
            disp('Invalid "start Artefact" point')
            disp(' ')
        else
            handles.score{5,handles.currentscore}= ...
                [handles.score{5,handles.currentscore}; timedbtart timedbtart 0];
            handles.score{8,handles.currentscore}=[handles.score{8,handles.currentscore};...
                {lab}];
            set(handles.addundefart,'Label','Add "end undefined Artefact"');
            handles.adddeb(handles.currentscore) = 0;
            fact    =   min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
            plot(ones(1,2)*timedbtart,[0 handles.scale*(fact+1)], ...
                'UIContextMenu',handles.Deletemenu,'Color',[0 0 0])
            text(timedbtart,handles.scale*(fact+6/8), ...
                'S.Art','Color',[0 0 0],'FontSize',14)
            set(handles.axes1,'Color',[0.9 0.7 0.7])

        end

    else
        handles.score{5,handles.currentscore}=...
            [handles.score{5,handles.currentscore}; timedbtart timedbtart 0];
        handles.score{8,handles.currentscore}=[handles.score{8,handles.currentscore};...
            {lab}]; %for each artefact, we save the name of the artefact
        set(handles.addundefart,'Label','Add "end undefined Artefact"');
        handles.adddeb(handles.currentscore) = 0;
        fact    =  min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
        plot(ones(1,2)*timedbtart,[0 handles.scale*(fact+1)], ...
            'UIContextMenu',handles.Deletemenu,'Color',[0 0 0])

        text(timedbtart,handles.scale*(fact+6/8), ...
            'S.Art','Color',[0 0 0],'FontSize',14)
        set(handles.axes1,'Color',[0.9 0.7 0.7])
    end
else
    Mouse   =    get(handles.axes1,'CurrentPoint');
    timefinart  =   Mouse(1,1);
    [row]   =   find(and(and(timefinart>handles.score{5,handles.currentscore}(:,1),...
                timefinart>handles.score{5,handles.currentscore}(:,2)),handles.score{5,handles.currentscore}(:,3)==0));
    test3   =   sum(and(handles.score{5,handles.currentscore}...
                (size(handles.score{5,handles.currentscore},1),1)<...
                handles.score{5,handles.currentscore}(row,1), ...
                handles.score{5,handles.currentscore}...
                (size(handles.score{5,handles.currentscore},1),2)<...
                handles.score{5,handles.currentscore}(row,2)));
    if or(or(sum(and(and(timefinart>handles.score{5,handles.currentscore}(:,1),...
            timefinart<handles.score{5,handles.currentscore}(:,2)),handles.score{5,handles.currentscore}(:,3)==0))>0, ...
            timefinart<handles.score{5,handles.currentscore}...
            (size(handles.score{5,handles.currentscore},1),2)),test3)
        beep
        disp('Invalid "end Artefact" point')
        disp(' ')
    else
        set(handles.addundefart,'Label','Add "start undefined Artefact"');
        handles.score{5,handles.currentscore}...
            (size(handles.score{5,handles.currentscore},1),2)= timefinart;
        handles.adddeb(handles.currentscore) = 1;
        fact    =   min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
        plot(ones(1,2)*timedbtart,[0 handles.scale*(fact+1)], ...
            'UIContextMenu',handles.Deletemenu,'Color',[0 0 0])
        text(timedbtart,handles.scale*(fact+6/8), ...
            'E.Art','Color',[0 0 0],'FontSize',14)
        set(handles.axes1,'Color',[1 1 1])
        set(handles.figure1,'CurrentAxes',handles.axes4)
%         plot(handles.score{5,handles.currentscore}(size(handles.score{5,handles.currentscore},1),1),ones(1,1)*8,...
%             '+','MarkerSize',8,'MarkerFaceColor',[0.4 0.4 0.4],...
%             'MarkerEdgeColor',[0.4 0.4 0.4],'tag','undart')
        set(handles.figure1,'CurrentAxes',handles.axes1)
    end
end
handles.Dmeg{1}.CRC.score   =   handles.score;
D   =   handles.Dmeg{1};
save(D);

% Update handles structure
guidata(hObject, handles);
fftchan_Callback(hObject, [],handles)

% --------------------------------------------------------------------
function addonlyone_Callback(hObject, eventdata, handles)
% hObject    handle to addonlyone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function addstart(hObject,eventdata,handles)

set(handles.figure1,'CurrentAxes',handles.axes1)

a=get(hObject,'Parent');
b=get(a,'Parent');
c=get(b,'Parent');
handles=guidata(c);

% add the eighth line
if size(handles.score,1)<8
    for isc=1:size(handles.score,2)
        handles.score{8,isc}=cell(size(handles.score{5,isc},1),1);
    end
end

% add the zeros on the last column
if size(handles.score{5,handles.currentscore},2)<3
    for ii = 1 : size(handles.score{5,handles.currentscore},1)
        handles.score{5,handles.currentscore}(:,3)=0;
    end 
end 

%Time pointed 
chan = ceil((handles.Mouse(1,2)-handles.scale/2)/handles.scale);
time = handles.Mouse(1,1);

Chanslidval     =   get(handles.Chanslider,'Value');
slidpos         =   Chanslidval-rem(Chanslidval,1);
NbreChandisp    =   str2double(get(handles.NbreChan,'String'));
tmp = slidpos : 1 : slidpos + NbreChandisp -1;

chantodel   =   get(gcbo,'Label');
channel     =   handles.inddis(tmp(chan));
addend      =   intersect(handles.chan, channel);

%label noted in the last line to describe the artefacts  
lab = 'unspecified on only one channel';  

if ~isempty(strfind(chantodel,'Start'))
    if ~isempty(handles.score{5,handles.currentscore})
        if ~isempty(addend)
            beep
            disp('Invalid "start Artefact" point, you must first end the last artefact on this channel')
            disp(' ')
        else
            [ch, line, dum]=intersect(handles.score{5,handles.currentscore}(:,3), channel);
            teststart =0;
            for l=1:length(line)
                teststart = sum(or(and(handles.score{5,handles.currentscore}(line(l),2)>time, ...
                    handles.score{5,handles.currentscore}(line(l),1)<time),...
                    handles.score{5,handles.currentscore}(line(l),2)==handles.score{5,handles.currentscore}(line(l),1)));
            end            
            if teststart~=0 
                    beep
                    disp('Invalid "start Artefact" point, this zone is already been recovered')
                    disp(' ') 
            else 
                tfinal = nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1});
                handles.score{5,handles.currentscore}=[handles.score{5,handles.currentscore}; time tfinal channel];
                handles.score{8,handles.currentscore}=[handles.score{8,handles.currentscore}; {lab}];          
              	handles.chan =[handles.chan channel]; 
                plot(handles.axes1,ones(1,2)*time,[(chan*handles.scale-handles.scale/2) (chan*handles.scale + handles.scale/2)], ...
                    'Color',[0 0 0])
                axes(handles.axes1)
                text(time,chan*handles.scale + handles.scale/2, ...
                    'Start Bad Chan','UIContextMenu',handles.Deletemenuone,'Color',[0 0 0],'FontSize',12) 
            end
         end
    else
        tfinal = nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1});
        handles.score{5,handles.currentscore}=[handles.score{5,handles.currentscore}; time tfinal channel];
        handles.score{8,handles.currentscore}=[handles.score{8,handles.currentscore}; {lab}]; 
        handles.chan =[handles.chan channel];  
        plot(handles.axes1,ones(1,2)*time,[(chan*handles.scale-handles.scale/2) (chan*handles.scale + handles.scale/2)], ...
            'Color',[0 0 0])
        axes(handles.axes1)
        text(time,chan*handles.scale + handles.scale/2, ...
        	'Start Bad Chan','UIContextMenu',handles.Deletemenuone,'Color',[0 0 0],'FontSize',12) 
    end
else
    if isempty(addend)
        beep
        disp('Invalid "end Artefact" point, you must first determine the "Start artefact on this channel"')
        disp(' ')
    else 
        [ch,check,dum] = intersect(handles.score{5,handles.currentscore}(:,3),channel);
        if length(check)>1
            [ch, in, dum] = intersect(handles.score{5,handles.currentscore}(:,3), channel);
            for i = 1:length(check)-1
                chk = sum(or(handles.score{5,handles.currentscore}(in(end),1)>timefin),...
                    and(handles.score{5,handles.currentscore}(check(i),1)<timefin,...
                        handles.score{5,handles.currentscore}(check(i),2)<timefin));
            end
            if chk  ~= 0
                beep
                disp('This end is not available')
                disp(' ')
            else
                handles.score{5,handles.currentscore}(in(end),2) = time;
                handles.chan = setdiff(handles.chan, channel);
                plot(handles.axes1,ones(1,2)*time,[(chan*handles.scale-handles.scale/2) (chan*handles.scale + handles.scale/2)], ...
                    'Color',[0 0 0])
                axes(handles.axes1)
                text(time,chan*handles.scale + handles.scale/2, ...
                    'End Bad Chan','UIContextMenu',handles.Deletemenuone,'Color',[0 0 0],'FontSize',12) 
             end 
        else 
            [ch, in, dum] = intersect(handles.score{5,handles.currentscore}(:,3), channel);
            if handles.score{5,handles.currentscore}(in(end),1)>time
                beep
                disp('This end is not available')
                disp(' ')
            else
                handles.score{5,handles.currentscore}(in(end),2) = time;
                handles.chan = setdiff(handles.chan, channel);
                plot(handles.axes1,ones(1,2)*time,[(chan*handles.scale-handles.scale/2) (chan*handles.scale + handles.scale/2)], ...
                    'Color',[0 0 0])
                axes(handles.axes1)
                text(time,chan*handles.scale + handles.scale/2, ...
                    'End Bad Chan','UIContextMenu',handles.Deletemenuone,'Color',[0 0 0],'FontSize',12) 
            end
        end
    end
end
slidval = get(handles.slider1,'Value');  
if slidval<1/fsample(handles.Dmeg{1})
    slidval=1/fsample(handles.Dmeg{1});
    set(handles.slider1,'Value',slidval);
elseif slidval>nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2;
    slidval=nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2;
end
if ~isempty(handles.score{5,handles.currentscore})
    tdebs=str2double(get(handles.currenttime,'String'))-handles.winsize/2;
    tfins=str2double(get(handles.currenttime,'String'))+handles.winsize/2;       
    %---artefact on single channels
    [dumb1,dumb2,index2] = intersect(upper(chanlabels(handles.Dmeg{1},channel)),handles.names);
    factscale=handles.scale*chan; %cycle on channels if one file
    tdeb = min(round(slidval*fsample(handles.Dmeg{1})),nsamples(handles.Dmeg{1})-10);
    temps = tdeb:1:min(tdeb +(fsample(handles.Dmeg{1})*handles.winsize)-1, ...
        nsamples(handles.Dmeg{1}));
    toshow = temps;
    temps = temps/fsample(handles.Dmeg{1});
    if  any(channel==emgchannels(handles.Dmeg{1}))  %strfind(testcond{:},'EMG')
        contents = get(handles.EMGpopmenu,'String');
        selchan = upper(contents{get(handles.EMGpopmenu,'Value')});
        if isfield(handles,'emgscale') && ~isempty(handles.emgscale)
            scall=handles.emgscale;
        else
            unemg=units(handles.Dmeg{1},channel);
            try
                scall=eval(unemg{1});
            catch
                if strcmpi(unemg{1},'V')
                    scall=10^-6;
                else
                    scall=1;
                end
            end
        end
        filtparam=handles.filter.coeffEMG;
    elseif any(channel==eogchannels(handles.Dmeg{1})) %strfind(testcond{:},'EOG')
        contents = get(handles.EOGpopmenu,'String');
        selchan=upper(contents{get(handles.EOGpopmenu,'Value')});
        if isfield(handles,'eogscale') && ~isempty(handles.eogscale)
            scall=handles.eogscale;
        else
            unemg=units(handles.Dmeg{1},channel);
            try
                scall=eval(unemg{1});
            catch
                if strcmpi(unemg{1},'V')
                    scall=10^-6;
                else
                    scall=1;
                end
            end
        end
        filtparam=handles.filter.coeffEOG;
    elseif any(channel==ecgchannels(handles.Dmeg{1})) %strfind(testcond{:},'ECG')
        contents = get(handles.otherpopmenu,'String');
        selchan=upper(contents{get(handles.otherpopmenu,'Value')});
        if isfield(handles,'ecgscale') && ~isempty(handles.ecgscale)
            scall=handles.ecgscale;
        else
            unemg=units(handles.Dmeg{1},channel);
            try
                scall=eval(unemg{1});
            catch
                if strcmpi(unemg{1},'V')
                    scall=3*10^-5;
                else
                    scall=1;
                end
            end
        end
        filtparam=handles.filter.coeffother;
    elseif any(channel==meegchannels(handles.Dmeg{1})) %'EEG', 'MEGMAG', MEGPLANAR'
        contents = get(handles.EEGpopmenu,'String');
        selchan=upper(contents{get(handles.EEGpopmenu,'Value')});
        chtyp=chantype(handles.Dmeg{1},channel);
        if strcmpi(chtyp,'EEG')
            if isfield(handles,'eegscale') && ~isempty(handles.eegscale)
                scall=handles.eegscale;
            else
                unemg=units(handles.Dmeg{1},channel);
                try
                    scall=eval(unemg{1});
                catch
                    if strcmpi(unemg{1},'V')
                        scall=10^-6;
                    else
                        scall=1;
                    end
                end
            end
        elseif strcmpi(chtyp,'MEGMAG')
            selchan = 'MEG';
            if isfield(handles,'megmagscale') && ~isempty(handles.megmagscale)
                scall=handles.megmagscale;
            else
                unemg=units(handles.Dmeg{1},channel);
                try
                    scall=eval(unemg{1});
                catch
                    if strcmpi(unemg{1},'T')
                        scall=5*10^-14;
                    else
                        scall=1;
                    end
                end
            end
        elseif strcmpi(chtyp,'MEGPLANAR')
            selchan = 'MEG';
            if isfield(handles,'megplanarscale') && ~isempty(handles.megplanarscale)
                scall=handles.megplanarscale;
            else
                unemg=units(handles.Dmeg{1},channel);
                try
                    scall=eval(unemg{1});
                catch
                    if strcmpi(unemg{1},'T/m')
                        scall=5*10^-13;
                    else
                        scall=1;
                    end
                end
            end
        elseif strcmpi(chtyp,'LFP')
            if isfield(handles,'lfpscale') && ~isempty(handles.lfpscale)
                scall=handles.lfpscale;
            else
                unemg=units(handles.Dmeg{1},channel);
                try
                    scall=eval(unemg{1});
                catch
                    if strcmpi(unemg{1},'V')
                        scall=10^-5;
                    else
                        scall=10 ;
                    end
                end
            end      
        end
        filtparam = handles.filter.coeffother;
    else
        contents = get(handles.EEGpopmenu,'String');
        selchan=upper(contents{get(handles.EEGpopmenu,'Value')});
        chtyp=chantype(handles.Dmeg{1},channel);
        if strcmpi(chtyp,'other') || strcmpi(chtyp,'unknown')
            if isfield(handles,'otherscale') && ~isempty(handles.otherscale)
                scall=handles.otherscale;
            else
                unemg=units(handles.Dmeg{1},channel);
                try
                    scall=eval(unemg{1});
                catch
                    if strcmpi(unemg{1},'V')
                        scall=10^-6;
                    else
                        scall=1;
                    end
                end
            end
        end
        filtparam = handles.filter.coeffother;
    end
    switch  selchan
        case 'MEG'
            % MEG data
            normalize = get(handles.normalize,'Value');
            chtyp=chantype(handles.Dmeg{1},channel);
            if  strcmpi(chtyp,'MEGMAG') 
                plt=plot(handles.axes1,temps,factscale+(handles.Dmeg{1}(channel,toshow))/scall,'Color',[0.25 0.25 0.25]);
            elseif  strcmpi(chtyp,'MEGPLANAR')
                if (~normalize)
                    plt=plot(handles.axes1,temps,factscale+(handles.Dmeg{1}(channel,toshow))/scall,'LineStyle',':','Color',[0 0.5 0]);
                else
                    plt=plot(handles.axes1,temps,factscale+(((handles.Dmeg{1}(channel,toshow)).^2+...
                        (handles.Dmeg{1}(channel+1,toshow)).^2).^0.5)/scall,'Color',[0 0.5 0]);
                end
            end
         case    'REF1'
            plt = plot(handles.axes1,temps,factscale+(handles.Dmeg{1}(channel,toshow))/scall);             
         case    'MEAN OF REF'
            basedata = handles.Dmeg{1}(channel,toshow);
            ref2idx = find(strcmp(chanlabels(handles.Dmeg{1}),'REF2'));
            scnddata = handles.Dmeg{1}(channel,toshow) - ...
                handles.Dmeg{1}(ref2idx,toshow);
            toplotdat = mean([basedata ; scnddata]);
            plt = plot(handles.axes1,temps,factscale+(toplotdat)/scall);

        case    'M1-M2'
            basedata = handles.Dmeg{1}(channel,toshow);
            M1idx = find(strcmp(chanlabels(handles.Dmeg{1}),'M1'));
            M2idx = find(strcmp(chanlabels(handles.Dmeg{1}),'M2'));
            meanM = mean([handles.Dmeg{1}(M1idx,toshow) ; ...
                handles.Dmeg{1}(M2idx,toshow)]);
            toplotdat = basedata - meanM;
            plt = plot(handles.axes1,temps,factscale+(toplotdat)/scall);

        case    'BIPOLAR'
            if handles.crc_types(index2)>0
                [dumb1,index3] = ...
                    intersect(upper(chanlabels(handles.Dmeg{1})), ...
                    upper(handles.names(handles.crc_types(index2))));
            else
                index3 = [];
            end
            if ~isempty(index3)
                bipolar = handles.Dmeg{1}(channel,toshow) - ...
                    handles.Dmeg{1}(index3,toshow);
                plt = plot(handles.axes1,temps,factscale+(bipolar)/scall,'Color',[0 0 0]);
            else
                plt = plot(handles.axes1,temps,factscale+(handles.Dmeg{1}(channel,toshow))/scall,'Color',[0  0 0]);
            end
        otherwise
            [dumb1,index3] = ...
                intersect(upper(chanlabels(handles.Dmeg{1})),selchan);
            basedata = handles.Dmeg{1}(channel,toshow);
            toplotdat = basedata - ...
                handles.Dmeg{1}(index3,toshow);
            plt = plot(handles.axes1,temps,factscale+(toplotdat)/scall);
    end
    filterlowhigh(plt,1,handles,filtparam,factscale)
    sart = find(and(or(not(handles.score{5,handles.currentscore}(:,1)>tfins),...
        not(handles.score{5,handles.currentscore}(:,2)<tdebs)),handles.score{5,handles.currentscore}(:,3)== channel));
    for p = 1 : length(sart)
        sfin = min(tfins*fsample(handles.Dmeg{1}),handles.score{5,handles.currentscore}(sart(p),2)*fsample(handles.Dmeg{1}));
        sdebut = max(handles.score{5,handles.currentscore}(sart(p),1)*fsample(handles.Dmeg{1}), tdebs*fsample(handles.Dmeg{1}));              
        time = sdebut+1 : sfin;               
        time = time/fsample(handles.Dmeg{1});
        X = get(plt,'YData');
        % Plot
        X = X(sdebut-tdebs*fsample(handles.Dmeg{1})+1:sfin-tdebs*fsample(handles.Dmeg{1}))+factscale-mean(X);
        plot(handles.axes1,time,X,'UIContextMenu',handles.Deletemenuone,'LineWidth',1,'Color',[0.8 0.8 0.8]);
    end
end
% ---- save data ----  
handles.Dmeg{1}.CRC.score = handles.score;
D = handles.Dmeg{1};
save(D);

% ---- update menu ----
delete(get(handles.addonlyone,'Children'));   
uimenu(handles.addonlyone,'Label', ...
            ('Start artefact on this channel'),'Callback',{@addstart,handles}) ;
if ~isempty(handles.chan)
    uimenu(handles.addonlyone,'Label', ...
            'End artefact on this channel ','Callback',{@addstart,handles});
end

set(handles.figure1,'CurrentAxes',handles.axes4)
crc_hypnoplot(handles.axes4, ...
    handles,handles.score{3,handles.currentscore})
set(handles.figure1,'CurrentAxes',handles.axes1)

% Update handles structure
guidata(c, handles);
fftchan_Callback(hObject,[],handles)
% --------------------------------------------------------------------
function addspecart_Callback(hObject, eventdata, handles)
% hObject    handle to addspecart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.figure1,'CurrentAxes',handles.axes1)

function addtypeart(hObject,eventdata,handles)
% hObject    handle to addspecart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.figure1,'CurrentAxes',handles.axes1)
a   =   get(hObject,'Parent');
b   =   get(a,'Parent');
c   = 	get(b,'Parent');
handles	=   guidata(c);
handles.unspecart   =   0;

if size(handles.score,1)<8
    for isc=1:size(handles.score,2)
        handles.score{8,isc}=cell(size(handles.score{5,isc},1),1);
    end
end

if handles.adddeb(handles.currentscore) == 1

    Mouse   =   handles.Mouse;
    timedbtart=Mouse(1,1);

    if ~isempty(handles.score{5,handles.currentscore})
        if sum(and(timedbtart>handles.score{5,handles.currentscore}(:,1),...
                timedbtart<handles.score{5,handles.currentscore}(:,2)))

            beep
            disp('Invalid "start Artefact" point')
            disp(' ')

        else
            lab=get(hObject,'Label');

            handles.score{5,handles.currentscore}= ...
                [handles.score{5,handles.currentscore};...
                timedbtart timedbtart 0];
            handles.score{8,handles.currentscore}=[handles.score{8,handles.currentscore};...
                {lab}];

            set(handles.addspecart,'Label','Add "end specified Artefact"');

            handles.adddeb(handles.currentscore) = 0;
            fact    =   min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
            plot(ones(1,2)*timedbtart,[0 handles.scale*(fact+1)], ...
                'UIContextMenu',handles.Deletemenu,'Color',[0 0 0])

            text(timedbtart,handles.scale*(fact+6/8), ...
                'S.Art','Color',[0 0 0],'FontSize',14)
            set(handles.axes1,'Color',[0.9 0.7 0.7])
        end
    else
        lab=get(hObject,'Label');
        handles.score{5,handles.currentscore}=...
            [handles.score{5,handles.currentscore};...
            timedbtart timedbtart 0];
        handles.score{8,handles.currentscore}=[handles.score{8,handles.currentscore};...
            {lab}];

        set(handles.addspecart,'Label','Add "end specified Artefact"');

        handles.adddeb(handles.currentscore) = 0;
        fact    =   min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
        plot(ones(1,2)*timedbtart,[0 handles.scale*(fact+1)], ...
            'UIContextMenu',handles.Deletemenu,'Color',[0 0 0])

        text(timedbtart,handles.scale*(fact+6/8), ...
            'S.Art','Color',[0 0 0],'FontSize',14)
        set(handles.axes1,'Color',[0.9 0.7 0.7])

    end
end
handles.Dmeg{1}.CRC.score=handles.score;
D=handles.Dmeg{1};
save(D);

crcdef = crc_get_defaults('score');
delete(get(handles.addspecart,'Children'));

if strfind(get(handles.addspecart,'Label'),'start')
    for iart=1:size(crcdef.lab_art,2)
        uimenu(handles.addspecart,'Label', ...
            char(crcdef.lab_art{iart}),'Callback',{@addtypeart,handles}) ;
    end
elseif strfind(get(handles.addspecart,'Label'),'end')
    uimenu(handles.addspecart,'Label', ...
        'End artefact','Callback',{@endtypeart,handles}) ;
end

% Update handles structure
guidata(c, handles);

function endtypeart(hObject,eventdata,handles)

a  	=   get(hObject,'Parent');
b   =   get(a,'Parent');
c   =   get(b,'Parent');
handles	=   guidata(c);
Mouse   =   handles.Mouse;
timefinart  =   Mouse(1,1);
handles.unspecart   =   0;
[row]   =   find(and(timefinart>handles.score{5,handles.currentscore}(:,1),...
            timefinart>handles.score{5,handles.currentscore}(:,2)));

test3   =  sum(and(handles.score{5,handles.currentscore}...
    (size(handles.score{5,handles.currentscore},1),1)<...
    handles.score{5,handles.currentscore}(row,1), ...
    handles.score{5,handles.currentscore}...
    (size(handles.score{5,handles.currentscore},1),2)<...
    handles.score{5,handles.currentscore}(row,2)));

if or(or(sum(and(timefinart>handles.score{5,handles.currentscore}(:,1),...
        timefinart<handles.score{5,handles.currentscore}(:,2)))>0, ...
        timefinart<handles.score{5,handles.currentscore}...
        (size(handles.score{5,handles.currentscore},1),2)),test3)

    beep
    disp('Invalid "end Artefact" point')
    disp(' ')
else
    set(handles.addspecart,'Label','Add "start specified Artefact"');

    handles.score{5,handles.currentscore}...
        (size(handles.score{5,handles.currentscore},1),2)= timefinart;

    handles.adddeb(handles.currentscore) = 1;
    fact    =   min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
    plot(ones(1,2)*timefinart,[0 handles.scale*(fact+1)], ...
        'UIContextMenu',handles.Deletemenu,'Color',[0 0 0])
    text(timefinart,handles.scale*(fact+6/8), ...
        'E.Art','Color',[0 0 0],'FontSize',14)
    set(handles.axes1,'Color',[1 1 1])

end
handles.Dmeg{1}.CRC.score=handles.score;
D=handles.Dmeg{1};
save(D);

crcdef = crc_get_defaults('score');
delete(get(handles.addspecart,'Children'));

if strfind(get(handles.addspecart,'Label'),'start')
    for iart=1:size(crcdef.lab_art,2)
        uimenu(handles.addspecart,'Label', ...
            char(crcdef.lab_art{iart}),'Callback',{@addtypeart,handles}) ;
    end
elseif strfind(get(handles.addspecart,'Label'),'end')
    uimenu(handles.addspecart,'Label', ...
        'End artefact','Callback',{@endtypeart,handles}) ;
end
% Update handles structure
guidata(c, handles);

% --------------------------------------------------------------------
function addaro_Callback(hObject, eventdata, handles)
% hObject    handle to addaro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('Arousalchan_data.mat');
load('Arousal_data.mat');
Mouse   =   handles.Mouse;
timedbtaro = Mouse(1,1);
load('Datapath.mat');load('Arousalchan_data.mat')
if handles.addardeb(handles.currentscore) == 1  
    gtext('*S','color',[1 0 0],'FontSize',20);
    timedbtaro  =   Mouse(1,1);%%鼠标所在位置对应的时间
    startpoint = timedbtaro*fsample(handles.Dmeg{1});%纺锤波开始时对应的数据点
    startpage=str2num(get(handles.currentpage,'string'));%当前的页数
    save('Start','startpoint','startpage');
    handles.score{6,handles.currentscore}=[handles.score{6,handles.currentscore}; timedbtaro timedbtaro];
    set(handles.addaro,'Label','Add "end Arousal" point');
    handles.addardeb(handles.currentscore) = 0;
    fact    =   min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
         %       plot(ones(1,2)*timedbtaro,[0 handles.scale*(fact+1)], ...
         %           'UIContextMenu',handles.Delar,'Color',[0 0 0])
     text(timedbtaro,Mouse(1,2), '.','Color',[1 0 0],'FontSize',10)%%在鼠标右击的位置标出记号
         %       text(timedbtaro,handles.scale*(fact+6/8), ...
         %           'S.Aro.','Color',[1 0 0],'FontSize',14)
    set(handles.axes1,'Color',[0.8 0.8 0.95]);
else
    gtext('*E','color',[1 0 0],'FontSize',20);
    load('Start.mat');
    timefinaro=Mouse(1,1);
    endpoint = timefinaro*fsample(handles.Dmeg{1});%纺锤波结束时鼠标对应的数据点
    endpage=str2num(get(handles.currentpage,'string'));%当前的页数
% % %     [row]=find(and(timefinaro>handles.score{6,handles.currentscore}(:,1),...
% % %         timefinaro>handles.score{6,handles.currentscore}(:,2)));
% % %     
% % %     test3=sum(and(handles.score{6,handles.currentscore}...
% % %         (size(handles.score{6,handles.currentscore},1),1)<...
% % %         handles.score{6,handles.currentscore}(row,1), ...
% % %         handles.score{6,handles.currentscore}...
% % %         (size(handles.score{6,handles.currentscore},1),2)<...
% % %         handles.score{6,handles.currentscore}(row,2)));
     set(handles.addaro,'Label','Add "start Arousal" point');
     handles.score{6,handles.currentscore}(size(handles.score{6,handles.currentscore},1),2)= timefinaro;
     handles.addardeb(handles.currentscore) = 1;
     fact    =   min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
   %     plot(ones(1,2)*timefinaro,[0 handles.scale*(fact+1)], ...
   %         'UIContextMenu',handles.Delar,'Color',[0 0 0])
%         text(timefinaro,handles.scale*(fact+6/8), ...
%             'E.Aro','Color',[1 0 0],'FontSize',14)
     text(timefinaro,Mouse(1,2),'E.Aro','Color',[1 0 0],'FontSize',10);
     set(handles.axes1,'Color',[1 1 1]);
      %  set(handles.figure1,'CurrentAxes',handles.axes4)
%         plot(handles.score{6,handles.currentscore}(size(handles.score{6,handles.currentscore},1),1),ones(1,1)*8,...
%             '+','MarkerSize',8,'MarkerFaceColor',[1 0 0],...
%             'MarkerEdgeColor',[1 0 0],'tag','arou')
%         set(handles.figure1,'CurrentAxes',handles.axes1)
     prefix='aro';%设置文件的前缀为aro
     subname=SelChan;
     datFile=strcat(prefix,'_',subname,'_',dataname(1:end-4));
     subname=datFile;%设置文件名
     subname=subname{1};
     filefull=strcat(datFile,'.mat'); 
     startpoint=round(startpoint);
     endpoint=round(endpoint);
     temps=5000;
     startpoint=mod(startpoint,temps);
     endpoint=mod(endpoint,temps);
     Arousal_point(startpage,startpoint:endpoint,ChanIndex)=1;
% %      if  startpage==endpage
% %         DD(startpage,startpoint:endpoint)=1;%%%将数组中对应标记的部分赋值为1
% %     %     save('Arousal','DD');
% %      else
% %          DD(startpage,startpoint:temps)=1;
% %          DD(startpage+1:endpage,1:5000)=1;
% %          DD(endpage,1:endpoint)=1;
% %      end 
     filename='Arousal';
     mkdir(datapath,'Arousal');%在当前目录下面产生一个名为Arousal的文件夹
     % % fullpath=mfilename('fullpath');
     % % fullpath=fileparts(mfilename('fullpath'));
     
     filepath=strcat(datapath,'\Arousal');%设置一个路径，也就是Arousal下
     save('Arousal_data','Arousal_point')
     save(subname,'Arousal_point');%保存纺锤波标记的数据，名为DD的数组，保存为名为aro_***的mat文件（保存在默认目录下）
     datfile=strcat(subname,'.mat');
     copyfile(datfile,filepath);%将保存的mat文件移动到Arousal目录下面
     handles.addardeb(handles.currentscore) = 1;
     delete('Start.mat');
 
    
end


% Save the changes
handles.Dmeg{1}.CRC.score = handles.score;
save(handles.Dmeg{1});

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function addeoi_Callback(hObject, eventdata, handles)
% hObject    handle to addeoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Mouse   =   handles.Mouse;
if handles.add_eoi(handles.currentscore) == 1
    timedbteoi=Mouse(1,1);
    if ~isempty(handles.score{7,handles.currentscore})
        if sum(and(timedbteoi>handles.score{7,handles.currentscore}(:,1),...
                timedbteoi<handles.score{7,handles.currentscore}(:,2)))

            beep
            disp('Invalid "start Event of interest" point')
            disp(' ')

        else
            handles.score{7,handles.currentscore}=...
                [handles.score{7,handles.currentscore}; ...
                timedbteoi timedbteoi];

            set(handles.addeoi,'Label','Add "end Event of interest" point');
            handles.add_eoi(handles.currentscore) = 0;
            fact    =   min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
            plot(ones(1,2)*timedbteoi,[0 handles.scale*(fact+1)], ...
                'UIContextMenu',handles.Deleoi,'Color',[0 0 0])
            text(timedbteoi,handles.scale*(fact+6/8), ...
                'S.EOI.','Color',[0.75 0.2 0.2],'FontSize',14)
        end
    else
        handles.score{7,handles.currentscore}=...
            [handles.score{7,handles.currentscore};...
            timedbteoi timedbteoi];

        set(handles.addeoi,'Label','Add "end Event of interest" point');
        handles.add_eoi(handles.currentscore) = 0;
        fact    =   min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
        plot(ones(1,2)*timedbteoi,[0 handles.scale*(fact+1)], ...
            'UIContextMenu',handles.Deleoi,'Color',[0 0 0])
        text(timedbteoi,handles.scale*(fact+6/8), ...
            'S.EOI','Color',[0.75 0.2 0.2],'FontSize',14)
    end
else
    timefineoi=Mouse(1,1);

    [row]=find(and(timefineoi>handles.score{7,handles.currentscore}(:,1),...
        timefineoi>handles.score{7,handles.currentscore}(:,2)));

    test3=sum(and(handles.score{7,handles.currentscore}...
        (size(handles.score{7,handles.currentscore},1),1)<...
        handles.score{7,handles.currentscore}(row,1), ...
        handles.score{7,handles.currentscore}...
        (size(handles.score{7,handles.currentscore},1),2)<...
        handles.score{7,handles.currentscore}(row,2)));

    if or(or(sum(and(timefineoi>handles.score{7,handles.currentscore}(:,1),...
            timefineoi<handles.score{7,handles.currentscore}(:,2)))>0, ...
            timefineoi<handles.score{7,handles.currentscore}...
            (size(handles.score{7,handles.currentscore},1),2)),test3)

        beep
        disp('Invalid "end Event of interest" point')
        disp(' ')
    else
        set(handles.addeoi,'Label','Add "start Event of interest" point');

        handles.score{7,handles.currentscore}...
            (size(handles.score{7,handles.currentscore},1),2)= timefineoi;

        handles.add_eoi(handles.currentscore) = 1;
        fact    =   min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
        plot(ones(1,2)*timefineoi,[0 handles.scale*(fact+1)], ...
            'UIContextMenu',handles.Deleoi,'Color',[0 0 0])
        text(timefineoi,handles.scale*(fact+6/8), ...
            'E.EOI','Color',[0.75 0.2 0.2],'FontSize',14)
        set(handles.figure1,'CurrentAxes',handles.axes4)
%         plot(handles.score{7,handles.currentscore}(size(handles.score{7,handles.currentscore},1),1),ones(1,1)*8,...
%             '+','MarkerSize',8,'MarkerFaceColor',[0.75 0.2 0.2],...
%             'MarkerEdgeColor',[0.75 0.2 0.2],'tag','eoi')
        set(handles.figure1,'CurrentAxes',handles.axes1)

    end
end

% Save the changes
handles.Dmeg{1}.CRC.score = handles.score;
save(handles.Dmeg{1});

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function FPL_Callback(hObject, eventdata, handles)
% hObject    handle to FPL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Mouse	=  	handles.Mouse;
cpoint  =   Mouse(1,1);
handles.score{4,handles.currentscore}(1)=cpoint;

% Display everything on the axes
mainplot(handles);

set(handles.figure1,'CurrentAxes',handles.axes4)

crc_hypnoplot(handles.axes4,...
    handles,handles.score{3,handles.currentscore});

set(handles.figure1,'CurrentAxes',handles.axes1);

% Save the changes
handles.Dmeg{1}.CRC.score = handles.score;
save(handles.Dmeg{1});

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function OPL_Callback(hObject, eventdata, handles)
% hObject    handle to OPL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Mouse   =   handles.Mouse;
cpoint  =   Mouse(1,1);

handles.score{4,handles.currentscore}(2)=cpoint;

mainplot(handles)

set(handles.figure1,'CurrentAxes',handles.axes4)

crc_hypnoplot(handles.axes4,...
    handles,handles.score{3,handles.currentscore})

set(handles.figure1,'CurrentAxes',handles.axes1);

% Save the changes
handles.Dmeg{1}.CRC.score = handles.score;
save(handles.Dmeg{1});

% Update handles structure
guidata(hObject, handles);

function newtype_Callback(hObject, eventdata, handles)

% hObject    handle to spike (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = gcbo;
b = get(a,'Parent');
handles = guidata(gcbo);

guidata(b, handles);

set(handles.figure1, 'windowbuttonmotionfcn', '')

%create new type structure
prompt = {'Please enter a name for this type of spike'};
def = {'Newtype'};
num_lines = 1;
dlg_title = 'Name of a new kind of spike';
type = inputdlg(prompt,dlg_title,num_lines,def);

%update the uimenu to add this new TYPE
ntype = size(handles.type,1);
handles.type(ntype+1,1) = type;
handles.type(ntype+1,2) = cellstr('red');

delete(get(handles.manevent,'Children'));

for i = 1:size(handles.type,1)
    uimenu(handles.manevent,'Label', char(handles.type(i,1)),'Callback',@Define_event)
end

uimenu(handles.manevent,'Label', ...
    'New Type','Callback', @newtype_Callback,...
    'Separator','on') ;

%update the popupmenu10 (events)
current_events = get(handles.popupmenu10,'String');
events_updated = [current_events; type]; 
set(handles.popupmenu10,'String',events_updated,'Value',length(events_updated))

%update the popupmenu11 (Value of the event = scorer)
current_value = get(handles.popupmenu11,'String');
scorer  = char(handles.score{2,handles.currentscore});
check   = intersect(current_value,scorer);
if isempty(check)
    current_value{end+1} = scorer;
end
set(handles.popupmenu11,'String',current_value,'Value',length(current_value))

set(handles.figure1, 'windowbuttonmotionfcn', @update_powerspect)

guidata(b, handles);
% Update handles structure
mainplot(handles)

function Define_event(hObject, eventdata)

b = get(gcbo,'Parent');
c = get(b,'Parent');
d = get(c,'Parent');

handles = guidata(gcbo);

%Parameters of the new event
type    =   get(gcbo,'Label');
Mouse	=  	handles.Mouse;
cpoint  =   Mouse(1,1);

%Update the events
D   =   handles.Dmeg{1};
ev  =   events(D);
Nev =   size(ev,2);

ev(Nev+1).type  = char(type);
ev(Nev+1).value = char(handles.score{2,handles.currentscore});
ev(Nev+1).time  = cpoint;
ev(Nev+1).duration  = 0;
ev(Nev+1).offset    = 0;

%save 
D = events(D,1,ev);
D.CRC.goodevents    =   ones(1,numel(ev));
save(D);
handles.Dmeg{1} = D;

%redefine handles.evt :
if ~isempty(ev)
    for i   =   1   :   size(ev,2)
        if ~isempty(ev(i)) && isnumeric(ev(i).value)
            ev(i).value    =   num2str(ev(i).value);
        end
    end
end
handles.evt = ev;

%add the scorer in value for events
current_value = get(handles.popupmenu11,'String');
scorer  = char(handles.score{2,handles.currentscore});
check   = intersect(current_value,scorer);
if isempty(check)
    current_value{end+1} = scorer;
end
set(handles.popupmenu11,'String',current_value,'Value',1);

%redefine handles.chosevt
evnum  = get(handles.popupmenu10,'Value');
evtype  = get(handles.popupmenu10,'String');
todisp = evtype(evnum);

if evnum==1
    evnum = 2 : size(evtype,1);
end

chos=[];

for i=1:size(handles.evt,2)
    if any(strcmpi(handles.evt(i).type,evtype(evnum)))
        chos=[chos, i];
    end
end

handles.chosevt = chos;

%new types
evtype = [{'All'} unique({ev(:).type})];
[valtype intevt intdis] = intersect(evtype, todisp);
if isempty(intevt)
    intevt = 1;
elseif intevt>length(evtype)
    intevt = 1;
end
set(handles.popupmenu10,'String',evtype,'Value',intevt);

%new values
pmstring = [{'All'},{'Scan number'},unique({ev(:).value})];

for i=1:size(chos,2)
    if ~strcmpi(handles.evt(chos(i)).value, pmstring)
        pmstring = [pmstring, {handles.evt(chos(i)).value}];
    end
end

handles.displevt    = 0;

set(handles.popupmenu11,...
    'String',pmstring,...
    'Value',length(pmstring))

%Add an landmark on the top axes
set(handles.figure1,'CurrentAxes',handles.axes4);
crc_hypnoplot(handles.axes4, ...
    handles,handles.score{3,handles.currentscore});
set(handles.figure1,'CurrentAxes',handles.axes1);

%Store data in the figure's application 
guidata(d, handles);
%plot the new event
mainplot(handles)

function Delete_Event_Callback(hObject, eventdata, handles)
% hObject    handle to Delete_Event (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Mouse = get(handles.axes1,'CurrentPoint');
locx  = Mouse(1,1);

%search the event to delete
ev = events(handles.Dmeg{1});
locev = cell2mat({(ev(:).time)});
loc = locev - locx;

[m indm]= min(abs(loc(:)));

Stock1 = ev(1 : indm-1);
Stock2 = ev(indm+1 : size(ev,2));

ev = [Stock1 Stock2];
%save the modifications
D = handles.Dmeg{1};
D = events(D,1,ev);
D.CRC.goodevents    =   ones(1,numel(ev));
save(D);
handles.Dmeg{1} = D;

%redefine handles.evt :
if ~isempty(ev)
    for i   =   1   :   size(ev,2)
        if ~isempty(ev(i)) && isnumeric(ev(i).value)
            ev(i).value    =   num2str(ev(i).value);
        end
    end
end
handles.evt = ev;

%redefine handles.chosevt
evnum  = get(handles.popupmenu10,'Value');
evtype  = get(handles.popupmenu10,'String');
todisp = evtype(evnum);

if evnum==1
    evnum = 2 : size(evtype,1);
end

chos=[];

for i=1:size(handles.evt,2)
    if any(strcmpi(handles.evt(i).type,evtype(evnum)))
        chos=[chos, i];
    end
end

handles.chosevt = chos;

%new types
evtype = [{'All'} unique({ev(:).type})];
[valtype intevt intdis] = intersect(evtype, todisp);
if isempty(intevt)
    intevt = 1;
elseif intevt>length(evtype)
    intevt = 1;
end
set(handles.popupmenu10,'String',evtype,'Value',intevt);

%new values
pmstring = [{'All'},{'Scan number'},unique({ev(:).value})];

for i=1:size(chos,2)
    if ~strcmpi(handles.evt(chos(i)).value, pmstring)
        pmstring = [pmstring, {handles.evt(chos(i)).value}];
    end
end

handles.displevt    = 0;

set(handles.popupmenu11,...
    'String',pmstring,...
    'Value',length(pmstring))

set(handles.figure1,'CurrentAxes',handles.axes4);
crc_hypnoplot(handles.axes4, ...
    handles,handles.score{3,handles.currentscore});
set(handles.figure1,'CurrentAxes',handles.axes1);

%update and save
guidata(hObject,handles)
mainplot(handles)
% --------------------------------------------------------------------
function manevent_Callback(hObject, eventdata, handles)
% hObject    handle to manevent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Deletemenu_Callback(hObject, eventdata, handles)
% hObject    handle to Deletemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Deletemenuone_Callback(hObject, eventdata, handles)
% hObject    handle to Deletemenuone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------

function grid_Callback(hObject, eventdata, handles)
% hObject    handle to grid_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function vertgrid_Callback(hObject, eventdata, handles)
% hObject    handle to vertgrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmpi(get(gcbo,'Checked'),'on')
    set(gcbo,'Checked','off')
    handles.vert_grid=0;
else
    set(gcbo,'Checked','on')
    handles.vert_grid=1;
end
mainplot(handles)

guidata(gcbo, handles);

% --------------------------------------------------------------------
function horgrid_Callback(hObject, eventdata, handles)
% hObject    handle to horgrid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmpi(get(gcbo,'Checked'),'on')
    set(gcbo,'Checked','off')
    handles.hor_grid=0;
else
    set(gcbo,'Checked','on')
    handles.hor_grid=1;
end

mainplot(handles)

guidata(gcbo, handles);

%--------------------------------------------------------------------------
% --------------------------------------------------------------------
function score_user_Callback(hObject, eventdata, handles)
% hObject    handle to score_user (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function new_scorer(hObject, eventdata)
% hObject    handle to score_user (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
%get handles of the main parent
a = get(gcbo,'Parent');
b = get(a,'Parent');
c = get(b,'Parent');
%to be checked = old version contained : get(c); What does it means?
handles=guidata(gcbo);

%create new scoring structure
prompt = {'Please enter your name'};
def = {'Newuser'};
num_lines = 1;
dlg_title = 'Name of the new scorer';
handles.score(2,handles.num_scorers +1) = inputdlg(prompt,dlg_title,num_lines,def);

%Choosing size of window to score
prompt = {'Please choose the size of the scoring windows'};
def = {num2str(crc_get_defaults('score.winsize'))};
num_lines = 1;
dlg_title = 'Size of the scoring windows (in sec)';
handles.score{3,handles.num_scorers +1} = inputdlg(prompt,dlg_title,num_lines,def);
handles.score{3,handles.num_scorers +1} = str2double(handles.score{3,handles.num_scorers +1});

% Creating FPL & OPL
handles.score{4,handles.num_scorers +1} = [1/fsample(handles.Dmeg{1}) ...
    nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})];

% Creating artefacts
handles.score{5,handles.num_scorers +1} = [];

% Creating arousals
handles.score{6,handles.num_scorers +1} = [];

% Creating event of interest
handles.score{7,handles.num_scorers +1} = [];

% Putting NaN in the score
handles.score{1,handles.num_scorers +1} = ...
    0/0*ones(1,ceil(nsamples(handles.Dmeg{1}) / ...
    (handles.score{3,handles.num_scorers +1}*fsample(handles.Dmeg{1}))));

D = handles.Dmeg{1};
if isfield(D, 'CRC')
    D.CRC.score=handles.score;
else
    D.CRC = struct('score',[]);
    D.CRC.score=handles.score;
end
handles.num_scorers = handles.num_scorers + 1;
handles.Dmeg{1} = D;
%update the uimenu to add this new scorer
delete(get(handles.score_user,'Children'));
for isc=1:size(handles.score,2)
    handles.scorers{isc} = uimenu(handles.score_user,'Label', ...
        char(handles.score{2,isc}),'Callback',@defined_scorer) ;
    handles.namesc{isc}=char(handles.score{2,isc});
end
handles.num_scorers=isc;
handles.currentscore=isc;
handles.scorers{isc+1}=uimenu(handles.score_user,'Label', ...
    'New scorer','Callback', @new_scorer,...
    'Separator','on') ;
set(handles.scorers{handles.currentscore},'Checked','on');
set(handles.figure1,'CurrentAxes',handles.axes4);
crc_hypnoplot(handles.axes4, ...
    handles,handles.score{3,handles.currentscore});
set(handles.figure1,'CurrentAxes',handles.axes1);
% Setting up the add artefact/arousal/event of interest.
handles.adddeb = ones(1,size(handles.score,2));
handles.addardeb = ones(1,size(handles.score,2));
handles.add_eoi = ones(1,size(handles.score,2));
mainplot(handles)
% Update handles structure
guidata(c, handles);
return

function defined_scorer(hObject, eventdata)
% hObject    handle to score_user (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = get(gcbo,'Parent');
b = get(a,'Parent');
c = get(b,'Parent');
%To be checked = old version contained : get(c);

handles = guidata(gcbo);
namuser = get(gcbo,'Label');

for isc=1:size(handles.namesc,2)
    if strcmpi(namuser,handles.namesc{isc})
        handles.currentscore=isc;
        set(gcbo, 'Checked', 'on');
    else
        set(handles.scorers{isc},'Checked','off')
    end
end

set(handles.figure1,'CurrentAxes',handles.axes4);
crc_hypnoplot(handles.axes4, ...
    handles,handles.score{3,handles.currentscore});
set(handles.figure1,'CurrentAxes',handles.axes1);
mainplot(handles)
% Update handles structure
guidata(c, handles);
return

% -------------------------------------------------------------------
%To be checked : new subfunctions in click
% --- Click

function click(hObject, eventdata, handles)
Mouse = get(handles.axes1,'CurrentPoint');

Mouse = get(handles.axes4,'CurrentPoint');

if Mouse(1,2) > 0   %Even without score sleep, possibility to access from axes4 where we want on main screen
    slidval = Mouse(1);
    slidval = floor(slidval/handles.winsize)*handles.winsize;
    slidval = max(slidval,1/fsample(handles.Dmeg{1}));
    if slidval==nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})
        slidval=str2double(get(handles.currenttime,'String'));
    else
        slidval = min(slidval, ...
            nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2);
    end
    set(handles.slider1,'Value',slidval)
    set(handles.figure1,'CurrentAxes',handles.axes4)
    a=get(handles.axes4,'Children');
    for i=1:size(a,1)
        if strcmpi(get(a(i),'tag'),'cursor')
            delete(a(i))
        end
    end
    hold on
    handles.cursor = plot(slidval+handles.winsize/2,8,'v','Color',[0.2 0.2 0.2],'LineWidth',2.5,'tag','cursor');
    handles.displevt=0;
    guidata(hObject, handles);
    mainplot(handles)
end  
    
% To plot the sensors on the localizer
Mouse2 = get(handles.axes1,'CurrentPoint');
X = get(handles.axes1,'XTick');
Y = get(handles.axes1,'YTick');

if ~get(handles.counterspect,'Value') && and(and(Mouse2(1,1)<X(end),Mouse2(1,1)>X(1)),and(Mouse2(1,2)<Y(end),Mouse2(1,2)>Y(1)))&&~isempty(handles.evt)
    if isfield(handles,'namesc') 
        P = Mouse2(1,1);
        E = [handles.evt(:).time];
        [ve handles.move]=min(abs(E-C)); 
        if and(any(abs(C-E) < 1),any(strcmpi(handles.evt(handles.move).value,handles.namesc)))
            fprintf(['You are going to move the event ' char(handles.evt(handles.move).type) ' of ' char(handles.evt(handles.move).value) '\n']) 
        else 
            handles.move = 0; 
        end
    else 
        handles.move = 0;
    end
    guidata(hObject,handles);
   
    set(handles.figure1,'CurrentAxes',handles.axes5)
    delete(findobj('tag', 'powerspctrm'))   %Effacer le denier power spectrum
    delete(findobj('tag', 'error')) 
    chan = get(handles.fftchan,'Value');
    list = cellstr(get(handles.fftchan,'String'));
    listcompl = chanlabels(handles.Dmeg{1},handles.index);
    [dumb1,dumb2,index]	=   intersect(upper(list),upper(handles.names));
    chantodis  = list(chan);         
    [dumb1,dumb2,indextodis] = intersect(upper(chantodis),upper(handles.names));

    if isempty(indextodis)

        id = indchannel(handles.Dmeg{1},chantodis);
        iddis = indchannel(handles.Dmeg{1},list);
        idtot = indchannel(handles.Dmeg{1},listcompl);

        xytot = coor2D(handles.Dmeg{1},idtot);           
        xbl = xytot(1,:);
        ybl = xytot(2,:);

        xytodis = coor2D(handles.Dmeg{1},id);           
        xblack = xytodis(1);
        yblack = xytodis(2);

        xy = coor2D(handles.Dmeg{1},iddis);
        xblue = xy(1,:);
        yblue = xy(2,:);

        cleargraph(handles.axes5)

        if (xblack)==0
            cleargraph(handles.figure1,'axes5')
        end

        hold on
        plot(xblack,yblack,'kv','tag','localizer'), plot(xblue,yblue,'b+','tag','localizer'),plot(xbl,ybl,'b.','tag','localizer')
        hold off

    else 
    idxred	=   index(find(handles.crc_types(index)<-1));
    idxblue	=   index(find(handles.crc_types(index)>-2));

    xred  	=   handles.pos(1,idxred);
    yred    =   handles.pos(2,idxred);

    xblu    =   handles.pos(1,idxblue);
    yblu    =   handles.pos(2,idxblue);

    xblack  =   handles.pos(1,indextodis);
    yblack  =   handles.pos(2,indextodis);

    cleargraph(handles.axes5)

    hold on
    plot(xred,yred,'r+','tag','localizer'), plot(xblu,yblu,'b+','tag','localizer'), plot(xblack,yblack,'kv','tag','localizer')
    hold off
    if and(length(xblu)==0,length(xred)==0)
        cleargraph(handles.figure1,'axes5')
    end
    end
    xlim([0 1])
    ylim([0 1])

    set(handles.fftchan,'visible','off');
end

set(handles.figure1,'CurrentAxes',handles.axes5); 

% Plot the power spectrum on a bigger figure

Mouse3 = abs(get(handles.axes5,'CurrentPoint'));
X = abs(get(handles.axes5,'XTick'));
Y = abs(get(handles.axes5,'YTick'));
grid off   
if ~or(isempty(X),isempty(Y))     
    if and(and(Mouse3(1,1)<X(end),Mouse3(1,1)>X(1)),or(and(Mouse3(1,2)<Y(end),Mouse3(1,2)>Y(1)),and(Mouse3(1,2)<Y(1),Mouse3(1,2)>Y(end))))                   
        set(handles.figure1,'CurrentAxes',handles.axes5);
        pl = get(findobj('tag', 'powerspctrm'));
       % if handles.figz~=0
       %     z   =   handles.figz;
       % else
       %     z   =   figure;
       % end
       % figure(z)
       % axs     =   get(handles.figz,'Children');
       % cleargraph(z)
         %   set(handles.figure1,'YData',pl.Ydata)
         %   handles.notdetect = 0;
         %   handles.figz = z;
    end
end 
   
    
% --- E
function keypress(hObject, eventdata, handles)
handles = guidata(hObject);
crcdef  =   crc_get_defaults('score');
key     =   str2double(get(handles.figure1,'CurrentCharacter'));
currentwindow   =	floor(str2double(get(handles.currenttime,'String')) ...
                                /handles.winsize)+1;
winsize_select  =   str2double(get(handles.edit1,'String'));
winsize_score   =   handles.Dmeg{1}.CRC.score{3,handles.currentscore};

if handles.scoring && (key>-1 && key<crcdef.nrStage)
    handles.move = 0;
    % Update Score
    maxwindow   =   ceil(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})/...
                            handles.score{3,handles.currentscore});
    if currentwindow>maxwindow
       currentwindow    =   maxwindow;
    end
    handles.score{1,handles.currentscore}(currentwindow)    =   key;

    % Save Score
    handles.Dmeg{1}.CRC.score = handles.score;
    save(handles.Dmeg{1});

    hypjustplot = 0;

    set(handles.figure1,'CurrentAxes',handles.axes1);
    % Goes to next window
    slidval     =   str2double(get(handles.currenttime,'String'));
    slidval     =   (floor(slidval/handles.winsize)+1)*(handles.winsize);
    slidval     =   max(slidval,1/fsample(handles.Dmeg{1}));

    if slidval>=nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2
        slidval     =   currentwindow*handles.winsize;
    else
        slidval     =	min(slidval, currentwindow*handles.winsize);
        %         nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2);
    end
    set(handles.slider1,'Value',slidval);
    set(handles.figure1,'CurrentAxes',handles.axes4);
    crc_plothypno(handles.axes4,...
        handles.score{4,handles.currentscore},handles,handles.score{3,handles.currentscore});
    %Goes to the previous window
elseif or(get(handles.figure1,'CurrentCharacter')=='B',get(handles.figure1,'CurrentCharacter')=='b')
    handles.move = 0;
    slidval = str2double(get(handles.currenttime,'String'));
    slidval = (floor(slidval/handles.winsize)-1)*handles.winsize;
    slidval = max(slidval,1/fsample(handles.Dmeg{1}));
    slidval = min(slidval, currentwindow*handles.winsize);
    %         nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2);

    set(handles.slider1,'Value',slidval);
    set(handles.figure1,'CurrentAxes',handles.axes4);
    crc_plothypno(handles.axes4,...
        handles.score{4,handles.currentscore},handles,handles.score{3,handles.currentscore});
    hypjustplot=0;
    % Goes to next window
elseif or(get(handles.figure1,'CurrentCharacter')=='F',get(handles.figure1,'CurrentCharacter')=='f')
    handles.move = 0;
    slidval     =   str2double(get(handles.currenttime,'String'));
    slidval     =   (floor(slidval/handles.winsize)+1)*handles.winsize;
    slidval     =   max(slidval,1/fsample(handles.Dmeg{1}));

    if slidval>=nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})
        slidval     =   currentwindow*handles.winsize;
    else
        slidval     =   min(slidval, currentwindow*handles.winsize);
        %         nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2);
        set(handles.slider1,'Value',slidval);
    end
    
    set(handles.figure1,'CurrentAxes',handles.axes4);
    crc_plothypno(handles.axes4,...
        handles.score{4,handles.currentscore},handles,handles.score{3,handles.currentscore});
    hypjustplot=0;
else
    touch = int2str(get(handles.figure1,'CurrentCharacter'));
    if and(handles.move~=0,strcmpi(touch,'28'))
        ev = events(handles.Dmeg{1});
        ev(handles.move).time = ev(handles.move).time - 1/fsample(handles.Dmeg{1}); % On avance par 閏hantillon
        handles.evt = ev;
        handles.Dmeg{1} = events(handles.Dmeg{1},1,ev);
        save(handles.Dmeg{1});
        fprintf(['The event ' char(handles.evt(handles.move).type) ' of ' char(handles.evt(handles.move).value) ' is moving on the left : ' num2str(handles.evt(handles.move).time) 'sec \n']) 
        mainplot(handles)
    elseif and(handles.move~=0,strcmpi(touch,'29'))
        ev = events(handles.Dmeg{1});
        ev(handles.move).time + 1/fsample(handles.Dmeg{1});
        ev(handles.move).time = ev(handles.move).time + 1/fsample(handles.Dmeg{1}); % On avance par 閏hantillon
        handles.evt = ev;
        handles.Dmeg{1} = events(handles.Dmeg{1},1,ev);
        save(handles.Dmeg{1});
        fprintf(['The event ' char(handles.evt(handles.move).type) ' of ' char(handles.evt(handles.move).value) ' is moving on the right : ' num2str(handles.evt(handles.move).time) 'sec \n']) 
        mainplot(handles)
    else 
        beep;
        fprintf('Wrong key pressed! Please choose press a number between 0 and %d.\n',crcdef.nrStage-1)
        for ii = 1    :   crcdef.nrStage
            fprintf('%d : %s\n',ii-1,crcdef.stnames_L{ii})
        end
        fprintf('\n')   
    end
    hypjustplot     =  1;
end 

if hypjustplot
    slidval = get(handles.slider1,'Value');
    set(handles.figure1,'CurrentAxes',handles.axes4);
    a   =   get(handles.axes4,'Children');
    for i   =   1   :   size(a,1)
        if strcmpi(get(a(i),'Type'),'line')
            delete(a(i));
        end
    end
    hold on
    handles.cursor  =    plot(slidval+handles.winsize/2,8,'v','Color',[0.6 0.6 0.6],'LineWidth',2.5);
    hold off
else
    set(handles.figure1,'CurrentAxes',handles.axes1);
    mainplot(handles)
end
set(handles.figure1,'CurrentAxes',handles.axes1);
% Update handles structure
guidata(hObject, handles);

%Options for multiple files comparison-------------------------------------
%--------------------------------------------------------------------------
% --------------------------------------------------------------------
% --------------------------------------------------------------------
function multfil_Callback(hObject, eventdata, handles)
% hObject    handle to multfil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%function new_scorer(hObject, eventdata)
%function defined_scorer

function multnames_Callback(hObject, eventdata, handles)
% hObject    handle to multnames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(gcbo, 'Checked'),'on')
    set(gcbo, 'Checked', 'off');
else
    set(gcbo, 'Checked', 'on');
end
mainplot(handles)

% --------------------------------------------------------------------
function multchan_Callback(hObject, eventdata, handles)
% hObject    handle to multchan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Chantodisp(hObject, eventdata)
% hObject    handle to multchan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
namchan=get(hObject,'Label');
a=get(hObject,'Parent');
b=get(a,'Parent');
c=get(b,'Parent');
handles=guidata(c);
for ii=1:size(handles.chanset,2)
    if strcmpi(namchan,handles.chanset{ii})
        set(handles.multchanlab{ii}, 'Checked', 'on');
        handles.Chantodis=ii;
    else
        set(handles.multchanlab{ii},'Checked','off')
    end
end
mainplot(handles)
% Update handles structure
guidata(c, handles);


function multother_Callback(hObject, eventdata, handles)
% hObject    handle to multother (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1)
try
    close(handles.figz)
end
flags=struct('multcomp',[]);
flags.multcomp=1;
Montage(flags)

% --------------------------------------------------------------------
function multclose_Callback(hObject, eventdata, handles)
% hObject    handle to multclose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1)
try
    close(handles.figz)
end

% --------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------------------------------
%------------------------------ MAIN PLOT FUNCTION ------------------------
%--------------------------------------------------------------------------

function mainplot(handles)
set(handles.Fsec,'value',0);
set(handles.Bsec,'value',0);
load('Datapath.mat');
% Fvalue=str2double(get(handles.Fsec,'value'));
% Bvalue=str2double(get(handles.Bsec,'value'));
Fvalue = (get(handles.Fsec,'value'));
Bvalue = (get(handles.Bsec,'value'));
save('Datapath','MarValue','datapath','dataname','Fvalue','Bvalue');
load('data_int');load('Datapath.mat');
if handles.displevt
    handles.evt(handles.displevt).time;
    slidval=handles.evt(handles.displevt).time-handles.winsize/2;
    if slidval<=1
        slidval=max(handles.evt(handles.displevt).time-2,1/fsample(handles.Dmeg{1})); %default value if first event is at the boundary of the file
    elseif slidval>=(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2)        
        slidval=min(handles.evt(handles.displevt).time-2,nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2); %default value if last event is at the boundary of the file
    end
else           
    slidval = floor((get(handles.slider1,'Value')/handles.winsize))*handles.winsize;  
    if slidval<1/fsample(handles.Dmeg{1})
        slidval=1/fsample(handles.Dmeg{1});
        set(handles.slider1,'Value',slidval);
    elseif slidval>nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2;
        slidval=nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2;
        aval=get(handles.slider1,'Max');
        set(handles.slider1,'Value',aval);
    end
end
set(handles.figure1,'CurrentAxes',handles.axes4)
a=get(handles.axes4,'Children');
for i=1:size(a,1)
    if strcmpi(get(a(i),'tag'),'cursor')
        delete(a(i))
    end
end
hold on
handles.cursor = plot(slidval+handles.winsize/2,8,'v','Color',[0.2 0.2 0.2],'LineWidth',2.5,'tag','cursor');
set(handles.figure1,'CurrentAxes',handles.axes1)

cmap = hsv(length(handles.Dmeg));

if handles.export
    axs=get(handles.currentfigure,'CurrentAxes');
    h=axs;
else
    cleargraph(handles.figure1,'axes1');
    h=handles.axes1; 
end
axes(h);

if handles.multcomp
    maxi=length(handles.Dmeg); %number of files
    maxj=1;                    %one channel/file
else
    maxi=1;                    %one file
end
set(handles.currenttime,'String',num2str(round(slidval+handles.winsize/2)));
set(handles.edit1,'String',num2str(handles.winsize));
set(handles.currentpage,'String',num2str(ceil((slidval+handles.winsize/2)/handles.winsize)));
for i=1:maxi
    nosign=1;
    if handles.multcomp
        %Write the names of the files
        if strcmpi(get(handles.multnames,'Checked'),'on')
            [dumb name] = fileparts(handles.Dmeg{i}.fname);
            under       =   find(name=='_');
            name(under) =   ' ';
            text(slidval+4*handles.winsize/10,handles.scale*(i+1/4),name, ...
                'Color',[0.8 0.8 0.8],'FontSize',14)
        end
        %handles timing problem
        start   =   datevec(handles.date(i,1)-handles.mindate);
        start   =   start(4)*60^2+start(5)*60+start(6);
        ending  =   datevec(handles.date(i,2)-handles.mindate);
        ending  =   ending(4)*60^2 + ending(5)*60 + ending(6);
        if or(slidval<start,slidval>ending)
            nosign=0;
        else
            beg     =   slidval - start;
            tdeb    =   round(beg*fsample(handles.Dmeg{i}));
            temps   =   tdeb:1:min(tdeb+(fsample(handles.Dmeg{i})*handles.winsize)-1, ...
                        nsamples(handles.Dmeg{i}));
            toshow  =   temps;
            temps   =   temps/fsample(handles.Dmeg{i})+start;
        end
        %handles channel to display
        Ctodis  =   handles.Chantodis;
        [dumb1,dumb2,index]     =   intersect(handles.chanset{Ctodis}, ...
                                    upper(chanlabels(handles.Dmeg{i})));
   else 
        %timing
        tdeb = min(round(slidval*fsample(handles.Dmeg{i})),nsamples(handles.Dmeg{i})-10);
        %channels
        Chanslidval = get(handles.Chanslider,'Value');
        slidpos     = Chanslidval-rem(Chanslidval,1);
        NbreChandisp    = str2double(get(handles.NbreChan,'String'));%选择通道的数目    
        index   = [handles.indnomeeg handles.indexMEEG];
        handles.inddis = index(slidpos : 1 : slidpos + NbreChandisp -1);
        index   =   handles.inddis;
        set(handles.fftchan,'String',chanlabels(handles.Dmeg{1},handles.inddis))
        maxj    =   length(handles.inddis); %number of channels
        temps   =   tdeb:1:min(tdeb+(fsample(handles.Dmeg{i})*handles.winsize)-1, ...
                    nsamples(handles.Dmeg{i}));
        toshow  =   temps;
        temps   =   temps/fsample(handles.Dmeg{i});
        win =  floor((str2double(get(handles.currenttime,'String')) - handles.winsize/2)/handles.winsize + 1);
   end
   
    if ~nosign  %if multiple comparison and no signal in the considered file
        text(slidval+1*handles.winsize/50,handles.scale*i, ...
            'No Signal here','Color',[0 0 0],'FontSize',14);        
    else
        for j=1:maxj
            hold on
            [dumb1,dumb2,index2] = ...
                intersect(upper(chanlabels(handles.Dmeg{i},index(j))),handles.names);
            %To be checked = old version contained : testcond = chanlabels(handles.Dmeg{i},index(j));
            if handles.multcomp
                factscale = handles.scale*i; %cycle on files if mult comp
            else
                factscale = handles.scale*j; %cycle on channels if one file    
            end
            if  any(index(j)==emgchannels(handles.Dmeg{i}))  %strfind(testcond{:},'EMG')
                contents = get(handles.EMGpopmenu,'String');
                selchan=upper(contents{get(handles.EMGpopmenu,'Value')});
                if isfield(handles,'emgscale') && ~isempty(handles.emgscale)
                    scal=handles.emgscale;
                else
                    unemg=units(handles.Dmeg{i},index(j));
                    try
                        scal=eval(unemg{1});
                    catch
                        if strcmpi(unemg{1},'V')
                            scal=1e0;
                        else
                            scal=1;
                        end
                    end
                end
                filtparam=handles.filter.coeffEMG;
            elseif any(index(j)==eogchannels(handles.Dmeg{i})) %strfind(testcond{:},'EOG')
                contents = get(handles.EOGpopmenu,'String');
                selchan=upper(contents{get(handles.EOGpopmenu,'Value')});
                if isfield(handles,'eogscale') && ~isempty(handles.eogscale)
                    scal=handles.eogscale;
                else
                    unemg=units(handles.Dmeg{i},index(j));
                    try
                        scal=eval(unemg{1});
                    catch
                        if strcmpi(unemg{1},'V')
                            scal=1e0;
                        else
                            scal=1;
                        end
                    end
                end
                filtparam=handles.filter.coeffEOG;
            elseif any(index(j)==ecgchannels(handles.Dmeg{i})) %strfind(testcond{:},'ECG'
                contents = get(handles.otherpopmenu,'String');
                selchan=upper(contents{get(handles.otherpopmenu,'Value')});
                if isfield(handles,'ecgscale') && ~isempty(handles.ecgscale)
                    scal=handles.ecgscale;
                else
                    unemg=units(handles.Dmeg{i},index(j));
                    try
                        scal=eval(unemg{1});
                    catch
                        if strcmpi(unemg{1},'V')
                            scal=3*10^-5;
                        else
                            scal=1;
                        end
                    end
                end
                filtparam=handles.filter.coeffother;
            elseif any(index(j)==meegchannels(handles.Dmeg{i})) %'EEG', 'MEGMAG', MEGPLANAR'               
% %                 contents = get(handles.EEGpopmenu,'String');
% %                 selchan=upper(contents{get(handles.EEGpopmenu,'Value')});
                  cotents=totalstring;
                  selchan=refstring(j);
                  chtyp=chantype(handles.Dmeg{i},index(j));
                if strcmpi(chtyp,'EEG')
                    if isfield(handles,'eegscale') && ~isempty(handles.eegscale)
                        scal=handles.eegscale;
                    else
                        unemg=units(handles.Dmeg{i},index(j));
                        try
                            scal=eval(unemg{1});
                        catch
                            if strcmpi(unemg{1},'V')
                                scal=1e0;
                            else
                                scal=1;
                            end
                        end
                    end
                elseif strcmpi(chtyp,'MEGMAG')
                    selchan = 'MEG';
                    if isfield(handles,'megmagscale') && ~isempty(handles.megmagscale)
                        scal=handles.megmagscale;
                    else
                        unemg=units(handles.Dmeg{i},index(j));
                        try
                            scal=eval(unemg{1});
                        catch
                            if strcmpi(unemg{1},'T')
                                scal=5*10^-14;
                            else
                                scal=1;
                            end
                        end
                    end
                elseif strcmpi(chtyp,'MEGPLANAR')
                    selchan = 'MEG';
                    if isfield(handles,'megplanarscale') && ~isempty(handles.megplanarscale)
                        scal=handles.megplanarscale;
                    else
                        unemg=units(handles.Dmeg{i},index(j));
                        try
                            scal=eval(unemg{1});
                        catch
                            if strcmpi(unemg{1},'T/m')
                                scal=5*10^-13;
                            else
                                scal=1;
                            end
                        end
                    end
                 elseif strcmpi(chtyp,'LFP')
                    if isfield(handles,'lfpscale') && ~isempty(handles.lfpscale)
                        scal=handles.lfpscale;
                    else
                        unemg=units(handles.Dmeg{i},index(j));
                        try
                            scal=eval(unemg{1});
                        catch
                            if strcmpi(unemg{1},'V')
                                scal=10^-5;
                            else
                                scal=10 ;
                            end
                        end
                    end
                end
                filtparam=handles.filter.coeffother;
            else
                contents = get(handles.EEGpopmenu,'String');
                selchan=upper(contents{get(handles.EEGpopmenu,'Value')});
                chtyp=chantype(handles.Dmeg{i},index(j));
                if strcmpi(chtyp,'other') || strcmpi(chtyp,'unknown')
                    if isfield(handles,'otherscale') && ~isempty(handles.otherscale)
                        scal=handles.otherscale;
                    else
                        unemg=units(handles.Dmeg{i},index(j));
                        try
                            scal=eval(unemg{1});
                        catch
                            if strcmpi(unemg{1},'V')
                                scal=1e0;
                            else
                                scal=1;
                            end
                            
                        end
                    end
                end
                filtparam=handles.filter.coeffother;
            end
           %Plot data   
           if iscell(selchan)
             selchan = cell2mat(selchan);
           end
            switch  selchan
                case 'MEG'
                    % MEG data
                    normalize   =   get(handles.normalize,'Value');
                    chtyp = chantype(handles.Dmeg{i},index(j));
                    if  strcmpi(chtyp,'MEGMAG') 
                        plt     =   plot(temps,factscale+(handles.Dmeg{i}(index(j),toshow))/scal,'Color',[0.25 0.25 0.25]);
                    elseif  strcmpi(chtyp,'MEGPLANAR')
                        if (~normalize)
                            plt     =   plot(temps,factscale+(handles.Dmeg{i}(index(j),toshow))/scal,'Color',[0.5 0.5 0]);
                        else
                            plt     =   plot(temps,factscale+(((handles.Dmeg{i}(index(j),toshow)).^2+...
                                        (handles.Dmeg{i}(index(j)+1,toshow)).^2).^0.5)/scal,'Color',[0 0.5 0]);
                        end
                    end
                 case    'REF1'
                    plt         = 	plot(temps,factscale + (handles.Dmeg{i}(index(j),toshow))/scal);      %%%%%显示图形     
                   
                 case    'MEAN OF REF'
                    basedata    =   handles.Dmeg{i}(index(j),toshow);
                    ref2idx     =   find(strcmp(chanlabels(handles.Dmeg{i}),'REF2'));
                    scnddata    =   handles.Dmeg{i}(index(j),toshow) - handles.Dmeg{i}(ref2idx,toshow);                         
                    toplotdat   =   mean([basedata ; scnddata]);
                    plt         =   plot(temps,factscale+(toplotdat)/scal);

                case    'M1-M2'
                    basedata    =   handles.Dmeg{i}(index(j),toshow);
                    M1idx       =   find(strcmp(chanlabels(handles.Dmeg{i}),'M1'));
                    M2idx       =   find(strcmp(chanlabels(handles.Dmeg{i}),'M2'));
                    meanM       =   mean([handles.Dmeg{i}(M1idx,toshow) ; ...
                                            handles.Dmeg{i}(M2idx,toshow)]);
                    toplotdat   = 	basedata - meanM;
                    plt         =   plot(temps,factscale+(toplotdat)/scal);

                case    'BIPOLAR'
                    if handles.crc_types(index2)>0
                        [dumb1,index3] = ...
                            intersect(upper(chanlabels(handles.Dmeg{i})), ...
                            upper(handles.names(handles.crc_types(index2))));
                    else
                        index3 = [];
                    end
                    if ~isempty(index3)
                        bipolar	=   handles.Dmeg{i}(index(j),toshow) - handles.Dmeg{i}(index3,toshow);
                        plt  	=   plot(temps,factscale+(bipolar)/scal,'Color','k');
                    else
                        plt     =   plot(temps,factscale+(handles.Dmeg{i}(index(j),toshow))/scal,'Color','k');       
                    end

                otherwise
                    dumb1=refstring(maxj-j+1);
                    index3=ref(maxj-j+1);
%                     [dumb1,index3]  =   intersect(upper(chanlabels(handles.Dmeg{i})),selchan);       
                    basedata        =   handles.Dmeg{i}(index(j),toshow);
                    toplotdat       =   basedata - handles.Dmeg{i}(index3,toshow);
                    plt  	=   plot(temps,factscale+(toplotdat)/scal);
            end
            filterlowhigh(plt,i,handles,filtparam,factscale)
            if plt~=0 && any(index(j)==ecgchannels(handles.Dmeg{i}))
                set(plt,'Color',[1 0.1 0.1])
            end
            if plt~=0 && handles.multcomp
                set(plt,'Color',cmap(i,:))
            end    
            currentIndex=get(handles.Chans,'Value');
            if plt~=0 && currentIndex~=j && (MarValue==1)
                set(plt,'Color',[0 0 0])
            end
            
            %artefacts on single channel  (To be checked) 
            if handles.scoring && ~isempty(handles.score{5,handles.currentscore}) && any(index(j)== handles.score{5,handles.currentscore}(:,3))
                [dum indice]= intersect(handles.score{5,handles.currentscore}(:,3),index(j)); 
                l=1;
                tdebs   =   str2double(get(handles.currenttime,'String'))-handles.winsize/2;
                tfins   =	str2double(get(handles.currenttime,'String'))+handles.winsize/2;
                while l<=length(indice) 
                    if(or(or(handles.score{5,handles.currentscore}(indice(l),2)>tdebs,handles.score{5,handles.currentscore}(indice(l),1)<tdebs),...
                        or(handles.score{5,handles.currentscore}(indice(l),1)<tfins,handles.score{5,handles.currentscore}(indice(l),2)>tfins)))
                        [dum ind]=intersect(handles.inddis,index(j));
                        if handles.score{5,handles.currentscore}(indice(l),1)>tdebs
                            text(handles.score{5,handles.currentscore}(indice(l),1),...
                            (ind*handles.scale + handles.scale/2), ...
                            'Start Bad Chan','Color',[0 0 0],'FontSize',12) ;
                            plot(ones(1,2)*handles.score{5,handles.currentscore}(indice(l),1), ...
                            [(ind*handles.scale-handles.scale/2) (ind*handles.scale + handles.scale/2)], ...
                            'Color',[0 0 0])
                        end
                        if handles.score{5,handles.currentscore}(indice(l),2)<tfins
                            text(handles.score{5,handles.currentscore}(indice(l),2),...
                            (ind*handles.scale + handles.scale/2), ...
                            'End Bad Chan','Color',[0 0 0],'FontSize',12) 
                            plot(ones(1,2)*handles.score{5,handles.currentscore}(indice(l),2), ...
                            [(ind*handles.scale-handles.scale/2) (ind*handles.scale + handles.scale/2)], ...
                            'Color',[0 0 0])
                        end
                        if handles.score{5,handles.currentscore}(indice(l),2) ~= handles.score{5,handles.currentscore}(indice(l),1)
                            sfin = min(tfins*fsample(handles.Dmeg{1}),handles.score{5,handles.currentscore}(indice(l),2)*fsample(handles.Dmeg{1}));
                        else
                            sfin = tfins*fsample(handles.Dmeg{1});
                        end
                        tdeb = min(round(slidval*fsample(handles.Dmeg{1})),nsamples(handles.Dmeg{1})-10);
                        sdebut = max(handles.score{5,handles.currentscore}(indice(l),1)*fsample(handles.Dmeg{1}), tdebs*fsample(handles.Dmeg{1}));               
                        time = sdebut+1 : sfin;               
                        time = time/fsample(handles.Dmeg{1});
                        X = get(plt,'YData');
                        
                        %Plot
                        X = X(sdebut-tdebs*fsample(handles.Dmeg{1})+1:sfin-tdebs*fsample(handles.Dmeg{1}));
                        if handles.export
                            plot(time,X,'Color',[0.8 0.8 0.8]);
                        else  
                            plot(time,X,'UIContextMenu',handles.Deletemenuone,'Color',[0.8 0.8 0.8]);
                        end
                    end
                    l=l+1;
                end
            end
            %artefacts : automatique  
            if ~isempty(handles.artefacteeg)                
                deb_epoch   =   find(and(handles.artefacteeg>=temps(1),handles.artefacteeg<=temps(end)));
                for epo     =   1 : length(deb_epoch)   
                    time_epo = handles.artefacteeg(deb_epoch(epo)) : 1/fsample(handles.Dmeg{1}) : min(handles.artefacteeg(deb_epoch(epo))+1, temps(end));   
                    deb =   max((time_epo(1)-(win-1)*30)*fsample(handles.Dmeg{i}),1);
                    fin =   deb + length(time_epo)-1;
                    X   =   get(plt,'YData');
                    X   =   X(deb:fin);
                    plot(time_epo,X,'-.','color','r');
                end  
            end
            %artefacts channels: automatic        
            if isfield(handles.Dmeg{1}.CRC,'badchannels')
                deb_epoch   =   find(handles.Dmeg{i}.CRC.badchannels(:,1) == win);
                if any(index(j) == handles.indeeg(handles.Dmeg{i}.CRC.badchannels(deb_epoch,2)))   
                    X   =   get(plt,'YData');
                    plot(temps,X,'-.','color','r');
                end
            end
            plt = 0;
        end
    end
end

if handles.displevt
    timevt=handles.evt(handles.displevt).time;
    szevt=handles.scale*size(index,2);
    hold on
    plot(timevt*ones(1,szevt+1),handles.scale/2:handles.scale/2+szevt,'-r','Linewidth',2)
end

%display the labels on the y-axis
if handles.multcomp
    i=length(handles.Dmeg);
else
    i=length(index);
end

 ylim([0 handles.scale*(length(index)+1)])
 set(handles.axes1,'YTick',[handles.scale/2 :handles.scale/2:i*handles.scale+handles.scale/2]);
 ylabels=[num2str(round(handles.scale/2))];

for j = 1 : i
    if handles.multcomp
        ylabels =[ylabels {num2str(j)}];
    else
        if and(get(handles.normalize,'Value'),strcmpi(chantype(handles.Dmeg{1},index(j)),'MEGPLANAR'))
            stringn = char(chanlabels(handles.Dmeg{1},index(j)+2));
            string = [stringn(1:end-1), 'N'];
            ylabels  = [ylabels {string}];
        else 
           ylabels = [ylabels chanlabels(handles.Dmeg{1},index(j))];
        end
    end
    ylabels = [ylabels num2str(round(handles.scale/2))];
end
set(handles.axes1,'YTickLabel',ylabels);

xlim([temps(1) temps(1)+handles.winsize])
xtick = get(handles.axes1,'XTick');
if isfield(handles,'offset')
    xtick = mod(xtick + handles.offset,24*60^2);
end
[time string] = crc_time_converts(xtick);
set(handles.axes1,'XTickLabel',string)

% display horizontal grid
if handles.hor_grid
    for i = 1:length(index)
        plot([temps(1) temps(end)],[(35+handles.scale*i) (35+handles.scale*i)], ...
            ':','Color',[0.6 0.6 0.6])
        plot([temps(1) temps(end)],[(handles.scale*i-35) (handles.scale*i-35)], ...
            ':','Color',[0.6 0.6 0.6])
    end
end

% display vertical grid
if handles.vert_grid
    Ax=get(handles.axes1,'XTick');
    for ii = Ax(1)-1:1:Ax(end)+1
        plot([ii ii],[0 (handles.scale*(1+length(index)))],':','Color',[0.6 0.6 0.6])
    end
end

%%%%plot Arousal marker
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (MarValue==1)
    set(handles.togglebutton,'Enable','on');
    set(handles.togglebutton,'value',0);
    set(handles.togglebutton,'string','Spindle Marker');
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
            down_y=Arou.pos_Fp2(Arou.j_fp1(1,currentpage-1),2,currentpage-1);%上一页最后一条线起始点的纵坐标
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
    %%%c3通道
    if (currentpage>1)&&any(((Arou.C3(currentpage-1,:))))&&(Arou.j_c3(1,currentpage-1)>0)&&...
            any((Arou.pos_C3(Arou.j_c3(1,currentpage-1),1,currentpage-1)))%如果上一页面末尾有纺锤波标记,且对应位置记录了坐标值%如果上一页面有纺锤波标记
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
            down_x=min(Arou.pos_C3(1:Arou.j_c3(currentpage+1),1,currentpage+1));;%下一页第一条线起始点的横坐标
            down_y=Arou.pos_C3(1,2,currentpage+1);%上一页第一条线起始点的纵坐标
            up_x=min(Arou.pos_C3(1:Arou.j_c3(currentpage+1),3,currentpage+1));;%下一页第一条线终止点的横坐标
            up_y=Arou.pos_C3(1,4,currentpage+1);%下一页第一条线终止点的纵坐标
            plot([down_x,up_x],[down_y,up_y],'Color',[0 0.6 0],'LineWidth',4,'DisplayName','plot_c3','Tag','1');%连接这两点，作为标记
        elseif ((Arou.C3(currentpage+1,1)==0.5))
            down_x=min(Arou.pos_C3(1:Arou.j_c3(currentpage+1),1,currentpage+1));;%下一页第一条线起始点的横坐标
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
    set(gcf,'WindowButtonDownFcn',@buttondown_change);
end
%Update the score of the current window
if handles.scoring && handles.winsize == handles.score{3,handles.currentscore} % New gardian to check the window size corresponds to those is used to score file
    ll  =   str2double(get(handles.NbreChan,'String'));
    fact    =   min(ll,length(handles.indexMEEG) + length(handles.indnomeeg));
    currentwindow = floor(str2double(get(handles.currenttime,'String'))/handles.winsize)+1;  
    if currentwindow>size(handles.score{1,handles.currentscore},2)
        currentwindow = currentwindow-1;
    end
    curscore = handles.score{1,handles.currentscore}(currentwindow);
    text(temps(end-round(0.8*fsample(handles.Dmeg{1}))),handles.scale*(fact+5/8),num2str(curscore),'Color','k','FontSize',14)
    switch  curscore
        case    0
            plot(temps,((length(index)+1)*handles.scale-1/10000000)*ones(1,length(temps)), ...
                'linewidth',10,'color',[0.2 0.75 0.6])
        case    1
            plot(temps,((length(index)+1)*handles.scale-1/10000000)*ones(1,length(temps)), ...
                'linewidth',10,'color',[0 0.8 1])
        case    2
            plot(temps,((length(index)+1)*handles.scale-1/10000000)*ones(1,length(temps)), ...
                'linewidth',10,'color',[0.1 0.5 0.9])
        case    3
            plot(temps,((length(index)+1)*handles.scale-1/10000000)*ones(1,length(temps)), ...
                'linewidth',10,'color',[0.1 0.2 0.8])
        case    4
            plot(temps,((length(index)+1)*handles.scale-1/10000000)*ones(1,length(temps)), ...
                'linewidth',10,'color',[0.1 0.15 0.5])
        case    5
            plot(temps,((length(index)+1)*handles.scale-1/10000000)*ones(1,length(temps)), ...
                'linewidth',10,'color',[0.5 0.5 0.9])
        case    6
            plot(temps,((length(index)+1)*handles.scale-1/10000000)*ones(1,length(temps)), ...
                'linewidth',10,'color',[0.9 0.4 0.4])
        case    7
            plot(temps,((length(index)+1)*handles.scale-1/10000000)*ones(1,length(temps)), ...
                'linewidth',10,'color',[0.9 0.6 0.3])
    end


    
    % Plot opl & fpl
    tdebs = str2double(get(handles.currenttime,'String'))-handles.winsize/2;
    tfins = str2double(get(handles.currenttime,'String'))+handles.winsize/2;
    fpl = find(and(handles.score{4,handles.currentscore}(:,1)>tdebs,...
        handles.score{4,handles.currentscore}(:,1)<tfins));
    opl = find(and(handles.score{4,handles.currentscore}(:,2)>tdebs,...
        handles.score{4,handles.currentscore}(:,2)<tfins));
    for i=1:length(fpl)
        plot(ones(1,2)*handles.score{4,handles.currentscore}(fpl(i),1),[0 handles.scale*(fact+1)],'Color',[0 0 0])
        text(handles.score{4,handles.currentscore}(fpl(i),1),handles.scale*(fact+6/8),'FPL','Color',[0 0 0.9],'FontSize',14)
    end
    for i=1:length(opl)
        plot(ones(1,2)*handles.score{4,handles.currentscore}(opl(i),2),[0 handles.scale*(fact+1)],'Color',[0 0 0])
        text(handles.score{4,handles.currentscore}(opl(i),2),handles.scale*(fact+6/8),'OPL','Color',[0 0 0.9],'FontSize',14)
    end
    % Display art
    if ~isempty(handles.score{5,handles.currentscore})
        tdebs=str2double(get(handles.currenttime,'String'))-handles.winsize/2;
        tfins=str2double(get(handles.currenttime,'String'))+handles.winsize/2;       
        %---artefact on all channels
        startart=find(and(and(handles.score{5,handles.currentscore}(:,1)>tdebs,...
            handles.score{5,handles.currentscore}(:,1)<tfins),handles.score{5,handles.currentscore}(:,3)==0));
        endart=find(and(and(handles.score{5,handles.currentscore}(:,2)>tdebs,...
            handles.score{5,handles.currentscore}(:,2)<tfins),handles.score{5,handles.currentscore}(:,3)==0));
        for i=1:length(startart)
            if handles.export 
                plot(ones(1,2)*handles.score{5,handles.currentscore}(startart(i),1), ...
                    [0 handles.scale*(fact+1)], ...
                    'Color',[0 0 0])
                text(handles.score{5,handles.currentscore}(startart(i),1),...
                    handles.scale*(fact+6/8), ...
                    'S.Art','Color',[0 0 0],'FontSize',14)             
            else
                plot(ones(1,2)*handles.score{5,handles.currentscore}(startart(i),1), ...
                    [0 handles.scale*(fact+1)], ...
                    'UIContextMenu',handles.Deletemenu,'Color',[0 0 0])
                text(handles.score{5,handles.currentscore}(startart(i),1),...
                    handles.scale*(fact+6/8), ...
                    'S.Art','Color',[0 0 0],'FontSize',14)                              
            end
        end
        for i=1:length(endart)
            if handles.export
                plot(ones(1,2)*handles.score{5,handles.currentscore}(endart(i),2), ...
                	[0 handles.scale*(fact+1)], ...
                   	'Color',[0 0 0])
                text(handles.score{5,handles.currentscore}(endart(i),1),...
                    handles.scale*(fact+6/8), ...
                    'E.Art','Color',[0 0 0],'FontSize',14)         
            else
                plot(ones(1,2)*handles.score{5,handles.currentscore}(endart(i),2), ...
                    [0 handles.scale*(fact+1)],'UIContextMenu', ...
                    handles.Deletemenu,'Color',[0 0 0])
                text(handles.score{5,handles.currentscore}(endart(i),2),...
                    handles.scale*(fact+6/8), ...
                    'E.Art','Color',[0 0 0],'FontSize',14)
            end
        end  
    end 
                                                
    % Display arousal
    if ~isempty(handles.score{6,handles.currentscore})
        tdebs=str2double(get(handles.currenttime,'String'))-handles.winsize/2;
        tfins=str2double(get(handles.currenttime,'String'))+handles.winsize/2;
        startaro=find(and(handles.score{6,handles.currentscore}(:,1)>tdebs,...
            handles.score{6,handles.currentscore}(:,1)<tfins));
        endaro=find(and(handles.score{6,handles.currentscore}(:,2)>tdebs,...
            handles.score{6,handles.currentscore}(:,2)<tfins));
        for i=1:length(startaro)
%             if handles.export
%                 plot(ones(1,2)*handles.score{6,handles.currentscore}(startaro(i),1), ...
%                     [0 handles.scale*(fact+1)],...
%                     'Color',[0 0 0])
%             else
%                 plot(ones(1,2)*handles.score{6,handles.currentscore}(startaro(i),1), ...
%                     [0 handles.scale*(fact+1)],'UIContextMenu',...
%                     handles.Delar,'Color',[0 0 0])
%             end
            plot(handles.score{6,handles.currentscore}(startaro(i),1),handles.scale*fact,'r*');
% % %             text(handles.score{6,handles.currentscore}(startaro(i),1),...
% % %                 handles.scale*(fact+6/8), ...
% % %                 'S.Aro','Color',[1 0 0],'FontSize',10)
        end
        for i=1:length(endaro)
%             if handles.export
%                 plot(ones(1,2)*handles.score{6,handles.currentscore}(endaro(i),2), ...
%                     [0 handles.scale*(fact+1)],...
%                     'Color',[0 0 0])
%             else
%                 plot(ones(1,2)*handles.score{6,handles.currentscore}(endaro(i),2), ...
%                     [0 handles.scale*(fact+1)],'UIContextMenu',...
%                     handles.Delar,'Color',[0 0 0])
%             end
             plot(handles.score{6,handles.currentscore}(endaro(i),1),handles.scale*fact,'r*');
% % %             text(handles.score{6,handles.currentscore}(endaro(i),2),...
% % %                 handles.scale*(fact+6/8), ...
% % %                 'E.Aro','Color',[1 0 0],'FontSize',10)
        end
    end

    % Display EOI
    if ~isempty(handles.score{7,handles.currentscore})
        tdebs=str2double(get(handles.currenttime,'String'))-handles.winsize/2;
        tfins=str2double(get(handles.currenttime,'String'))+handles.winsize/2;
        starteoi=find(and(handles.score{7,handles.currentscore}(:,1)>tdebs,...
            handles.score{7,handles.currentscore}(:,1)<tfins));
        endeoi=find(and(handles.score{7,handles.currentscore}(:,2)>tdebs,...
            handles.score{7,handles.currentscore}(:,2)<tfins));
        for i=1:length(starteoi)
            if handles.export
                plot(ones(1,2)*handles.score{7,handles.currentscore}(starteoi(i),1), ...
                    [0 handles.scale*(fact+1)],...
                    'Color',[0 0 0])
            else
                plot(ones(1,2)*handles.score{7,handles.currentscore}(starteoi(i),1), ...
                    [0 handles.scale*(fact+1)],'UIContextMenu',...
                    handles.Deleoi,'Color',[0 0 0])
            end
            text(handles.score{7,handles.currentscore}(starteoi(i),1),...
                handles.scale*(fact+6/8), ...
                'S.EOI','Color',[0.75 0.2 0.2],'FontSize',14)
        end
        for i=1:length(endeoi)
            if handles.export
                plot(ones(1,2)*handles.score{7,handles.currentscore}(endeoi(i),2), ...
                    [0 handles.scale*(fact+1)],...
                    'Color',[0 0 0])
            else
                plot(ones(1,2)*handles.score{7,handles.currentscore}(endeoi(i),2), ...
                    [0 handles.scale*(fact+1)],'UIContextMenu',...
                    handles.Deleoi,'Color',[0 0 0])
            end
            text(handles.score{7,handles.currentscore}(endeoi(i),2),...
                handles.scale*(fact+6/8), ...
                'E.EOI','Color',[0.75 0.2 0.2],'FontSize',14)
        end
    end
end
grid on

% Display trigger
if ~handles.multcomp
    ev = events(handles.Dmeg{1});

    if iscell(ev)
        ev=cell2mat(ev);
    end
    if isempty(ev)
        ev=struct('time', -500,'value', -2000);
    end
    try
        [int indextoshow indextrig] = intersect(toshow,round([ev(:).time]*fsample(handles.Dmeg{1})));
    catch
        [int indextoshow indextrig] = intersect(toshow,round([ev{:}.time]*fsample(handles.Dmeg{1})));
    end
    itrigger=[];
    if ~isempty(handles.base) && ~isempty(intersect(handles.base(:,1),{ev(indextrig).type}))
        for tr = 1 : max(size(indextrig))
            itrigger = [itrigger find([ev(:).time] == ev(indextrig(tr)).time)];
        end
    end

%     %Check if some events happens at the same time (je ne pense pas que
%     %cette partie de code fonctionne!)
%     if ~isempty(indextrig) && indextrig(1)~=1
%         if and(ev(indextrig(1)).time == ev(indextrig(1)-1).time,length(indextrig)~=length(indextrig(1):indextrig(end)))
%             trou=diff(indextrig);
%             trouve=find(trou==2)+1;
%             int = sort([int(1) int int(trouve)]);
%             indextrig = sort([(indextrig(1)-1) indextrig (indextrig(trouve)-1)]);
%         elseif ev(indextrig(1)).time == ev(indextrig(1)-1).time
%             int = sort([int(1) int]);
%             indextrig = sort([(indextrig(1)-1) indextrig]);
%         end
%     end
%     if ~isempty(indextrig) && length(indextrig)~=length(indextrig(1):indextrig(end))
%         trou=diff(indextrig);
%         trouve=find(trou==2)+1;
%         int = sort([int int(trouve)]);
%         indextrig = sort([indextrig (indextrig(trouve)-1)]);
%     end
    int = int/fsample(handles.Dmeg{1});
    Nev_dis = length(int);
    if Nev_dis % do all this if there are several triggers to be displayed !
        try
            tmp_val = ev(indextrig(1)).value;
        catch
            tmp_val = ev{indextrig(1)}.value;
        end
        if ischar(tmp_val)
            use_numv = 0;
        else
            use_numv = 1;
        end
        etype=cell(Nev_dis,1);
        for i=1:Nev_dis
            if use_numv
                etype{i}=num2str(ev(indextrig(i)).value);
            else
                etype{i}=ev(indextrig(i)).value;
            end
        end
        etpv = {ev(indextrig).type};
        plot(int,0.5*ones(1,length(int))*handles.scale/50*(NbreChandisp), ...
            'k^','LineWidth',2.5)
        if ~isempty(handles.type)
            [manev inte intm] = intersect(etpv,handles.type(:,1));
        else 
            manev = [];
        end
        nme = length(manev);
        for me = 1 : nme
            inte = find(strcmpi(etpv,manev(me)));
            col = char(handles.type(intm(me),2));
            incol = col(:,1);
            if ~handles.export 
                plot(int(inte),0.5*ones(1,length(int(inte)))*handles.scale/50*(NbreChandisp),'^','Color',incol,'UIContextMenu',handles.DeletEvents,...
                    'LineWidth',2.5)
                for nse = 1 : length(inte)
                    plot(ones(1,2).*int(inte(nse)),[handles.scale/2 handles.scale*(NbreChandisp)+handles.scale],'Color',incol,'UIContextMenu',handles.DeletEvents,...
                        'LineWidth',0.5)
                end
            else 
                plot(int(inte),0.5*ones(1,length(int(inte)))*handles.scale/50*(NbreChandisp),'^','Color',incol,...
                    'LineWidth',2.5)
                for nse = 1 : length(inte)
                    plot(ones(1,2).*int(inte(nse)),[handles.scale/2 handles.scale*(NbreChandisp)+handles.scale],'Color',incol,'LineWidth',0.5)
                end
            end                
        end
        %chose between the display of type or of value
        fmric=0;
        if ~(max(size(handles.evt))==max(size(handles.chosevt)))
            disc=1;
%            evtp=get(handles.popupmenu11,'Value');
%            if evtp==1
%                evtch=get(handles.popupmenu10,'String');
%                evtp=get(handles.popupmenu10,'Value');
%                chostype=1;
%                typevt=evtch(evtp);
%            elseif evtp==2
%                fmric=1;
%                evtch=get(handles.popupmenu10,'String');
%                evtp=get(handles.popupmenu10,'Value');
%                chostype=1;
%                typevt=evtch(evtp);
%            else
%               evtch=get(handles.popupmenu11,'String');
%               chostype=0;
%                typevt=evtch(evtp);
%           end
        else
            disc=0;
%            if get(handles.popupmenu11,'Value')==2
%                fmric=1;
%            end
        end
        for jj = 1:Nev_dis
            %if types or values are chosen by the user, only display their
            %names
             if isempty(handles.base) || isempty(intersect(handles.base(:,1),{ev(indextrig).type})) % pas de selection faite ou pas de trigger correspondant ?la selection faite
                if disc && chostype && strcmpi(etpv{jj},typevt) && ~fmric
                    msg = etpv{jj};
                elseif disc && chostype && strcmpi(etpv{jj},typevt) && fmric
                    msg = etype{jj};                
                elseif disc && ~(strcmpi(etype{jj},typevt)) %(disc && chostype && strcmpi(etpv{jj},typevt)) || ...
                    msg='';
                elseif disc && ~chostype && strcmpi(etype{jj},typevt) || fmric
                    msg = etype{jj};
                elseif ~disc
                    msg = etpv{jj};
                end
             else
                %msg must contain value in base 10 :
                m = find([ev(itrigger(:)).time]==ev(indextrig(jj)).time);      
                [evsel itri ibase]= intersect({ev(itrigger(m)).type},handles.base(:,1));
                if isempty(evsel)
                    sumtrig = 0;
                else
                    sumtrig = sum(2.^(ibase-1));
                end
                msg = num2str(sumtrig);
            end
            %Affichage
                if isempty(msg), msg = ''; end
                lgmsg = length(msg);
                if isfield(handles.Dmeg{1},'CRC') && ...
                        isfield(handles.Dmeg{1}.CRC,'goodevents') && ...
                            size(handles.Dmeg{1}.CRC.goodevents,2)>=indextrig(jj)&& ...
                                handles.Dmeg{1}.CRC.goodevents(indextrig(jj))==0
                    b=[0.8 0.2 0.2];
                else
                    b = 'k';
                end
                text(int(jj)-(0.4*lgmsg/(lgmsg+1))*handles.winsize/20, ...
                    2.1*handles.scale/50*NbreChandisp,msg,'Color',b);
        end
    end
end
return
%-------------------------- SUBFUNCTIONS ----------------------------------
%--------------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function filterlowhigh(plt,ii,handles,frqcut,scale)

% if nargin<4
     Hd = bandpass_window_500;
     B = Hd.Numerator;
     A = 1;
%     flc = handles.filter.other(1)/(fsample(handles.Dmeg{ii})/2);
%     fhc = handles.filter.other(2)/(fsample(handles.Dmeg{ii})/2);
%     if fsample(handles.Dmeg{ii})>1500
%         forder = 1;
%     else
%         forder = 3;
%     end
%     [B,A] = butter(forder,[flc,fhc],'bandpass');
% else
%     B = frqcut(1,:);
%     A = frqcut(2,:);
% end

X = get(plt,'YData');
% Apply Butterworth filter
Y = filtfilt(B,A,X);
set(plt,'YData',Y+scale - mean(Y))%,'Color',Col{ii})

return

function Hd = bandpass_window_500
%BANDPASS_WINDOW_500 Returns a discrete-time filter object.

%
% MATLAB Code
% Generated by MATLAB(R) 7.14 and the Signal Processing Toolbox 6.17.
%
% Generated on: 02-Sep-2014 08:50:32
%

% FIR Window Bandpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 500;  % Sampling Frequency

N    = 1660;     % Order
Fc1  = 0.3;      % First Cutoff Frequency
Fc2  = 35;       % Second Cutoff Frequency
flag = 'scale';  % Sampling Flag
Beta = 0.5;       % Window Parameter
% Create the window vector for the design algorithm.
win = kaiser(N+1, Beta);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);
Hd = dfilt.dffir(b);

return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y = filterforspect(handles,X,frqcut,ii)
if fsample(handles.Dmeg{ii})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[frqcut(1)/(fsample(handles.Dmeg{ii})/2),...
    frqcut(2)/(fsample(handles.Dmeg{ii})/2)],'bandpass');

% Apply Butterworth filter
Y = filtfilt(B,A,X);

return
%%%%%%%%%%%%%%%%%%%%%%%

function cleargraph(figure,axnum)

if nargin<2
    prop    =   'Type';
    compr   =   'axes';
else
    prop    =   'Tag';
    compr   =   axnum;
end

A       =   get(figure,'Children');
idx     =   find(strcmp(get(A,prop),compr)==1);
delete(get(A(idx),'Children'))

%new function : to calculate FFT in detailed (To be checked)
function counterspect_Callback(hObject, eventdata, handles)

if get(handles.counterspect,'Value')
    fprintf('FFT detailed if on \n')
    set(handles.counterspect,'BackgroundColor',[0.5 0.5 0.5])
    cla(handles.axes5)
    set(handles.figure1,'CurrentAxes',handles.axes1)
    set(handles.Cmp_Pwr_Sp,'Enable','off','Visible','off')
    set(handles.figure1, 'windowbuttonmotionfcn',@wbdcb)
else
    fprintf('FFT detailed if off \n')
    set(handles.figure1,'CurrentAxes',handles.axes1)
    delete(findobj('tag','O'))
    delete(findobj('tag','trc'))
    set(handles.counterspect,'BackgroundColor',[0.8 0.8 0.8])
    set(handles.figure1, 'windowbuttonmotionfcn', @update_powerspect)
    set(handles.figure1, 'WindowButtonUpFcn','') 
    set(handles.Cmp_Pwr_Sp,'Enable','on','Visible','on')
end

guidata(hObject, handles)

function wbdcb(hObject, eventdata)

handles = guidata(hObject);
set(handles.figure1,'CurrentAxes',handles.axes1)
if strcmp(get(hObject,'SelectionType'),'open')
    delete(findobj('tag','O'))
    set(hObject,'pointer','circle')
    set(handles.figure1,'CurrentAxes',handles.axes1)
    cp = get(handles.axes1,'CurrentPoint');
    handles.xinit = cp(1,1); handles.yinit = cp(1,2);
    plot(cp(1,1),cp(1,2),'.','color','b','tag','O');
    set(hObject,'windowbuttonmotionfcn',@wbmcb)
    set(hObject,'WindowButtonUpFcn',@wbucb) 
end
guidata(hObject,handles)


function wbmcb(hObject, eventdata)

handles = guidata(hObject);
cp = get(handles.axes1,'CurrentPoint');

xinit =   handles.xinit;
yinit =   handles.yinit;  

delete(findobj('tag','trc'))

xdat1 = [xinit,cp(1,1)];
xdat2 = [xinit,xinit];
xdat3 = [cp(1,1), cp(1,1)];

ydat1 = [yinit, yinit];
ydat2 = [yinit, cp(1,2)];
ydat3 = [cp(1,2), cp(1,2)];

hold on
plot(xdat1,ydat1,'tag','trc');
plot(xdat2,ydat2,'tag','trc');
plot(xdat1,ydat3,'tag','trc');
plot(xdat3,ydat2,'tag','trc');

handles.coor = [xinit cp(1,1); yinit cp(1,2)];
guidata(hObject,handles)


function wbucb(hObject,eventdata)

handles = guidata(hObject);
if strcmp(get(hObject,'SelectionType'),'normal')

    set(hObject,'Pointer','arrow')
    set(hObject,'windowbuttonmotionfcn',@wbdcb)
    set(handles.figure1,'CurrentAxes',handles.axes5);

    delete(findobj('tag', 'powerspctrm'))   %Effacer le denier power spectrum
    delete(findobj('tag', 'error')) 
    delete(findobj('tag', 'localizer')) 

    NbreChandisp    =   str2double(get(handles.NbreChan,'String'));
    Chanslidval     =   get(handles.Chanslider,'Value');
    slidpos         =   Chanslidval-rem(Chanslidval,1);
    index           =   [handles.indnomeeg handles.indexMEEG];
    chan            =   index(slidpos : 1 : slidpos + NbreChandisp -1);

    chandeb = floor(min(handles.coor(2,:))/handles.scale)+1;
    chanfin = floor(max(handles.coor(2,:))/handles.scale);  
    chan    =   chan(chandeb : chanfin);
    fs      =   fsample(handles.Dmeg{1});   

    tt = sort(handles.coor(1,:));
    temps = tt(1) :1/fs: tt(end);
    toshow = ceil(temps*fs);
        
    set(handles.figure1,'CurrentAxes',handles.axes5);
    Xtot = 0;
    X = 0;
    for ichan = 1 : length(chan)       
        hold on
        [dumb1,dumb2,index2] = ...
            intersect(upper(chanlabels(handles.Dmeg{1},chan(ichan))),handles.names);
        if abs(handles.crc_types(index2))>1
            if handles.crc_types(index2)>0
                [dumb1,index1,dumb2] = ...
                    intersect(upper(chanlabels(handles.Dmeg{1})), ...
                    upper(handles.names(handles.crc_types(index2))));
                try
                    X   =   handles.Dmeg{1}(chan(ichan),toshow) - ...
                            handles.Dmeg{1}(index1,toshow);
                catch
                    X   = 0;
                end
            else
                range   =   max(handles.Dmeg{1}(chan(ichan),toshow)) - ...
                            min(handles.Dmeg{1}(chan(ichan),toshow));
                try
                    X  = 	(handles.scale)*handles.Dmeg{1}(chan(ichan),toshow)/range;
                catch
                    X   =   0;
                end
            end
        else
            try
                X   =   handles.Dmeg{1}(chan(ichan),toshow);
                Col	=   3;
            catch
                X   =   0;
            end
        end
        Xtot = Xtot + X;
    end

    if length(X) == 1
        set(handles.figure1,'CurrentAxes',handles.axes5);
        text(0.75,1, 'No Signal here')
        xlim([0 2])
        ylim([0 2])
        grid off
    else
        X       =   filterforspect(handles,X,[0.001 fs/3],1);
        [P,F]   =   pwelch(X,[],[],[],fs);           
        P       =   log(P);       
        p_fft   =   plot(F,P,'Color','r');
        grid on
        axis auto
        xd  = str2double(get(handles.pwrblw,'String'));
        xf = str2double(get(handles.pwrabv,'String'));
        xlim([xd xf])      %(on zoom sur ce qui nous int閞esse)
        set(p_fft,'tag', 'powerspctrm')
    end  
    return;

elseif strcmp(get(hObject,'SelectionType'),'alt')   
    set(hObject,'Pointer','arrow')
    delete(findobj('tag','trc'))
    delete(findobj('tag','O'))
    set(handles.figure1, 'windowbuttonmotionfcn', @wbdcb)
    set(hObject,'WindowButtonUpFcn','')    
else
    
  return
  
end

guidata(hObject,handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%New funtion : To be checked %%%%%%%%%%%%%%%%%%%
function fftchan_Callback(hObject, eventdata, handles)
% hObject    handle to fftchan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fftchan contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fftchan

set(handles.fftchan,'visible','off');
set(handles.figure1,'CurrentAxes',handles.axes5);
Chan    =   get(handles.fftchan, 'Value');                  
delete(findobj('tag', 'powerspctrm'))   %Effacer le denier power spectrum
delete(findobj('tag', 'error')) 
delete(findobj('tag', 'localizer')) 

fs      =   fsample(handles.Dmeg{1});   
slidval =   get(handles.slider1,'Value');    %Prendre le pos actuelle

if handles.multcomp % To be checked : I just take this part form old version but never tried to use it
    fil     =   min(max(1,Chan),length(handles.Dmeg));
    Ctodis  =	handles.Chantodis;
    [dumb1,dumb2,Chan]  =   intersect(handles.chanset{Ctodis}, ...
                            upper(chanlabels(handles.Dmeg{fil})));
    start   =   datevec(handles.date(fil,1)-handles.mindate);
    start   =   start(4)*60^2+start(5)*60+start(6);
    beg     =   slidval - start;
    tdeb    =   round(beg*fsample(handles.Dmeg{fil}));
    temps   =   tdeb:1:min(tdeb+(fsample(handles.Dmeg{fil})*handles.winsize), ...
                nsamples(handles.Dmeg{fil}));
    toshow  =   temps;
    cmap 	=   hsv(length(handles.Dmeg));
    Col     =   fil;
else
    fil     =   1;
    Chan    =   min(max(1,Chan),length(handles.indexMEEG) + length(handles.indnomeeg));
    NbreChandisp    =   str2double(get(handles.NbreChan,'String')); %通道数
    Chanslidval     =   get(handles.Chanslider,'Value');
    slidpos         =   Chanslidval-rem(Chanslidval,1);
    index           =   [handles.indnomeeg handles.indexMEEG];
    handles.inddis  =   index(slidpos : 1 : slidpos + NbreChandisp -1);
    Chan            =   handles.inddis(Chan);
    chandis         =   chanlabels(handles.Dmeg{fil},Chan);
    chtype          =   chantype(handles.Dmeg{fil},Chan);
    fs              =   fsample(handles.Dmeg{fil});
    tdeb            =   round(slidval*fs);
    temps           =   tdeb:1:min(tdeb+(fs*handles.winsize), ...
                        nsamples(handles.Dmeg{fil}));
    toshow          =   temps;
    cmap            =   [0 0 0; 1 0 0; 0 0 1];
end

tdeb_w = round(slidval*fs);
tend_w = min(tdeb+(fs*handles.winsize), ...
                        nsamples(handles.Dmeg{fil}));
tohid_all = [];
if ~isempty(handles.score{5,handles.currentscore}) 
    tdebs   =   str2double(get(handles.currenttime,'String')) - handles.winsize/2;
    tfins   =   str2double(get(handles.currenttime,'String')) + handles.winsize/2;
    art     =   find(and((or(and(handles.score{5,handles.currentscore}(:,2)>tdebs,handles.score{5,handles.currentscore}(:,2)<tfins),...
                and(handles.score{5,handles.currentscore}(:,1)<tfins,handles.score{5,handles.currentscore}(:,1)>tdebs))),...
                or(handles.score{5,handles.currentscore}(:,3) == 0,handles.score{5,handles.currentscore}(:,3) == Chan)));
    art_concerned   =   handles.score{5,handles.currentscore}(art,1:2);
    if ~isempty(art_concerned)
        a=1;
        while a <= size(art_concerned,1)
            art_concerned(a);
            begart      =   max(tdeb_w,round(art_concerned(a,1)*fs));
            endart      =   min(tend_w,round(art_concerned(a,2)*fs)); 
            tohid2   	=   begart : endart;
            tohid_all   =   union(tohid_all,tohid2);
            tdeb_w      =   endart;
            a   =  a+1;
        end 
        toshow 	=   setdiff(toshow,tohid_all);
    end 
end

set(handles.figure1,'CurrentAxes',handles.axes5);
fs      =   fsample(handles.Dmeg{fil});
leg     =   cell(0);
hold on
[dumb1,dumb2,index2] = ...
    intersect(upper(chanlabels(handles.Dmeg{fil},Chan)),handles.names);
if abs(handles.crc_types(index2))>1
    if handles.crc_types(index2)>0
        [dumb1,index1,dumb2] = ...
            intersect(upper(chanlabels(handles.Dmeg{fil})), ...
            upper(handles.names(handles.crc_types(index2))));
        try
            X   =   handles.Dmeg{fil}(Chan,toshow) - ...
                    handles.Dmeg{fil}(index1,toshow);
            Col	= 1;
        catch
            X   = 0;
        end
    else
        range   =   max(handles.Dmeg{fil}(Chan,toshow)) - ...
                    min(handles.Dmeg{fil}(Chan,toshow));
        try
            X   = 	(handles.scale)*handles.Dmeg{fil}(Chan,toshow)/range;
            Col =   2;
        catch
            X   =   0;
        end
    end
else
    try
        X   =   handles.Dmeg{fil}(Chan,toshow);
        Col	=   3;
    catch
        X   =   0;
    end
end
if length(X) == 1
    set(handles.figure1,'CurrentAxes',handles.axes5);
    text(0.75,1, 'No Signal here')
    xlim([0 2])
    ylim([0 2])
    grid off
else
    set(handles.figure1,'CurrentAxes',handles.axes5)%,'PaperSize',[20.98 29.68]);
    reset(handles.axes5)
    X       =   filterforspect(handles,X,[0.001 fs/3],fil);
    [P,F]   =   pwelch(X,[],[],[],fs);    
    P       =   log(P);
    p_fft   =   plot(handles.axes5,F,P,'Color',cmap(Col,:));
    set(p_fft,'tag', 'powerspctrm')
    titre   =   chandis;
    title(handles.axes5,titre,'FontSize',12,'FontWeight','demi','FontName','Consolas')
    ylabel(handles.axes5,'Log of (power/Hz) / ','FontSize',10,'FontName','Consolas')
    xlabel(handles.axes5,'Frequency (Hz)','FontSize',10,'FontName','Consolas')
%     if P<0
%         set(handles.axes5,'XTick',[0 5 10 15 20],'YTick',[-60 -40 -20 0],'ZTick',[],...
%             'XTickLabel',{'0' '5' '10' '15' '20'},'YTickLabel',{'-60' '-40' '-20' '0'},'ZTickLabel',{})
%         axis([0 20 -60 0])
%     else
%         set(handles.axes5,'XTick',[0 5 10 15 20],'YTick',[0 2 4 6 8],'ZTick',[],...
%             'XTickLabel',{'0' '5' '10' '15' '20'},'YTickLabel',{'0' '2' '4' '6' '8'},'ZTickLabel',{})
%          axis([0 20 0 8])
%     end
    xd = str2double(get(handles.pwrblw,'String'));
    xf = str2double(get(handles.pwrabv,'String'));
    xlim(handles.axes5,[xd xf])
    grid on
end  
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function fftchan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fftchan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
end

%New Function : To be checked %%%%%%%%%%%%%%%%%%%%%%
function update_powerspect(hObject, eventdata, handles)

handles = guidata(hObject);
% Get the current position of the mouse pointer
set(handles.figure1,'CurrentAxes',handles.axes1)
Mouse =     get(handles.axes1, 'CurrentPoint');
x = get(handles.axes1,'XTick');
y = get(handles.axes1,'YTick');
winscale=get(handles.edit2,'string');
if and(and(Mouse(1,1)<x(end),Mouse(1,1)>x(1)),and(Mouse(1,2)<y(end),Mouse(1,2)>y(1)))
   %% chan    =   ceil((Mouse(1,2)-winscale/2)/winscale);
   chan    =   ceil((Mouse(1,2)-handles.scale/2)/handles.scale);
    propo 	=   cellstr(get(handles.fftchan,'String'));
    chanpop =   propo(chan);
	[chanpop in] =   intersect(propo,chanpop); 
	set(handles.fftchan,'Value', in);
    fftchan_Callback(hObject,eventdata,handles); 
end
guidata(hObject,handles)

% function Detection_Callback(hObject, eventdata, handles)
% 
% set(handles.figure1, 'windowbuttonmotionfcn', '')
% 
% flags.index	=   handles.index;
% flags.Dmeg  =   handles.Dmeg;
% flags.file  =   handles.file;
% flags.winsize = handles.winsize;
% flags.user = handles.currentscore;
% 
% %faire passer la taille des 閜oques choisies pour l'analyse des artefacts
% DC_detection(flags);

function saveart(handles)

D = handles.Dmeg{1};
D.CRC.artefacteeg = handles.artefacteeg;
save(D);
D.CRC

return

%%%%%%%%%%%%%%% Changement from base 2 to 10 for the triggers  %%%%%%%%%%

% --- Executes on selection Selection in menu bar.
function selection_trigger_Callback(hObject, eventdata, handles)
% hObject    handle to Selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.figure1, 'windowbuttonmotionfcn', '')

flags.index	=   handles.index;
flags.Dmeg  =   handles.Dmeg;
flags.file  =   handles.file;
DC_selection(flags)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- power spectrum display
function pwrabv_Callback(hObject, eventdata, handles)
% hObject    handle to pwrabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.counterspect,'Value')
    set(handles.figure1,'CurrentAxes',handles.axes5);

    delete(findobj('tag', 'powerspctrm'))   %Effacer le denier power spectrum
    delete(findobj('tag', 'error')) 
    delete(findobj('tag', 'localizer')) 

    NbreChandisp    =   str2double(get(handles.NbreChan,'String'));
    Chanslidval     =   get(handles.Chanslider,'Value');
    slidpos         =   Chanslidval-rem(Chanslidval,1);
    index           =   [handles.indnomeeg handles.indexMEEG];
    chan            =   index(slidpos : 1 : slidpos + NbreChandisp -1);

    chandeb = floor(min(handles.coor(2,:))/handles.scale)+1;
    chanfin = floor(max(handles.coor(2,:))/handles.scale);  
    chan    = chan(chandeb : chanfin);
    fs      = fsample(handles.Dmeg{1});   

    tt = sort(handles.coor(1,:));
    temps = tt(1) :1/fs: tt(end);
    toshow = ceil(temps*fs);
        
    set(handles.figure1,'CurrentAxes',handles.axes5);
    Xtot = 0;
    X = 0;
    for ichan = 1 : length(chan)       
        hold on
        [dumb1,dumb2,index2] = ...
            intersect(upper(chanlabels(handles.Dmeg{1},chan(ichan))),handles.names);
        if abs(handles.crc_types(index2))>1
            if handles.crc_types(index2)>0
                [dumb1,index1,dumb2] = ...
                    intersect(upper(chanlabels(handles.Dmeg{1})), ...
                    upper(handles.names(handles.crc_types(index2))));
                try
                    X   =   handles.Dmeg{1}(chan(ichan),toshow) - ...
                            handles.Dmeg{1}(index1,toshow);
                catch
                    X   = 0;
                end
            else
                range   =   max(handles.Dmeg{1}(chan(ichan),toshow)) - ...
                            min(handles.Dmeg{1}(chan(ichan),toshow));
                try
                    X  = 	(handles.scale)*handles.Dmeg{1}(chan(ichan),toshow)/range;
                catch
                    X   =   0;
                end
            end
        else
            try
                X   =   handles.Dmeg{1}(chan(ichan),toshow);
                Col	=   3;
            catch
                X   =   0;
            end
        end
        Xtot = Xtot + X;
    end

    if length(X) == 1
        set(handles.figure1,'CurrentAxes',handles.axes5);
        text(0.75,1, 'No Signal here')
        xlim([0 2])
        ylim([0 2])
        grid off
    else
        X       =   filterforspect(handles,X,[0.001 fs/3],1);
        [P,F]   =   pwelch(X,[],[],[],fs);           
        P       =   log(P);       
        p_fft   =   plot(F,P,'Color','r');
        grid on
        axis auto
        xd  = str2double(get(handles.pwrblw,'String'));
        xf = str2double(get(handles.pwrabv,'String'));
        xlim([xd xf])      %(on zoom sur ce qui nous int閞esse)
        set(p_fft,'tag', 'powerspctrm')
    end  
    return;
end


function pwrabv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pwrabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function pwrblw_Callback(hObject, eventdata, handles)
% hObject    handle to pwrblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.counterspect,'Value')
    set(handles.figure1,'CurrentAxes',handles.axes5);

    delete(findobj('tag', 'powerspctrm'))   %Effacer le denier power spectrum
    delete(findobj('tag', 'error')) 
    delete(findobj('tag', 'localizer')) 

    NbreChandisp    =   str2double(get(handles.NbreChan,'String'));
    Chanslidval     =   get(handles.Chanslider,'Value');
    slidpos         =   Chanslidval-rem(Chanslidval,1);
    index           =   [handles.indnomeeg handles.indexMEEG];
    chan            =   index(slidpos : 1 : slidpos + NbreChandisp -1);

    chandeb = floor(min(handles.coor(2,:))/handles.scale)+1;
    chanfin = floor(max(handles.coor(2,:))/handles.scale);  
    chan    =   chan(chandeb : chanfin);
    fs      =   fsample(handles.Dmeg{1});   

    tt = sort(handles.coor(1,:));
    temps = tt(1) :1/fs: tt(end);
    toshow = ceil(temps*fs);
        
    set(handles.figure1,'CurrentAxes',handles.axes5);
    Xtot = 0;
    X = 0;
    for ichan = 1 : length(chan)       
        hold on
        [dumb1,dumb2,index2] = ...
            intersect(upper(chanlabels(handles.Dmeg{1},chan(ichan))),handles.names);
        if abs(handles.crc_types(index2))>1
            if handles.crc_types(index2)>0
                [dumb1,index1,dumb2] = ...
                    intersect(upper(chanlabels(handles.Dmeg{1})), ...
                    upper(handles.names(handles.crc_types(index2))));
                try
                    X   =   handles.Dmeg{1}(chan(ichan),toshow) - ...
                            handles.Dmeg{1}(index1,toshow);
                catch
                    X   = 0;
                end
            else
                range   =   max(handles.Dmeg{1}(chan(ichan),toshow)) - ...
                            min(handles.Dmeg{1}(chan(ichan),toshow));
                try
                    X  = 	(handles.scale)*handles.Dmeg{1}(chan(ichan),toshow)/range;
                catch
                    X   =   0;
                end
            end
        else
            try
                X   =   handles.Dmeg{1}(chan(ichan),toshow);
                Col	=   3;
            catch
                X   =   0;
            end
        end
        Xtot = Xtot + X;
    end

    if length(X) == 1
        set(handles.figure1,'CurrentAxes',handles.axes5);
        text(0.75,1, 'No Signal here')
        xlim([0 2])
        ylim([0 2])
        grid off
    else
        X       =   filterforspect(handles,X,[0.001 fs/3],1);
        [P,F]   =   pwelch(X,[],[],[],fs);           
        P       =   log(P);       
        p_fft   =   plot(F,P,'Color','r');
        grid on
        axis auto
        xd  = str2double(get(handles.pwrblw,'String'));
        xf = str2double(get(handles.pwrabv,'String'));
        xlim([xd xf])      %(on zoom sur ce qui nous int閞esse)
        set(p_fft,'tag', 'powerspctrm')
    end  
    return;
end
function pwrblw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pwrblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%score_menu_callback
%score_stats
%score_import_Callback
%saveimportscore
%plothypnoimport
%score_compare_Callback
%score_check_Callback
% --------------------------------------------------------------------
function scales_menu_Callback(hObject, eventdata, handles)
% hObject    handle to scales_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%To be checked : new subfunctions in click
% --- Click

% --------------------------------------------------------------------
function spectral_analysis_menu_Callback(hObject, eventdata, handles)
% hObject    handle to spectral_analysis_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
% --------------------------------------------------------------------

% --------------------------------------------------------------------
function Mouse_Selection_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Mouse_Selection_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Whole_sleep_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Whole_sleep_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------

% --------------------------------------------------------------------

% --------------------------------------------------------------------
function eeg_menu_Callback(hObject, eventdata, handles)
% hObject    handle to eeg_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eegsc=spm_input('EEG scale?',1,'s','1');
close gcf
try
    handles.eegscale=eval(eegsc);
catch
    if strcmpi(eegsc,'V')
        handles.eegscale=10^-6;
    elseif strcmpi(eegsc,'礦')
        handles.eegscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or 礦')
        handles.eegscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);


% --------------------------------------------------------------------
function eog_menu_Callback(hObject, eventdata, handles)
% hObject    handle to eog_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eogsc=spm_input('EOG scale?',1,'s','1');
close gcf
try
    handles.eogscale=eval(eogsc);
catch
    if strcmpi(eogsc,'V')
        handles.eogscale=10^-6;
    elseif strcmpi(eogsc,'礦')
        handles.eogscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or 礦')
        handles.eogscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

% --------------------------------------------------------------------
function emg_menu_Callback(hObject, eventdata, handles)
% hObject    handle to emg_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
emgsc=spm_input('EMG scale?',1,'s','1');
close gcf
try
    handles.emgscale=eval(emgsc);
catch
    if strcmpi(emgsc,'V')
        handles.emgscale=10^-6;
    elseif strcmpi(emgsc,'礦')
        handles.emgscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or 礦')
        handles.emgscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

% --------------------------------------------------------------------
function ecg_menu_Callback(hObject, eventdata, handles)
% hObject    handle to ecg_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecgsc=spm_input('ECG scale?',1,'s','1');
close gcf
try
    handles.ecgscale=eval(ecgsc);
catch
    if strcmpi(ecgsc,'V')
        handles.ecgscale=10^-6;
    elseif strcmpi(ecgsc,'礦')
        handles.ecgscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or 礦')
        handles.ecgscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

% --------------------------------------------------------------------
function other_menu_Callback(hObject, eventdata, handles)
% hObject    handle to other_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecgsc=spm_input('Other scale?',1,'s','1');
close gcf
try
    handles.otherscale=eval(ecgsc);
catch
    beep
    disp('Enter scale in 10^-x format')
    handles.otherscale=[];
    return
end
mainplot(handles)
guidata(hObject, handles);

% --------------------------------------------------------------------
function close_menu_Callback(hObject, eventdata, handles)
% hObject    handle to close_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_12_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_8_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ------------------------------------------------------------------


% --------------------------------------------------------------------
function auto_chunking_menu_Callback(hObject, eventdata, handles)
% hObject    handle to auto_chunking_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function W_chunk_menu_Callback(hObject, eventdata, handles)
% hObject    handle to W_chunk_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%Auto chunk
handles = guidata(hObject);
load('W_chunk.mat');
for i=1:W.num
    Begpts=W.points(i,1);
    Endpts=W.points(i,2);
    flags=W.flags(i);
    W_process_chunk(handles.Dmeg{1}, Begpts, Endpts, flags);
end



% --------------------------------------------------------------------
function N1_chunk_menu_Callback(hObject, eventdata, handles)
% hObject    handle to N1_chunk_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
load('N1_chunk.mat');
for i=1:N1.num
    Begpts=N1.points(i,1);
    Endpts=N1.points(i,2);
    flags=N1.flags(i);
    N1_process_chunk(handles.Dmeg{1}, Begpts, Endpts, flags);
end

function N2_chunk_menu_Callback(hObject, eventdata, handles)
% hObject    handle to N1_chunk_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
load('N2_chunk.mat');
for i=1:N2.num
    Begpts=N2.points(i,1);
    Endpts=N2.points(i,2);
    flags=N2.flags(i);
    N2_process_chunk(handles.Dmeg{1}, Begpts, Endpts, flags);
end
% --------------------------------------------------------------------

function N3_chunk_menu_Callback(hObject, eventdata, handles)
% hObject    handle to N3_chunk_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
load('N3_chunk.mat');
for i=1:N3.num
    Begpts=N3.points(i,1);
    Endpts=N3.points(i,2);
    flags=N3.flags(i);
    N3_process_chunk(handles.Dmeg{1}, Begpts, Endpts, flags);
end


% --------------------------------------------------------------------
function R_chunk_menu_Callback(hObject, eventdata, handles)
% hObject    handle to R_chunk_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
load('R_chunk.mat');
for i=1:R.num
    Begpts=R.points(i,1);
    Endpts=R.points(i,2);
    flags=R.flags(i);
    R_process_chunk(handles.Dmeg{1}, Begpts, Endpts, flags);
end



% --------------------------------------------------------------------
function N1_Callback(hObject, eventdata, handles)
% hObject    handle to N2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
% N1_chunk(handles.axes4,handles.score{4,handles.currentscore},handles,handles.winsize)
% D = struct(Dmeg);
% handles.Dmeg = Dmeg;
if iscell(handles.Dmeg)
    D = handles.Dmeg{1};
else
    D = handles.Dmeg;
end
if nargin < 5 && isfield(handles,'score')
    score = handles.score{1,handles.currentscore};
elseif nargin<5 && ~isfield(handles,'score')
    score = D.CRC.score{1,handles.currentscore};
    handles.score = D.CRC.score;
end
% % if nargin < 4
% %     windowsize = 20;
% % end
% % def = crc_get_defaults('score');
% % vect = -.5:1/windowsize:(.5-1/windowsize);
%%%%nsamples(Dmeg)/fsample(Dmeg) 总秒数即时间   
%%%%用diff函数找出score中前后状态不同的点，即为两个状态的转换点，再通过if语句的判断，确定
%%%%每一段N1的起始点Bgpts,和截止点Edpts
% % if isfield(handles.Dmeg{1},'info')
% %     if isfield(handles.Dmeg{1}.info,'hour')
% %         Str = [' ' num2str(handles.Dmeg{1}.info.hour(1)) 'h ' num2str(handles.Dmeg{1}.info.hour(2)) 'm ' num2str(handles.Dmeg{1}.info.hour(3)) 's' ];
% %     end
% % end
if handles.scoring
    stchange=diff(score);%%score的两两值之差
    j_n1=0;
    N1_time = []; N1_points = [];N1_len = []; N1_flags=[];
    if score(1)==1
        j_n1=j_n1+1;
        Begctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) ));%%计算阶段w数据的开始时间
            Begh=Begctime(1);%%开始的小时
            Begm=Begctime(2);%%开始的分钟
            Begs=Begctime(3);%%开始的秒
            Begpts=1;
    end 
   for i=1:length(stchange);
       
       %%N2阶段
          if stchange(i)==0
              continue
          elseif score(i+1)==1 
              %如果这个点的下一个阶段是2，代表这个是第二个阶段的开始点
            j_n1=j_n1+1;
            %%阶段1的个数  
            Begctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + handles.Dmeg{1}.info.hour(2)*60 +handles.Dmeg{1}.info.hour(3) +  i*10));
            %%计算阶段2数据的开始时间
            Begh=Begctime(1);%%开始的小时
            Begm=Begctime(2);%%开始的分钟
            Begs=Begctime(3);%%开始的秒
            lgt=(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/60^2; % 计算整个数据持续了多少小时
            ch_sec_rounding =round(handles.Dmeg{1}.info.hour(3)) - handles.Dmeg{1}.info.hour(3);     
              if abs(ch_sec_rounding)<1e-4
            % Rounding off if "seconds" saved differs from rounded "seconds" by
            % less than .1ms.
                handles.Dmeg{1}.info.hour(3) =round(handles.Dmeg{1}.info.hour(3));       
              end
              datenumstart=datenum([0 0 0 handles.Dmeg{1}.info.hour]);     %整个数据的开始时间
              datenumBeg=datenum([0 0 0 Begh Begm Begs]);       %截取部分数据的开始时间

              datediff=datevec(datenumBeg-datenumstart);      %截取部分的开始时间和整个数据的开始时间差
              if datediff(4)>lgt % 判断两个开始时间差是否大于整个数据持续的总小时，
                  %%也就是说，如果跨过00：00的话就算是第二天，计算的结果会大于lgt
                 datenumBeg=datenum([0 0 1 Begh Begm Begs]);
                 datediff=datevec(datenumBeg-datenumstart);
              end

            Begpts=min(nsamples(handles.Dmeg{1}),max(1,round((datediff(4)*60^2+datediff(5)*60+datediff(6))*fsample(handles.Dmeg{1}))));       
          elseif score(i)==1      
            Endctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) + ...
            i*10));
            Endh=Endctime(1);
            Endm=Endctime(2);
            Ends=Endctime(3);
            lgt=(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/60^2; % 计算整个数据持续了多少小时
            datenumstart=datenum([0 0 0 handles.Dmeg{1}.info.hour]);     %整个数据的开始时间
            datenumEnd=datenum([0 0 0 Endh Endm Ends]);       %截取部分数据的结束时间

              datediff=datevec(datenumEnd-datenumstart);      %截取部分的结束时间和整个数据的开始时间差
              if datediff(4)>lgt % 判断两个开始时间差是否大于整个数据持续的总小时，
                  %%也就是说，如果跨过00：00的话就算是第二天，计算的结果会大于lgt
                 datenumEnd=datenum([0 0 1 Endh Endm Ends]);
                 datediff=datevec(datenumEnd-datenumstart);
              end
            Endpts=min(nsamples(handles.Dmeg{1}),max(1,round((datediff(4)*60^2+datediff(5)*60+datediff(6))*fsample(handles.Dmeg{1}))));  
             if (Endh-Begh<0)
                len_n1=(24+Endh-Begh)*60^2+(Endm-Begm)*60 + (Ends-Begs);%%计算N2持续的时长，单位是秒
            else
                len_n1=(Endh-Begh)*60^2+(Endm-Begm)*60 + (Ends-Begs);
             end
            N1_len=[N1_len;len_n1];%%每个N2阶段的持续时间 
            if Begctime(1)<24
                Begctime = Begctime;
            else
                Begctime=Begctime-[24 0 0];
            end
            if Endctime(1)<24
                Endctime = Endctime;
            else
                Endctime=Endctime-[24 0 0];
            end
            N1_time = [N1_time;Begctime Endctime];
            N1_points=[N1_points;Begpts Endpts];%%n1阶段每个开始与结束所对应的数据点位置的信息
            N1.time = N1_time;
            N1.points = N1_points;
            N1.len = N1_len;
            flags = struct('clockt',1); % use defaults for the rest
            N1_flags=[N1_flags,flags];
            N1.flags=N1_flags;
            N1.num=j_n1;
            save('N1_chunk','N1')
          end
   end
end

function N2_Callback(hObject, eventdata, handles)
% hObject    handle to N2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
% N1_chunk(handles.axes4,handles.score{4,handles.currentscore},handles,handles.winsize)
% D = struct(Dmeg);
% handles.Dmeg = Dmeg;
if iscell(handles.Dmeg)
    D = handles.Dmeg{1};
else
    D = handles.Dmeg;
end
if nargin < 5 && isfield(handles,'score')
    score = handles.score{1,handles.currentscore};
elseif nargin<5 && ~isfield(handles,'score')
    score = D.CRC.score{1,handles.currentscore};
    handles.score = D.CRC.score;
end
if nargin < 4
    windowsize = 20;
end
% % def = crc_get_defaults('score');
% % vect = -.5:1/windowsize:(.5-1/windowsize);
%%%%nsamples(Dmeg)/fsample(Dmeg) 总秒数即时间   
%%%%用diff函数找出score中前后状态不同的点，即为两个状态的转换点，再通过if语句的判断，确定
%%%%每一段N2的起始点Bgpts,和截止点Edpts
% % if isfield(handles.Dmeg{1},'info')
% %     if isfield(handles.Dmeg{1}.info,'hour')
% %         Str = [' ' num2str(handles.Dmeg{1}.info.hour(1)) 'h ' num2str(handles.Dmeg{1}.info.hour(2)) 'm ' num2str(handles.Dmeg{1}.info.hour(3)) 's' ];
% %     end
% % end
if handles.scoring
    stchange=diff(score);%%score的两两值之差
    j_n2=0;
    N2_time = [];N2_points = []; N2_len = []; N2_flags=[];
    if score(1)==2
        j_n2=j_n2+1;
        Begctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) ));%%计算阶段w数据的开始时间
            Begh=Begctime(1);%%开始的小时
            Begm=Begctime(2);%%开始的分钟
            Begs=Begctime(3);%%开始的秒
            Begpts=1;
    end 
   for i=1:length(stchange);
       
       %%N2阶段
          if stchange(i)==0
              continue
          elseif score(i+1)==2 
              %如果这个点的下一个阶段是2，代表这个是第二个阶段的开始点
            j_n2=j_n2+1;  %%阶段2的个数  
            Begctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) + ...
            i*10));%%计算阶段2数据的开始时间
            Begh=Begctime(1);%%开始的小时
            Begm=Begctime(2);%%开始的分钟
            Begs=Begctime(3);%%开始的秒
            lgt=(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/60^2; % 计算整个数据持续了多少小时
            ch_sec_rounding =round(handles.Dmeg{1}.info.hour(3)) - handles.Dmeg{1}.info.hour(3);     
              if abs(ch_sec_rounding)<1e-4
            % Rounding off if "seconds" saved differs from rounded "seconds" by
            % less than .1ms.
                handles.Dmeg{1}.info.hour(3) =round(handles.Dmeg{1}.info.hour(3));       
              end
              datenumstart=datenum([0 0 0 handles.Dmeg{1}.info.hour]);     %整个数据的开始时间
              datenumBeg=datenum([0 0 0 Begh Begm Begs]);       %截取部分数据的开始时间

              datediff=datevec(datenumBeg-datenumstart);      %截取部分的开始时间和整个数据的开始时间差
              if datediff(4)>lgt % 判断两个开始时间差是否大于整个数据持续的总小时，
                  %%也就是说，如果跨过00：00的话就算是第二天，计算的结果会大于lgt
                 datenumBeg=datenum([0 0 1 Begh Begm Begs]);
                 datediff=datevec(datenumBeg-datenumstart);
              end

            Begpts=min(nsamples(handles.Dmeg{1}),max(1,round((datediff(4)*60^2+datediff(5)*60+datediff(6))*fsample(handles.Dmeg{1}))));       
          elseif score(i)==2      
            Endctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) + ...
            i*10));
            Endh=Endctime(1);
            Endm=Endctime(2);
            Ends=Endctime(3);
            lgt=(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/60^2; % 计算整个数据持续了多少小时
            datenumstart=datenum([0 0 0 handles.Dmeg{1}.info.hour]);     %整个数据的开始时间
            datenumEnd=datenum([0 0 0 Endh Endm Ends]);       %截取部分数据的结束时间

              datediff=datevec(datenumEnd-datenumstart);      %截取部分的结束时间和整个数据的开始时间差
              if datediff(4)>lgt % 判断两个开始时间差是否大于整个数据持续的总小时，
                  %%也就是说，如果跨过00：00的话就算是第二天，计算的结果会大于lgt
                 datenumEnd=datenum([0 0 1 Endh Endm Ends]);
                 datediff=datevec(datenumEnd-datenumstart);
              end
            Endpts=min(nsamples(handles.Dmeg{1}),max(1,round((datediff(4)*60^2+datediff(5)*60+datediff(6))*fsample(handles.Dmeg{1}))));  
             if (Endh-Begh<0)
                len_n2=(24+Endh-Begh)*60^2+(Endm-Begm)*60 + (Ends-Begs);%%计算N2持续的时长，单位是秒
            else
                len_n2=(Endh-Begh)*60^2+(Endm-Begm)*60 + (Ends-Begs);
             end
            N2_len=[N2_len;len_n2];%%每个N2阶段的持续时间 
            if Begctime(1)<24
                Begctime = Begctime;
            else
                Begctime=Begctime-[24 0 0];
            end
            if Endctime(1)<24
                Endctime = Endctime;
            else
                Endctime=Endctime-[24 0 0];
            end
            N2_time = [N2_time;Begctime Endctime];
            N2_points=[N2_points;Begpts Endpts];%%n2阶段每个开始与结束所对应的数据点位置的信息
            N2.time = N2_time;
            N2.points = N2_points;
            N2.len = N2_len;
            flags = struct('clockt',1); % use defaults for the rest
            N2_flags=[N2_flags,flags];
            N2.flags=N2_flags;
            N2.num=j_n2;
            save('N2_chunk','N2')    
          end 
   end
end

% --------------------------------------------------------------------
 function N3_Callback(hObject, eventdata, handles)
% hObject    handle to N2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
% N1_chunk(handles.axes4,handles.score{4,handles.currentscore},handles,handles.winsize)
% D = struct(Dmeg);
% handles.Dmeg = Dmeg;
if iscell(handles.Dmeg)
    D = handles.Dmeg{1};
else
    D = handles.Dmeg;
end
if nargin < 5 && isfield(handles,'score')
    score = handles.score{1,handles.currentscore};
elseif nargin<5 && ~isfield(handles,'score')
    score = D.CRC.score{1,handles.currentscore};
    handles.score = D.CRC.score;
end
% % if nargin < 4
% %     windowsize = 20;
% % end
% % def = crc_get_defaults('score');
% % vect = -.5:1/windowsize:(.5-1/windowsize);
%%%%nsamples(Dmeg)/fsample(Dmeg) 总秒数即时间   
%%%%用diff函数找出score中前后状态不同的点，即为两个状态的转换点，再通过if语句的判断，确定
%%%%每一段N1的起始点Bgpts,和截止点Edpts
% % if isfield(handles.Dmeg{1},'info')
% %     if isfield(handles.Dmeg{1}.info,'hour')
% %         Str = [' ' num2str(handles.Dmeg{1}.info.hour(1)) 'h ' num2str(handles.Dmeg{1}.info.hour(2)) 'm ' num2str(handles.Dmeg{1}.info.hour(3)) 's' ];
% %     end
% % end
if handles.scoring
    stchange=diff(score);%%score的两两值之差
    j_n3=0;
    N3_time = []; N3_points = [];N3_len = []; N3_flags=[];
    if score(1)==3
        j_n3=j_n3+1;
        Begctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) ));%%计算阶段w数据的开始时间
            Begh=Begctime(1);%%开始的小时
            Begm=Begctime(2);%%开始的分钟
            Begs=Begctime(3);%%开始的秒
            Begpts=1;
    end 
   for i=1:length(stchange); 
    %%N3阶段
          if stchange(i)==0
              continue
          elseif score(i+1)==3 
              %如果这个点的下一个阶段是1，代表这个是第1个阶段的开始点
            j_n3=j_n3+1;  %%阶段1的个数   
            Begctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) + ...
            i*10));%%计算阶段2数据的开始时间
            Begh=Begctime(1);%%开始的小时
            Begm=Begctime(2);%%开始的分钟
            Begs=Begctime(3);%%开始的秒
            lgt=(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/60^2; % 计算整个数据持续了多少小时
            ch_sec_rounding =round(handles.Dmeg{1}.info.hour(3)) - handles.Dmeg{1}.info.hour(3);     
              if abs(ch_sec_rounding)<1e-4
            % Rounding off if "seconds" saved differs from rounded "seconds" by
            % less than .1ms.
                handles.Dmeg{1}.info.hour(3) =round(handles.Dmeg{1}.info.hour(3));       
              end
              datenumstart=datenum([0 0 0 handles.Dmeg{1}.info.hour]);     %整个数据的开始时间
              datenumBeg=datenum([0 0 0 Begh Begm Begs]);       %截取部分数据的开始时间

              datediff=datevec(datenumBeg-datenumstart);      %截取部分的开始时间和整个数据的开始时间差
              if datediff(4)>lgt % 判断两个开始时间差是否大于整个数据持续的总小时，
                  %%也就是说，如果跨过00：00的话就算是第二天，计算的结果会大于lgt
                 datenumBeg=datenum([0 0 1 Begh Begm Begs]);
                 datediff=datevec(datenumBeg-datenumstart);
              end

            Begpts=min(nsamples(handles.Dmeg{1}),max(1,round((datediff(4)*60^2+datediff(5)*60+datediff(6))*fsample(handles.Dmeg{1}))));       
          elseif score(i)==3     
            Endctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) + ...
            i*10));
            Endh=Endctime(1);
            Endm=Endctime(2);
            Ends=Endctime(3);
            lgt=(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/60^2; % 计算整个数据持续了多少小时
            datenumstart=datenum([0 0 0 handles.Dmeg{1}.info.hour]);     %整个数据的开始时间
            datenumEnd=datenum([0 0 0 Endh Endm Ends]);       %截取部分数据的结束时间

              datediff=datevec(datenumEnd-datenumstart);      %截取部分的结束时间和整个数据的开始时间差
              if datediff(4)>lgt % 判断两个开始时间差是否大于整个数据持续的总小时，
                  %%也就是说，如果跨过00：00的话就算是第二天，计算的结果会大于lgt
                 datenumEnd=datenum([0 0 1 Endh Endm Ends]);
                 datediff=datevec(datenumEnd-datenumstart);
              end
            Endpts=min(nsamples(handles.Dmeg{1}),max(1,round((datediff(4)*60^2+datediff(5)*60+datediff(6))*fsample(handles.Dmeg{1}))));  
             if (Endh-Begh<0)
                len_n3=(24+Endh-Begh)*60^2+(Endm-Begm)*60 + (Ends-Begs);%%计算N1持续的时长，单位是秒
            else
                len_n3=(Endh-Begh)*60^2+(Endm-Begm)*60 + (Ends-Begs);
             end
            N3_len=[N3_len;len_n3];%%每个N2阶段的持续时间 
            if Begctime(1)<24
                Begctime = Begctime;
            else
                Begctime=Begctime-[24 0 0];
            end
            if Endctime(1)<24
                Endctime = Endctime;
            else
                Endctime=Endctime-[24 0 0];
            end
            N3_time = [N3_time;Begctime Endctime];
            N3_points=[N3_points;Begpts Endpts];%%n1阶段每个开始与结束所对应的数据点位置的信息
            N3.time = N3_time;
            N3.points = N3_points;
            N3.len = N3_len;
            flags = struct('clockt',1); % use defaults for the rest
            N3_flags=[N3_flags,flags];
            N3.flags=N3_flags;
            N3.num=j_n3;
            save('N3_chunk','N3')
          end
   end
end


% --------------------------------------------------------------------
 function W_Callback(hObject, eventdata, handles)
% hObject    handle to N2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
% N1_chunk(handles.axes4,handles.score{4,handles.currentscore},handles,handles.winsize)
% D = struct(Dmeg);
% handles.Dmeg = Dmeg;
if iscell(handles.Dmeg)
    D = handles.Dmeg{1};
else
    D = handles.Dmeg;
end
if nargin < 5 && isfield(handles,'score')
    score = handles.score{1,handles.currentscore};
elseif nargin<5 && ~isfield(handles,'score')
    score = D.CRC.score{1,handles.currentscore};
    handles.score = D.CRC.score;
end
if nargin < 4
    windowsize = 20;
end
% % def = crc_get_defaults('score');
% % vect = -.5:1/windowsize:(.5-1/windowsize);
%%%%nsamples(Dmeg)/fsample(Dmeg) 总秒数即时间   
%%%%用diff函数找出score中前后状态不同的点，即为两个状态的转换点，再通过if语句的判断，确定
%%%%每一段N1的起始点Bgpts,和截止点Edpts
% % if isfield(handles.Dmeg{1},'info')
% %     if isfield(handles.Dmeg{1}.info,'hour')
% %         Str = [' ' num2str(handles.Dmeg{1}.info.hour(1)) 'h ' num2str(handles.Dmeg{1}.info.hour(2)) 'm ' num2str(handles.Dmeg{1}.info.hour(3)) 's' ];
% %     end
% % end
if handles.scoring
    stchange=diff(score);%%score的两两值之差
    j_w = 0;
    W_time = []; W_points = [];W_len = []; W_flags=[];
    if score(1)==0
        j_w=j_w+1;
        Begctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) ));%%计算阶段w数据的开始时间
            Begh=Begctime(1);%%开始的小时
            Begm=Begctime(2);%%开始的分钟
            Begs=Begctime(3);%%开始的秒
            Begpts=1;
    end    
   for i=1:length(stchange); 
    %%W阶段
        if stchange(i)==0
              continue
          elseif score(i+1)==0 
              %如果这个点的下一个阶段是w，代表这个是第1个阶段的开始点
            j_w=j_w+1;  %%阶段1的个数   
            Begctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) + ...
            i*10));%%计算阶段2数据的开始时间
            Begh=Begctime(1);%%开始的小时
            Begm=Begctime(2);%%开始的分钟
            Begs=Begctime(3);%%开始的秒
            lgt=(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/60^2; % 计算整个数据持续了多少小时
            ch_sec_rounding =round(handles.Dmeg{1}.info.hour(3)) - handles.Dmeg{1}.info.hour(3);     
              if abs(ch_sec_rounding)<1e-4
            % Rounding off if "seconds" saved differs from rounded "seconds" by
            % less than .1ms.
                handles.Dmeg{1}.info.hour(3) =round(handles.Dmeg{1}.info.hour(3));       
              end
              datenumstart=datenum([0 0 0 handles.Dmeg{1}.info.hour]);     %整个数据的开始时间
              datenumBeg=datenum([0 0 0 Begh Begm Begs]);       %截取部分数据的开始时间

              datediff=datevec(datenumBeg-datenumstart);      %截取部分的开始时间和整个数据的开始时间差
              if datediff(4)>lgt % 判断两个开始时间差是否大于整个数据持续的总小时，
                  %%也就是说，如果跨过00：00的话就算是第二天，计算的结果会大于lgt
                 datenumBeg=datenum([0 0 1 Begh Begm Begs]);
                 datediff=datevec(datenumBeg-datenumstart);
              end

            Begpts=min(nsamples(handles.Dmeg{1}),max(1,round((datediff(4)*60^2+datediff(5)*60+datediff(6))*fsample(handles.Dmeg{1}))));       
          elseif score(i)==0     
            Endctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) + ...
            i*10));
            Endh=Endctime(1);
            Endm=Endctime(2);
            Ends=Endctime(3);
            lgt=(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/60^2; % 计算整个数据持续了多少小时
            datenumstart=datenum([0 0 0 handles.Dmeg{1}.info.hour]);     %整个数据的开始时间
            datenumEnd=datenum([0 0 0 Endh Endm Ends]);       %截取部分数据的结束时间

              datediff=datevec(datenumEnd-datenumstart);      %截取部分的结束时间和整个数据的开始时间差
              if datediff(4)>lgt % 判断两个开始时间差是否大于整个数据持续的总小时，
                  %%也就是说，如果跨过00：00的话就算是第二天，计算的结果会大于lgt
                 datenumEnd=datenum([0 0 1 Endh Endm Ends]);
                 datediff=datevec(datenumEnd-datenumstart);
              end
            Endpts=min(nsamples(handles.Dmeg{1}),max(1,round((datediff(4)*60^2+datediff(5)*60+datediff(6))*fsample(handles.Dmeg{1}))));  
             if (Endh-Begh<0)
                len_w=(24+Endh-Begh)*60^2+(Endm-Begm)*60 + (Ends-Begs);%%计算N1持续的时长，单位是秒
            else
                len_w=(Endh-Begh)*60^2+(Endm-Begm)*60 + (Ends-Begs);
             end
            W_len=[W_len;len_w];%%每个N2阶段的持续时间 
            if Begctime(1)<24
                Begctime = Begctime;
            else
                Begctime=Begctime-[24 0 0];
            end
            if Endctime(1)<24
                Endctime = Endctime;
            else
                Endctime=Endctime-[24 0 0];
            end
            W_time = [W_time;Begctime Endctime];
            W_points=[W_points;Begpts Endpts];%%n1阶段每个开始与结束所对应的数据点位置的信息
            W.time = W_time;
            W.points = W_points;
            W.len = W_len;
            flags = struct('clockt',1); % use defaults for the rest
            W_flags=[W_flags,flags];
            W.flags=W_flags;
            W.num=j_w;
            save('W_chunk','W')
        end
   end
end

% --------------------------------------------------------------------
function R_Callback(hObject, eventdata, handles)
% hObject    handle to N2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
if iscell(handles.Dmeg)
    D = handles.Dmeg{1};
else
    D = handles.Dmeg;
end
if nargin < 5 && isfield(handles,'score')
    score = handles.score{1,handles.currentscore};
elseif nargin<5 && ~isfield(handles,'score')
    score = D.CRC.score{1,handles.currentscore};
    handles.score = D.CRC.score;
end
if nargin < 4
    windowsize = 20;
end
% % def = crc_get_defaults('score');
% % vect = -.5:1/windowsize:(.5-1/windowsize);
%%%%nsamples(Dmeg)/fsample(Dmeg) 总秒数即时间   
%%%%用diff函数找出score中前后状态不同的点，即为两个状态的转换点，再通过if语句的判断，确定
%%%%每一段N1的起始点Bgpts,和截止点Edpts
% % if isfield(handles.Dmeg{1},'info')
% %     if isfield(handles.Dmeg{1}.info,'hour')
% %         Str = [' ' num2str(handles.Dmeg{1}.info.hour(1)) 'h ' num2str(handles.Dmeg{1}.info.hour(2)) 'm ' num2str(handles.Dmeg{1}.info.hour(3)) 's' ];
% %     end
% % end
if handles.scoring
    stchange=diff(score);%%score的两两值之差
    j_r=0;
    R_time = []; R_points = [];R_len = []; R_flags=[];
    if score(1)==5
        j_r=j_r+1;
        Begctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) ));%%计算阶段w数据的开始时间
            Begh=Begctime(1);%%开始的小时
            Begm=Begctime(2);%%开始的分钟
            Begs=Begctime(3);%%开始的秒
            Begpts=1;
    end 
   for i=1:length(stchange); 
    %%R阶段
     %%R阶段
          if stchange(i)==0
              continue
          elseif score(i+1)==5
              %如果这个点的下一个阶段是1，代表这个是第1个阶段的开始点
            j_r=j_r+1;  %%阶段1的个数   
            Begctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) + ...
            i*10));%%计算阶段2数据的开始时间
            Begh=Begctime(1);%%开始的小时
            Begm=Begctime(2);%%开始的分钟
            Begs=Begctime(3);%%开始的秒
            lgt=(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/60^2; % 计算整个数据持续了多少小时
            ch_sec_rounding =round(handles.Dmeg{1}.info.hour(3)) - handles.Dmeg{1}.info.hour(3);     
              if abs(ch_sec_rounding)<1e-4
            % Rounding off if "seconds" saved differs from rounded "seconds" by
            % less than .1ms.
                handles.Dmeg{1}.info.hour(3) =round(handles.Dmeg{1}.info.hour(3));       
              end
              datenumstart=datenum([0 0 0 handles.Dmeg{1}.info.hour]);     %整个数据的开始时间
              datenumBeg=datenum([0 0 0 Begh Begm Begs]);       %截取部分数据的开始时间

              datediff=datevec(datenumBeg-datenumstart);      %截取部分的开始时间和整个数据的开始时间差
              if datediff(4)>lgt % 判断两个开始时间差是否大于整个数据持续的总小时，
                  %%也就是说，如果跨过00：00的话就算是第二天，计算的结果会大于lgt
                 datenumBeg=datenum([0 0 1 Begh Begm Begs]);
                 datediff=datevec(datenumBeg-datenumstart);
              end

            Begpts=min(nsamples(handles.Dmeg{1}),max(1,round((datediff(4)*60^2+datediff(5)*60+datediff(6))*fsample(handles.Dmeg{1}))));       
          elseif score(i)==5     
            Endctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) + ...
            i*10));
            Endh=Endctime(1);
            Endm=Endctime(2);
            Ends=Endctime(3);
            lgt=(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/60^2; % 计算整个数据持续了多少小时
            datenumstart=datenum([0 0 0 handles.Dmeg{1}.info.hour]);     %整个数据的开始时间
            datenumEnd=datenum([0 0 0 Endh Endm Ends]);       %截取部分数据的结束时间

              datediff=datevec(datenumEnd-datenumstart);      %截取部分的结束时间和整个数据的开始时间差
              if datediff(4)>lgt % 判断两个开始时间差是否大于整个数据持续的总小时，
                  %%也就是说，如果跨过00：00的话就算是第二天，计算的结果会大于lgt
                 datenumEnd=datenum([0 0 1 Endh Endm Ends]);
                 datediff=datevec(datenumEnd-datenumstart);
              end
            Endpts=min(nsamples(handles.Dmeg{1}),max(1,round((datediff(4)*60^2+datediff(5)*60+datediff(6))*fsample(handles.Dmeg{1}))));  
             if (Endh-Begh<0)
                len_r=(24+Endh-Begh)*60^2+(Endm-Begm)*60 + (Ends-Begs);%%计算N1持续的时长，单位是秒
            else
                len_r=(Endh-Begh)*60^2+(Endm-Begm)*60 + (Ends-Begs);
             end
            R_len=[R_len;len_r];%%每个N2阶段的持续时间 
            if Begctime(1)<24
                Begctime = Begctime;
            else
                Begctime=Begctime-[24 0 0];
            end
            if Endctime(1)<24
                Endctime = Endctime;
            else
                Endctime=Endctime-[24 0 0];
            end
            R_time = [R_time;Begctime Endctime];
            R_points=[R_points;Begpts Endpts];%%n1阶段每个开始与结束所对应的数据点位置的信息
            R.time = R_time;
            R.points = R_points;
            R.len = R_len;
            flags = struct('clockt',1); % use defaults for the rest
            R_flags=[R_flags,flags];
            R.flags=R_flags;
            R.num=j_r;
            save('R_chunk','R');
          end
   end
end







% --- Executes on selection change in Chans.
function Chans_Callback(hObject, eventdata, handles)
% hObject    handle to Chans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AllChan = get(handles.Chans,'string');%所有通道的名字
Index=get(handles.Chans,'value');
SelChan=AllChan(Index);%所选通道的名字
SelChan=cell2mat(SelChan);
switch  SelChan
    case 'Fp1'
        ChanIndex=1;
    case 'Fp2'
        ChanIndex=2;
    case 'F3'
        ChanIndex=3;
    case 'F4'
        ChanIndex=4;
    case 'C3'
        ChanIndex=5;
    case 'C4'
        ChanIndex=6;
    case 'P3'
        ChanIndex=7;
    case 'P4'
        ChanIndex=8;
    case 'O1'
        ChanIndex=9;
    case 'O2'
        ChanIndex=10;%这样就能得到所选通道对应电极帽的位置
end
save('Arousalchan_data','AllChan','ChanIndex','SelChan')%将这些在之后的纺锤波标记需要用到的数据保存
% Hints: contents = cellstr(get(hObject,'String')) returns Chans contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Chans


% --- Executes during object creation, after setting all properties.
function Chans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Chans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%鼠标在axes1上面划线
% --- Executes on button press in Aromark.
% % function Aromark_Callback(hObject, eventdata, handles)
% % % hObject    handle to Aromark (see GCBO)
% % % eventdata  reserved - to be defined in a future version of MATLAB
% % % handles    structure with handles and user data (see GUIDATA)
% % set(handles.figure1,'CurrentAxes',handles.axes1)
% % set(gcf,'WindowButtonDownFcn',@buttondown);
function togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
buttonvalue=get(handles.togglebutton,'value');
if buttonvalue==1
    set(handles.togglebutton,'string','Marking ON');
    set(handles.figure1,'CurrentAxes',handles.axes1);
    set(gcf,'WindowButtonDownFcn',@buttondown);
else
    set(handles.togglebutton,'string','Spindle Marker');
end
% Hint: get(hObject,'Value') returns toggle state of togglebutton
function buttondown(hObject, eventdata, handles)
handles = guidata(hObject);
set(gcf, 'WindowButtonMotionFcn', @buttonmove);
set(gcf, 'WindowButtonUpFcn', @buttonup);

function buttonmove(hObject, eventdata, handles)
handles = guidata(hObject);
b = get(gca,'CurrentPoint');
x = b(1,1);
y = b(1,2);
hold on;
line(x,y,'Color','r','LineStyle','.','LineWidth',10,'DisplayName','plot_line');

function buttonup(hObject, eventdata, handles)
load('Arousalchan_data.mat');
handles = guidata(hObject);
uppt = get(gca,'CurrentPoint');
ctshow=str2double(get(handles.currenttime,'String'));
x = uppt(1,1);
y = uppt(1,2);
set(gcf,'WindowButtonMotionFcn','');
set(gcf,'WindowButtonUpFcn','');
sure_or_not = [0,0,0];
save('sure_or_not.mat','sure_or_not');
%%划直线
a = get(gca,'Children');
n = length(a);
X = [];
switch SelChan
        case 'Fp1'
            for i = 1:n
                c = get(a(i),'DisplayName');
                if strcmp(c,'plot_line')
                    x1 = get(a(i),'Xdata');
                    y1 = get(a(i),'Ydata');
                    X = [X;x1 y1];
                    delete(a(i));
                end
            end
            Y = X;           
            if ~isempty(Y)
                minpt=min(Y(:,1));
                maxpt=max(Y(:,1));
                if  (max(X(:,2))>900)||(min(X(:,2))<0)||(minpt>ctshow+handles.winsize/2)||(maxpt<ctshow-handles.winsize/2)
                    msgbox('您绘制的线段不在正确范围内，请重新绘制！','提示信息','help','modal');
                elseif    (maxpt-minpt)>0.1
                    Y(:,2) = Y(1,2);%为了划直线
                    hold on;
                    name='plot_fp1';
                    line(Y(:,1),Y(:,2),'Color','r','LineStyle','.','LineWidth',10,'DisplayName',name);                                
                    minpt=min(Y(:,1));
                    maxpt=max(Y(:,1));
                    yvalue=Y(1,2);                   
                    uppt=[maxpt yvalue];
                    downpt = [minpt yvalue];                   
                    save('currentpoint','downpt','uppt');%%保存起始点的坐标信息（当前）
                    uicontrol(gcf,'Style','radiobutton','Position',[80 650 100 20],'String','Sure','Tag','1','BackgroundColor','w','Callback',@sure);%生成Sure按钮
                    uicontrol(gcf,'Style','radiobutton','Position',[80 630 100 20],'String','Not Sure','Tag','2','BackgroundColor','w','Callback',@NOsure);%生成Not Sure按钮
                    uicontrol(gcf,'Style','pushbutton','Position',[80 610 100 20],'String','delete','Tag','3','Callback',@deleteLine);%生成delete按钮
                    set(gcf,'WindowButtonDownFcn',@buttondown_change);%选中直线，对线进行删除和变化
                    load('sure_or_not.mat');
                    if any(sure_or_not)
                        set(gcf,'KeyPressFcn',@keypress);
                    else
                        set(gcf,'KeyPressFcn',@keypress3);
                        set(handles.slider1,'Enable','off');
                        set(handles.Fsec,'Enable','off');
                        set(handles.Bsec,'Enable','off');
                    end   
                    set(handles.togglebutton,'Enable','off');
                else
                    msgbox('您绘制的线段太短了，请重新绘制！','提示信息','help','modal');
                end
            end
        case 'Fp2'
            for i = 1:n
                c = get(a(i),'DisplayName');
                if strcmp(c,'plot_line')
                    x1 = get(a(i),'Xdata');
                    y1 = get(a(i),'Ydata');
                    X = [X;x1 y1];
                    delete(a(i));
                end
            end
            Y = X;
            if ~isempty(Y)
                minpt=min(Y(:,1));
                maxpt=max(Y(:,1));
                if  (max(X(:,2))>900)||(min(X(:,2))<0)||(minpt>ctshow+handles.winsize/2)||(maxpt<ctshow-handles.winsize/2)
                    msgbox('您绘制的线段不在正确范围内，请重新绘制！','提示信息','help','modal');
                elseif    (maxpt-minpt)>0.1
                    Y(:,2) = Y(1,2);%为了划直线
                    hold on;
                    name='plot_fp2';
                    line(Y(:,1),Y(:,2),'Color','r','LineStyle','.','LineWidth',10,'DisplayName',name);
                    minpt=min(Y(:,1));
                    maxpt=max(Y(:,1));
                    yvalue=Y(1,2);
                    uppt=[maxpt yvalue];
                    downpt = [minpt yvalue]; 
                    save('currentpoint','downpt','uppt');%%保存起始点的坐标信息（当前）
                    uicontrol(gcf,'Style','radiobutton','Position',[80 650 100 20],'String','Sure','Tag','1','BackgroundColor','w','Callback',@sure);%生成Sure按钮
                    uicontrol(gcf,'Style','radiobutton','Position',[80 630 100 20],'String','Not Sure','Tag','2','BackgroundColor','w','Callback',@NOsure);%生成Not Sure按钮
                    uicontrol(gcf,'Style','pushbutton','Position',[80 610 100 20],'String','delete','Tag','3','Callback',@deleteLine);%生成delete按钮
                    set(gcf,'WindowButtonDownFcn',@buttondown_change);%选中直线，对线进行删除和变化
                    load('sure_or_not.mat');
                    if any(sure_or_not)
                        set(gcf,'KeyPressFcn',@keypress);
                    else
                        set(gcf,'KeyPressFcn',@keypress3);
                        set(handles.slider1,'Enable','off');
                        set(handles.Fsec,'Enable','off');
                        set(handles.Bsec,'Enable','off');
                    end
                    set(handles.togglebutton,'Enable','off');
                else
                    msgbox('您绘制的线段太短了，请重新绘制！','提示信息','help','modal');
                end
            end
        case 'F3'
            for i = 1:n
                c = get(a(i),'DisplayName');
                if strcmp(c,'plot_line')
                    x1 = get(a(i),'Xdata');
                    y1 = get(a(i),'Ydata');
                    X = [X;x1 y1];
                    delete(a(i));
                end
            end
            Y = X;
            if ~isempty(Y)
                minpt=min(Y(:,1));
                maxpt=max(Y(:,1));
                if  (max(X(:,2))>900)||(min(X(:,2))<0)||(minpt>ctshow+handles.winsize/2)||(maxpt<ctshow-handles.winsize/2)
                    msgbox('您绘制的线段不在正确范围内，请重新绘制！','提示信息','help','modal');
                elseif    (maxpt-minpt)>0.1
                    Y(:,2) = Y(1,2);%为了划直线
                    hold on;
                    name='plot_f3';
                    line(Y(:,1),Y(:,2),'Color','r','LineStyle','.','LineWidth',10,'DisplayName',name);
                    minpt=min(Y(:,1));
                    maxpt=max(Y(:,1));
                    yvalue=Y(1,2);
                    uppt=[maxpt yvalue];
                    downpt = [minpt yvalue]; 
                    save('currentpoint','downpt','uppt');%%保存起始点的坐标信息（当前）
                    uicontrol(gcf,'Style','radiobutton','Position',[80 650 100 20],'String','Sure','Tag','1','BackgroundColor','w','Callback',@sure);%生成Sure按钮
                    uicontrol(gcf,'Style','radiobutton','Position',[80 630 100 20],'String','Not Sure','Tag','2','BackgroundColor','w','Callback',@NOsure);%生成Not Sure按钮
                    uicontrol(gcf,'Style','pushbutton','Position',[80 610 100 20],'String','delete','Tag','3','Callback',@deleteLine);%生成delete按钮
                    set(gcf,'WindowButtonDownFcn',@buttondown_change);%选中直线，对线进行删除和变化
                    load('sure_or_not.mat');
                    if any(sure_or_not)
                        set(gcf,'KeyPressFcn',@keypress);
                    else
                        set(gcf,'KeyPressFcn',@keypress3);
                        set(handles.slider1,'Enable','off');
                        set(handles.Fsec,'Enable','off');
                        set(handles.Bsec,'Enable','off');
                    end
                    set(handles.togglebutton,'Enable','off');
                else
                    msgbox('您绘制的线段太短了，请重新绘制！','提示信息','help','modal');
                end
            end
        case 'F4'
            for i = 1:n
                c = get(a(i),'DisplayName');
                if strcmp(c,'plot_line')
                    x1 = get(a(i),'Xdata');
                    y1 = get(a(i),'Ydata');
                    X = [X;x1 y1];
                    delete(a(i));
                end
            end
            Y = X;
            if ~isempty(Y)
                minpt=min(Y(:,1));
                maxpt=max(Y(:,1));
                if  (max(X(:,2))>900)||(min(X(:,2))<0)||(minpt>ctshow+handles.winsize/2)||(maxpt<ctshow-handles.winsize/2)
                    msgbox('您绘制的线段不在正确范围内，请重新绘制！','提示信息','help','modal');
                elseif    (maxpt-minpt)>0.1
                    Y(:,2) = Y(1,2);%为了划直线
                    hold on;
                    name='plot_f4';
                    line(Y(:,1),Y(:,2),'Color','r','LineStyle','.','LineWidth',10,'DisplayName',name);
                    minpt=min(Y(:,1));
                    maxpt=max(Y(:,1));
                    yvalue=Y(1,2);
                    uppt=[maxpt yvalue];
                    downpt = [minpt yvalue]; 
                    save('currentpoint','downpt','uppt');%%保存起始点的坐标信息（当前）
                    uicontrol(gcf,'Style','radiobutton','Position',[80 650 100 20],'String','Sure','Tag','1','BackgroundColor','w','Callback',@sure);%生成Sure按钮
                    uicontrol(gcf,'Style','radiobutton','Position',[80 630 100 20],'String','Not Sure','Tag','2','BackgroundColor','w','Callback',@NOsure);%生成Not Sure按钮
                    uicontrol(gcf,'Style','pushbutton','Position',[80 610 100 20],'String','delete','Tag','3','Callback',@deleteLine);%生成delete按钮
                    set(gcf,'WindowButtonDownFcn',@buttondown_change);%选中直线，对线进行删除和变化
                    load('sure_or_not.mat');
                    if any(sure_or_not)
                        set(gcf,'KeyPressFcn',@keypress);
                    else
                        set(gcf,'KeyPressFcn',@keypress3);
                        set(handles.slider1,'Enable','off');
                        set(handles.Fsec,'Enable','off');
                        set(handles.Bsec,'Enable','off');
                    end
                    set(handles.togglebutton,'Enable','off');
                else
                    msgbox('您绘制的线段太短了，请重新绘制！','提示信息','help','modal');
                end
            end
        case 'C3'
            for i = 1:n
                c = get(a(i),'DisplayName');
                if strcmp(c,'plot_line')
                    x1 = get(a(i),'Xdata');
                    y1 = get(a(i),'Ydata');
                    X = [X;x1 y1];
                    delete(a(i));
                end
            end
            Y = X;
            if ~isempty(Y)
                minpt=min(Y(:,1));
                maxpt=max(Y(:,1));
                if  (max(X(:,2))>900)||(min(X(:,2))<0)||(minpt>ctshow+handles.winsize/2)||(maxpt<ctshow-handles.winsize/2)
                    msgbox('您绘制的线段不在正确范围内，请重新绘制！','提示信息','help','modal');
                elseif    (maxpt-minpt)>0.1
                    Y(:,2) = Y(1,2);%为了划直线
                    hold on;
                    name='plot_c3';
                    line(Y(:,1),Y(:,2),'Color','r','LineStyle','.','LineWidth',10,'DisplayName',name);
                    minpt=min(Y(:,1));
                    maxpt=max(Y(:,1));
                    yvalue=Y(1,2);                   
                    uppt=[maxpt yvalue];
                    downpt = [minpt yvalue];                   
                    save('currentpoint','downpt','uppt');%%保存起始点的坐标信息（当前）
                    uicontrol(gcf,'Style','radiobutton','Position',[80 650 100 20],'String','Sure','Tag','1','BackgroundColor','w','Callback',@sure);%生成Sure按钮
                    uicontrol(gcf,'Style','radiobutton','Position',[80 630 100 20],'String','Not Sure','Tag','2','BackgroundColor','w','Callback',@NOsure);%生成Not Sure按钮
                    uicontrol(gcf,'Style','pushbutton','Position',[80 610 100 20],'String','delete','Tag','3','Callback',@deleteLine);%生成delete按钮
                    set(gcf,'WindowButtonDownFcn',@buttondown_change);%选中直线，对线进行删除和变化
                    load('sure_or_not.mat');
                    if any(sure_or_not)
                        set(gcf,'KeyPressFcn',@keypress);
                    else
                        set(gcf,'KeyPressFcn',@keypress3);
                        set(handles.slider1,'Enable','off');
                        set(handles.Fsec,'Enable','off');
                        set(handles.Bsec,'Enable','off');
                    end
                    set(handles.togglebutton,'Enable','off');
                else
                    msgbox('您绘制的线段太短了，请重新绘制！','提示信息','help','modal');
                end
            end
        case 'C4'
            for i = 1:n
                c = get(a(i),'DisplayName');
                if strcmp(c,'plot_line')
                    x1 = get(a(i),'Xdata');
                    y1 = get(a(i),'Ydata');
                    X = [X;x1 y1];
                    delete(a(i));
                end
            end
            Y = X;
            if ~isempty(Y)
                minpt=min(Y(:,1));
                maxpt=max(Y(:,1));
                if  (max(X(:,2))>900)||(min(X(:,2))<0)||(minpt>ctshow+handles.winsize/2)||(maxpt<ctshow-handles.winsize/2)
                    msgbox('您绘制的线段不在正确范围内，请重新绘制！','提示信息','help','modal');
                elseif    (maxpt-minpt)>0.1
                    Y(:,2) = Y(1,2);%为了划直线
                    hold on;
                    name='plot_c4';
                    line(Y(:,1),Y(:,2),'Color','r','LineStyle','.','LineWidth',10,'DisplayName',name);
                    minpt=min(Y(:,1));
                    maxpt=max(Y(:,1));
                    yvalue=Y(1,2);
                    uppt=[maxpt yvalue];
                    downpt = [minpt yvalue]; 
                    save('currentpoint','downpt','uppt');%%保存起始点的坐标信息（当前）
                    uicontrol(gcf,'Style','radiobutton','Position',[80 650 100 20],'String','Sure','Tag','1','BackgroundColor','w','Callback',@sure);%生成Sure按钮
                    uicontrol(gcf,'Style','radiobutton','Position',[80 630 100 20],'String','Not Sure','Tag','2','BackgroundColor','w','Callback',@NOsure);%生成Not Sure按钮
                    uicontrol(gcf,'Style','pushbutton','Position',[80 610 100 20],'String','delete','Tag','3','Callback',@deleteLine);%生成delete按钮
                    set(gcf,'WindowButtonDownFcn',@buttondown_change);%选中直线，对线进行删除和变化
                    load('sure_or_not.mat');
                    if any(sure_or_not)
                        set(gcf,'KeyPressFcn',@keypress);
                    else
                        set(gcf,'KeyPressFcn',@keypress3);
                        set(handles.slider1,'Enable','off');
                        set(handles.Fsec,'Enable','off');
                        set(handles.Bsec,'Enable','off');
                    end
                    set(handles.togglebutton,'Enable','off');
                else
                    msgbox('您绘制的线段太短了，请重新绘制！','提示信息','help','modal');
                end
            end
        case 'P3'
            for i = 1:n
                c = get(a(i),'DisplayName');
                if strcmp(c,'plot_line')
                    x1 = get(a(i),'Xdata');
                    y1 = get(a(i),'Ydata');
                    X = [X;x1 y1];
                    delete(a(i));
                end
            end
            Y = X;
            if ~isempty(Y)
                minpt=min(Y(:,1));
                maxpt=max(Y(:,1));
                if  (max(X(:,2))>900)||(min(X(:,2))<0)||(minpt>ctshow+handles.winsize/2)||(maxpt<ctshow-handles.winsize/2)
                    msgbox('您绘制的线段不在正确范围内，请重新绘制！','提示信息','help','modal');
                elseif    (maxpt-minpt)>0.1
                    Y(:,2) = Y(1,2);%为了划直线
                    hold on;
                    name='plot_p3';
                    line(Y(:,1),Y(:,2),'Color','r','LineStyle','.','LineWidth',10,'DisplayName',name);
                    minpt=min(Y(:,1));
                    maxpt=max(Y(:,1));
                    yvalue=Y(1,2);
                    uppt=[maxpt yvalue];
                    downpt = [minpt yvalue];                   
                    save('currentpoint','downpt','uppt');%%保存起始点的坐标信息（当前）
                    uicontrol(gcf,'Style','radiobutton','Position',[80 650 100 20],'String','Sure','Tag','1','BackgroundColor','w','Callback',@sure);%生成Sure按钮
                    uicontrol(gcf,'Style','radiobutton','Position',[80 630 100 20],'String','Not Sure','Tag','2','BackgroundColor','w','Callback',@NOsure);%生成Not Sure按钮
                    uicontrol(gcf,'Style','pushbutton','Position',[80 610 100 20],'String','delete','Tag','3','Callback',@deleteLine);%生成delete按钮
                    set(gcf,'WindowButtonDownFcn',@buttondown_change);%选中直线，对线进行删除和变化
                    load('sure_or_not.mat');
                    if any(sure_or_not)
                        set(gcf,'KeyPressFcn',@keypress);
                    else
                        set(gcf,'KeyPressFcn',@keypress3);
                        set(handles.slider1,'Enable','off');
                        set(handles.Fsec,'Enable','off');
                        set(handles.Bsec,'Enable','off');
                    end
                    set(handles.togglebutton,'Enable','off');
                else
                    msgbox('您绘制的线段太短了，请重新绘制！','提示信息','help','modal');
                end
            end
        case 'P4'
            for i = 1:n
                c = get(a(i),'DisplayName');
                if strcmp(c,'plot_line')
                    x1 = get(a(i),'Xdata');
                    y1 = get(a(i),'Ydata');
                    X = [X;x1 y1];
                    delete(a(i));
                end
            end
            Y = X;
            if ~isempty(Y)
                minpt=min(Y(:,1));
                maxpt=max(Y(:,1));
                if  (max(X(:,2))>900)||(min(X(:,2))<0)||(minpt>ctshow+handles.winsize/2)||(maxpt<ctshow-handles.winsize/2)
                    msgbox('您绘制的线段不在正确范围内，请重新绘制！','提示信息','help','modal');
                elseif    (maxpt-minpt)>0.1
                    Y(:,2) = Y(1,2);%为了划直线
                    hold on;
                    name='plot_p4';
                    line(Y(:,1),Y(:,2),'Color','r','LineStyle','.','LineWidth',10,'DisplayName',name);
                    minpt=min(Y(:,1));
                    maxpt=max(Y(:,1));
                    yvalue=Y(1,2);
                    uppt=[maxpt yvalue];
                    downpt = [minpt yvalue]; 
                    save('currentpoint','downpt','uppt');%%保存起始点的坐标信息（当前）
                    uicontrol(gcf,'Style','radiobutton','Position',[80 650 100 20],'String','Sure','Tag','1','BackgroundColor','w','Callback',@sure);%生成Sure按钮
                    uicontrol(gcf,'Style','radiobutton','Position',[80 630 100 20],'String','Not Sure','Tag','2','BackgroundColor','w','Callback',@NOsure);%生成Not Sure按钮
                    uicontrol(gcf,'Style','pushbutton','Position',[80 610 100 20],'String','delete','Tag','3','Callback',@deleteLine);%生成delete按钮
                    set(gcf,'WindowButtonDownFcn',@buttondown_change);%选中直线，对线进行删除和变化
                    load('sure_or_not.mat');
                    if any(sure_or_not)
                        set(gcf,'KeyPressFcn',@keypress);
                    else
                        set(gcf,'KeyPressFcn',@keypress3);
                        set(handles.slider1,'Enable','off');
                        set(handles.Fsec,'Enable','off');
                        set(handles.Bsec,'Enable','off');
                    end
                    set(handles.togglebutton,'Enable','off');
                else
                    msgbox('您绘制的线段太短了，请重新绘制！','提示信息','help','modal');
                end
            end
        case 'O1'
            for i = 1:n
                c = get(a(i),'DisplayName');
                if strcmp(c,'plot_line')
                    x1 = get(a(i),'Xdata');
                    y1 = get(a(i),'Ydata');
                    X = [X;x1 y1];
                    delete(a(i));
                end
            end
            Y = X;
            if ~isempty(Y)
                minpt=min(Y(:,1));
                maxpt=max(Y(:,1));
                if  (max(X(:,2))>900)||(min(X(:,2))<0)||(minpt>ctshow+handles.winsize/2)||(maxpt<ctshow-handles.winsize/2)
                    msgbox('您绘制的线段不在正确范围内，请重新绘制！','提示信息','help','modal');
                elseif    (maxpt-minpt)>0.1
                    Y(:,2) = Y(1,2);%为了划直线
                    hold on;
                    name='plot_o1';
                    line(Y(:,1),Y(:,2),'Color','r','LineStyle','.','LineWidth',10,'DisplayName',name);
                    minpt=min(Y(:,1));
                    maxpt=max(Y(:,1));
                    yvalue=Y(1,2);
                    uppt=[maxpt yvalue];
                    downpt = [minpt yvalue]; 
                    save('currentpoint','downpt','uppt');%%保存起始点的坐标信息（当前）
                    uicontrol(gcf,'Style','radiobutton','Position',[80 650 100 20],'String','Sure','Tag','1','BackgroundColor','w','Callback',@sure);%生成Sure按钮
                    uicontrol(gcf,'Style','radiobutton','Position',[80 630 100 20],'String','Not Sure','Tag','2','BackgroundColor','w','Callback',@NOsure);%生成Not Sure按钮
                    uicontrol(gcf,'Style','pushbutton','Position',[80 610 100 20],'String','delete','Tag','3','Callback',@deleteLine);%生成delete按钮
                    set(gcf,'WindowButtonDownFcn',@buttondown_change);%选中直线，对线进行删除和变化
                    load('sure_or_not.mat');
                    if any(sure_or_not)
                        set(gcf,'KeyPressFcn',@keypress);
                    else
                        set(gcf,'KeyPressFcn',@keypress3);
                        set(handles.slider1,'Enable','off');
                        set(handles.Fsec,'Enable','off');
                        set(handles.Bsec,'Enable','off');
                    end
                    set(handles.togglebutton,'Enable','off');
                else
                    msgbox('您绘制的线段太短了，请重新绘制！','提示信息','help','modal');
                end
            end
        case 'O2'
            for i = 1:n
                c = get(a(i),'DisplayName');
                if strcmp(c,'plot_line')
                    x1 = get(a(i),'Xdata');
                    y1 = get(a(i),'Ydata');
                    X = [X;x1 y1];
                    delete(a(i));
                end
            end
            Y = X;
            if ~isempty(Y)
                minpt=min(Y(:,1));
                maxpt=max(Y(:,1));
                if  (max(X(:,2))>900)||(min(X(:,2))<0)||(minpt>ctshow+handles.winsize/2)||(maxpt<ctshow-handles.winsize/2)
                    msgbox('您绘制的线段不在正确范围内，请重新绘制！','提示信息','help','modal');
                elseif    (maxpt-minpt)>0.1
                    Y(:,2) = Y(1,2);%为了划直线
                    hold on;
                    name='plot_o2';
                    line(Y(:,1),Y(:,2),'Color','r','LineStyle','.','LineWidth',10,'DisplayName',name);
                    minpt=min(Y(:,1));
                    maxpt=max(Y(:,1));
                    yvalue=Y(1,2);
                    uppt=[maxpt yvalue];
                    downpt = [minpt yvalue]; 
                    save('currentpoint','downpt','uppt');%%保存起始点的坐标信息（当前）
                    uicontrol(gcf,'Style','radiobutton','Position',[80 650 100 20],'String','Sure','Tag','1','BackgroundColor','w','Callback',@sure);%生成Sure按钮
                    uicontrol(gcf,'Style','radiobutton','Position',[80 630 100 20],'String','Not Sure','Tag','2','BackgroundColor','w','Callback',@NOsure);%生成Not Sure按钮
                    uicontrol(gcf,'Style','pushbutton','Position',[80 610 100 20],'String','delete','Tag','3','Callback',@deleteLine);%生成delete按钮
                    set(gcf,'WindowButtonDownFcn',@buttondown_change);%选中直线，对线进行删除和变化
                    load('sure_or_not.mat');
                    if any(sure_or_not)
                        set(gcf,'KeyPressFcn',@keypress);
                    else
                        set(gcf,'KeyPressFcn',@keypress3);
                        set(handles.slider1,'Enable','off');
                        set(handles.Fsec,'Enable','off');
                        set(handles.Bsec,'Enable','off');
                    end
                    set(handles.togglebutton,'Enable','off');
                else
                   msgbox('您绘制的线段太短了，请重新绘制！','提示信息','help','modal');
                end
            end
end



%摁sure按钮之后，标记的线变绿色
function sure(hObject, eventdata, handles)
handles = guidata(hObject);
a = get(gca,'Children');%a(1)代表最新更新的对象
set(a(1),'Color',[0 0.6 0],'Tag','1');%确定，线变绿色,Tag为1
load('sure_or_not.mat');
sure_or_not(1) = 1;
save('sure_or_not','sure_or_not');
handles_gcf = guihandles(gcf);
handels_children = get(handles_gcf.figure1,'Children');%figure1代表图形对象，图形窗口对象的子对象包括坐标轴对象、UI对象和注释坐标轴
delete(handels_children(1));%delete按钮
delete(handels_children(2));%nosure按钮
delete(handels_children(3));%sure按钮


%%%%点击sure之后鼠标的位置信息自动保存
load('currentpoint.mat');load('Datapath.mat');
load('Arousalchan_data.mat');
load('Arousal_data.mat');
global currentpage
global totalpage
currentpage=str2double(get(handles.currentpage,'string'));%当前的页数
totalpage = ceil((nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/handles.winsize);
%%%%保存鼠标的位置信息，用来update数据的时候重新画图
a = get(gca,'Children');
n = length(a);
X = [];
ctture = currentpage*handles.winsize-handles.winsize/2;%计算当前页对应的正确时间
ctshow = str2double(get(handles.currenttime,'string'));%得到当前显示的时间
% if ctture<ctshow  %说明是前进了
%     Fvalue=1;
%     Bvalue=0;
% elseif ctture>ctshow  %后退了
%     Fvalue=0;
%     Bvalue=1; 
% else
%     Fvalue=0;
%     Bvalue=0;
% end
save('Datapath','datapath','dataname','MarValue','Fvalue','Bvalue')
switch SelChan
    case 'Fp1'  
        %Arou.j_fp1(1,currentpage)=0;%当前页标记的数量初始值设置为0
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_fp1'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.Fp1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                       (Arou.j_fp1(1,currentpage-1)>0)&& (max(Arou.pos_Fp1(:,1,currentpage-1))==[downpt1])
                    Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.Fp1(currentpage+1,1))&&...
                       (Arou.j_fp1(1,currentpage+1)>0)&& (min(Arou.pos_Fp1(1:Arou.j_fp1(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage);%如果这条线属下一页不计数
                else
                   % Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)  %前进了
                Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage)+1;%将这一页的标记数加1
                Arou.Fp1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1
                Arou.Fp1(currentpage+1,1:endpt)=1;
                %将下一页的开始到endpt设置为1
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息                
%                 Arou.pos_Fp1(Arou.j_fp1(1,currentpage),:,currentpage)=[downpt next_x downpt(2)];%存入Fp1通道当前页标记线段的坐标信息
%                 Arou.pos_Fp1(Arou.j_fp1(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)  %后退了
                Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage)+1;%将当前页的标记数加1
                Arou.Fp1(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1
                Arou.Fp1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage)+1;%将这一页的标记数加1
                Arou.Fp1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage)+1;%将当前页的标记数加1
                Arou.Fp1(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
                
                Arou.j_fp1(1,currentpage+1) = Arou.j_fp1(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.Fp1(currentpage+1,startpt:endpt)=1;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_fp1(1,currentpage-1) = Arou.j_fp1(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.Fp1(currentpage-1,startpt:endpt)=1;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage)+1;
                Arou.Fp1(currentpage,startpt:endpt)=1;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'Fp2'
        %Arou.j_fp2(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_fp2'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.Fp2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_fp2(1,currentpage-1)>0)&&(max(Arou.pos_Fp2(:,1,currentpage-1))==[downpt1])
                    Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.Fp2(currentpage+1,1))&&...
                   (Arou.j_fp2(1,currentpage+1)>0)&& (min(Arou.pos_Fp2(1:Arou.j_fp2(currentpage+1),1,currentpage+1))==[downpt1])
                    Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage);%如果这条线属下一页不计数
                else
                %    Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0 %如果在第一页左边坐标之外
            downpt(1,1)=1/fsample(handles.Dmeg{1});          
        elseif uppt(1,1)>totalpage*handles.winsize %如果在最后一页右边坐标之外
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1}));        
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
         if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间 
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)    %前进了
                Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage)+1;%将下一页的标记数加1
                Arou.Fp2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1
                Arou.Fp2(currentpage+1,1:endpt)=1;
                %将下一页的开始到endpt设置为1
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
    %            Arou.pos_Fp2(Arou.j_fp2(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)  %后退了
                Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage)+1;%将上一页的标记数加1
                Arou.Fp2(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1
                Arou.Fp2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
  %              Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage)+1;%将这一页的标记数加1
                Arou.Fp2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage)+1;%将当前页的标记数加1
                Arou.Fp2(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
             if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
                
                Arou.j_fp2(1,currentpage+1) = Arou.j_fp2(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.Fp2(currentpage+1,startpt:endpt)=1;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_fp2(1,currentpage-1) = Arou.j_fp2(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.Fp2(currentpage-1,startpt:endpt)=1;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage)+1;
                Arou.Fp2(currentpage,startpt:endpt)=1;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'F3'    
   %     Arou.j_f3(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_f3'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.F3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_f3(1,currentpage-1)>0)&&(max(Arou.pos_F3(:,1,currentpage-1))==[downpt1])
                    Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.F3(currentpage+1,1))&&...
                       (Arou.j_f3(1,currentpage+1)>0)&& (min(Arou.pos_F3(1:Arou.j_f3(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage);%如果这条线属下一页不计数
                else
             %       Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
         if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)  %前进了
                Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage)+1;%将下一页的标记数加1
                Arou.F3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1
                Arou.F3(currentpage+1,1:endpt)=1;
                %将下一页的开始到endpt设置为1
                Arou.pos_F3(Arou.j_f3(1,currentpage),:,currentpage)=[downpt uppt];%存入f3通道当前页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)  %后退了
                Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage)+1;%将上一页的标记数加1
                Arou.F3(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1
                Arou.F3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_F3(Arou.j_f3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
      %          Arou.pos_F3(Arou.j_f3(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage)+1;%将这一页的标记数加1
                Arou.F3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_F3(Arou.j_f3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage)+1;%将当前页的标记数加1
                Arou.F3(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_F3(Arou.j_f3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
               
                Arou.j_f3(1,currentpage+1) = Arou.j_f3(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.F3(currentpage+1,startpt:endpt)=1;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_F3(Arou.j_f3(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_f3(1,currentpage-1) = Arou.j_f3(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.F3(currentpage-1,startpt:endpt)=1;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_F3(Arou.j_f3(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage)+1;
                Arou.F3(currentpage,startpt:endpt)=1;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_F3(Arou.j_f3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'F4'
%        Arou.j_f4(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_f4'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.F4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_f4(1,currentpage-1)>0)&&(max(Arou.pos_F4(:,1,currentpage-1))==[downpt1])
                    Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.F4(currentpage+1,1))&&...
                       (Arou.j_f4(1,currentpage+1)>0)&& (min(Arou.pos_F4(1:Arou.j_f4(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage);%如果这条线属下一页不计数
                else
  %                  Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0 %如果在第一页左边坐标之外
            downpt(1,1)=1/fsample(handles.Dmeg{1});          
        elseif uppt(1,1)>totalpage*handles.winsize %如果在最后一页右边坐标之外
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1}));        
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        
         if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间  %如果这两点不在同一页，也就是我们执行了前进或者后退一秒的操作
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)  %前进了
                Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage)+1;%将下一页的标记数加1
                Arou.F4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1
                Arou.F4(currentpage+1,1:endpt)=1;
                %将下一页的开始到endpt设置为1
                Arou.pos_F4(Arou.j_f4(1,currentpage),:,currentpage)=[downpt uppt];%存入F4通道当前页标记线段的坐标信息
 %               Arou.pos_F4(Arou.j_f4(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入F4通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)  %后退了
                Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage)+1;%将上一页的标记数加1
                Arou.F4(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1
                Arou.F4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_F4(Arou.j_f4(1,currentpage),:,currentpage)=[downpt uppt];%pt(2) 存入F4通道当前页标记线段的坐标信息
  %              Arou.pos_F4(Arou.j_f4(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入F4通道上一页标记线段的坐标信息
           elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage)+1;%将这一页的标记数加1
                Arou.F4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_F4(Arou.j_f4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage)+1;%将当前页的标记数加1
                Arou.F4(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_F4(Arou.j_f4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
                
                Arou.j_f4(1,currentpage+1) = Arou.j_f4(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.F4(currentpage+1,startpt:endpt)=1;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_F4(Arou.j_f4(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_f4(1,currentpage-1) = Arou.j_f4(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.F4(currentpage-1,startpt:endpt)=1;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_F4(Arou.j_f4(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage)+1;
                Arou.F4(currentpage,startpt:endpt)=1;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_F4(Arou.j_f4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'C3'
 %       Arou.j_c3(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_c3'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.C3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_c3(1,currentpage-1)>0)&&(max(Arou.pos_C3(:,1,currentpage-1))==[downpt1])
                    Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.C3(currentpage+1,1))&&...
                       (Arou.j_c3(1,currentpage+1)>0)&& (min(Arou.pos_C3(1:Arou.j_c3(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage);%如果这条线属下一页不计数
                else
    %                Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
         if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)<=ctshow+handles.winsize/2)&&(uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)  %前进了
                Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage)+1;%将标记数加1
                Arou.C3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1
                Arou.C3(currentpage+1,1:endpt)=1;
                %将下一页的开始到endpt设置为1
                Arou.pos_C3(Arou.j_c3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
   %             Arou.pos_C3(Arou.j_c3(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)>=ctshow-handles.winsize/2)&&(uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)  %后退了
                Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage)+1;%将标记数加1
                Arou.C3(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1
                Arou.C3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_C3(Arou.j_c3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage)+1;%将这一页的标记数加1
                Arou.C3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_C3(Arou.j_c3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage)+1;%将当前页的标记数加1
                Arou.C3(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_C3(Arou.j_c3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页               
                Arou.j_c3(1,currentpage+1) = Arou.j_c3(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.C3(currentpage+1,startpt:endpt)=1;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_C3(Arou.j_c3(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_c3(1,currentpage-1) = Arou.j_c3(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.C3(currentpage-1,startpt:endpt)=1;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_C3(Arou.j_c3(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage)+1;
                Arou.C3(currentpage,startpt:endpt)=1;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_C3(Arou.j_c3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'C4'
  %      Arou.j_c4(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_c4'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.C4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_c4(1,currentpage-1)>0)&&(max(Arou.pos_C4(:,1,currentpage-1))==[downpt1])
                    Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.C4(currentpage+1,1))&&...
                       (Arou.j_c4(1,currentpage+1)>0)&& (min(Arou.pos_C4(1:Arou.j_c4(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage);%如果这条线属下一页不计数
                else
    %                Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)  %前进了
                Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage)+1;%将下一页的标记数加1
                Arou.C4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1
                Arou.C4(currentpage+1,1:endpt)=1;
                %将下一页的开始到endpt设置为1
                Arou.pos_C4(Arou.j_c4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
 %               Arou.pos_C4(Arou.j_c4(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)   %后退了
                Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage)+1;%将上一页的标记数加1
                Arou.C4(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1
                Arou.C4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_C4(Arou.j_c4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
 %               Arou.pos_C4(Arou.j_c4(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage)+1;%将这一页的标记数加1
                Arou.C4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_C4(Arou.j_c4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage)+1;%将当前页的标记数加1
                Arou.C4(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_C4(Arou.j_c4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
         else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
                
                Arou.j_c4(1,currentpage+1) = Arou.j_c4(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.C4(currentpage+1,startpt:endpt)=1;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_C4(Arou.j_c4(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_c4(1,currentpage-1) = Arou.j_c4(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.C4(currentpage-1,startpt:endpt)=1;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_C4(Arou.j_c4(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage)+1;
                Arou.C4(currentpage,startpt:endpt)=1;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_C4(Arou.j_c4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'P3'
 %       Arou.j_p3(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_p3'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.P3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_p3(1,currentpage-1)>0)&&(max(Arou.pos_P3(:,1,currentpage-1))==[downpt1])
                    Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.P3(currentpage+1,1))&&...
                       (Arou.j_p3(1,currentpage+1)>0)&& (min(Arou.pos_P3(1:Arou.j_p3(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage);%如果这条线属下一页不计数
                else
   %                 Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)   %前进了
                Arou.j_p3(1,purrentpage) = Arou.j_p3(1,currentpage)+1;%将下一页的标记数加1
                Arou.P3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1
                Arou.P3(currentpage+1,1:endpt)=1;
                %将下一页的开始到endpt设置为1
                Arou.pos_P3(Arou.j_p3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_P3(Arou.j_p3(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)  %后退了
                Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage)+1;%将上一页的标记数加1
                Arou.P3(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1
                Arou.P3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_P3(Arou.j_p3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_P3(Arou.j_p3(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage)+1;%将这一页的标记数加1
                Arou.P3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_P3(Arou.j_p3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage)+1;%将当前页的标记数加1
                Arou.P3(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_P3(Arou.j_p3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
         else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页                
                Arou.j_p3(1,currentpage+1) = Arou.j_p3(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.P3(currentpage+1,startpt:endpt)=1;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_P3(Arou.j_p3(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_p3(1,currentpage-1) = Arou.j_p3(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.P3(currentpage-1,startpt:endpt)=1;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_P3(Arou.j_p3(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage)+1;
                Arou.P3(currentpage,startpt:endpt)=1;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_3P(Arou.j_p3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'P4'
 %       Arou.j_p4(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_p4'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.P4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_p4(1,currentpage-1)>0)&&(max(Arou.pos_P4(:,1,currentpage-1))==[downpt1])
                    Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.P4(currentpage+1,1))&&...
                       (Arou.j_p4(1,currentpage+1)>0)&& (min(Arou.pos_P4(1:Arou.j_p4(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage);%如果这条线属下一页不计数    
                else
 %                   Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间  %如果这两点不在同一页，也就是我们执行了前进或者后退一秒的操作
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)   %前进了
                Arou.j_p4(1,purrentpage) = Arou.j_p4(1,currentpage)+1;%将下一页的标记数加1
                Arou.P4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1
                Arou.P4(currentpage+1,1:endpt)=1;
                %将下一页的开始到endpt设置为1
                Arou.pos_P4(Arou.j_p4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_P4(Arou.j_p4(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)  %后退了
                Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage)+1;%将上一页的标记数加1
                Arou.P4(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1
                Arou.P4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_P4(Arou.j_p4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_P4(Arou.j_p4(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage)+1;%将这一页的标记数加1
                Arou.P4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_P4(Arou.j_p4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage)+1;%将当前页的标记数加1
                Arou.P4(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_P4(Arou.j_p4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页                
                Arou.j_p4(1,currentpage+1) = Arou.j_p3(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.P4(currentpage+1,startpt:endpt)=1;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_P4(Arou.j_p4(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_p4(1,currentpage-1) = Arou.j_p4(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.P4(currentpage-1,startpt:endpt)=1;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_P4(Arou.j_p4(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage)+1;
                Arou.P4(currentpage,startpt:endpt)=1;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_4P(Arou.j_p4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'O1'
 %       Arou.j_o1(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_o1'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.O1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_o1(1,currentpage-1)>0)&&(max(Arou.pos_O1(:,1,currentpage-1))==[downpt1])
                    Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.O1(currentpage+1,1))&&...
                       (Arou.j_o1(1,currentpage+1)>0)&& (min(Arou.pos_O1(1:Arou.j_o1(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage);%如果这条线属下一页不计数
                else
   %                 Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)  %前进了
                Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage)+1;%将下一页的标记数加1
                Arou.O1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1
                Arou.O1(currentpage+1,1:endpt)=1;
                %将下一页的开始到endpt设置为1
                Arou.pos_O1(Arou.j_o1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_O1(Arou.j_o1(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)  %后退了
                Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage)+1;%将上一页的标记数加1
                Arou.O1(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1
                Arou.O1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_O1(Arou.j_o1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_O1(Arou.j_o1(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage)+1;%将这一页的标记数加1
                Arou.O1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_O1(Arou.j_o1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage)+1;%将当前页的标记数加1
                Arou.O1(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_O1(Arou.j_o1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
         else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
                
                Arou.j_o1(1,currentpage+1) = Arou.j_o1(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.O1(currentpage+1,startpt:endpt)=1;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_O1(Arou.j_o1(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_o1(1,currentpage-1) = Arou.j_o1(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.O1(currentpage-1,startpt:endpt)=1;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_O1(Arou.j_o1(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage)+1;
                Arou.O1(currentpage,startpt:endpt)=1;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_O1(Arou.j_o1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'O2'   
 %       Arou.j_o2(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_o2'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.O2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_o2(1,currentpage-1)>0)&&(max(Arou.pos_O2(:,1,currentpage-1))==[downpt1])
                    Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.O2(currentpage+1,1))&&...
                       (Arou.j_o2(1,currentpage+1)>0)&& (min(Arou.pos_O2(1:Arou.j_o2(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage);%如果这条线属下一页不计数
                else
    %                Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)   %前进了
                Arou.j_o2(1,purrentpage) = Arou.j_o2(1,currentpage)+1;%将下一页的标记数加1
                Arou.O2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1
                Arou.O2(currentpage+1,1:endpt)=1;
                %将下一页的开始到endpt设置为1
                Arou.pos_O2(Arou.j_o2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_O2(Arou.j_o2(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)   %后退了
                Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage)+1;%将上一页的标记数加1
                Arou.O2(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1
                Arou.O2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_O2(Arou.j_o2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
 %               Arou.pos_O2(Arou.j_o2(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage)+1;%将这一页的标记数加1
                Arou.O2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=1;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_O2(Arou.j_o2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage)+1;%将当前页的标记数加1
                Arou.O2(currentpage,1:endpt)=1;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_O2(Arou.j_o2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
                
                Arou.j_o2(1,currentpage+1) = Arou.j_o2(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.O2(currentpage+1,startpt:endpt)=1;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_O2(Arou.j_o2(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_o2(1,currentpage-1) = Arou.j_o2(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.O2(currentpage-1,startpt:endpt)=1;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_O2(Arou.j_o2(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage)+1;
                Arou.O2(currentpage,startpt:endpt)=1;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_O2(Arou.j_o2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
end

prefix='aro';%设置文件的前缀为aro
% subname=SelChan;
datFile=strcat(prefix,'_',dataname(1:end-4));
subname=datFile;%设置文件名为aro+数据名
% filefull=strcat(datFile,'.mat');
% filename='Arousal';
save('Arousal_data','Arou');%将数据保存到默认目录下
datfile=strcat(subname,'.mat');
save(datfile,'Arou');%将arou结构体保存为“aro+数据名”的mat文件，这一步也很慢
set(gcf,'KeyPressFcn',@keypress);
set(handles.slider1,'Enable','on');
set(handles.Fsec,'Enable','on');
set(handles.Bsec,'Enable','on');
set(handles.togglebutton,'Enable','on');
set(handles.togglebutton,'value',0);
set(handles.togglebutton,'string','Spindle Marker');

function NOsure(hObject, eventdata, handles)
handles = guidata(hObject);
a = get(gca,'Children');
set(a(1),'Color',[1 0.5 0],'Tag','0');%不确定，线变橘黄，Tag为0
load('sure_or_not.mat');
sure_or_not(2) = 1;
save('sure_or_not','sure_or_not');
handles_gcf = guihandles(gcf);
handels_children = get(handles_gcf.figure1,'Children');
delete(handels_children(1));
delete(handels_children(2));
delete(handels_children(3))%sure按钮
set(gcf,'KeyPressFcn',@keypress);

%%%%点击NOsure之后鼠标的位置信息自动保存
load('currentpoint.mat');load('Datapath.mat');
load('Arousalchan_data.mat');
load('Arousal_data.mat');
global currentpage
global totalpage
currentpage=str2double(get(handles.currentpage,'string'));%当前的页数
totalpage = ceil((nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/handles.winsize);
%%%%保存鼠标的位置信息，用来update数据的时候重新画图
a = get(gca,'Children');
n = length(a);
X = [];
ctture = currentpage*handles.winsize-handles.winsize/2;%计算当前页对应的正确时间
ctshow = str2double(get(handles.currenttime,'string'));%得到当前显示的时间
% if ctture<ctshow  %说明是前进了
%     Fvalue=1;
%     Bvalue=0;
% elseif ctture>ctshow  %后退了
%     Fvalue=0;
%     Bvalue=1; 
% else
%     Fvalue=0;
%     Bvalue=0;
% end
save('Datapath','datapath','dataname','MarValue','Fvalue','Bvalue')
switch SelChan
    case 'Fp1'  
        %Arou.j_fp1(1,currentpage)=0;%当前页标记的数量初始值设置为0
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_fp1'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.Fp1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                       (Arou.j_fp1(1,currentpage-1)>0)&& (max(Arou.pos_Fp1(:,1,currentpage-1))==[downpt1])
                    Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.Fp1(currentpage+1,1))&&...
                       (Arou.j_fp1(1,currentpage+1)>0)&& (min(Arou.pos_Fp1(1:Arou.j_fp1(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage);%如果这条线属下一页不计数
                else
                   % Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)<=ctshow+handles.winsize/2)&&(uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)  %前进了
                Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage)+1;%将这一页的标记数加1
                Arou.Fp1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1
                Arou.Fp1(currentpage+1,1:endpt)=0.5;
                %将下一页的开始到endpt设置为1
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息                
%                 Arou.pos_Fp1(Arou.j_fp1(1,currentpage),:,currentpage)=[downpt next_x downpt(2)];%存入Fp1通道当前页标记线段的坐标信息
%                 Arou.pos_Fp1(Arou.j_fp1(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)>=ctshow-handles.winsize/2)&&(uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)  %后退了
                Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage)+1;%将当前页的标记数加1
                Arou.Fp1(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1
                Arou.Fp1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize;
                Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage)+1;%将这一页的标记数加1
                Arou.Fp1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize)
                downpt(1,1)=ctshow-handles.winsize+1/fsample(handles.Dmeg{1});
                Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage)+1;%将当前页的标记数加1
                Arou.Fp1(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
                
                Arou.j_fp1(1,currentpage+1) = Arou.j_fp1(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.Fp1(currentpage+1,startpt:endpt)=0.5;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_fp1(1,currentpage-1) = Arou.j_fp1(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.Fp1(currentpage-1,startpt:endpt)=0.5;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_fp1(1,currentpage) = Arou.j_fp1(1,currentpage)+1;
                Arou.Fp1(currentpage,startpt:endpt)=0.5;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_Fp1(Arou.j_fp1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'Fp2'
        %Arou.j_fp2(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_fp2'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.Fp2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_fp2(1,currentpage-1)>0)&&(max(Arou.pos_Fp2(:,1,currentpage-1))==[downpt1])
                    Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.Fp2(currentpage+1,1))&&...
                   (Arou.j_fp2(1,currentpage+1)>0)&& (min(Arou.pos_Fp2(1:Arou.j_fp2(currentpage+1),1,currentpage+1))==[downpt1])
                    Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage);%如果这条线属下一页不计数
                else
                %    Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0 %如果在第一页左边坐标之外
            downpt(1,1)=1/fsample(handles.Dmeg{1});          
        elseif uppt(1,1)>totalpage*handles.winsize %如果在最后一页右边坐标之外
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1}));        
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
         if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间 
            if (uppt(1,1)<=ctshow+handles.winsize/2) &&(uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)   %前进了
                Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage)+1;%将下一页的标记数加1
                Arou.Fp2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1
                Arou.Fp2(currentpage+1,1:endpt)=0.5;
                %将下一页的开始到endpt设置为1
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
    %            Arou.pos_Fp2(Arou.j_fp2(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)>=ctshow-handles.winsize/2)&&(uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)  %后退了
                Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage)+1;%将上一页的标记数加1
                Arou.Fp2(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1
                Arou.Fp2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
  %              Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize;
                Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage)+1;%将这一页的标记数加1
                Arou.Fp2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize)
                downpt(1,1)=ctshow-handles.winsize+1/fsample(handles.Dmeg{1});
                Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage)+1;%将当前页的标记数加1
                Arou.Fp2(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
             if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
                
                Arou.j_fp2(1,currentpage+1) = Arou.j_fp2(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.Fp2(currentpage+1,startpt:endpt)=0.5;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_fp2(1,currentpage-1) = Arou.j_fp2(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.Fp2(currentpage-1,startpt:endpt)=0.5;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_fp2(1,currentpage) = Arou.j_fp2(1,currentpage)+1;
                Arou.Fp2(currentpage,startpt:endpt)=0.5;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_Fp2(Arou.j_fp2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'F3'    
   %     Arou.j_f3(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_f3'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.F3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_f3(1,currentpage-1)>0)&&(max(Arou.pos_F3(:,1,currentpage-1))==[downpt1])
                    Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.F3(currentpage+1,1))&&...
                       (Arou.j_f3(1,currentpage+1)>0)&& (min(Arou.pos_F3(1:Arou.j_f3(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage);%如果这条线属下一页不计数
                else
             %       Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
         if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)  %前进了
                Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage)+1;%将下一页的标记数加1
                Arou.F3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1
                Arou.F3(currentpage+1,1:endpt)=0.5;
                %将下一页的开始到endpt设置为1
                Arou.pos_F3(Arou.j_f3(1,currentpage),:,currentpage)=[downpt uppt];%存入f3通道当前页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)  %后退了
                Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage)+1;%将上一页的标记数加1
                Arou.F3(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1
                Arou.F3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_F3(Arou.j_f3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
      %          Arou.pos_F3(Arou.j_f3(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage)+1;%将这一页的标记数加1
                Arou.F3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_F3(Arou.j_F3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage)+1;%将当前页的标记数加1
                Arou.F3(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_F3(Arou.j_f3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
               
                Arou.j_f3(1,currentpage+1) = Arou.j_f3(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.F3(currentpage+1,startpt:endpt)=0.5;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_F3(Arou.j_f3(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_f3(1,currentpage-1) = Arou.j_f3(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.F3(currentpage-1,startpt:endpt)=0.5;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_F3(Arou.j_f3(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_f3(1,currentpage) = Arou.j_f3(1,currentpage)+1;
                Arou.F3(currentpage,startpt:endpt)=0.5;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_F3(Arou.j_f3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'F4'
%        Arou.j_f4(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_f4'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.F4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_f4(1,currentpage-1)>0)&&(max(Arou.pos_F4(:,1,currentpage-1))==[downpt1])
                    Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.F4(currentpage+1,1))&&...
                       (Arou.j_f4(1,currentpage+1)>0)&& (min(Arou.pos_F4(1:Arou.j_f4(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage);%如果这条线属下一页不计数
                else
  %                  Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0 %如果在第一页左边坐标之外
            downpt(1,1)=1/fsample(handles.Dmeg{1});          
        elseif uppt(1,1)>totalpage*handles.winsize %如果在最后一页右边坐标之外
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1}));        
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        
         if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间  %如果这两点不在同一页，也就是我们执行了前进或者后退一秒的操作
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)  %前进了
                Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage)+1;%将下一页的标记数加1
                Arou.F4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1
                Arou.F4(currentpage+1,1:endpt)=0.5;
                %将下一页的开始到endpt设置为1
                Arou.pos_F4(Arou.j_f4(1,currentpage),:,currentpage)=[downpt uppt];%存入F4通道当前页标记线段的坐标信息
 %               Arou.pos_F4(Arou.j_f4(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入F4通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)  %后退了
                Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage)+1;%将上一页的标记数加1
                Arou.F4(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1
                Arou.F4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_F4(Arou.j_f4(1,currentpage),:,currentpage)=[downpt uppt];%pt(2) 存入F4通道当前页标记线段的坐标信息
  %              Arou.pos_F4(Arou.j_f4(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入F4通道上一页标记线段的坐标信息
           elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage)+1;%将这一页的标记数加1
                Arou.F4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_F4(Arou.j_f4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage)+1;%将当前页的标记数加1
                Arou.F4(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_F4(Arou.j_f4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
                
                Arou.j_f4(1,currentpage+1) = Arou.j_f4(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.F4(currentpage+1,startpt:endpt)=0.5;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_F4(Arou.j_f4(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_f4(1,currentpage-1) = Arou.j_f4(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.F4(currentpage-1,startpt:endpt)=0.5;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_F4(Arou.j_f4(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_f4(1,currentpage) = Arou.j_f4(1,currentpage)+1;
                Arou.F4(currentpage,startpt:endpt)=0.5;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_F4(Arou.j_f4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'C3'
 %       Arou.j_c3(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_c3'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.C3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_c3(1,currentpage-1)>0)&&(max(Arou.pos_C3(:,1,currentpage-1))==[downpt1])
                    Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.C3(currentpage+1,1))&&...
                       (Arou.j_c3(1,currentpage+1)>0)&& (min(Arou.pos_C3(1:Arou.j_c3(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage);%如果这条线属下一页不计数
                else
    %                Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
         if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)<=ctshow+handles.winsize/2)&&(uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)  %前进了
                Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage)+1;%将标记数加1
                Arou.C3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1
                Arou.C3(currentpage+1,1:endpt)=0.5;
                %将下一页的开始到endpt设置为1
                Arou.pos_C3(Arou.j_c3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
   %             Arou.pos_C3(Arou.j_c3(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)>=ctshow-handles.winsize/2)&&(uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)  %后退了
                Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage)+1;%将标记数加1
                Arou.C3(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1
                Arou.C3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_C3(Arou.j_c3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage)+1;%将这一页的标记数加1
                Arou.C3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_C3(Arou.j_c3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage)+1;%将当前页的标记数加1
                Arou.C3(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_C3(Arou.j_c3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页               
                Arou.j_c3(1,currentpage+1) = Arou.j_c3(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.C3(currentpage+1,startpt:endpt)=0.5;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_C3(Arou.j_c3(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_c3(1,currentpage-1) = Arou.j_c3(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.C3(currentpage-1,startpt:endpt)=0.5;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_C3(Arou.j_c3(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_c3(1,currentpage) = Arou.j_c3(1,currentpage)+1;
                Arou.C3(currentpage,startpt:endpt)=0.5;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_C3(Arou.j_c3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'C4'
  %      Arou.j_c4(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_c4'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.C4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_c4(1,currentpage-1)>0)&&(max(Arou.pos_C4(:,1,currentpage-1))==[downpt1])
                    Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.C4(currentpage+1,1))&&...
                       (Arou.j_c4(1,currentpage+1)>0)&& (min(Arou.pos_C4(1:Arou.j_c4(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage);%如果这条线属下一页不计数
                else
    %                Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)  %前进了
                Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage)+1;%将下一页的标记数加1
                Arou.C4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1
                Arou.C4(currentpage+1,1:endpt)=0.5;
                %将下一页的开始到endpt设置为1
                Arou.pos_C4(Arou.j_c4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
 %               Arou.pos_C4(Arou.j_c4(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)   %后退了
                Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage)+1;%将上一页的标记数加1
                Arou.C4(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1
                Arou.C4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_C4(Arou.j_c4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
 %               Arou.pos_C4(Arou.j_c4(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage)+1;%将这一页的标记数加1
                Arou.C4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_C4(Arou.j_c4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage)+1;%将当前页的标记数加1
                Arou.C4(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_C4(Arou.j_c4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
         else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
                
                Arou.j_c4(1,currentpage+1) = Arou.j_c4(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.C4(currentpage+1,startpt:endpt)=0.5;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_C4(Arou.j_c4(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_c4(1,currentpage-1) = Arou.j_c4(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.C4(currentpage-1,startpt:endpt)=0.5;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_C4(Arou.j_c4(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_c4(1,currentpage) = Arou.j_c4(1,currentpage)+1;
                Arou.C4(currentpage,startpt:endpt)=0.5;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_C4(Arou.j_c4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'P3'
 %       Arou.j_p3(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_p3'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.P3(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_p3(1,currentpage-1)>0)&&(max(Arou.pos_P3(:,1,currentpage-1))==[downpt1])
                    Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.P3(currentpage+1,1))&&...
                       (Arou.j_p3(1,currentpage+1)>0)&& (min(Arou.pos_P3(1:Arou.j_p3(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage);%如果这条线属下一页不计数
                else
   %                 Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)   %前进了
                Arou.j_p3(1,purrentpage) = Arou.j_p3(1,currentpage)+1;%将下一页的标记数加1
                Arou.P3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1
                Arou.P3(currentpage+1,1:endpt)=0.5;
                %将下一页的开始到endpt设置为1
                Arou.pos_P3(Arou.j_p3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_P3(Arou.j_p3(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)  %后退了
                Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage)+1;%将上一页的标记数加1
                Arou.P3(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1
                Arou.P3(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_P3(Arou.j_p3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_P3(Arou.j_p3(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage)+1;%将这一页的标记数加1
                Arou.P3(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_P3(Arou.j_p3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage)+1;%将当前页的标记数加1
                Arou.P3(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_P3(Arou.j_p3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
         else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页                
                Arou.j_p3(1,currentpage+1) = Arou.j_p3(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.P3(currentpage+1,startpt:endpt)=0.5;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_P3(Arou.j_p3(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_p3(1,currentpage-1) = Arou.j_p3(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.P3(currentpage-1,startpt:endpt)=0.5;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_P3(Arou.j_p3(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_p3(1,currentpage) = Arou.j_p3(1,currentpage)+1;
                Arou.P3(currentpage,startpt:endpt)=0.5;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_P3(Arou.j_p3(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'P4'
 %       Arou.j_p4(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_p4'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.P4(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_p4(1,currentpage-1)>0)&&(max(Arou.pos_P4(:,1,currentpage-1))==[downpt1])
                    Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.P4(currentpage+1,1))&&...
                       (Arou.j_p4(1,currentpage+1)>0)&& (min(Arou.pos_P4(1:Arou.j_p4(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage);%如果这条线属下一页不计数    
                else
 %                   Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间  %如果这两点不在同一页，也就是我们执行了前进或者后退一秒的操作
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)   %前进了
                Arou.j_p4(1,purrentpage) = Arou.j_p4(1,currentpage)+1;%将下一页的标记数加1
                Arou.P4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1
                Arou.P4(currentpage+1,1:endpt)=0.5;
                %将下一页的开始到endpt设置为1
                Arou.pos_P4(Arou.j_p4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_P4(Arou.j_p4(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)  %后退了
                Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage)+1;%将上一页的标记数加1
                Arou.P4(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1
                Arou.P4(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_P4(Arou.j_p4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_P4(Arou.j_p4(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage)+1;%将这一页的标记数加1
                Arou.P4(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_P4(Arou.j_p4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage)+1;%将当前页的标记数加1
                Arou.P4(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_P4(Arou.j_p4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页                
                Arou.j_p4(1,currentpage+1) = Arou.j_p3(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.P4(currentpage+1,startpt:endpt)=0.5;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_P4(Arou.j_p4(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_p4(1,currentpage-1) = Arou.j_p4(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.P4(currentpage-1,startpt:endpt)=0.5;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_P4(Arou.j_p4(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_p4(1,currentpage) = Arou.j_p4(1,currentpage)+1;
                Arou.P4(currentpage,startpt:endpt)=0.5;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_P4(Arou.j_p4(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'O1'
 %       Arou.j_o1(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_o1'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.O1(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_o1(1,currentpage-1)>0)&&(max(Arou.pos_O1(:,1,currentpage-1))==[downpt1])
                    Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.O1(currentpage+1,1))&&...
                       (Arou.j_o1(1,currentpage+1)>0)&& (min(Arou.pos_O1(1:Arou.j_o1(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage);%如果这条线属下一页不计数
                else
   %                 Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)  %前进了
                Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage)+1;%将下一页的标记数加1
                Arou.O1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1
                Arou.O1(currentpage+1,1:endpt)=0.5;
                %将下一页的开始到endpt设置为1
                Arou.pos_O1(Arou.j_o1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_O1(Arou.j_o1(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)  %后退了
                Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage)+1;%将上一页的标记数加1
                Arou.O1(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1
                Arou.O1(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_O1(Arou.j_o1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_O1(Arou.j_o1(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage)+1;%将这一页的标记数加1
                Arou.O1(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_O1(Arou.j_o1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage)+1;%将当前页的标记数加1
                Arou.O1(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_O1(Arou.j_o1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
         else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
                
                Arou.j_o1(1,currentpage+1) = Arou.j_o1(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.O1(currentpage+1,startpt:endpt)=0.5;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_O1(Arou.j_o1(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_o1(1,currentpage-1) = Arou.j_o1(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.O1(currentpage-1,startpt:endpt)=0.5;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_O1(Arou.j_o1(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_o1(1,currentpage) = Arou.j_o1(1,currentpage)+1;
                Arou.O1(currentpage,startpt:endpt)=0.5;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_O1(Arou.j_o1(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
    case 'O2'   
 %       Arou.j_o2(1,currentpage)=0;
        for i = 1:n
            if (strcmp(get(a(i),'DisplayName'),'plot_o2'))
                 x1 = get(a(i),'Xdata');
                 downpt1=x1(1);
                if (currentpage>1)&&any(Arou.O2(currentpage-1,handles.winsize*fsample(handles.Dmeg{1})))&&...
                        (Arou.j_o2(1,currentpage-1)>0)&&(max(Arou.pos_O2(:,1,currentpage-1))==[downpt1])
                    Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage);%如果这条线属于上一页不计数
                elseif (currentpage<totalpage)&&any(Arou.O2(currentpage+1,1))&&...
                       (Arou.j_o2(1,currentpage+1)>0)&& (min(Arou.pos_O2(1:Arou.j_o2(currentpage+1),1,currentpage+1))==[downpt1])
                   Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage);%如果这条线属下一页不计数
                else
    %                Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage)+1;
                end
            end
        end
        if downpt(1,1)<0
            downpt(1,1)=1/fsample(handles.Dmeg{1});
        elseif uppt(1,1)>totalpage*handles.winsize
            uppt(1,1)=(totalpage*handles.winsize-1/fsample(handles.Dmeg{1})); 
        end
        down_x  =  mod(downpt(1,1),10);%%按下鼠标时，所在位置对应的时间
        down_y  =   downpt(1,2);%%按下鼠标时，鼠标所在位置对应的纵坐标值
        up_x = mod(uppt(1,1),10);%%松开鼠标时，所在位置对应的时间
        up_y = uppt(1,2);%%松开鼠标时，所在位置对应的纵坐标值时间
        startpt = round(down_x*fsample(handles.Dmeg{1}));%纺锤波开始时对应的数据点
        endpt = round(up_x*fsample(handles.Dmeg{1}));%纺锤波结束时鼠标对应的数据点
        if ((uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize))||...
                ((uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)) %如果这两点在两页之间
            if (uppt(1,1)>currentpage*handles.winsize)&&(downpt(1,1)<currentpage*handles.winsize)&&(uppt(1,1)<=ctshow+handles.winsize/2)   %前进了
                Arou.j_o2(1,purrentpage) = Arou.j_o2(1,currentpage)+1;%将下一页的标记数加1
                Arou.O2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1
                Arou.O2(currentpage+1,1:endpt)=0.5;
                %将下一页的开始到endpt设置为1
                Arou.pos_O2(Arou.j_o2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
%                Arou.pos_O2(Arou.j_o2(1,currentpage+1),:,currentpage+1)=[next_x uppt(2) uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (uppt(1,1)>(currentpage-1)*handles.winsize)&&(downpt(1,1)<(currentpage-1)*handles.winsize)&&(downpt(1,1)>=ctshow-handles.winsize/2)   %后退了
                Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage)+1;%将上一页的标记数加1
                Arou.O2(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1
                Arou.O2(currentpage-1,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将上一页的startpt到上一页的末尾设置为1
                Arou.pos_O2(Arou.j_o2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
 %               Arou.pos_O2(Arou.j_o2(1,currentpage-1),:,currentpage-1)=[downpt pre_x downpt(2)];%存入Fp1通道上一页标记线段的坐标信息
            elseif (uppt(1,1)>ctshow+handles.winsize/2)%没有前进，右边超出
                uppt(1,1)=ctshow+handles.winsize/2;
                Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage)+1;%将这一页的标记数加1
                Arou.O2(currentpage,startpt:(fsample(handles.Dmeg{1})*handles.winsize))=0.5;
                %将从startpt开始一直到此页最后标记为1               
                Arou.pos_O2(Arou.j_o2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            elseif (downpt(1,1)<ctshow-handles.winsize/2)
                downpt(1,1)=ctshow-handles.winsize/2+1/fsample(handles.Dmeg{1});
                Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage)+1;%将当前页的标记数加1
                Arou.O2(currentpage,1:endpt)=0.5;
                %将从当前页开始一直到endpt标记为1               
                Arou.pos_O2(Arou.j_o2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        else %如果这条线段不在两页之间
            if (downpt(1,1)>=currentpage*handles.winsize)&&(uppt(1,1)>=currentpage*handles.winsize)%当前线段属于下一页
                
                Arou.j_o2(1,currentpage+1) = Arou.j_o2(1,currentpage+1)+1;%将当前线段计数到下一页
                Arou.O2(currentpage+1,startpt:endpt)=0.5;%将FP1通道下一页线段部分对应的数据赋值为1
                Arou.pos_O2(Arou.j_o2(1,currentpage+1),:,currentpage+1)=[downpt uppt];%存入Fp1通道下一页标记线段的坐标信息
            elseif (downpt(1,1)<(currentpage-1)*handles.winsize)&&(uppt(1,1)<(currentpage-1)*handles.winsize)%当前线段属于上一页
                Arou.j_o2(1,currentpage-1) = Arou.j_o2(1,currentpage-1)+1;%将当前线段计数到上一页
                Arou.O2(currentpage-1,startpt:endpt)=0.5;%将FP1通道上一页线段部分对应的数据赋值为1
                Arou.pos_O2(Arou.j_o2(1,currentpage-1),:,currentpage-1)=[downpt uppt];%存入Fp1通道上一页标记线段的坐标信息
            else
                Arou.j_o2(1,currentpage) = Arou.j_o2(1,currentpage)+1;
                Arou.O2(currentpage,startpt:endpt)=0.5;%将FP1通道当前页线段部分对应的数据赋值为1
                Arou.pos_O2(Arou.j_o2(1,currentpage),:,currentpage)=[downpt uppt];%存入Fp1通道当前页标记线段的坐标信息
            end
        end
end

prefix='aro';%设置文件的前缀为aro
% subname=SelChan;
datFile=strcat(prefix,'_',dataname(1:end-4));
subname=datFile;%设置文件名为aro+数据名
% filefull=strcat(datFile,'.mat');
% filename='Arousal';
save('Arousal_data','Arou');%将数据保存到默认目录下
datfile=strcat(subname,'.mat');
save(datfile,'Arou');%将arou结构体保存为“aro+数据名”的mat文件，这一步也很慢
set(gcf,'KeyPressFcn',@keypress);
set(handles.slider1,'Enable','on');
set(handles.Fsec,'Enable','on');
set(handles.Bsec,'Enable','on');
set(handles.togglebutton,'Enable','on');
set(handles.togglebutton,'value',0);
set(handles.togglebutton,'string','Spindle Marker');

function deleteLine(hObject, eventdata, handles)
handles = guidata(hObject);
a = get(gca,'Children');
n = length(a);
X = [];
delete(a(1));%删除线
load('sure_or_not.mat');
sure_or_not(3) = 1;
save('sure_or_not','sure_or_not');
handles = guihandles(gcf);
handels_children = get(handles.figure1,'Children');
delete(handels_children(1));
delete(handels_children(2));
delete(handels_children(3));
set(gcf,'KeyPressFcn',@keypress);
set(handles.slider1,'Enable','on');
set(handles.Fsec,'Enable','on');
set(handles.Bsec,'Enable','on');
set(handles.togglebutton,'Enable','on');
set(handles.togglebutton,'value',0);
set(handles.togglebutton,'string','Spindle Marker');





function  buttondown_change(hObject, eventdata, handles)
handles = guidata(hObject);
b = get(gca,'CurrentPoint');
x = b(1,1);
y = b(1,2);
a = get(gca,'Children');%%所有的子对象，即所有线条数目
n = length(a);%%子对象个数即所有线条数目
h_gcf = guihandles(gcf);
h_children = get(h_gcf.figure1,'Children');
j = 0;
load('Arousal_data.mat');
for i = 1:n  %%%i代表的是第几个子对象
    if (strcmp(get(a(i),'DisplayName'),'plot_fp1'))
       x1 = get(a(i),'Xdata');
       y1 = get(a(i),'Ydata');      
       if x>= (min(x1)-1) && x<=(max(x1)+1) && y>= (min(y1)-5) && y<=(max(y1)+5)%判断是否在线附近
          set(a(i),'Color',[0.5 0 1]);%鼠标点击的位置在线附近，线变紫色，代表线选中，可以对线进行操作
          save('index_line','i');
          if strcmp(get(h_children(1),'Tag'),'3')%若有sure，nosure和delete按钮存在
              set(a(i),'Color','r');      
          else
              set(gcf,'KeyPressFcn',@keypress2);%摁D键可删除线,R键恢复线
          end
        end
    end
    if (strcmp(get(a(i),'DisplayName'),'plot_fp2'))
       x1 = get(a(i),'Xdata');
       y1 = get(a(i),'Ydata');
       if x>= (min(x1)-1) && x<=(max(x1)+1) && y>= (min(y1)-5) && y<=(max(y1)+5)%判断是否在线附近
          set(a(i),'Color',[0.5 0 1]);%鼠标点击的位置在线附近，线变紫色，代表线选中，可以对线进行操作
          save('index_line','i');
          if strcmp(get(h_children(1),'Tag'),'3')%若有sure，nosure和delete按钮存在
              set(a(i),'Color','r');      
          else
              set(gcf,'KeyPressFcn',@keypress2);%摁D键可删除线,R键恢复线
          end
        end
    end    
    if (strcmp(get(a(i),'DisplayName'),'plot_f3'))
       x1 = get(a(i),'Xdata');
       y1 = get(a(i),'Ydata');
       if x>= (min(x1)-1) && x<=(max(x1)+1) && y>= (min(y1)-5) && y<=(max(y1)+5)%判断是否在线附近
          set(a(i),'Color',[0.5 0 1]);%鼠标点击的位置在线附近，线变紫色，代表线选中，可以对线进行操作
          save('index_line','i');
          if strcmp(get(h_children(1),'Tag'),'3')%若有sure，nosure和delete按钮存在
              set(a(i),'Color','r');      
          else
              set(gcf,'KeyPressFcn',@keypress2);%摁D键可删除线,R键恢复线
          end
        end
    end
    if (strcmp(get(a(i),'DisplayName'),'plot_f4'))
       x1 = get(a(i),'Xdata');
       y1 = get(a(i),'Ydata');
       if x>= (min(x1)-1) && x<=(max(x1)+1) && y>= (min(y1)-5) && y<=(max(y1)+5)%判断是否在线附近
          set(a(i),'Color',[0.5 0 1]);%鼠标点击的位置在线附近，线变紫色，代表线选中，可以对线进行操作
          save('index_line','i');
          if strcmp(get(h_children(1),'Tag'),'3')%若有sure，nosure和delete按钮存在
              set(a(i),'Color','r');      
          else
              set(gcf,'KeyPressFcn',@keypress2);%摁D键可删除线,R键恢复线
          end
        end
    end    
     if (strcmp(get(a(i),'DisplayName'),'plot_c3'))
       x1 = get(a(i),'Xdata');
       y1 = get(a(i),'Ydata');
       if x>= (min(x1)-1) && x<=(max(x1)+1) && y>= (min(y1)-5) && y<=(max(y1)+5)%判断是否在线附近
          set(a(i),'Color',[0.5 0 1]);%鼠标点击的位置在线附近，线变紫色，代表线选中，可以对线进行操作
          save('index_line','i');
          if strcmp(get(h_children(1),'Tag'),'3')%若有sure，nosure和delete按钮存在
              set(a(i),'Color','r');      
          else
              set(gcf,'KeyPressFcn',@keypress2);%摁D键可删除线,R键恢复线
          end
        end
    end   
    if (strcmp(get(a(i),'DisplayName'),'plot_c4'))
       x1 = get(a(i),'Xdata');
       y1 = get(a(i),'Ydata');
       if x>= (min(x1)-1) && x<=(max(x1)+1) && y>= (min(y1)-5) && y<=(max(y1)+5)%判断是否在线附近
          set(a(i),'Color',[0.5 0 1]);%鼠标点击的位置在线附近，线变紫色，代表线选中，可以对线进行操作
          save('index_line','i');
          if strcmp(get(h_children(1),'Tag'),'3')%若有sure，nosure和delete按钮存在
              set(a(i),'Color','r');      
          else
              set(gcf,'KeyPressFcn',@keypress2);%摁D键可删除线,R键恢复线
          end
        end
    end    
     if (strcmp(get(a(i),'DisplayName'),'plot_p3'))
       x1 = get(a(i),'Xdata');
       y1 = get(a(i),'Ydata');
       if x>= (min(x1)-1) && x<=(max(x1)+1) && y>= (min(y1)-5) && y<=(max(y1)+5)%判断是否在线附近
          set(a(i),'Color',[0.5 0 1]);%鼠标点击的位置在线附近，线变紫色，代表线选中，可以对线进行操作
          save('index_line','i');
          if strcmp(get(h_children(1),'Tag'),'3')%若有sure，nosure和delete按钮存在
              set(a(i),'Color','r');      
          else
              set(gcf,'KeyPressFcn',@keypress2);%摁D键可删除线,R键恢复线
          end
        end
    end   
     if (strcmp(get(a(i),'DisplayName'),'plot_p4'))
       x1 = get(a(i),'Xdata');
       y1 = get(a(i),'Ydata');
       if x>= (min(x1)-1) && x<=(max(x1)+1) && y>= (min(y1)-5) && y<=(max(y1)+5)%判断是否在线附近
          set(a(i),'Color',[0.5 0 1]);%鼠标点击的位置在线附近，线变紫色，代表线选中，可以对线进行操作
          save('index_line','i');
          if strcmp(get(h_children(1),'Tag'),'3')%若有sure，nosure和delete按钮存在
              set(a(i),'Color','r');      
          else
              set(gcf,'KeyPressFcn',@keypress2);%摁D键可删除线,R键恢复线
          end
        end
    end   
    if (strcmp(get(a(i),'DisplayName'),'plot_o1'))
       x1 = get(a(i),'Xdata');
       y1 = get(a(i),'Ydata');
       if x>= (min(x1)-1) && x<=(max(x1)+1) && y>= (min(y1)-5) && y<=(max(y1)+5)%判断是否在线附近
          set(a(i),'Color',[0.5 0 1]);%鼠标点击的位置在线附近，线变紫色，代表线选中，可以对线进行操作
          save('index_line','i');
          if strcmp(get(h_children(1),'Tag'),'3')%若有sure，nosure和delete按钮存在
              set(a(i),'Color','r');      
          else
              set(gcf,'KeyPressFcn',@keypress2);%摁D键可删除线,R键恢复线
          end
        end
    end
    if (strcmp(get(a(i),'DisplayName'),'plot_o2'))
       x1 = get(a(i),'Xdata');
       y1 = get(a(i),'Ydata');
       if x>= (min(x1)-1) && x<=(max(x1)+1) && y>= (min(y1)-5) && y<=(max(y1)+5)%判断是否在线附近
          set(a(i),'Color',[0.5 0 1]);%鼠标点击的位置在线附近，线变紫色，代表线选中，可以对线进行操作
          save('index_line','i');
          if strcmp(get(h_children(1),'Tag'),'3')%若有sure，nosure和delete按钮存在
              set(a(i),'Color','r');      
          else
              set(gcf,'KeyPressFcn',@keypress2);%摁D键可删除线,R键恢复线
          end
        end
    end    
end

function keypress2(hObject, eventdata, handles)
handles = guidata(hObject);
INDEX = load('index_line.mat');
load('Datapath.mat');load('Arousal_data.mat');load('currentpoint.mat');
load('Arousalchan_data.mat');
a = get(gca,'Children');
global currentpage
currentpage=str2double(get(handles.currentpage,'string'));%当前的页数
ctshow=str2double(get(handles.currenttime,'String'));
ctture = currentpage*handles.winsize-handles.winsize/2;%计算当前页对应的正确时间
key = get(gcf,'CurrentCharacter');
save('Datapath','datapath','dataname','MarValue','Fvalue','Bvalue')
if (key=='D'||key=='d')
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
elseif (key=='c'||key=='C')
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
elseif (key=='r'||key=='R')
        tag = get(a(INDEX.i),'Tag');
        if strcmp(tag,'1')
            set(a(INDEX.i),'Color',[0 0.6 0]);
        elseif strcmp(tag,'0')
            set(a(INDEX.i),'Color',[1 0.5 0]);
        elseif isempty(tag)
            set(a(INDEX.i),'Color','r');
        end
        delete('index_line.mat');
end
set(gcf,'KeyPressFcn',@keypress);


function keypress3(hObject, eventdata, handles)
    




% --------------------------------------------------------------------
function Score_detail_Callback(hObject, eventdata, handles)
% hObject    handle to Score_detail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------


% --- Executes on button press in Fsec.
function Fsec_Callback(hObject, eventdata, handles)
% hObject    handle to Fsec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
set(handles.Fsec,'value',1);
set(handles.Bsec,'value',0);
load('datapath.mat');
Fvalue = (get(handles.Fsec,'value'));
Bvalue = (get(handles.Bsec,'value'));
save('Datapath','MarValue','datapath','dataname','Fvalue','Bvalue');
crcdef  =   crc_get_defaults('score');
currentwindow   =	floor(str2double(get(handles.currenttime,'String')) ...
                                /handles.winsize)+1;
winsize_select  =   str2double(get(handles.edit1,'String'));
winsize_score   =   handles.Dmeg{1}.CRC.score{3,handles.currentscore};
handles.move = 0;
slidval     =   str2double(get(handles.currenttime,'String'));%%得到当前的时间
slidval     =   (floor(slidval/handles.winsize))*handles.winsize;%%将slidval赋值为下一个时间
slidval     =   max(slidval,1/fsample(handles.Dmeg{1}));

if slidval>=nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})
    slidval     =   currentwindow*handles.winsize;
else
    slidval     =   min(slidval, currentwindow*handles.winsize);
    %         nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2);
    set(handles.slider1,'Value',slidval);
end

set(handles.figure1,'CurrentAxes',handles.axes4);
crc_plothypno(handles.axes4,...
    handles.score{4,handles.currentscore},handles,handles.score{3,handles.currentscore});
hypjustplot=0;
mainplotsec(handles);
set(handles.figure1,'CurrentAxes',handles.axes1);


% --- Executes on button press in Bsec.
function Bsec_Callback(hObject, eventdata, handles)
% hObject    handle to Bsec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
set(handles.Bsec,'value',1);
set(handles.Fsec,'value',0);
load('datapath.mat');
%Fvalue=str2double(get(handles.Fsec,'value'));
%Bvalue=str2double(get(handles.Bsec,'value'));
Fvalue = (get(handles.Fsec,'value'));
Bvalue = (get(handles.Bsec,'value'));
save('datapath','MarValue','datapath','dataname','Fvalue','Bvalue');
crcdef  =   crc_get_defaults('score');
currentwindow   =	floor(str2double(get(handles.currenttime,'String')) ...
                                /handles.winsize)+1;
winsize_select  =   str2double(get(handles.edit1,'String'));
winsize_score   =   handles.Dmeg{1}.CRC.score{3,handles.currentscore};
handles.move = 0;
slidval = str2double(get(handles.currenttime,'String'));
slidval = (floor(slidval/handles.winsize))*handles.winsize;
slidval = max(slidval,1/fsample(handles.Dmeg{1}));
slidval = min(slidval, currentwindow*handles.winsize);
%         nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2);

set(handles.slider1,'Value',slidval);
set(handles.figure1,'CurrentAxes',handles.axes4);
crc_plothypno(handles.axes4,...
    handles.score{4,handles.currentscore},handles,handles.score{3,handles.currentscore});
hypjustplot=0;
mainplotsec(handles)
set(handles.figure1,'CurrentAxes',handles.axes1);



function mainplotsec(handles)
load('data_int'); load('Datapath.mat');
slidval =floor(get(handles.slider1,'Value'));
set(handles.figure1,'CurrentAxes',handles.axes1);
cleargraph(handles.figure1,'axes1');
h=handles.axes1; 
axes(h);
Fvalue=get(handles.Fsec,'value');
Bvalue=get(handles.Bsec,'value');
curtime=str2double(get(handles.currenttime,'string'))+Fvalue-Bvalue;
if (curtime==4)&&(Bvalue==1)
    curtime=5;
else
end
curpage=floor((curtime-1)/handles.winsize+1);%计算对应的页数

if curpage==str2double(get(handles.currentpage,'string'));%当前页数
elseif curpage==0
    curpage=1;
    set(handles.currentpage,'String',num2str(curpage));%设置页数
else
    set(handles.currentpage,'String',num2str(curpage));%设置页数
end

% set(handles.edit1,'String',num2str(handles.winsize));
%set(handles.currentpage,'String',num2str(ceil((slidval+handles.winsize/2)/handles.winsize)));
maxi=1;
for i=1:maxi
    %timing
    timestr=str2double(get(handles.currenttime,'String'));
    tdeb = min(round((timestr-handles.winsize/2)*fsample(handles.Dmeg{i})),nsamples(handles.Dmeg{i})-10)+1;%当前页面起始点
    %channels
    Chanslidval = get(handles.Chanslider,'Value');
    slidpos     = Chanslidval-rem(Chanslidval,1);
    NbreChandisp    = str2double(get(handles.NbreChan,'String'));%选择通道的数目    
    index   = [handles.indnomeeg handles.indexMEEG];
    handles.inddis = index(slidpos : 1 : slidpos + NbreChandisp -1);
    index   =   handles.inddis;
    set(handles.fftchan,'String',chanlabels(handles.Dmeg{1},handles.inddis))
    maxj    =   length(handles.inddis); %number of channels
    if (tdeb<fsample(handles.Dmeg{i}))&&(Bvalue==1)
        temps=tdeb:1:(tdeb+fsample(handles.Dmeg{i})*handles.winsize-1);
    %     set(handles.currenttime,'String',num2str(curtime));
    elseif (tdeb>(nsamples(handles.Dmeg{1})-handles.winsize*fsample(handles.Dmeg{i})))&&(Fvalue==1)
        temps=tdeb:1:(tdeb+fsample(handles.Dmeg{i})*handles.winsize-1);
    else
        temps   =   (tdeb+fsample(handles.Dmeg{i})*Fvalue-fsample(handles.Dmeg{i})*...
        Bvalue):1:(tdeb+ fsample(handles.Dmeg{i})*Fvalue-fsample(handles.Dmeg{i})*Bvalue+...
        handles.winsize*fsample(handles.Dmeg{i})-1);
        set(handles.currenttime,'String',num2str(curtime));
    %需要绘制的数据点对应总数据点的位置，一屏5000个点
    end
    toshow  =   temps;
    temps   =   temps/fsample(handles.Dmeg{i});
    win =  floor((str2double(get(handles.currenttime,'String')) - handles.winsize/2)/handles.winsize + 1);
    for j=1:maxj
        hold on
        [dumb1,dumb2,index2] =intersect(upper(chanlabels(handles.Dmeg{i},index(j))),handles.names);
        %To be checked = old version contained : testcond = chanlabels(handles.Dmeg{i},index(j));

        factscale = handles.scale*j; %cycle on channels if one file    
        filtparam=handles.filter.coeffother;

        % %                 contents = get(handles.EEGpopmenu,'String');
        % %                 selchan=upper(contents{get(handles.EEGpopmenu,'Value')});
        cotents=totalstring;
        selchan=refstring(j);
        chtyp=chantype(handles.Dmeg{i},index(j));          

        contents = get(handles.EEGpopmenu,'String');
        selchan=upper(contents{get(handles.EEGpopmenu,'Value')});
        chtyp=chantype(handles.Dmeg{i},index(j));

        %Plot data   
        dumb1=refstring(maxj-j+1);
        index3=ref(maxj-j+1);
        %                     [dumb1,index3]  =   intersect(upper(chanlabels(handles.Dmeg{i})),selchan);       
        basedata        =   handles.Dmeg{i}(index(j),toshow);
        toplotdat       =   basedata - handles.Dmeg{i}(index3,toshow);
        plt  	=   plot(temps,factscale+toplotdat);

        filterlowhigh(plt,i,handles,filtparam,factscale)
        if plt~=0 && any(index(j)==ecgchannels(handles.Dmeg{i}))
            set(plt,'Color',[1 0.1 0.1])
        end
        if plt~=0 && handles.multcomp
            set(plt,'Color',cmap(i,:))
        end  
        currentIndex=get(handles.Chans,'Value');
        if plt~=0&&currentIndex~=j&&(MarValue==1)
            set(plt,'Color',[0 0 0])
        end
    end
end
       
%display the labels on the y-axis
i=length(index);
ylim([0 handles.scale*(length(index)+1)])
set(handles.axes1,'YTick',[handles.scale/2 :handles.scale/2:i*handles.scale+handles.scale/2]);
ylabels=[num2str(round(handles.scale/2))];
for j = 1 : i
    if handles.multcomp
        ylabels =[ylabels {num2str(j)}];
    else
        if and(get(handles.normalize,'Value'),strcmpi(chantype(handles.Dmeg{1},index(j)),'MEGPLANAR'))
            stringn = char(chanlabels(handles.Dmeg{1},index(j)+2));
            string = [stringn(1:end-1), 'N'];
            ylabels  = [ylabels {string}];
        else 
           ylabels = [ylabels chanlabels(handles.Dmeg{1},index(j))];
        end
    end
    ylabels = [ylabels num2str(round(handles.scale/2))];
end
set(handles.axes1,'YTickLabel',ylabels);
xlim([temps(1) temps(1)+handles.winsize])
xtick = get(handles.axes1,'XTick');
if isfield(handles,'offset')
    xtick = mod(xtick + handles.offset,24*60^2);
end
[time string] = crc_time_converts(xtick);
set(handles.axes1,'XTickLabel',string);
down_x=0;

%%%%plot Arousal marker
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (MarValue==1)
    set(handles.togglebutton,'Enable','on');
    set(handles.togglebutton,'value',0);
    set(handles.togglebutton,'string','Spindle Marker');
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
    set(gcf,'WindowButtonDownFcn',@buttondown_change);
end

function figure1_CloseRequestFcn(hObject,eventdata,handles)
load('Datapath.mat');
current_folder = strcat(datapath,'\');
current_folder_datapath = [current_folder,'Datapath.mat'];
current_folder_dataint=[current_folder,'data_int.mat'];
current_folder_sure_or_not=[current_folder,'sure_or_not.mat'];
delete(current_folder_datapath);
delete(current_folder_dataint);
delete(current_folder_sure_or_not);
delete(hObject);


% --------------------------------------------------------------------

function Sleep_parameters_Callback(hObject, eventdata, handles)
% hObject    handle to N2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
% N1_chunk(handles.axes4,handles.score{4,handles.currentscore},handles,handles.winsize)
% D = struct(Dmeg);
% handles.Dmeg = Dmeg;
if iscell(handles.Dmeg)
    D = handles.Dmeg{1};
else
    D = handles.Dmeg;
end
if nargin < 5 && isfield(handles,'score')
    score = handles.score{1,handles.currentscore};
elseif nargin<5 && ~isfield(handles,'score')
    score = D.CRC.score{1,handles.currentscore};
    handles.score = D.CRC.score;
end
bedtime=(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})); % 计算整个数据持续了多少分钟,床上总时间
Sleeppa.Bedtime=round((bedtime/60)*10)/10;
% Sleeppa.Bedtime=vpa(Sleeppa.Bedtime,2);
datestart=handles.Dmeg{1}.info.hour;     %整个数据的开始时间
Endh=datestart(1) + floor(bedtime/60^2);
if Endh>=24
    Endh=num2str(Endh-24);
else
    Endh=num2str(End);
end
Endm=num2str(datestart(2) + floor((mod(bedtime,60^2))/60));
Ends=num2str(round(datestart(3) + mod(bedtime,60)));
Starth=num2str(datestart(1));%%开始的小时
Startm=num2str(datestart(2));%%开始的分钟
Starts=num2str(round(datestart(3)));%%开始的秒           
Sleeppa.DataStart=strcat(Starth,':',Startm,':',Starts);%整个数据开始的时间
Sleeppa.DataEnd=strcat(Endh,':',Endm,':',Ends);
Sleeppa.Wtime=0.0;
Sleeppa.N1time=0.0;
Sleeppa.N2time=0.0;
Sleeppa.N3time=0.0;
Sleeppa.REMtime=0.0;
%%%%用diff函数找出score中前后状态不同的点，即为两个状态的转换点，再通过if语句的判断，确定
%%%%每一段的起始时间和终止时间,每个阶段的持续时间
if handles.scoring
    for j = 0:5
        numn1=0; numn2=0;numrem=0;
        stchange=diff(score);%%score的两两值之差
        if score(1)==j      
            Begctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
                handles.Dmeg{1}.info.hour(2)*60 + ...
                handles.Dmeg{1}.info.hour(3) ));%%计算阶段某数据的开始时间
                Begh=Begctime(1);%%开始的小时
                Begm=Begctime(2);%%开始的分钟
                Begs=Begctime(3);%%开始的秒           
        end 
        for i=1:length(stchange);
          if stchange(i)==0
              continue
          elseif score(i+1)==j
              %如果这个点的下一个阶段是j，代表这个是某阶段的开始点              
            Begctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + handles.Dmeg{1}.info.hour(2)*60 +handles.Dmeg{1}.info.hour(3) +  i*10));
            %%计算阶段的开始时间
            Begh=Begctime(1);%%开始的小时
            Begm=Begctime(2);%%开始的分钟
            Begs=Begctime(3);%%开始的秒
            ch_sec_rounding =round(handles.Dmeg{1}.info.hour(3)) - handles.Dmeg{1}.info.hour(3);     
            if abs(ch_sec_rounding)<1e-4
            % Rounding off if "seconds" saved differs from rounded "seconds" by
            % less than .1ms.
                handles.Dmeg{1}.info.hour(3) =round(handles.Dmeg{1}.info.hour(3));       
            end
          elseif score(i)==j      %如果当前阶段是j，则这个点是j阶段的结束
            Endctime=round(crc_time_converts(handles.Dmeg{1}.info.hour(1)*60^2 + ...
            handles.Dmeg{1}.info.hour(2)*60 + ...
            handles.Dmeg{1}.info.hour(3) + ...
            i*10));
            Endh=Endctime(1);
            Endm=Endctime(2);
            Ends=Endctime(3);
            if (Endh-Begh<0)
                len=((24+Endh-Begh)*60+(Endm-Begm) + (Ends-Begs)/60);%%计算N2持续的时长，单位是分钟，精确到小数点后面一位
                len=(round(len*10))/10;
            else
                len=((Endh-Begh)*60+(Endm-Begm) + (Ends-Begs)/60);
                len=(round(len*10))/10;
            end                          
            datenumstart=datenum([0 0 0 handles.Dmeg{1}.info.hour]);     %整个数据的开始时间                      
            switch j
                case 0
                      Sleeppa.Wtime=Sleeppa.Wtime +len;%W阶段的总时间计算
                      if score(length(stchange))==0 %如果最后一页是w阶段
                          if Begh>24
                              Begh=Begh-24;
                          else
                          end
                          Sleeppa.Lastweek=strcat(num2str(Begh),':',num2str(Begm),':',num2str(Begs));
                      end %计算最后一次醒来的时间
                case 1
                      Sleeppa.N1time=Sleeppa.N1time+len;%N1阶段的总时间计算
                      numn1=numn1+1;
                      if numn1==1
                          datenumBeg=datenum([0 0 0 Begh Begm Begs]);       %第一个N1部分数据的开始时间
                          datediff=datevec(datenumBeg-datenumstart);      %第一个N1部分的开始时间和整个数据的开始时间差
                          datediff=(round((datediff(4)*60+datediff(5)+datediff(6)/60)*10))/10;
                          Sleeppa.N1delay=datediff;%N1延迟
                          if Begh<24                             
                          else
                              Begh=Begh-24;                        
                          end
                          Sleeppa.FirstN1=strcat(num2str(Begh),':',num2str(Begm),':',num2str(Begs));
                      end
                case 2
                      Sleeppa.N2time=Sleeppa.N2time+len;%N2阶段的总时间计算
                      numn2=numn2+1;
                      if numn2==1
                          datenumBeg=datenum([0 0 0 Begh Begm Begs]);       %第一个N2部分数据的开始时间
                          datediff=datevec(datenumBeg-datenumstart);      %第一个N2部分的开始时间和整个数据的开始时间差
                          datediff=(round((datediff(4)*60+datediff(5)+datediff(6)/60)*10))/10;
                          Sleeppa.N2delay=datediff;%N2延迟                     
                      if Begh<24
                      else
                              Begh=Begh-24;                        
                      end
                      Sleeppa.FirstN2=strcat(num2str(Begh),':',num2str(Begm),':',num2str(Begs));
                      end
                case 3
                      Sleeppa.N3time=Sleeppa.N3time+len;%N3阶段的总时间计算
                case 5
                      Sleeppa.REMtime=Sleeppa.REMtime+len;%REM阶段的总时间计算
                      numrem=numrem+1;
                      if numrem==1
                          datenumBeg=datenum([0 0 0 Begh Begm Begs]);       %第一个REM部分数据的开始时间
                          datediff=datevec(datenumBeg-datenumstart);      %第一个REM部分的开始时间和整个数据的开始时间差
                          datediff=(round((datediff(4)*60+datediff(5)+datediff(6)/60)*10))/10;
                          Sleeppa.REMdelay=datediff;%REM延迟
                      end
                otherwise
                      break;
            end
            if score(length(stchange))==0 %如果最后一页不是阶段
            else
                Sleeppa.Lastweek = Sleeppa.DataEnd;
            end         
            save('Sleep_parameters','Sleeppa');%保存为mat文件         
          end
        end
    end
    Sleeppa.Sleeptime=Sleeppa.N1time+Sleeppa.N2time+Sleeppa.N3time+Sleeppa.REMtime;%计算睡眠总时间
    SleepEfficiency = num2str(round(((Sleeppa.Sleeptime/Sleeppa.Bedtime)*100)*10)/10);  %计算睡眠效率
    N1ratio = num2str(round(((Sleeppa.N1time/Sleeppa.Sleeptime)*100)*10)/10); %N1占比
    N2ratio = num2str(round(((Sleeppa.N2time/Sleeppa.Sleeptime)*100)*10)/10);%N2占比
    N3ratio = num2str(round(((Sleeppa.N3time/Sleeppa.Sleeptime)*100)*10)/10);%N3占比
    REMratio = num2str(round(((Sleeppa.REMtime/Sleeppa.Sleeptime)*100)*10)/10);%REM占比
    Sleeppa.Bedtime=num2str(round((Sleeppa.Bedtime)*10)/10);
    %转换成百分数形式
    Sleeppa.SleepEfficiency=strcat(' ',SleepEfficiency);
    Sleeppa.N1ratio=strcat(' ',N1ratio);
    Sleeppa.N2ratio=strcat(' ',N2ratio);
    Sleeppa.N3ratio=strcat(' ',N3ratio);
    Sleeppa.REMratio=strcat('  ',REMratio); 
    Sleeppa.N1time = num2str(round(Sleeppa.N1time*10)/10);
    Sleeppa.N2time = num2str(round(Sleeppa.N2time*10)/10);
    Sleeppa.N3time = num2str(round(Sleeppa.N3time*10)/10);  
    Sleeppa.REMtime = num2str(round(Sleeppa.REMtime*10)/10); 
    Sleeppa.Wtime = num2str(round(Sleeppa.Wtime*10)/10);
    Sleeppa.Sleeptime = num2str(round(Sleeppa.Sleeptime*10)/10);
    Sleeppa.N1delay = num2str(round(Sleeppa.N1delay*10)/10);
    Sleeppa.N2delay = num2str(round(Sleeppa.N2delay*10)/10);
    Sleeppa.REMdelay = num2str(round(Sleeppa.REMdelay*10)/10);
    save('Sleep_parameters','Sleeppa');%保存为mat文件     
end
edit Sleep_parameters.xls;
A1={'床上总时间（Min）:'};A2={'睡眠总时间（Min）:'};A3={'睡眠效率（%）： '};
A4={'N1阶段延迟（Min）:'};A5={'N2阶段延迟（Min）: '};A6={'REM阶段延迟（Min）:'};
A7={'N1阶段总时间（Min）： '};A8={'N2阶段总时间（Min）： '};A9={'N3阶段总时间（Min）： '};A10={'REM阶段总时间（Min）： '};
A11={'N1占比（%）：'};A12={'N2占比（%）：'};A13={'N3占比（%）：'};A14={'REM占比（%）：'};
A15={'数据开始时间（Min）:'};A16={'数据结束时间（Min）:'};A17={'最后一次醒来的时间（Min）: '};
A18={'N1入睡时刻：'};A19={'N2入睡时刻：'};
AA=[A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 A11 A12 A13 A14 A15 A16 A17 A18 A19]';
B1={Sleeppa.Bedtime};B2={Sleeppa.Sleeptime};B3={Sleeppa.SleepEfficiency};B4={Sleeppa.N1delay};
B5={Sleeppa.N2delay};B6={Sleeppa.REMdelay};B7={Sleeppa.N1time};B8={Sleeppa.N2time};
B9={Sleeppa.N3time};B10={Sleeppa.REMtime};
B11={Sleeppa.N1ratio};B12={Sleeppa.N2ratio};B13={Sleeppa.N3ratio};B14={Sleeppa.REMratio};
B16={Sleeppa.DataEnd};B15={Sleeppa.DataStart}; B17={Sleeppa.Lastweek};
B18={Sleeppa.FirstN1};B19={Sleeppa.FirstN2};
BB=[B1 B2 B3 B4 B5 B6 B7 B8 B9 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19]';
xlswrite('Sleep_parameters.xls',AA,'Sleep_parameters','A1:A19');
xlswrite('Sleep_parameters.xls',BB,'Sleep_parameters','B1:B19');
