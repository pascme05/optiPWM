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
function [lmd, i_in, v_in] = applyVSF(inp, pwmPara, lmd, i_in, v_in, fsTs)
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
i_c_rms_sq = i_in.i_c_rms_sq;
u_dc_rms_sq = v_in.u_dc_rms_sq;
fs_lmd = fsTs.fs_lmd;
Ts_lmd = fsTs.Ts_lmd;
fs_udc = fsTs.fs_udc;
Ts_udc = fsTs.Ts_udc;

%---------------------------------------------------
% general variables
%---------------------------------------------------
lmd_frms_sq_fs       = zeros(length(M_i),1);
lmd_frms_sq_Ts       = zeros(length(M_i),1);
modulated            = zeros(length(M_i), length(Theta_u_i));
lmd_rms_sq_fs        = zeros(length(M_i), length(Theta_u_i));
lmd_rms_sq_Ts        = zeros(length(M_i), length(Theta_u_i));
i_c_frms_sq_fs       = zeros(length(M_i), length(cosphi_i));
u_dc_frms_sq_fs      = zeros(length(M_i), length(cosphi_i));
i_c_frms_sq_Ts       = zeros(length(M_i), length(cosphi_i));
u_dc_frms_sq_Ts      = zeros(length(M_i), length(cosphi_i));
i_c_rms_sq_fs        = zeros(length(M_i), length(Theta_u_i), length(cosphi_i));
u_dc_rms_sq_fs       = zeros(length(M_i), length(Theta_u_i), length(cosphi_i));
i_c_rms_sq_Ts        = zeros(length(M_i), length(Theta_u_i), length(cosphi_i));
u_dc_rms_sq_Ts       = zeros(length(M_i), length(Theta_u_i), length(cosphi_i));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(M_i)
    %---------------------------------------------------
    % Undermodulation region
    %---------------------------------------------------
    if(M_i(i) <= 0.907)
        for ii = 1:length(Theta_u_i)
            for iii = 1:length(cosphi_i)
                i_c_rms_sq_fs(i,ii,iii) = i_c_rms_sq(i,ii,iii);
                i_c_frms_sq_fs(i,iii) = sum(i_c_rms_sq_fs(i,:,iii))/length(Theta_u_i);
                i_c_rms_sq_Ts(i,ii,iii) =  i_c_rms_sq(i,ii,iii);
                i_c_frms_sq_Ts(i,iii) = sum(i_c_rms_sq_Ts(i,:,iii))/length(Theta_u_i);
                u_dc_rms_sq_fs(i,ii,iii) = u_dc_rms_sq(i,ii,iii) / fs_udc(i,ii,iii)^2;
                u_dc_frms_sq_fs(i,iii) = sum(u_dc_rms_sq_fs(i,:,iii))/length(Theta_u_i);
                u_dc_rms_sq_Ts(i,ii,iii) =  u_dc_rms_sq(i,ii,iii) * Ts_udc(i,ii,iii)^2;
                u_dc_frms_sq_Ts(i,iii) = sum(u_dc_rms_sq_Ts(i,:,iii))/length(Theta_u_i);
            end
            lmd_rms_sq_fs(i,ii) = lmd_rms_sq(i,ii) / fs_lmd(i,ii)^2;
            lmd_frms_sq_fs(i) = sum(lmd_rms_sq_fs(i, :))/length(Theta_u_i)*288/pi^2;
            lmd_rms_sq_Ts(i,ii) =  lmd_rms_sq(i,ii) * Ts_lmd(i,ii)^2;
            lmd_frms_sq_Ts(i) = sum(lmd_rms_sq_Ts(i, :))/length(Theta_u_i)*288/pi^2;
        end
    
    %---------------------------------------------------
    % First Overmodulation region
    %---------------------------------------------------
    elseif(M_i(i) > 0.907 && M_i(i) <= 0.952)
        for ii = 1:length(Theta_u_i)
            for iii = 1:length(cosphi_i)
                i_c_rms_sq_fs(i,ii,iii) = i_c_rms_sq(i,ii,iii);
                i_c_frms_sq_fs(i,iii) = sum(i_c_rms_sq_fs(i,:,iii))/length(Theta_u_i);
                i_c_rms_sq_Ts(i,ii,iii) =  i_c_rms_sq(i,ii,iii);
                i_c_frms_sq_Ts(i,iii) = sum(i_c_rms_sq_Ts(i,:,iii))/length(Theta_u_i);
                u_dc_rms_sq_fs(i,ii,iii) = u_dc_rms_sq(i,ii,iii) / fs_udc(i,ii,iii)^2;
                u_dc_frms_sq_fs(i,iii) = sum(u_dc_rms_sq_fs(i,:,iii))/length(Theta_u_i);
                u_dc_rms_sq_Ts(i,ii,iii) =  u_dc_rms_sq(i,ii,iii) * Ts_udc(i,ii,iii)^2;
                u_dc_frms_sq_Ts(i,iii) = sum(u_dc_rms_sq_Ts(i,:,iii))/length(Theta_u_i);
            end
            lmd_rms_sq_fs(i,ii) = lmd_rms_sq(i,ii) / fs_lmd(i,ii)^2;
            lmd_frms_sq_fs(i) = sum(lmd_rms_sq_fs(i, :))/length(Theta_u_i)*288/pi^2;
            lmd_rms_sq_Ts(i,ii) =  lmd_rms_sq(i,ii) * Ts_lmd(i,ii)^2;
            lmd_frms_sq_Ts(i) = sum(lmd_rms_sq_Ts(i, :))/length(Theta_u_i)*288/pi^2;
        end
    
    %---------------------------------------------------
    % Second Overmodulation region
    %---------------------------------------------------    
    elseif(M_i(i) > 0.952 && M_i(i) < 1.000)
        modulated(i,:) = [0;diff(squeeze(dt_total(3,i,:)))];
        for ii = 1:length(Theta_u_i)
            for iii = 1:length(cosphi_i)
                    i_c_rms_sq_fs(i,ii,iii) = i_c_rms_sq(i,ii,iii);
                    i_c_rms_sq_Ts(i,ii,iii) =  i_c_rms_sq(i,ii,iii);
                if(modulated(i,ii) == 0 || modulated(i,ii)==1)
                    u_dc_rms_sq_fs(i,ii,iii) = u_dc_rms_sq(i,ii,iii);
                    u_dc_rms_sq_Ts(i,ii,iii) =  u_dc_rms_sq(i,ii,iii);
                    lmd_rms_sq_fs(i,ii) = lmd_rms_sq(i,ii);
                    lmd_rms_sq_Ts(i,ii) =  lmd_rms_sq(i,ii);
                else
                    u_dc_rms_sq_fs(i,ii,iii) = u_dc_rms_sq(i,ii,iii) / fs_udc(i,ii,iii)^2;
                    u_dc_rms_sq_Ts(i,ii,iii) =  u_dc_rms_sq(i,ii,iii) * Ts_udc(i,ii,iii)^2;
                    lmd_rms_sq_fs(i,ii) = lmd_rms_sq(i,ii) / fs_lmd(i,ii)^2;
                    lmd_rms_sq_Ts(i,ii) =  lmd_rms_sq(i,ii) * Ts_lmd(i,ii)^2;
                end
            end
        end
    
    %---------------------------------------------------
    % Third Overmodulation region
    %---------------------------------------------------
    elseif(M_i(i) == 1.000)
        for ii = 1:length(Theta_u_i)
            for iii = 1:length(cosphi_i)
                i_c_rms_sq_fs(i,ii,iii) = i_c_rms_sq(i,ii,iii);
                i_c_rms_sq_Ts(i,ii,iii) =  i_c_rms_sq(i,ii,iii);
                u_dc_rms_sq_fs(i,ii,iii) = u_dc_rms_sq(i,ii,iii);
                u_dc_rms_sq_Ts(i,ii,iii) =  u_dc_rms_sq(i,ii,iii);
                lmd_rms_sq_fs(i,ii) = lmd_rms_sq(i,ii);
                lmd_rms_sq_Ts(i,ii) =  lmd_rms_sq(i,ii);
            end
        end
    end
    
    %---------------------------------------------------
    % frms values
    %---------------------------------------------------
    i_c_frms_sq_fs(i,iii) = sum(i_c_rms_sq_fs(i,:,iii))/length(Theta_u_i);
    i_c_frms_sq_Ts(i,iii) = sum(i_c_rms_sq_Ts(i,:,iii))/length(Theta_u_i);
    u_dc_frms_sq_fs(i,iii) = sum(u_dc_rms_sq_fs(i,:,iii))/length(Theta_u_i);
    u_dc_frms_sq_Ts(i,iii) = sum(u_dc_rms_sq_Ts(i,:,iii))/length(Theta_u_i);
    lmd_frms_sq_fs(i) = sum(lmd_rms_sq_fs(i, :))/length(Theta_u_i)*288/pi^2;
    lmd_frms_sq_Ts(i) = sum(lmd_rms_sq_Ts(i, :))/length(Theta_u_i)*288/pi^2;
    
    %---------------------------------------------------
    % harmonic content
    %---------------------------------------------------
    if(exist('P_harmonic', 'var') == 1)
        lmd_frms_sq_fs(i) = lmd_frms_sq_fs(i)*P_harmonic(i);
        lmd_frms_sq_Ts(i) = lmd_frms_sq_Ts(i)*P_harmonic(i);
    end
        
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lmd.lmd_frms_sq_fs = lmd_frms_sq_fs;
lmd.lmd_frms_sq_Ts = lmd_frms_sq_Ts;
lmd.lmd_rms_sq_fs = lmd_rms_sq_fs;
lmd.lmd_rms_sq_Ts = lmd_rms_sq_Ts;

v_in.u_dc_frms_sq_fs = u_dc_frms_sq_fs;
v_in.u_dc_frms_sq_Ts = u_dc_frms_sq_Ts;
v_in.u_dc_rms_sq_fs = u_dc_rms_sq_fs;
v_in.u_dc_rms_sq_Ts = u_dc_rms_sq_Ts;

i_in.i_c_frms_sq_fs = i_c_frms_sq_fs;
i_in.i_c_frms_sq_Ts = i_c_frms_sq_Ts;
i_in.i_c_rms_sq_fs = i_c_rms_sq_fs;
i_in.i_c_rms_sq_Ts = i_c_rms_sq_Ts;

end