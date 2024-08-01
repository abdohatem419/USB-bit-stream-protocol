function varargout = USB_bit_stream_player(varargin)
% USB_BIT_STREAM_PLAYER MATLAB code for USB_bit_stream_player.fig
%      USB_BIT_STREAM_PLAYER, by itself, creates a new USB_BIT_STREAM_PLAYER or raises the existing
%      singleton*.
%
%      H = USB_BIT_STREAM_PLAYER returns the handle to a new USB_BIT_STREAM_PLAYER or the handle to
%      the existing singleton*.
%
%      USB_BIT_STREAM_PLAYER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USB_BIT_STREAM_PLAYER.M with the given input arguments.
%
%      USB_BIT_STREAM_PLAYER('Property','Value',...) creates a new USB_BIT_STREAM_PLAYER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before USB_bit_stream_player_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to USB_bit_stream_player_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help USB_bit_stream_player

% Last Modified by GUIDE v2.5 26-Aug-2023 00:00:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @USB_bit_stream_player_OpeningFcn, ...
                   'gui_OutputFcn',  @USB_bit_stream_player_OutputFcn, ...
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


% --- Executes just before USB_bit_stream_player is made visible.
function USB_bit_stream_player_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to USB_bit_stream_player (see VARARGIN)

% Choose default command line output for USB_bit_stream_player
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
%default values:
global data_file_name
global data_file_id
global random_data
global start_byte
global out_array
global packeted_usb_array
global conversion_file_name
global conversion_file_id
global dstate
global rstate
data_file_name="Text Files\input.txt";
dstate=1;
rstate=0;
set(handles.dradio,'value',1);
set(handles.rradio,'value',0);

% UIWAIT makes USB_bit_stream_player wait for user response (see UIRESUME)
% uiwait(handles.figure1);
ah=axes('unit','normalized','position',[0 0 1 1]);
bg=imread("Text Files\USB_logo.png");
imagesc(bg);
set(ah,'handlevisibility','off','visible','off');


% --- Outputs from this function are returned to the command line.
function varargout = USB_bit_stream_player_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in set_input.
function set_input_Callback(hObject, eventdata, handles)
% hObject    handle to set_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_file_name
global random_data
data_file_id=fopen(data_file_name,'r');
%if we need to make an input file:
%data_file_id=data_file_generator(data_file_name,MAX_SIZE);

 if data_file_id==-1 %if it is not opened
     disp("Error Opening the data file");
     return;
 end
%read from the file
random_data=load(data_file_name);
% Close the file
fclose(data_file_id);


% --- Executes on button press in convert.
function convert_Callback(hObject, eventdata, handles)
% hObject    handle to convert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global random_data
global out_array
start_byte=[0 0 0 0 0 0 0 1];
random_data=[start_byte,random_data];
out_array=usb_conversion(random_data);
% Open the conversion file
conversion_file_id="Text Files\conversion.txt";
conversion_file_id = fopen(conversion_file_id, 'w');

if conversion_file_id ==-1 % it is not opened
    disp("Error Opening the conversion file");
    return;
end

% Write on the file the bit_stream after conversion
fprintf(conversion_file_id,'%s\n',num2str(out_array));

% Close the file
fclose(conversion_file_id);

% --- Executes on button press in Packet.
function Packet_Callback(hObject, eventdata, handles)
% hObject    handle to Packet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global out_array
packeted_usb_array=make_packets(out_array,32,[0,0,0]);
% Open the conversion file
conversion_file_id="Text Files\conversion.txt";
conversion_file_id = fopen(conversion_file_id, 'w');

if conversion_file_id ==-1 % it is not opened
    disp("Error Opening the conversion file");
    return;
end

% Write on the file the bit_stream after conversion
fprintf(conversion_file_id,'%s\n',num2str(packeted_usb_array));

% Close the file
fclose(conversion_file_id);

% --- Executes on button press in show_input.
function show_input_Callback(hObject, eventdata, handles)
% hObject    handle to show_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Create a new figure window
global data_file_name
figure('Name', 'Text File Viewer', 'Position', [100, 100, 600, 400]);

% Read the content of the text file
fileContent = fileread(data_file_name);

% Display the content in the figure window
text(0.1, 0.5, fileContent, 'FontSize', 12);
axis off; % Turn off the axes



% --- Executes on button press in show_output.
function show_output_Callback(hObject, eventdata, handles)
% hObject    handle to show_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure('Name', 'Text File Viewer', 'Position', [100, 100, 600, 400]);
conversion_file_name="Text Files\conversion.txt";
% Read the content of the text file
fileContent = fileread(conversion_file_name);

% Display the content in the figure window
text(0.1, 0.5, fileContent, 'FontSize', 12);
axis off; % Turn off the axes


% --- Executes on button press in dradio.
function dradio_Callback(hObject, eventdata, handles)
% hObject    handle to dradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dradio
global data_file_name
global dstate
global rstate
set(handles.dradio,'value',1);
dstate=1;
if rstate==1  %if it is on it will not do anything
    rstate=0;
    set(handles.rradio,'value',0);
    data_file_name="Text Files\input.txt";
end


% --- Executes on button press in rradio.
function rradio_Callback(hObject, eventdata, handles)
% hObject    handle to rradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rradio
global data_file_name
global dstate
global rstate
set(handles.rradio,'value',1);
rstate=1;
if dstate==1  %if it is on it will not do anything
    dstate=0;
    set(handles.dradio,'value',0);
    data_file_name="Text Files\data.txt";
    %generates the random input file with 2000 bit
    data_file_generator(data_file_name,2000);
end
