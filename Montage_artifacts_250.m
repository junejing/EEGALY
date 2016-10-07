function varargout = Montage_artifacts_250(varargin)
% MONTAGE_ARTIFACTS_250 MATLAB code for Montage_artifacts_250.fig
%      MONTAGE_ARTIFACTS_250, by itself, creates a new MONTAGE_ARTIFACTS_250 or raises the existing
%      singleton*.
%
%      H = MONTAGE_ARTIFACTS_250 returns the handle to a new MONTAGE_ARTIFACTS_250 or the handle to
%      the existing singleton*.
%
%      MONTAGE_ARTIFACTS_250('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MONTAGE_ARTIFACTS_250.M with the given input arguments.
%
%      MONTAGE_ARTIFACTS_250('Property','Value',...) creates a new MONTAGE_ARTIFACTS_250 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Montage_artifacts_250_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Montage_artifacts_250_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Montage_artifacts_250

% Last Modified by GUIDE v2.5 06-Sep-2015 11:13:58

% Begin initialization code - DO NOT EDIT
%disp(varargin)显示的是空
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Montage_artifacts_250_OpeningFcn, ...
                   'gui_OutputFcn',  @Montage_artifacts_250_OutputFcn, ...
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


% --- Executes just before Montage_artifacts_250 is made visible.
function Montage_artifacts_250_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Montage_artifacts_250 (see VARARGIN)

% Choose default command line output for Montage_artifacts_250

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
        set(handles.Artifacts_pushbutton,'enable','off','visible','off');
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
set(handles.artifacts_Marker,'Value',0);
MarValue=get(handles.artifacts_Marker,'Value');
save('Datapath','datapath','dataname','MarValue');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Montage_artifacts_250 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Montage_artifacts_250_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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

% --- Executes on button press in a1_emg_checkbox.
function a1_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to a1_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of a1_checkbox







% --- Executes on selection change in fp1_popupmenu.
function fp1_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to fp1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fp1_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fp1_popupmenu


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

% --- Executes on selection change in a1_popupmenu.
function a1_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to a1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns a1_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from a1_popupmenu


% --- Executes during object creation, after setting all properties.
function a1_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a1_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in a2_checkbox.
function a2_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to a2_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of a2_checkbox

% --- Executes on button press in t3_checkbox.
function t3_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to t3_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of t3_checkbox


% --- Executes on button press in t4_checkbox.
function t4_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to t4_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of t4_checkbox

% --- Executes on button press in t5_checkbox.
function t5_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to t5_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of t5_checkbox


% --- Executes on button press in t6_checkbox.
function t6_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to t6_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of t6_checkbox

% --- Executes on button press in chin_emg_checkbox.
function chin_emg_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to chin_emg_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chin_emg_checkbox


% --- Executes on button press in l_eog_checkbox.
function l_eog_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to l_eog_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of l_eog_checkbox



% --- Executes on button press in r_eog_checkbox.
function r_eog_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to r_eog_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r_eog_checkbox



% --- Executes on button press in ekg_checkbox.
function ekg_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to ekg_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ekg_checkbox

% --- Executes on button press in l_leg_checkbox.
function l_leg_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to l_leg_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of l_leg_checkbox


% --- Executes on button press in r_leg_checkbox.
function r_leg_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to r_leg_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of r_leg_checkbox

% --- Executes on button press in snore_checkbox.
function snore_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to snore_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of snore_checkbox


% --- Executes on button press in spo2_checkbox.
function spo2_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to spo2_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of spo2_checkbox


% --- Executes on button press in bpm_checkbox.
function bpm_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to bpm_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bpm_checkbox


% --- Executes on button press in position_checkbox.
function position_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to position_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of position_checkbox


% --- Executes on button press in eog_checkbox.
%%function eog_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to eog_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of eog_checkbox



% --- Executes on selection change in a2_popupmenu.
function a2_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to a2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns a2_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from a2_popupmenu


% --- Executes during object creation, after setting all properties.
function a2_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in t3_popupmenu.
function t3_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to t3_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns t3_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from t3_popupmenu


% --- Executes during object creation, after setting all properties.
function t3_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t3_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in t4_popupmenu.
function t4_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to t4_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns t4_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from t4_popupmenu


% --- Executes during object creation, after setting all properties.
function t4_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t4_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in t5_popupmenu.
function t5_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to t5_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns t5_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from t5_popupmenu


% --- Executes during object creation, after setting all properties.
function t5_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t5_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in t6_popupmenu.
function t6_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to t6_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns t6_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from t6_popupmenu



% --- Executes during object creation, after setting all properties.
function t6_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t6_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in chin_emg_popupmenu.
function chin_emg_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to chin_emg_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chin_emg_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chin_emg_popupmenu


% --- Executes during object creation, after setting all properties.
function chin_emg_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chin_emg_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in l_eog_popupmenu.
function l_eog_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to l_eog_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns l_eog_popupmenu
% contents as cell array%%显示的所有的电极
%        contents{get(hObject,'Value')} returns selected item from
%       chin_emg_popupmenu%%显示的选择的电极




% --- Executes during object creation, after setting all properties.
function l_eog_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to l_eog_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in r_eog_popupmenu.
function r_eog_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to r_eog_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns r_eog_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from r_eog_popupmenu


% --- Executes during object creation, after setting all properties.
function r_eog_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r_eog_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ekg_popupmenu.
function ekg_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to ekg_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ekg_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ekg_popupmenu


% --- Executes during object creation, after setting all properties.
function ekg_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ekg_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in l_leg_popupmenu.
function l_leg_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to l_leg_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns l_leg_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from l_leg_popupmenu


% --- Executes during object creation, after setting all properties.
function l_leg_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to l_leg_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in r_leg_popupmenu.
function r_leg_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to r_leg_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns r_leg_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from r_leg_popupmenu


% --- Executes during object creation, after setting all properties.
function r_leg_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r_leg_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in snore_popupmenu.
function snore_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to snore_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns snore_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from snore_popupmenu


% --- Executes during object creation, after setting all properties.
function snore_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to snore_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in spo2_popupmenu.
function spo2_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to spo2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns spo2_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from spo2_popupmenu


% --- Executes during object creation, after setting all properties.
function spo2_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spo2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in bpm_popupmenu.
function bpm_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to bpm_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bpm_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bpm_popupmenu


% --- Executes during object creation, after setting all properties.
function bpm_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bpm_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in position_popupmenu.+
function position_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to position_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns position_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from position_popupmenu


% --- Executes during object creation, after setting all properties.
function position_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to position_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in a1_a2_popupmenu.
function a1_a2_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to a1_a2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns a1_a2_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from a1_a2_popupmenu


% --- Executes during object creation, after setting all properties.
function a1_a2_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a1_a2_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in none_popupmenu.
function none_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to none_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns none_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from none_popupmenu


% --- Executes during object creation, after setting all properties.
function none_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to none_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in eog_popupmenu.
%%function eog_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to eog_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns eog_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from eog_popupmenu


% --- Executes during object creation, after setting all properties.
%%function eog_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eog_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  %%  set(hObject,'BackgroundColor','white');
%%end


% --- Executes on button press in Artifacts_pushbutton.
function Artifacts_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Artifacts_pushbutton (see GCBO)
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
vfz=get(handles.fz_checkbox,'value');
vcz=get(handles.cz_checkbox,'value');
vpz=get(handles.pz_checkbox,'value');
va1=get(handles.a1_checkbox,'value');
va2=get(handles.a2_checkbox,'value');
vt3=get(handles.t3_checkbox,'value');
vt4=get(handles.t4_checkbox,'value');
vt5=get(handles.t5_checkbox,'value');
vt6=get(handles.t6_checkbox,'value');
vchin_emg=get(handles.chin_emg_checkbox,'value');
vl_eog=get(handles.l_eog_checkbox,'value');
vr_eog=get(handles.r_eog_checkbox,'value');
vekg=get(handles.ekg_checkbox,'value');
vl_leg=get(handles.l_leg_checkbox,'value');
vr_leg=get(handles.r_leg_checkbox,'value');
vsnore=get(handles.snore_checkbox,'value');
vspo2=get(handles.spo2_checkbox,'value');
vbpm=get(handles.bpm_checkbox,'value');
vposition=get(handles.position_checkbox,'value');
%%veog=get(handles.eog_checkbox,'value');
%va1_a2=get(handles.a1_a2_checkbox,'value');
%vnone=get(handles.none_checkbox,'value');
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
reffz=get(handles.fz_popupmenu,'value');
refcz=get(handles.cz_popupmenu,'value');
refpz=get(handles.pz_popupmenu,'value');
refa1=get(handles.a1_popupmenu,'value');
refa2=get(handles.a2_popupmenu,'value');
reft3=get(handles.t3_popupmenu,'value');
reft4=get(handles.t4_popupmenu,'value');
reft5=get(handles.t5_popupmenu,'value');
reft6=get(handles.t6_popupmenu,'value');
refchin_emg=get(handles.chin_emg_popupmenu,'value');
refl_eog=get(handles.l_eog_popupmenu,'value');
refr_eog=get(handles.r_eog_popupmenu,'value');
refekg=get(handles.ekg_popupmenu,'value');
refl_leg=get(handles.l_leg_popupmenu,'value');
refr_leg=get(handles.r_leg_popupmenu,'value');
refsnore=get(handles.snore_popupmenu,'value');
refspo2=get(handles.spo2_popupmenu,'value');
refbpm=get(handles.bpm_popupmenu,'value');
refposition=get(handles.position_popupmenu,'value');
refa1_a2=get(handles.a1_a2_popupmenu,'value');
refnone=get(handles.none_popupmenu,'value');
%%refeog=get(handles.eog_popupmenu,'value');
%refnone=nonzeros(handles.fp1_popupmenu);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sum=0;
values=[vfp1,vfp2,vf3,vf4,vc3,vc4,vp3,vp4,vo1,vo2,...
vf7,vf8,vfz,vcz,vpz,va1,va2,vt3,vt4,vt5,vt6,vchin_emg,vl_eog,vr_eog,vekg,vl_leg,vr_leg,vsnore,vspo2,vbpm,vposition];
reference=[reffp1,reffp2,reff3,reff4,refc3,refc4,refp3,refp4,refo1,refo2,...
reff7,reff8,reffz,refcz,refpz,refa1,refa2,reft3,reft4,reft5,reft6,refchin_emg,refl_eog,refr_eog,refekg,refl_leg,refr_leg,refsnore,refspo2,refbpm,refposition,refa1_a2,refnone];
%  totalstring=[fp1,fp2,f3,f4,c3,c4,p3,p4,o1,o2,f7,f8,fz,cz,pz,a1,a2,t3,t4,t5,t6,chin_emg,l_eog,r_eog,ekg,l_leg,r_leg,snore,spo2,bpm,position,a1_a2,none];
totalstring=get(handles.fp1_popupmenu,'string');
 %%%%%%得到的是电极的名称
location=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21, 22,23, 24,25, 26,27,28,29,30,31,32,33];
%%%%电极对应的电极帽上面的位置
for i=1:length(values)
    sum=sum+values(i);
