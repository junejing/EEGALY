function varargout = Montage_500(varargin)
% MONTAGE_500 MATLAB code for Montage_500.fig
%      MONTAGE_500, by itself, creates a new MONTAGE_500 or raises the existing
%      singleton*.
%
%      H = MONTAGE_500 returns the handle to a new MONTAGE_500 or the handle to
%      the existing singleton*.
%
%      MONTAGE_500('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MONTAGE_500.M with the given input arguments.
%
%      MONTAGE_500('Property','Value',...) creates a new MONTAGE_500 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Montage_500_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Montage_500_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Montage_500

% Last Modified by GUIDE v2.5 02-Sep-2015 15:12:05

% Begin initialization code - DO NOT EDIT
%disp(varargin)显示的是空
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Montage_500_OpeningFcn, ...
                   'gui_OutputFcn',  @Montage_500_OutputFcn, ...
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


% --- Executes just before Montage_500 is made visible.
function Montage_500_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Montage_500 (see VARARGIN)

% Choose default command line output for Montage_500

set(0,'CurrentFigure',handles.figure1);
handles.output = hObject;
load CRC_electrodes.mat;
handles.names     = names;
handles.pos       = pos';
handles.crc_types = crc_types;

if isempty(varargin) || ~isfield(varargin{1},'file')
    % Filter for vhdr, mat and edf files
    try and(isfield(varargin{1},'multcomp'), varargin{1}.multcomp)
        %if the multiple comparison option is checked
        prefile = spm_select(Inf, 'any', 'Select imported EEG file','' ...
            ,pwd,'\.[mMvVeErR][dDhHaA][fFDdTtwW]');
        set(handles.uitable1,'enable','off','visible','off');
        set(handles.uitable2,'enable','off','visible','off');
        set(handles.score_pushbutton,'enable','off','visible','off');
        set(handles.spindle_pushbutton,'enable','off','visible','off');
        set(handles.filter_checkbox,'enable','off','visible','off');
        set(handles.exit_pushbutton,'enable','off','visible','off');
        handles.multcomp=1;
    catch
        prefile = spm_select(1, 'any', 'Select imported EEG file','' ...                 %%%%%%%%%%%显示加载数据界面
                       ,pwd,'\.[mMvVeErR][dDhHaA][fFDdTtwW]');
        handles.multcomp=0;
    end
   for i=1:size(prefile,1)
        D{i} = crc_eeg_load(deblank(prefile(i,:)));
        file = fullfile(D{i}.path,D{i}.fname);
        handles.file{i} = file;
        handles.chan{i} = upper(chanlabels(D{i}));
        if isfield(D{i}, 'info')
            try
                D{i}.info.date;
            catch
                D{i}.info.date = [1 1 1];
            end
            try
                D{i}.info.hour;
            catch
                D{i}.info.hour = [0 0 0];
            end
        else
            D{i}.info = struct('date',[1 1 1],'hour',[0 0 0]);
        end
        handles.Dmeg{i} = D{i};
        handles.Struct(i) = struct(D{i});
        handles.date{i} = zeros(1,2);
        handles.date{i}(1) = datenum([D{i}.info.date D{i}.info.hour]);
        handles.date{i}(2) = handles.date{i}(1) + ...
                        datenum([ 0 0 0 crc_time_converts(nsamples(D{i})/ ...
                                                            fsample(D{i}))] );
        handles.dates(i,:) = handles.date{i}(:);
   end
    datapath=path(D{i});dataname=fname(D{i});
    save('Datapath','datapath','dataname');%%%存储数据的路径和完整名字
else
    handles.file = varargin{1}.file;
    prefile = deblank(handles.file);
    index = varargin{1}.index;
    for i=1:size(varargin{1}.Dmeg,2)
        handles.Dmeg{i} = crc_eeg_load([path(varargin{1}.Dmeg{i}),filesep,fname(varargin{1}.Dmeg{i})]);
        handles.Dmeg{i} = varargin{1}.Dmeg{i};
    end
    if isempty(index)
        index = 1:nchannels(handles.Dmeg{1});
    end
end

%if ~isempty(varargin) && isfield(varargin{1},'delmap')
%    handles.delmap=varargin{1}.delmap;
%end

if (~isempty(varargin) && isfield(varargin{1},'multcomp') && varargin{1}.multcomp) || ...
        isempty(varargin)
    chanset=handles.chan{1};
    for i=1:size(prefile,1)
        chanset=intersect(chanset,handles.chan{i});
    end
  
    handles.chan=chanset;
end
handles.indmeeg = meegchannels(handles.Dmeg{1});
handles.indeeg = [meegchannels(handles.Dmeg{1},'EEG') meegchannels(handles.Dmeg{1},'LFP')];
handles.indmeg = meegchannels(handles.Dmeg{1},'MEG');
%handles.indmegplan = meegchannels(handles.Dmeg{1},'MEGPLANAR');
handles.namother = setdiff(chanlabels(handles.Dmeg{1}), chanlabels(handles.Dmeg{1},handles.indmeeg));
set(handles.Spindle_Marker,'Value',0);
MarValue=get(handles.Spindle_Marker,'Value');
save('Datapath','datapath','dataname','MarValue');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Montage_500 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Montage_500_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in fp1_checkbox.
function fp1_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to fp1_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fp1_checkbox



% --- Executes on button press in fp2_checkbox.
function fp2_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to fp2_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fp2_checkbox


% --- Executes on button press in f3_checkbox.
function f3_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to f3_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of f3_checkbox


% --- Executes on button press in f4_checkbox.
function f4_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to f4_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of f4_checkbox


% --- Executes on button press in c3_checkbox.
function c3_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to c3_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c3_checkbox


% --- Executes on button press in c4_checkbox.
function c4_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to c4_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c4_checkbox


% --- Executes on button press in p3_checkbox.
function p3_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to p3_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p3_checkbox


% --- Executes on button press in p4_checkbox.
function p4_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to p4_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p4_checkbox


% --- Executes on button press in o1_checkbox.
function o1_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to o1_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of o1_checkbox


% --- Executes on button press in o2_checkbox.
function o2_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to o2_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of o2_checkbox


% --- Executes on button press in f7_checkbox.
function f7_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to f7_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of f7_checkbox


% --- Executes on button press in f8_checkbox.
function f8_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to f8_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of f8_checkbox


% --- Executes on button press in t7_checkbox.
function t7_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to t7_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of t7_checkbox


% --- Executes on button press in t8_checkbox.
function t8_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to t8_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of t8_checkbox


% --- Executes on button press in p7_checkbox.
function p7_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to p7_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p7_checkbox


% --- Executes on button press in p8_checkbox.
function p8_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to p8_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p8_checkbox


% --- Executes on selection change in fp1_popupmenu.
function fp1_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to fp1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fp1_popupmenu
% contents as cell array显示的所有的电极
%        contents{get(hObject,'Value')} returns selected item from
%        fp1_popupmenu显示的选择的电极




% --- Executes during object creation, after setting all properties.
function fp1_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fp1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fp2_popupmenu.
function fp2_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to fp2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fp2_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fp2_popupmenu


% --- Executes during object creation, after setting all properties.
function fp2_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fp2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in f3_popupmenu.
function f3_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to f3_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns f3_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from f3_popupmenu


% --- Executes during object creation, after setting all properties.
function f3_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f3_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in f4_popupmenu.
function f4_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to f4_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns f4_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from f4_popupmenu


% --- Executes during object creation, after setting all properties.
function f4_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f4_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in c3_popupmenu.
function c3_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to c3_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns c3_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from c3_popupmenu


% --- Executes during object creation, after setting all properties.
function c3_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c3_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in c4_popupmenu.
function c4_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to c4_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns c4_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from c4_popupmenu


% --- Executes during object creation, after setting all properties.
function c4_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c4_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in p3_popupmenu.
function p3_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to p3_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p3_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p3_popupmenu


% --- Executes during object creation, after setting all properties.
function p3_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p3_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in p4_popupmenu.
function p4_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to p4_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p4_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p4_popupmenu


% --- Executes during object creation, after setting all properties.
function p4_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p4_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in o1_popupmenu.
function o1_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to o1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns o1_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from o1_popupmenu


% --- Executes during object creation, after setting all properties.
function o1_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to o1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in o2_popupmenu.
function o2_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to o2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns o2_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from o2_popupmenu


% --- Executes during object creation, after setting all properties.
function o2_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to o2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in f7_popupmenu.
function f7_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to f7_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns f7_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from f7_popupmenu


% --- Executes during object creation, after setting all properties.
function f7_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f7_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in f8_popupmenu.
function f8_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to f8_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns f8_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from f8_popupmenu


% --- Executes during object creation, after setting all properties.
function f8_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f8_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in t7_popupmenu.
function t7_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to t7_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns t7_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from t7_popupmenu


% --- Executes during object creation, after setting all properties.
function t7_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t7_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in t8_popupmenu.
function t8_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to t8_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns t8_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from t8_popupmenu


% --- Executes during object creation, after setting all properties.
function t8_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t8_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in p7_popupmenu.
function p7_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to p7_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p7_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p7_popupmenu


% --- Executes during object creation, after setting all properties.
function p7_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p7_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in p8_popupmenu.
function p8_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to p8_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p8_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p8_popupmenu


% --- Executes during object creation, after setting all properties.
function p8_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p8_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fz_checkbox.
function fz_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to fz_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fz_checkbox


% --- Executes on button press in cz_checkbox.
function cz_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to cz_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cz_checkbox


% --- Executes on button press in pz_checkbox.
function pz_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to pz_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pz_checkbox


% --- Executes on button press in oz_checkbox.
function oz_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to oz_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of oz_checkbox


% --- Executes on button press in fc1_checkbox.
function fc1_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to fc1_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fc1_checkbox


% --- Executes on button press in fc2_checkbox.
function fc2_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to fc2_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fc2_checkbox


% --- Executes on button press in cp1_checkbox.
function cp1_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to cp1_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cp1_checkbox


% --- Executes on button press in cp2_checkbox.
function cp2_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to cp2_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cp2_checkbox


% --- Executes on button press in fc5_checkbox.
function fc5_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to fc5_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fc5_checkbox


% --- Executes on button press in fc6_checkbox.
function fc6_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to fc6_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fc6_checkbox


% --- Executes on button press in cp5_checkbox.
function cp5_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to cp5_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cp5_checkbox


% --- Executes on button press in cp6_checkbox.
function cp6_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to cp6_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cp6_checkbox


% --- Executes on button press in tp9_checkbox.
function tp9_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to tp9_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tp9_checkbox


% --- Executes on button press in tp10_checkbox.
function tp10_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to tp10_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tp10_checkbox


% --- Executes on button press in poz_checkbox.
function poz_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to poz_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of poz_checkbox


% --- Executes on button press in eog_checkbox.
function eog_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to eog_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of eog_checkbox


% --- Executes on selection change in fz_popupmenu.
function fz_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to fz_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fz_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fz_popupmenu


% --- Executes during object creation, after setting all properties.
function fz_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fz_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cz_popupmenu.
function cz_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to cz_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cz_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cz_popupmenu



% --- Executes during object creation, after setting all properties.
function cz_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cz_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pz_popupmenu.
function pz_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to pz_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pz_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pz_popupmenu


% --- Executes during object creation, after setting all properties.
function pz_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pz_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in oz_popupmenu.
function oz_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to oz_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns oz_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from oz_popupmenu


% --- Executes during object creation, after setting all properties.
function oz_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to oz_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fc1_popupmenu.
function fc1_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to fc1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fc1_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fc1_popupmenu


% --- Executes during object creation, after setting all properties.
function fc1_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fc1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fc2_popupmenu.
function fc2_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to fc2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fc2_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fc2_popupmenu


% --- Executes during object creation, after setting all properties.
function fc2_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fc2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cp1_popupmenu.
function cp1_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to cp1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cp1_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cp1_popupmenu


% --- Executes during object creation, after setting all properties.
function cp1_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cp1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cp2_popupmenu.
function cp2_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to cp2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cp2_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cp2_popupmenu


% --- Executes during object creation, after setting all properties.
function cp2_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cp2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fc5_popupmenu.
function fc5_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to fc5_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fc5_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fc5_popupmenu


% --- Executes during object creation, after setting all properties.
function fc5_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fc5_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fc6_popupmenu.
function fc6_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to fc6_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fc6_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fc6_popupmenu


% --- Executes during object creation, after setting all properties.
function fc6_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fc6_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cp5_popupmenu.
function cp5_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to cp5_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cp5_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cp5_popupmenu


% --- Executes during object creation, after setting all properties.
function cp5_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cp5_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cp6_popupmenu.
function cp6_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to cp6_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cp6_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cp6_popupmenu


% --- Executes during object creation, after setting all properties.
function cp6_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cp6_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tp9_popupmenu.
function tp9_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to tp9_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tp9_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tp9_popupmenu


% --- Executes during object creation, after setting all properties.
function tp9_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tp9_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tp10_popupmenu.
function tp10_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to tp10_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tp10_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tp10_popupmenu


% --- Executes during object creation, after setting all properties.
function tp10_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tp10_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in poz_popupmenu.
function poz_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to poz_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns poz_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from poz_popupmenu


% --- Executes during object creation, after setting all properties.
function poz_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to poz_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in eog_popupmenu.
function eog_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to eog_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns eog_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from eog_popupmenu


% --- Executes during object creation, after setting all properties.
function eog_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eog_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in score_pushbutton.
function score_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to score_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vfp1=get(handles.fp1_checkbox,'value');
vfp2=get(handles.fp2_checkbox,'value');
vf3=get(handles.f3_checkbox,'value');
vf4=get(handles.f4_checkbox,'value');
vc3=get(handles.c3_checkbox,'value');
vc4=get(handles.c4_checkbox,'value');
vp3=get(handles.p3_checkbox,'value');
vp4=get(handles.p4_checkbox,'value');
vo1=get(handles.o1_checkbox,'value');
vo2=get(handles.o2_checkbox,'value');
vf7=get(handles.f7_checkbox,'value');
vf8=get(handles.f8_checkbox,'value');
vt7=get(handles.t7_checkbox,'value');
vt8=get(handles.t8_checkbox,'value');
vp7=get(handles.p7_checkbox,'value');
vp8=get(handles.p8_checkbox,'value');
vfz=get(handles.fz_checkbox,'value');
vcz=get(handles.cz_checkbox,'value');
vpz=get(handles.pz_checkbox,'value');
voz=get(handles.oz_checkbox,'value');
vfc1=get(handles.fc1_checkbox,'value');
vfc2=get(handles.fc2_checkbox,'value');
vcp1=get(handles.cp1_checkbox,'value');
vcp2=get(handles.cp2_checkbox,'value');
vfc5=get(handles.fc5_checkbox,'value');
vfc6=get(handles.fc6_checkbox,'value');
vcp5=get(handles.cp5_checkbox,'value');
vcp6=get(handles.cp6_checkbox,'value');
vtp9=get(handles.tp9_checkbox,'value');
vtp10=get(handles.tp10_checkbox,'value');
vpoz=get(handles.poz_checkbox,'value');
veog=get(handles.eog_checkbox,'value');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

reffp1=get(handles.fp1_popupmenu,'value');
reffp2=get(handles.fp2_popupmenu,'value');
reff3=get(handles.f3_popupmenu,'value');
reff4=get(handles.f4_popupmenu,'value');
refc3=get(handles.c3_popupmenu,'value');
refc4=get(handles.c4_popupmenu,'value');
refp3=get(handles.p3_popupmenu,'value');
refp4=get(handles.p4_popupmenu,'value');
refo1=get(handles.o1_popupmenu,'value');
refo2=get(handles.o2_popupmenu,'value');
reff7=get(handles.f7_popupmenu,'value');
reff8=get(handles.f8_popupmenu,'value');
reft7=get(handles.t7_popupmenu,'value');
reft8=get(handles.t8_popupmenu,'value');
refp7=get(handles.p7_popupmenu,'value');
refp8=get(handles.p8_popupmenu,'value');
reffz=get(handles.fz_popupmenu,'value');
refcz=get(handles.cz_popupmenu,'value');
refpz=get(handles.pz_popupmenu,'value');
refoz=get(handles.oz_popupmenu,'value');
reffc1=get(handles.fc1_popupmenu,'value');
reffc2=get(handles.fc2_popupmenu,'value');
refcp1=get(handles.cp1_popupmenu,'value');
refcp2=get(handles.cp2_popupmenu,'value');
reffc5=get(handles.fc5_popupmenu,'value');
reffc6=get(handles.fc6_popupmenu,'value');
refcp5=get(handles.cp5_popupmenu,'value');
refcp6=get(handles.cp6_popupmenu,'value');
reftp9=get(handles.tp9_popupmenu,'value');
reftp10=get(handles.tp10_popupmenu,'value');
refpoz=get(handles.poz_popupmenu,'value');
refeog=get(handles.eog_popupmenu,'value');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sum=0;
values=[vfp1,vfp2,vf3,vf4,vc3,vc4,vp3,vp4,vo1,vo2,vf7,vf8,vt7,vt8, ...
        vp7,vp8,vfz,vcz,vpz,voz,vfc1,vfc2,vcp1,vcp2,vfc5,vfc6,vcp5,vcp6,vtp9,vtp10,vpoz,veog];
reference=[reffp1,reffp2,reff3,reff4,refc3,refc4,refp3,refp4,refo1,refo2,reff7,reff8,reft7,reft8 ...
     refp7,refp8,reffz,refcz,refpz,refoz,reffc1,reffc2,refcp1,refcp2,reffc5,reffc6,refcp5,refcp6,reftp9,reftp10,refpoz,refeog];
%  totalstring=[fp1,fp2,f3,f4,c3,c4,p3,p4,o1,o2,f7,f8,t7,t8,p7,p8,fz,cz,pz,oz,fc1,fc2,cp1,cp2,fc5,fc6,cp5,cp6,tp9,tp10,poz,eog];
totalstring=get(handles.fp1_popupmenu,'string');
 %%%%%%得到的是电极的名称
location=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32];
%%%%电极对应的电极帽上面的位置
for i=1:length(values)
    sum=sum+values(i);
