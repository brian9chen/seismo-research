%%%%%%%%
% Script to 
% Prepare data for record section plotting for Sn/Lg
% This is the script to prepare data for final publication using methods
% discussed on Dec. 2nd, 2020:
% Uses a reduction velocity of 4 km/s based on epicentral distance and
% event's focal time.
% Uses 3.3 km/s - 3.6 km/s for Lg window and zero intercept, for
% new_data_processing.
% Uses 3.1 km/s - 3.6 km/s for Lg window and zero intercept, for
% new_data_processing2. Have to manually change this.
% Uses 4.8 km /s with mantle event's intercept as Sn start, and 4.3 km/s
% with crustal event's intercept as Sn end.
% Add a SNR filter. Noise is a 20s-window taken 5s before mantle Pn
% arrival.
%%%%%%%%
%%% Changes for new run:
%%% 1. Event name on line 24
%%% 2. Variable names on line 70, 71, click on change ALL
%%% 3. Variable name on LAST line
%%%%%%%%
% Author: Axel Wang 
% Date: 2020/12/03
%%%%%%%%
clear all; close all
%% Event ID
EVENT = 'P358'

%% Input Directory
data = dlmread('/Users/23brianc/Documents/Internship2020/Code/moho_overlay/Wyoming/xyzcoords_moho.txt');

%% Read N&Z components file names and corresponding depth
fid = fopen(fullfile(dir,'evtlst.txt'));
Input = textscan(fid,'%s %s %s %f');

Sacnm_Z = Input{1};
Sacnm_N = Input{2};
Sacnm_E = Input{3};
Depth = Input{4};
fclose(fid);

%% Simple model used to calculate arrival times:
h = 37.6500;
zc = 12.3; % crustal EQ depth
zm = 76.2;  % near (but below) Moho EQ depth
v0 = 3.5;  % shear velocity in crust
v1 = 4.6;  % shear velocity in mantle
v0p = 6.1; % P velocity in crust
v1p = 8.1; % P velocity in mantle

%% Data Processing
n_sac = length(Sacnm_Z);
% Resample rate (see below)
dt_out=0.01;

% Sn intercept time
inter_sn_c = (2*h-zc)*sqrt((v1^2-v0^2))/(v1*v0)  ;  % crust
inter_sn_m =  h*sqrt((v1^2-v0^2))/(v1*v0) ;        % Moho
% convert to indicies
idx_sn_c = floor(inter_sn_c/dt_out);
idx_sn_m = floor(inter_sn_m/dt_out);

% Pn intercept time (for noise; here we will use the smaller, i.e. moho
% event, intercept time as that will be the earliest.)
inter_pn_m =  h*sqrt((v1p^2-v0p^2))/(v1p*v0p);
idx_pn_m = floor(inter_pn_m/dt_out);


% File IDs
% new_data_processing: Lg window from 3.3-3.6 KM/s as suggested by Simon
% new_data_processing2: Lg window from 3.1-3.6 KM/s as conventional
output_dir = '/Users/axelwang/Research/TibetDeep/LgSn/script/new_data_processing2/';
STN = fopen(fullfile(output_dir,strcat(EVENT,'_new_stn.txt')),'w');
INFO = fopen(fullfile(output_dir,strcat(EVENT,'_new_info.txt')),'w');
P358_new_data = zeros(100000,n_sac);
P358_new_time = zeros(100000,n_sac);

% Specify filter passbands
% Use the same as in McNamara
lowpass=5;
highpass=1;
    

for k=1:n_sac

    
%-------------------- Reading and Raw Data -----------------     
    % Read in data
    sacnm_z = Sacnm_Z{k};
    sacnm_n = Sacnm_N{k};  
    sacnm_e = Sacnm_E{k};  
    sacst_z = SACST_fread({fullfile(dir,sacnm_z)});
    sacst_n = SACST_fread({fullfile(dir,sacnm_n)});
    sacst_e = SACST_fread({fullfile(dir,sacnm_e)});
    
    % Full Time Series 
    dt_in = sacst_z.delta;
    b_in = sacst_z.b;
    npts_in = sacst_z.npts;
    o_in = sacst_z.o;
    e_in = b_in+(npts_in-1)*dt_in;
    T = b_in:dt_in:e_in;
                
    % Original Data
    Z = sacst_z.data;
    N = sacst_n.data;
    E = sacst_e.data;
    
    % Make sure all data components have the same length by cutting them 
    % down to the shortest arrary.     
 if length(T) ~= length(N) | length(T) ~= length(E) | length(T) ~= length(Z)
     minLength= min([length(N) length(E) length(Z) length(T)]);
     N=N(1:minLength,1);
     E=E(1:minLength,1);
     Z=Z(1:minLength,1);
     T=T(1,1:minLength);
 end   
    
%----------------- Basic Parameters  ---------------
   
   % Magnitude
    Mag=sacst_z.mag;
 
    % Evt depth
    evdp = sacst_z.evdp;
        
    % Evt location
    evlo = sacst_z.evlo;
    evla = sacst_z.evla;
    
    % Stn location
    stlo = sacst_z.stlo;
    stla = sacst_z.stla;
    stnm = sacst_z.kstnm;  %Station name
    
    % Epicentral distance (degrees)
    gcarc = sacst_z.gcarc;  
    
    % Epicentral distance (km)
    dist = sacst_z.dist;
            
    % Azimuth
    az=sacst_z.az;
    
    % Back-azimuth   
    baz=sacst_z.baz;

