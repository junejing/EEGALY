function varargout = marker_end(varargin)
% MARKER_END MATLAB code for marker_end.fig
%      MARKER_END, by itself, creates a new MARKER_END or raises the existing
%      singleton*.
%
%      H = MARKER_END returns the handle to a new MARKER_END or the handle to
%      the existing singleton*.
%
%      MARKER_END('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MARKER_END.M with the given input arguments.
%
%      MARKER_END('Property','Value',...) creates a new MARKER_END or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before marker_end_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to marker_end_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help marker_end

% Last Modified by GUIDE v2.5 02-Jul-2014 09:28:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @marker_end_OpeningFcn, ...
                   'gui_OutputFcn',  @marker_end_OutputFcn, ...
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


% --- Executes just before marker_end is made visible.
function marker_end_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to marker_end (see VARARGIN)

% Choose default command line output for marker_end
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes marker_end wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = marker_end_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function endname_Callback(hObject, eventdata, handles)
% hObject    handle to endname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endname as text
%        str2double(get(hObject,'String')) returns contents of endname as a double


% --- Executes during object creation, after setting all properties.
function endname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endname_Callback(hObject, eventdata, handles)
% hObject    handle to endname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endname as text
%        str2double(get(hObject,'String')) returns contents of endname as a double


% --- Executes during object creation, after setting all properties.
function endname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
