%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: createVSF                                                         %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fsTs] = createVSF(inp, pwmPara, lmd, i, v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Inputs
%---------------------------------------------------
M_i = inp.M_i;
Theta_u_i = inp.theta_u_i;
cosphi_i = inp.cosphi_i;
dt_total = pwmPara.d.R1.dt_total;
lmd_rms_sq = lmd.lmd_rms_sq;
i_c_rms_sq = i.i_c_rms_sq;
u_dc_rms_sq = v.u_dc_rms_sq;

%---------------------------------------------------
% General
%-------------------------------------------------
T = zeros(length(M_i),length(Theta_u_i));                                   % normalised variable switching times in [s/s]
f = zeros(length(M_i),length(Theta_u_i));                                   % normalised variable switching frequencies in [1/s/1/s]

%---------------------------------------------------
% average values
%---------------------------------------------------
mean_lmd_fs = zeros(1,length(M_i));                                         % average value for harmonic flux with boundary condition fs = const.
mean_idc_fs = zeros(length(M_i),length(cosphi_i));                          % average value for capacitor current with boundary condition fs = const.
mean_udc_fs = zeros(length(M_i),length(cosphi_i));                          % average value for capacitor voltage with boundary condition fs = const.
mean_lmd_Ts = zeros(1,length(M_i));                                         % average value for harmonic flux with boundary condition Ts = const.
mean_idc_Ts = zeros(length(M_i),length(cosphi_i));                          % average value for capacitor current with boundary condition Ts = const.
mean_udc_Ts = zeros(length(M_i),length(cosphi_i));                          % average value for capacitor voltage with boundary condition Ts = const.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
modulation = zeros(length(M_i), length(Theta_u_i));                         % seperates modulated from unmodulated regions
for i = 1:length(M_i)
    modulation(i,:) = [1;diff(squeeze(dt_total(3,i,:)))];
    for ii = 1:length(Theta_u_i)
        if(M_i(i)==0 || modulation(i,ii) ~= 0)
            modulation(i,ii) = 1;
        end
    end
end
modulation(length(M_i),:) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% frequency functions
%---------------------------------------------------
fs_lmd = nthroot(lmd_rms_sq,3).*modulation;
fs_udc = nthroot(abs(u_dc_rms_sq),3);
fs_idc = nthroot(abs(i_c_rms_sq),3);

%---------------------------------------------------
% Time functions
%---------------------------------------------------
Ts_lmd = 1./nthroot(lmd_rms_sq,2).*modulation;
Ts_udc = 1./nthroot(abs(u_dc_rms_sq),2);
Ts_idc = 1./nthroot(abs(i_c_rms_sq),2);

%---------------------------------------------------
% Invers frequency functions
%---------------------------------------------------
fs_inv_lmd = zeros(length(M_i),length(Theta_u_i));
fs_inv_udc = zeros(length(M_i),length(Theta_u_i));

for i = 1:length(M_i)
    mean_lmd_fs(i) = sum(fs_lmd(i,:))/length(Theta_u_i);
    fs_lmd(i,:) = fs_lmd(i,:)/mean_lmd_fs(i);
    mean_lmd_Ts(i) = sum(Ts_lmd(i,:))/length(Theta_u_i);
    Ts_lmd(i,:) = Ts_lmd(i,:)/mean_lmd_Ts(i);
    fs_inv_lmd(i,:) = 1./Ts_lmd(i,:);
    for ii = 1:length(cosphi_i)
      mean_idc_fs(i,ii) = sum(fs_idc(i,:,ii))/length(Theta_u_i);
      mean_udc_fs(i,ii) = sum(fs_udc(i,:,ii))/length(Theta_u_i);
      fs_idc(i,:,ii) = fs_idc(i,:,ii)/mean_idc_fs(i,ii);
      fs_udc(i,:,ii) = fs_udc(i,:,ii)/mean_udc_fs(i,ii);
      mean_idc_Ts(i,ii) = sum(Ts_idc(i,:,ii))/length(Theta_u_i);
      mean_udc_Ts(i,ii) = sum(Ts_udc(i,:,ii))/length(Theta_u_i);
      Ts_idc(i,:,ii) = Ts_idc(i,:,ii)/mean_idc_Ts(i,ii);
      Ts_udc(i,:,ii) = Ts_udc(i,:,ii)/mean_udc_Ts(i,ii);
      fs_inv_udc(i,:,ii) = 1./Ts_udc(i,:,ii);
    end
end


for i=1:length(M_i)
    for ii=1:length(Theta_u_i)
        T(i,ii) = length(Theta_u_i)/(sqrt(lmd_rms_sq(i,ii))*sum(1./(sqrt(lmd_rms_sq(i,:)))));
        f(i,ii) = 1/T(i,ii);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% inverse frequencies flux
%---------------------------------------------------
fs_inv_lmd(fs_inv_lmd==inf) = 0;
fs_inv_lmd(end,:) = 0;
fs_inv_lmd(1,:) = 1;

%---------------------------------------------------
% inverse frequencies voltage
%---------------------------------------------------
fs_inv_udc(fs_inv_udc==inf) = 0;
fs_inv_udc(end,:) = 0;
fs_inv_udc(1,:) = 1;

%---------------------------------------------------
% frequencies flux
%---------------------------------------------------
fs_lmd(fs_inv_lmd==inf) = 0;
fs_lmd(end,:) = 0;
fs_lmd(1,:) = 1;

%---------------------------------------------------
% frequencies voltage
%---------------------------------------------------
fs_udc(fs_inv_udc==inf) = 0;
fs_udc(end,:) = 0;
fs_udc(1,:) = 1;

%---------------------------------------------------
% structs
%---------------------------------------------------
fsTs.fs_lmd = fs_lmd;
fsTs.Ts_lmd = Ts_lmd;
fsTs.fs_inv_lmd = fs_inv_lmd;
fsTs.fs_udc = fs_udc;
fsTs.Ts_udc = Ts_udc;
fsTs.fs_inv_udc = fs_inv_udc;

end