%--------------- Rotations-------------------    
  % Rotation to ZRT coordinate system
    [R TD]= rotation(N, E, Z,baz);
    

%------------ Data Processing: Resample, filter, scale ------------

    % Resample the data at dt_out= 0.01
   
    if (dt_in ~= dt_out)              %dt_out =0.01
        T_int = b_in:dt_out:e_in;

        Z = interp1(T,Z,T_int,'spline');
        R = interp1(T,R,T_int,'spline');
        TD = interp1(T,TD,T_int,'spline');
    end
    T=T_int;    %New Full time series
    
    t_shift = b_in-dt_out;
    t_start = dt_out;
    t_end = e_in-t_shift;
    T = t_start:dt_out:t_end;
    
    % Set 0 time to event origin time
    T = T+b_in;
   
    % Design a second order Butterworth band-pass filter           
    sample_fre=1/dt_out;
                
    low=lowpass/(sample_fre/2);
    high=highpass/(sample_fre/2);
    [b a] = butter(4,[high low], 'bandpass');
    
    Z_filtered=filter(b,a,Z);
    R_filtered=filter(b,a,R); 
    TD_filtered=filter(b,a,TD); 
    
    Z = Z_filtered;
    R = R_filtered;
    TD = TD_filtered;
    
%----------------- make data starts t=20s after event origin time, here O  ---------------
if o_in ==0
   cut_time = 20;
   [val, idx] = min(abs(T - cut_time));  %Only correct if O is 0!!
    
    T = T(idx:end);
    TD = TD(idx:end);
else 
    disp('Error: O is not at event origin time')
end
    

% Normalize the cutted trace
TD = TD./max(abs(TD));

%------------ Get Sn and Lg windows based on true velocity ------------

% Get velocity array
velocity = dist./T;

% Find the index of the velocity (reduction velocity) that we want to align data on
% these indicies are on the cutted time array
align_velocity = 4;
[val,idx_align_vel] = min(abs(velocity-align_velocity));

% Find the indicies of the velocity windows of Sn and Lg
vsn = 4.3;
vlg = 3.1;

vsn_max = 4.8;
vlg_max = 3.6;

[val,idx_vsn_end] = min(abs(velocity-vsn));
[val,idx_vlg_end] = min(abs(velocity-vlg));
[val,idx_vsn_start] = min(abs(velocity-vsn_max));
[val,idx_vlg_start] = min(abs(velocity-vlg_max));

% add the intercept times for Sn start and end
idx_vsn_start = idx_vsn_start + idx_sn_m;
idx_vsn_end = idx_vsn_end + idx_sn_c;

% get the noise window
vpn = 8.1 ;
[val,idx_vpn] = min(abs(velocity-vpn));
idx_vpn = idx_vpn + idx_pn_m;
idx_vn_end = idx_vpn - floor(5/dt_out);
idx_vn_start = idx_vpn-floor(25/dt_out);

%%%% plot to check if correct
% sn = TD(idx_vsn_start:idx_vsn_end);
% lg = TD(idx_vlg_start:idx_vlg_end);
% noise = TD(idx_vn_start:idx_vn_end);
% tsn = T(idx_vsn_start:idx_vsn_end);
% tlg = T(idx_vlg_start:idx_vlg_end);
% tnoise = T(idx_vn_start:idx_vn_end);
% figure(k)
% plot(T,TD,'k')
% hold on
% plot(tsn,sn,'r')
% hold on
% plot(tlg,lg+1,'c')
% hold on
% plot(tnoise,noise,'g')



%-------Get Sn, Lg and noise amplitudes
sn_amp = rms(TD(idx_vsn_start:idx_vsn_end));
lg_amp = rms(TD(idx_vlg_start:idx_vlg_end));
noise_amp = rms(TD(idx_vn_start:idx_vn_end));

% signal to noise ratio
SNRsn = sn_amp/noise_amp;
SNRlg = lg_amp/noise_amp;

if SNRsn <4 & SNRlg <4
    continue
end


% Sn/Lg amplitude ratio
ampr = sn_amp/lg_amp;

info =[dist,idx_vsn_start,idx_vsn_end,idx_vlg_start,idx_vlg_end,idx_vn_start,idx_vn_end,idx_align_vel]';

%----------------------- Write data---------------
P358_new_data(1:length(TD),k) = TD';
P358_new_time(1:length(T),k) = T';

fprintf(STN,'%f %f %f \n',[stlo ; stla; ampr;]);
fprintf(INFO,'%f %u %u %u %u %u %u %u\n',info);

end

P358_new_data( :, all(~P358_new_data,1) ) = [];  % delete zero columns, due to not passing SNR conditions
P358_new_time( :, all(~P358_new_time,1) ) = [];  % delete zero columns, due to not passing SNR conditions

fclose(STN); 
fclose(INFO); 

all_data_file = strcat(EVENT,'_new_data.mat');
save(fullfile(output_dir,all_data_file))
 


        
