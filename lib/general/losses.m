%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: losses                                                            %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p, inp] = losses(inp, p, lmd, i_in, setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Inputs
%---------------------------------------------------
cosphi_i = inp.cosphi_i;
lmd_frms_sq = lmd.lmd_frms_sq;
i_c_frms_sq = i_in.i_c_frms_sq;
SLF = p.SLF;
cos_SLF = p.cosphi_SLF;

%---------------------------------------------------
% Select load angle value
%---------------------------------------------------
[~,cosphi] = min(abs(cosphi_i - cosphi_i(setup.plot_cosphi)));
[~,cosphi_SLF] = min(abs(cos(cos_SLF) - cosphi_i(setup.plot_cosphi)));

%---------------------------------------------------
% Init Loss Calculation
%---------------------------------------------------
I_a = linspace(0,1,100);                                                    % normalised fundamental current $I_a$
T = linspace(0,1,100);                                                      % normalised fundamental torque $T$
n = linspace(0,setup.n_1,length(lmd_frms_sq));                              % normalised rotational speed $n$
n = [n,linspace(1+n(2)-n(1),setup.n_1*setup.n_2,length(n(1:end/2)))];       % normalised rotational speed $n$
P_mech = T'*n;                                                              % normalised mechanical Power $P_mech$                                                                  
idx = P_mech > setup.P_max;

%---------------------------------------------------
% variables
%---------------------------------------------------
HDF = lmd_frms_sq';
HDF(isnan(HDF)) = 0;
DCI = i_c_frms_sq(:,cosphi)';
DCI(isnan(DCI)) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calcualtions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Components losses
%---------------------------------------------------
P_EMA = (I_a.*I_a)'*HDF*setup.k1_EMA;
P_EMA = [P_EMA P_EMA(:,end)*(flipud(P_mech(end,length(P_EMA(1,:))+1:length(n)))).^2];
P_EMA(idx) = NaN;
P_DCI = (I_a.*I_a)'*DCI*setup.k2_DCI;
P_DCI = [P_DCI P_DCI(:,end)*(flipud(P_mech(end,length(P_DCI(1,:))+1:length(n)))).^2];
P_DCI(idx) = NaN;
P_IGBT = (I_a.*I_a)'*SLF(cosphi_SLF)*ones(1,length(HDF))*setup.k3_IGBT*(setup.normIp/sqrt(2))^2;
P_IGBT = [P_IGBT P_IGBT(:,end)*flipud(P_mech(end,length(P_IGBT(1,:))+1:length(n)))];
P_IGBT(idx) = NaN;

%---------------------------------------------------
% Total Losses
%---------------------------------------------------
P_loss = P_EMA + P_DCI + P_IGBT;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p.P_EMA = P_EMA;
p.P_DCI = P_DCI;
p.P_IGBT = P_IGBT;
p.P_loss = P_loss;
inp.T = T;
inp.n = n;

end