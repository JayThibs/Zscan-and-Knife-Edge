%% Code pour le GUI du jeux "duel à l'arc."
%  On commence par initialiser le GUI. C'est automatique après on sauve le
%  GUI dans GUIDE.


function varargout = duelalarc(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @duelalarc_OpeningFcn, ...
                   'gui_OutputFcn',  @duelalarc_OutputFcn, ...
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


% --- Executes just before duelalarc is made visible.
function duelalarc_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to duelalarc (see VARARGIN)

% Choose default command line output for duelalarc
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes duelalarc wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% Initialization
hp1=100;
hp2=100;
v0=0;
theta=0;
assignin('base','hp1',hp1);
assignin('base','hp2',hp2);
assignin('base','v0',v0);
assignin('base','theta',theta);

% --- Outputs from this function are returned to the command line.
function varargout = duelalarc_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% Le boutton "Tirer!" fait notre simulation aller.
%  Avant, on choisit l'angle et la vitesse. Ensuite, on utilise ce code qui
%  utilise les équations d'Euler.

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

theta = evalin('base', 'theta')+(rand-0.5);
v0 = evalin('base', 'v0')+(rand-0.5);

v0x=v0*cos(theta*pi/180);
v0y=v0*sin(theta*pi/180);
x=0;
y=8;
vx=v0x;
vy=v0y;

h=14;

g=9.81; % Accélération gravitationnelle
B=1; % Coefficient du bout
D=(5/16); % Diamètre de la flèche  (in)
L=(34); % Longueur de la flèche (in)
F=1.51*3; % Aire de plumes (in^2)

K=(0.000013*B*D^2+0.000000035*L*D+0.000000077*F)*4.448; %Coefficient de traînée
 
rho = 1.23; % La densité de l'air (kg/m^3)
Aire = 0.0568; % L'aire de la flèche (m^2)
D=1.2; % Coefficient de traînée
LongueurFleche=0.86; % Longueur de la flèche en mètres
DiametreFleche=0.008; % Diamètre

theta2=38+(2*rand-1)*4*rand; %angle en deg
v02=30+(2*rand-1)*1.2*rand;
v0x2=-v02*cos(theta2*pi/180);
v0y2=v02*sin(theta2*pi/180);

x2=100;
y2=8;
vx2=v0x2;
vy2=v0y2;

xmin=-2;
xmax=110;
ymin=0;
ymax=100;

m=0.0384;
t=0;
tmax=10;
dt=2.5e-2;

hp1 = evalin('base', 'hp1');
hp2 = evalin('base', 'hp2');

hit1=0;
hit2=0;

while y>=0 && hit1==0 && hp1>0 && x<120

    ax=-K/m*sqrt(vx^2+vy^2)*vx;     %Accélération en x (avec frottement)
    ay=-K/m*sqrt(vx^2+vy^2)*vy-g;   %Accélération en y (avec frottement)
    vx=vx+ax*dt;    %Euler
    vy=vy+ay*dt;
    x=x+vx*dt;  
    y=y+vy*dt;  
    t=t+dt;
    v=(vx^2+vy^2)^0.5;
    
    %% Les endroit où on frappe l'autre joueur (l'ordinateur)
    
    if 8<y && y<10 && 100<x && x<102
        hit1=hit1+1;
        hp2=hp2-(50+rand*v);
        beep
        beep
        assignin('base','hp2',hp2) %enregistre les variables dans le workspace
    end
    
    if 2<y && y<8 && 100<x && x<102
        hit1=hit1+1;
        hp2=hp2-(25+rand*v);
        beep
        assignin('base','hp2',hp2)
    end
    
    if 0<y && y<2 && 100<x && x<102
        hit1=hit1+1;
        hp2=hp2-rand*v;
        beep
        assignin('base','hp2',hp2)
    end
    
    plot(x,y,'>blue','MarkerSize',10);
    xlim([xmin xmax]);
    ylim([ymin ymax]);
    hold off;
    drawnow;
end
hp2
x
y
set(handles.HP2,'String',num2str(hp2));
while y2>=0 && hit2==0 && hp2>0
    ax=-K/m*sqrt(vx^2+vy^2)*vx;
    ay=-K/m*sqrt(vx^2+vy^2)*vy-9.8;
    vx2=vx2+ax*dt;
    vy2=vy2+ay*dt;
    x2=x2+vx2*dt;  
    y2=y2+vy2*dt;  
    t=t+dt;
    v2=(vx2^2+vy2^2)^0.5;
    
    if 8<y2 && y2<10 && -2<x2 && x2<0
        hit2=hit2+1;
        hp1=hp1-(50+rand*v);
        beep
        beep
        assignin('base','hp1',hp1)
    end
    
    if 2<y2 && y2<8 && -2<x2 && x2<0
        hit2=hit2+1;
        hp1=hp1-(25+rand*v);
        beep
        assignin('base','hp1',hp1)
    end
    
    
    if 0<y2 && y2<2 && -2<x2 && x2<0
        hit2=hit2+1;
        hp1=hp1-rand*v;
        beep
        assignin('base','hp1',hp1)
    end

    plot(x2,y2,'<red','MarkerSize',10);
    xlim([xmin xmax]);
    ylim([ymin ymax]);
    hold off;
    drawnow;
end
hp1
x2
y2
set(handles.HP1,'String',num2str(hp1));
clearvars -except hp1 hp2 

if hp2<0
    close all
    msgbox('Tu as tué quelqu''un! Yay!')
end

if hp1<0
    close all
    msgbox('Tu es mort! On ira peut-être à ton funéraille.');
end

%% Boutton "Faire la paix!"

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
clear
close all
msgbox('Tu as réalisé que tu te battais pour rien et tu as fait la paix. Bon travail!');

%% Slider pour changer la valeur de theta

% --- Executes on slider movement.
function Tslider_Callback(hObject, eventdata, handles)
% hObject    handle to Tslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
theta=get(hObject,'Value')
assignin('base','theta',theta);

set(handles.Ttext,'String',[num2str(theta) '°']);

% --- Executes during object creation, after setting all properties.
function Tslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Slider pour changer la valeur de v0

% --- Executes on slider movement.
function Vslider_Callback(hObject, eventdata, handles)
% hObject    handle to Vslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v0=get(hObject,'Value')
assignin('base','v0',v0);

set(handles.Vtext,'String',[num2str(v0) ' m/s']);

% --- Executes during object creation, after setting all properties.
function Vslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Vslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function Vtext_CreateFcn(hObject, eventdata, handles,theta)
% hObject    handle to Vtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function Ttext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ttext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function HP1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function HP2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