end%%计算所选电极总数
global base;
global ref;
global refstring;
base=[];  %选择的电极存放在数组a中
num = size(handles.Dmeg,1);
for ii = 1:num
    if sum==0
       beep 
       disp('there is no electrodes selection')
       set(handles.score,'enable','off');
       set(handles.spindle,'enable','off');
       return
    else
         refnum=0;
         for i=1:length(values)
             if values(i)~=0
                refnum=refnum+1;
                                                  %%%%%%%%%设置参考片电极
                                                  %%%%%%%%%直接相减会出现赋值怎么转化
                ref(refnum)=reference(i);        %%%%得到的是参考电极的位置

                base(refnum)=location(i);        %%得到是矩阵，选择电极在电极帽上对应的位置，例如c3则location(i)的值为5
                refstring{refnum}=totalstring{reference(i)};
% %                 C = handles.Dmeg{ii};
% %                %dd = C(a(j),:,:)-C(ref(j),:,:);
% %                electrdata= C(base(refnum),1:5000,1);
% %                referdata= C(ref(refnum),1:5000,1);
% %                toplotdata=electrdata-referdata;
% %                C(base(refnum),1:5000,1) = toplotdata;
% %                handles.Dmeg{ii} = C;
             end
             
         end
    end
end

try
    flags.index=sortch(handles.Dmeg{1},base);
%     handles.Dmeg{1}  %%%%显示的是相应的信息比如说是14个通道，每个通道的样点数等信息
%     a          %%%%%比如说选C5则显示其对应的地址
catch
    flags.index=fliplr(sort(base));
end
flags.Dmeg=handles.Dmeg;
flags.file=handles.file;
flags.scoresleep=1;
flags.electrode=base;
flags.reference=ref;
save('data_int','base','ref','refnum','refstring','totalstring','num');
dis_score_500(flags);
delete(handles.figure1)


% --- Executes on button press in spindle_pushbutton.
function spindle_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to spindle_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vfp1=get(handles.fp1_checkbox,'value');
vfp2=get(handles.fp2_checkbox,'value');
vf3=get(handles.f3_checkbox,'value');
vf4=get(handles.f4_checkbox,'value');
vc3=get(handles.c3_checkbox,'value');
vc4=get(handles.c4_checkbox,'value');
vp3=get(handles.p3_checkbox,'value');
vp4=get(handles.p4_checkbox,'value');
vo1=get(handles.o1_checkbox,'value');
vo2=get(handles.o2_checkbox,'value');
vf7=get(handles.f7_checkbox,'value');
vf8=get(handles.f8_checkbox,'value');
vt7=get(handles.t7_checkbox,'value');
vt8=get(handles.t8_checkbox,'value');
vp7=get(handles.p7_checkbox,'value');
vp8=get(handles.p8_checkbox,'value');
vfz=get(handles.fz_checkbox,'value');
vcz=get(handles.cz_checkbox,'value');
vpz=get(handles.pz_checkbox,'value');
voz=get(handles.oz_checkbox,'value');
vfc1=get(handles.fc1_checkbox,'value');
vfc2=get(handles.fc2_checkbox,'value');
vcp1=get(handles.cp1_checkbox,'value');
vcp2=get(handles.cp2_checkbox,'value');
vfc5=get(handles.fc5_checkbox,'value');
vfc6=get(handles.fc6_checkbox,'value');
vcp5=get(handles.cp5_checkbox,'value');
vcp6=get(handles.cp6_checkbox,'value');
vtp9=get(handles.tp9_checkbox,'value');
vtp10=get(handles.tp10_checkbox,'value');
vpoz=get(handles.poz_checkbox,'value');
veog=get(handles.eog_checkbox,'value');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
reffp1=get(handles.fp1_popupmenu,'value');
reffp2=get(handles.fp2_popupmenu,'value');
reff3=get(handles.f3_popupmenu,'value');
reff4=get(handles.f4_popupmenu,'value');
refc3=get(handles.c3_popupmenu,'value');
refc4=get(handles.c4_popupmenu,'value');
refp3=get(handles.p3_popupmenu,'value');
refp4=get(handles.p4_popupmenu,'value');
refo1=get(handles.o1_popupmenu,'value');
refo2=get(handles.o2_popupmenu,'value');
reff7=get(handles.f7_popupmenu,'value');
reff8=get(handles.f8_popupmenu,'value');
reft7=get(handles.t7_popupmenu,'value');
reft8=get(handles.t8_popupmenu,'value');
refp7=get(handles.p7_popupmenu,'value');
refp8=get(handles.p8_popupmenu,'value');
reffz=get(handles.fz_popupmenu,'value');
refcz=get(handles.cz_popupmenu,'value');
refpz=get(handles.pz_popupmenu,'value');
refoz=get(handles.oz_popupmenu,'value');
reffc1=get(handles.fc1_popupmenu,'value');
reffc2=get(handles.fc2_popupmenu,'value');
refcp1=get(handles.cp1_popupmenu,'value');
refcp2=get(handles.cp2_popupmenu,'value');
reffc5=get(handles.fc5_popupmenu,'value');
reffc6=get(handles.fc6_popupmenu,'value');
refcp5=get(handles.cp5_popupmenu,'value');
refcp6=get(handles.cp6_popupmenu,'value');
reftp9=get(handles.tp9_popupmenu,'value');
reftp10=get(handles.tp10_popupmenu,'value');
refpoz=get(handles.poz_popupmenu,'value');
refeog=get(handles.eog_popupmenu,'value');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sum=0;
values=[vfp1,vfp2,vf3,vf4,vc3,vc4,vp3,vp4,vo1,vo2,vf7,vf8,vt7,vt8, ...
        vp7,vp8,vfz,vcz,vpz,voz,vfc1,vfc2,vcp1,vcp2,vfc5,vfc6,vcp5,vcp6,vtp9,vtp10,vpoz,veog];
