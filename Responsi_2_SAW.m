function varargout = Responsi_2_SAW(varargin)
% Responsi_2_SAW MATLAB code for Responsi_2_SAW.fig
%      Responsi_2_SAW, by itself, creates a new Responsi_2_SAW or raises the existing
%      singleton*.
%
%      H = Responsi_2_SAW returns the handle to a new Responsi_2_SAW or the handle to
%      the existing singleton*.
%
%      Responsi_2_SAW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Responsi_2_SAW.M with the given input arguments.
%
%      Responsi_2_SAW('Property','Value',...) creates a new Responsi_2_SAW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Responsi_2_SAW_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Responsi_2_SAW_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Responsi_2_SAW

% Last Modified by GUIDE v2.5 25-Jun-2021 22:10:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Responsi_2_SAW_OpeningFcn, ...
                   'gui_OutputFcn',  @Responsi_2_SAW_OutputFcn, ...
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


% --- Executes just before Responsi_2_SAW is made visible.
function Responsi_2_SAW_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Responsi_2_SAW (see VARARGIN)

% Choose default command line output for Responsi_2_SAW
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Responsi_2_SAW wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Responsi_2_SAW_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_tampil.
function btn_tampil_Callback(hObject, eventdata, handles)
% hObject    handle to btn_tampil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data1 = xlsread('DATA RUMAH.xlsx','A2:A21'); %pengambilan dataset 20 baris pertama dari kolom A
data2 = xlsread('DATA RUMAH.xlsx','B2:H21'); %pengambilan dataset 20 baris pertama dari kolom B hingga H
data = [data1 data2]; %pengambilan dataset tanpa menyertakan kolom kedua
set(handles.table_data,'Data',data);


% --- Executes on button press in btn_proses.
function btn_proses_Callback(hObject, eventdata, handles)
% hObject    handle to btn_proses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x = xlsread('DATA RUMAH.xlsx','C2:H21');   %pengambilan dataset kolom ke-3 sampai 8
k = [0 1 1 1 1 1];                         %0 = cost, 1 = benefit. hanya harga yang bertindak sebagai cost
w = [0.30 0.20 0.23 0.10 0.07 0.10];       %bobot kriteria, dikonversikan ke desimal

%normalisasi matriks
[m, n]=size (x);    %matriks m x n dengan ukuran sebanyak variabel x (input);
R=zeros (m,n);      %membuat matriks R, yang merupakan matriks kosong
Y=zeros (m,n);      %membuat matriks Y, yang merupakan titik kosong

for j=1:n 
    if k(j)==1
        R(:,j)=x(:,j)./max(x(:,j)); %statement untuk kriteria dengan atribut benefit
    else
        R(:,j)=min(x(:,j))./x(:,j); %statement untuk kriteria dengan atribut cost
    end
end

%perhitungan utama, perkalian matriks data yan gtelah dinormalisasi dengan bobot masing-masing kriteria
for i=1:m
    V(i) = sum(w.*R(i,:));
end

%pengurutan data dari terbesar ke terkecil, ids adalah indeks dari hasil pengurutan
[~,ids] = sort(V,'descend');

%pengambilan dataset kolom ke-2 (nama rumah)
opts = detectImportOptions('DATA RUMAH.xlsx');
opts.SelectedVariableNames = (2);
nama = readmatrix('DATA RUMAH.xlsx', opts); %membaca file DATA RUMAH.xlsx
namaRumah = nama(1:20);                     %membaca matrix nama dari baris ke-1 sampai 20

set(handles.table_hasil,'Data', namaRumah(ids)); %indeks digunakan untuk menampilkan hasil berdasar rankingnya
