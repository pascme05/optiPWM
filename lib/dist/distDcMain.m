%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: distDcMain                                                        %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [i_in, v_in, time] = distDcMain(inp ,pwmPara, i_in, v_in, setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Inputs
%---------------------------------------------------
M_i = inp.M_i;
Theta_u_i = inp.Theta_u_i;
cosphi_i = inp.cosphi_i;
d = pwmPara.d;
kf = pwmPara.kf;
k = pwmPara.k;

%---------------------------------------------------
% General
%---------------------------------------------------
N_theta = length(Theta_u_i)/6;
u_dc_total = zeros(length(M_i),length(Theta_u_i),length(cosphi_i),size(d.R1.dt_total,1));
i_dc_total = zeros(length(M_i),length(Theta_u_i),length(cosphi_i),size(d.R1.dt_total,1));
i_ph_total = zeros(length(M_i),length(Theta_u_i),length(cosphi_i),3);
dt_total = zeros(size(d.R1.dt_total,1),length(M_i),length(Theta_u_i));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calcualtions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% distortions
%---------------------------------------------------
for i = 1:6
    theta_u_i = Theta_u_i((i-1)*N_theta+1:i*N_theta);
    [i_c_rms_sq, i_c_frms_sq,...
     u_dc_rms_sq, u_dc_frms_sq,...
     dt, u_dc,  i_dc, i_ph] = distDc(i,M_i,theta_u_i,cosphi_i,d,k,kf,setup);
    u_dc_total(:,(i-1)*N_theta+1:i*N_theta,:,:) = u_dc;
    i_dc_total(:,(i-1)*N_theta+1:i*N_theta,:,:) = i_dc;
    i_ph_total(:,(i-1)*N_theta+1:i*N_theta,:,:) = i_ph;
    dt_total(:,:,(i-1)*N_theta+1:i*N_theta) = dt;
end

%---------------------------------------------------
% Time Domain signals
%---------------------------------------------------
i_dc = [];
i_a = [];
u_dc = [];
t_dc = [];
for i = 1:length(Theta_u_i)
    i_dc = [i_dc; squeeze(i_dc_total(setup.plot_Mi,i,setup.plot_cosphi,:))];
    i_a = [i_a; squeeze(i_ph_total(setup.plot_Mi,i,setup.plot_cosphi,1))];
    u_dc = [u_dc; squeeze(u_dc_total(setup.plot_Mi,i,setup.plot_cosphi,:))];
    t_dc = [t_dc; (squeeze(dt_total(:,setup.plot_Mi,i)) + 2*(i-1))];
end
i_dc_avg = i_dc(1:end-1)'*diff(t_dc)/(max(t_dc)-min(t_dc));
i_c = i_dc - i_dc_avg; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Post-Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_c = [0; i_c(1:end-1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_in.i_c_rms_sq = i_c_rms_sq;
i_in.i_c_frms_sq = i_c_frms_sq;
i_in.i_c = i_c;
i_in.i_dc = i_dc;
i_in.i_a = i_a;
v_in.u_dc_rms_sq = u_dc_rms_sq;
v_in.u_dc_frms_sq = u_dc_frms_sq;
v_in.u_dc = u_dc;
time.dt = dt;
time.t_dc = t_dc;

end