reference=[reffp1,reffp2,reff3,reff4,refc3,refc4,refp3,refp4,refo1,refo2,reff7,reff8,reft7,reft8 ...
     refp7,refp8,reffz,refcz,refpz,refoz,reffc1,reffc2,refcp1,refcp2,reffc5,reffc6,refcp5,refcp6,reftp9,reftp10,refpoz,refeog];
 %%%%%%得到的是电极的名称
location=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32];
for i=1:length(values)
    sum=sum+values(i);
end
a=[];  %选择的电极存放在数组a中
num = size(handles.Dmeg,1);
for ii = 1:num
    if sum==0
       beep 
       disp('there is no electrodes selection')
       set(handles.score,'enable','off');
       set(handles.spindle,'enable','off');
       return
    else
         j=0;
         for i=1:length(values)
             if values(i)~=0
                j=j+1;
                                                  %%%%%%%%%设置参考片电极
                                                  %%%%%%%%%直接相减会出现赋值怎么转化
                    ref(j)=reference(i);        %%%%得到的是参考电极的位置

                a(j)=location(i);          %%得到是矩阵，选择电极在电极帽上对应的位置，例如c3则location(i)的值为5
                C = handles.Dmeg{ii};
                toplotdata = C(a(j),:,:)-C(ref(j),:,:);
                C(a(j),:,:) = toplotdata;
                handles.Dmeg{ii} = C;
             end
         end       
    end
