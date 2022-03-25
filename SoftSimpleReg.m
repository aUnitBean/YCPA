winstyle = 'docked';
% winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight



dels = 0.75;
spatialFactor = 1;


%constants
c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);


tSim = 200e-15 % simulation duration
f = 230e12; %frequency
lambda = c_c/f; %wavelength

xMax{1} = 20e-6; %region sesolution
%region size
nx{1} = 200;
ny{1} = 0.75*nx{1};


Reg.n = 1; %number of simulation regions

%magnetic permeability in medium

mu{1} = ones(nx{1},ny{1})*c_mu_0;

%electric permittivity in medium
epi{1} = ones(nx{1},ny{1})*c_eps_0;
epi{1}(100:150,80:150)= c_eps_0*11.3;
epi{1}(100:150,1:75)= c_eps_0*11.3;

% conductivity of region
sigma{1} = zeros(nx{1},ny{1});
sigmaH{1} = zeros(nx{1},ny{1});

%size of steps
dx = xMax{1}/nx{1};  
dt = 0.25*dx/c_c;
%number of steps
nSteps = round(tSim/dt*2);
%boundary in y
yMax = ny{1}*dx;
%total steps
nsteps_lamda = lambda/dx;

%Plotting
movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 1.1;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];

%boundary conditions
bc{1}.NumS = 2;      %number of waves

%wave parameters
bc{1}.s(1).xpos = nx{1}/(10) + 1;  %starting position
bc{1}.s(1).type = 'ss';           %wave boundary type
bc{1}.s(1).fct = @PlaneWaveBC;    %defines function of wave in space and time

bc{1}.s(2).xpos = nx{1}/(2) + 1;  %starting position
bc{1}.s(2).type = 's';           %wave boundary type
bc{1}.s(2).fct = @PlaneWaveBC;    %defines function of wave in space and time

% mag = -1/c_eta_0;
mag = 1;        
phi = 0;     %angle of incidence
omega = f*2*pi; %angular velocity
betap = 0;
t0 = 30e-15;
st = -0.05;
s = 0;
y0 = yMax/2;  %wave height

sty = 5*lambda;
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'};

Plot.y0 = round(y0/dx);


%Asborptive boundary
bc{1}.xm.type = 'e';
bc{1}.xp.type = 'e';
bc{1}.ym.type = 'e';
bc{1}.yp.type = 'e';

% pml.width = 100 * spatialFactor; 
% pml.m = 3.5;
pml.width = 0 * spatialFactor; 
pml.m = 100;

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg






