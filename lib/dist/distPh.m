%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: distPh                                                            %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [lmd, i_out] = distPh(inp, pwmPara, v_in, setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Inputs
%---------------------------------------------------
M_i = inp.M_i;
Theta_u_i = inp.Theta_u_i;
cosphi_i = inp.cosphi_i;
v_al = v_in.v_al;
d = pwmPara.d;
kf = pwmPara.kf;
k = pwmPara.k;

%---------------------------------------------------
% General
%---------------------------------------------------
N_theta = length(Theta_u_i)/6;
P_h = zeros(1,length(M_i));                                                 % harmonic power spectrum of alpha voltage
V1 = zeros(1,length(M_i));                                                  % voltage spectrum
lmd_h_total = [];
R = ["R1","R2","R3","R4","R5","R6"];

%---------------------------------------------------
% Transforms
%---------------------------------------------------
Tc_inv=inv(2/3*[1,  -1/2,       -1/2;
                0,   sqrt(3)/2, -sqrt(3)/2;
                1/2, 1/2,        1/2]);                                     % inverse clark transformation  

%---------------------------------------------------
% Normalization
%---------------------------------------------------
if setup.norm == 0
    lmd_b = 0.5*(setup.normDC/pi)*(setup.Ts)/setup.L;
    lmd_b_frms_sq = (setup.normDC/(24*setup.fs*setup.L))^2;
else
    lmd_b = 1;
    lmd_b_frms_sq = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Distortions Fourier domain for OM
%---------------------------------------------------
for i = 1:length(M_i)
    [P_h(i),V1(i)] = fourier(v_al(i,:));
end
P_h = P_h' - (P_h(2)*ones(length(P_h),1) - ones(length(P_h),1));

%---------------------------------------------------
% Numeric calculation of the harmonic flux
%---------------------------------------------------
for i = 1:6
    theta_u_i = Theta_u_i((i-1)*N_theta+1:i*N_theta);
    [lmd_rms_sq, lmd_frms_sq, lmd_h] = fluxNumeric(R(i),i,P_h,M_i,theta_u_i,kf,d,k,setup);
    lmd_h_total = [lmd_h_total, lmd_h];
end
lmd_h = lmd_h_total(setup.plot_Mi,:);

%---------------------------------------------------
% Analytic calculation of the harmonic flux
%---------------------------------------------------
if setup.Numeric == 0
    theta_u_i = linspace(0,pi/3,length(theta_u_i));
    [lmd_rms_sq, lmd_frms_sq] = fluxAnalytic(P_h,M_i,theta_u_i,kf,setup);
end
 
%---------------------------------------------------
% Line current
%---------------------------------------------------
Theta_u_i = linspace(0,2*pi,length(lmd_h));
i_a = zeros(length(M_i),length(Theta_u_i),length(cosphi_i));
for i = 1:length(M_i)
   for ii = 1:length(Theta_u_i)     
       for iii = 1:length(cosphi_i)
            Theta_i = Theta_u_i(ii) - acos(cosphi_i(iii));
            i_ph = setup.normIp*Tc_inv*[cos(Theta_i);sin(Theta_i); 0];
            i_a(i,ii,iii) = i_ph(1);
       end
   end
end
shift = length(lmd_h)/2 - floor(cosphi_i(setup.plot_cosphi)*length(lmd_h)/4);
i_a_rms = i_a(setup.plot_Mi,:,setup.plot_cosphi) + circshift(lmd_h,shift)*lmd_b;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lmd.lmd_frms_sq = lmd_frms_sq*lmd_b_frms_sq;
lmd.lmd_rms_sq = lmd_rms_sq*lmd_b_frms_sq;
lmd.lmd_h = lmd_h*lmd_b;
i_out.i_a_rms = i_a_rms;

end