end
try
    flags.index=sortch(handles.Dmeg{1},a);
catch
    flags.index=fliplr(sort(a));
end
flags.Dmeg=handles.Dmeg;
flags.file=handles.file;
flags.scoresleep=1;
if get(hObject,'value')==1&get(handles.filter_checkbox,'value')==1
   dis_filtered(flags);
   delete(handles.figure1)
elseif get(hObject,'value')==1&get(handles.filter_checkbox,'value')==0
       dis_unfiltered(flags);
       delete(handles.figure1)
end



% --- Executes on button press in filter_checkbox.
function filter_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to filter_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filter_checkbox


% --- Executes on button press in exit_pushbutton.
function exit_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to exit_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SORT CHANNEL FX
function idx = sortch(d,index)

% Find the EOG channels
EOGchan = eogchannels(d);
EOGchan = intersect(EOGchan,index);

% Find the ECG channels
ECGchan = ecgchannels(d);
ECGchan = intersect(ECGchan,index);

% Find the EMG channels
EMGchan = emgchannels(d);
EMGchan = intersect(EMGchan,index);

% Find the M/EEG channels
EEGchan = meegchannels(d);
EEGchan = intersect(EEGchan,index);

allbad = [EOGchan ECGchan EMGchan EEGchan];
other  = setdiff(index,allbad);