end%%计算所选电极总数
global base;
global ref;
global refstring;
base=[];  %选择的电极存放在数组a中
ref = [];
refstring = [];
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

                        ref(refnum)=reference(i);       %%%%得到的是参考电极的位置
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
dis_artifacts_250(flags);
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
vfz=get(handles.fz_checkbox,'value');
vcz=get(handles.cz_checkbox,'value');
vpz=get(handles.pz_checkbox,'value');
va1=get(handles.a1_checkbox,'value');
va2=get(handles.a2_checkbox,'value');
vt3=get(handles.t3_checkbox,'value');
vt4=get(handles.t4_checkbox,'value');
vt5=get(handles.t5_checkbox,'value');
vt6=get(handles.t6_checkbox,'value');
vchin_emg=get(handles.chin_emg_checkbox,'value');
vl_eog=get(handles.l_eog_checkbox,'value');
vr_eog=get(handles.r_eog_checkbox,'value');
vekg=get(handles.ekg_checkbox,'value');
vl_leg=get(handles.l_leg_checkbox,'value');
vr_leg=get(handles.r_leg_checkbox,'value');
vsnore=get(handles.snore_checkbox,'value');
vspo2=get(handles.spo2_checkbox,'value');
vbpm=get(handles.bpm_checkbox,'value');
vposition=get(handles.position_checkbox,'value');
%%veog=get(handles.eog_checkbox,'value');
%va1_a2=get(handles.a1_a2_checkbox,'value');
%vnone=get(handles.none_checkbox,'value');
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
reffz=get(handles.fz_popupmenu,'value');
refcz=get(handles.cz_popupmenu,'value');
refpz=get(handles.pz_popupmenu,'value');
refa1=get(handles.a1_popupmenu,'value');
refa2=get(handles.a2_popupmenu,'value');
reft3=get(handles.t3_popupmenu,'value');
reft4=get(handles.t4_popupmenu,'value');
reft5=get(handles.t5_popupmenu,'value');
reft6=get(handles.t6_popupmenu,'value');
refchin_emg=get(handles.chin_emg_popupmenu,'value');
refl_eog=get(handles.l_eog_popupmenu,'value');
refr_eog=get(handles.r_eog_popupmenu,'value');
refekg=get(handles.ekg_popupmenu,'value');
refl_leg=get(handles.l_leg_popupmenu,'value');
refr_leg=get(handles.r_leg_popupmenu,'value');
refsnore=get(handles.snore_popupmenu,'value');
refspo2=get(handles.spo2_popupmenu,'value');
refbpm=get(handles.bpm_popupmenu,'value');
refposition=get(handles.position_popupmenu,'value');
refa1_a2=get(handles.a1_a2_popupmenu,'value');
refnone=get(handles.none_popupmenu,'value');
%%refeog=get(handles.eog_popupmenu,'value');
%refnone=nonzeros(handles.fp1_popupmenu);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sum=0;
values=[vfp1,vfp2,vf3,vf4,vc3,vc4,vp3,vp4,vo1,vo2,...
vf7,vf8,vfz,vcz,vpz,va1,va2,vt3,vt4,vt5,vt6,vchin_emg,vl_eog,vr_eog,vekg,vl_leg,vr_leg,vsnore,vspo2,vbpm,vposition];
reference=[reffp1,reffp2,reff3,reff4,refc3,refc4,refp3,refp4,refo1,refo2,...
reff7,reff8,reffz,refcz,refpz,refa1,refa2,reft3,reft4,reft5,reft6,refchin_emg,refl_eog,refr_eog,refekg,refl_leg,refr_leg,refsnore,refspo2,refbpm,refposition,refa1_a2,refnone];
%  totalstring=[fp1,fp2,f3,f4,c3,c4,p3,p4,o1,o2,f7,f8,fz,cz,pz,a1,a2,t3,t4,t5,t6,chin_emg,l_eog,r_eog,ekg,l_leg,r_leg,snore,spo2,bpm,position,a1_a2,none];
location=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20, 21,22, 23,24, 25,26,27,28,29,30,31,32,33];
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
                switch i
                   case 32
                         ref(j)=reference(i)        %%%%得到的是参考电极的位置
                         a(j)=location(i)          %%得到是矩阵，选择电极在电极帽上对应的位置，例如c3则location(i)的值为5
                         C = handles.Dmeg{ii}
                         toplotdata = C(a(j),:,:)-C(ref(23),:,:)-C(ref(24),:,:)
                    case 33
                           ref(j)=reference(i)        %%%%得到的是参考电极的位置
                         a(j)=location(i)          %%得到是矩阵，选择电极在电极帽上对应的位置，例如c3则location(i)的值为5
                         C = handles.Dmeg{ii}
                         toplotdata = C(a(j),:,:)
                    otherwise
                        ref(j)=reference(i);        %%%%得到的是参考电极的位置
                        a(j)=location(i);          %%得到是矩阵，选择电极在电极帽上对应的位置，例如c3则location(i)的值为5
                        C = handles.Dmeg{ii};
                        toplotdata = C(a(j),:,:)-C(ref(j),:,:);
                end
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

allbad = [EOGchan ECGchan EMGchan EEGchan ];
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


% --- Executes on button press in artifacts_Marker.
function artifacts_Marker_Callback(hObject, eventdata, handles)
% hObject    handle to artifacts_Marker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of artifacts_Marker
load('Datapath.mat');
MarValue=get(handles.artifacts_Marker,'Value');
save('Datapath','datapath','dataname','MarValue');
