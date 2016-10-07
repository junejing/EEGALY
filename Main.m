function varargout = Main(varargin)
% MAIN MATLAB code for Main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main

% Last Modified by GUIDE v2.5 09-Nov-2015 11:29:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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


% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main (see VARARGIN)

% Choose default command line output for Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Tools_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Tools_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plot_menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Scoresleep_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Scoresleep_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Wavedetection_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Wavedetection_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function exsisting_menu_Callback(hObject, eventdata, handles)
% hObject    handle to exsisting_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Spindle_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Spindle_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Montage_500;

% --------------------------------------------------------------------
function Slowwave_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Slowwave_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Montage_500;


% --------------------------------------------------------------------
function EGI_menu_Callback(hObject, eventdata, handles)
% hObject    handle to EGI_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rdata_eeg_egi;

% --------------------------------------------------------------------
function EDF_menu_Callback(hObject, eventdata, handles)
% hObject    handle to EDF_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rdata_eeg_edf;

% --------------------------------------------------------------------
function BRPR_menu_Callback(hObject, eventdata, handles)
% hObject    handle to BRPR_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rdata_eeg_brpr;

% --------------------------------------------------------------------
function BCI2000_menu_Callback(hObject, eventdata, handles)
% hObject    handle to BCI2000_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rdata_eeg_BCI2000;

% --------------------------------------------------------------------
function EEG_menu_Callback(hObject, eventdata, handles)
% hObject    handle to EEG_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Montage_500;

% --------------------------------------------------------------------
function import_data_menu_Callback(hObject, eventdata, handles)
% hObject    handle to import_data_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function chunk_Callback(hObject, eventdata, handles)
% hObject    handle to chunk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
crc_chunks;


% --------------------------------------------------------------------
function Score_500_Callback(hObject, eventdata, handles)
% hObject    handle to Score_500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Montage_500;


% --------------------------------------------------------------------
function Score_250_Callback(hObject, eventdata, handles)
% hObject    handle to Score_250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Montage_250;


% --------------------------------------------------------------------
function artifacts_Callback(hObject, eventdata, handles)
% hObject    handle to artifacts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Artifact_500_Callback(hObject, eventdata, handles)
% hObject    handle to Artifact_500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Montage_artifacts;

% --------------------------------------------------------------------
function Artifact_250_Callback(hObject, eventdata, handles)
% hObject    handle to Artifact_250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Montage_artifacts_250;


% --------------------------------------------------------------------
function Auto_artifacts_Callback(hObject, eventdata, handles)
% hObject    handle to Auto_artifacts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Auto_artifacts


% --------------------------------------------------------------------
function Auto_spindle_Callback(hObject, eventdata, handles)
% hObject    handle to Auto_spindle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function RMS_percent_Callback(hObject, eventdata, handles)
% hObject    handle to RMS_percent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function PSD_2order_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_2order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MP_Callback(hObject, eventdata, handles)
% hObject    handle to MP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function RMS_500_Callback(hObject, eventdata, handles)
% hObject    handle to RMS_500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RMS_percentile_500

% --------------------------------------------------------------------
function RMS_250_Callback(hObject, eventdata, handles)
% hObject    handle to RMS_250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RMS_percentile_250


% --------------------------------------------------------------------
function PSD_Callback(hObject, eventdata, handles)
% hObject    handle to PSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PSD_250_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Power_spectra_density_250;

% --------------------------------------------------------------------
function PSD_500_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Power_spectra_density_500;


% --------------------------------------------------------------------
function PSD_2order_250_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_2order_250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PSD_second_order_derivative_250;

% --------------------------------------------------------------------
function PSD_2order_500_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_2order_500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PSD_second_order_derivative_500;


% --------------------------------------------------------------------
function MP_250_Callback(hObject, eventdata, handles)
% hObject    handle to MP_250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spindle_detection_MP_250;

% --------------------------------------------------------------------
function MP_500_Callback(hObject, eventdata, handles)
% hObject    handle to MP_500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spindle_detection_MP_500;


% --------------------------------------------------------------------
function AR_model_Callback(hObject, eventdata, handles)
% hObject    handle to AR_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AR_250_Callback(hObject, eventdata, handles)
% hObject    handle to AR_250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AR_500_Callback(hObject, eventdata, handles)
% hObject    handle to AR_500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PSD_chunk_menu_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_chunk_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PSD_W_chunk_menu_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_W_chunk_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PSD_N1_chunk_menu_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_N1_chunk_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PSD_N2_chunk_menu_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_N2_chunk_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PSD_N3_chunk_menu_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_N3_chunk_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PSD_R_chunk_menu_Callback(hObject, eventdata, handles)
% hObject    handle to PSD_R_chunk_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function N2_chunk_250_menu_Callback(hObject, eventdata, handles)
% hObject    handle to N2_chunk_250_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PSD_N2_chunk_250;

% --------------------------------------------------------------------
function N2_chunk_500_menu_Callback(hObject, eventdata, handles)
% hObject    handle to N2_chunk_500_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PSD_N2_chunk_500;


% --------------------------------------------------------------------
function EEG_map_menu_Callback(hObject, eventdata, handles)
% hObject    handle to EEG_map_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EEG_map;