otherknown    = [];
othernotknown = [];
chanstr = chantype(d);
for ff = other
    if ~strcmpi(chanstr,'Other')
        othernotknown = [othernotknown ff];
    else
        otherknown = [otherknown ff];
    end
end
other = [otherknown othernotknown];

allbad = [EOGchan ECGchan EMGchan other];
eeg = setdiff(index,allbad);

AFrontal  = intersect(find(strncmp(chanlabels(d),'AF',2) ==1),eeg);
Frontal   = intersect(find(strncmp(chanlabels(d),'F',1) ==1),eeg);
Coronal   = intersect(find(strncmp(chanlabels(d),'C',1) ==1),eeg);
Temporal  = intersect(find(strncmp(chanlabels(d),'T',1) ==1),eeg);
Parietal  = intersect(find(strncmp(chanlabels(d),'P',1) ==1),eeg);
Occipital = intersect(find(strncmp(chanlabels(d),'O',1) ==1),eeg);

neweeg = [Occipital Parietal Temporal Coronal Frontal AFrontal];
eeg2 = setdiff(eeg,neweeg);

eeg = [eeg2 neweeg];

idx = [otherknown othernotknown ECGchan EMGchan EOGchan eeg];


function cleargraph(handles)

A=get(handles.figure1,'Children');
idx=find(strcmp(get(A,'Type'),'axes')==1);
try
    delete(get(A(idx),'Children'))
end


% --- Executes on button press in Spindle_Marker.
function Spindle_Marker_Callback(hObject, eventdata, handles)
% hObject    handle to Spindle_Marker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Spindle_Marker
load('Datapath.mat');
MarValue=get(handles.Spindle_Marker,'Value');
save('Datapath','datapath','dataname','MarValue');
