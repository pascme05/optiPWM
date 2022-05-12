%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: distDc                                                            %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [i_c_rms_sq, i_c_frms_sq, u_dc_rms_sq, u_dc_frms_sq, dt_total, u_dc_total, i_dc_total, i_ph_total] = distDc(R,M_i,Theta_u_i,cosphi_i,d,k,k_f,setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% General
%---------------------------------------------------
Theta_over       = zeros(length(M_i),1);                                    
i_c_frms_sq      = zeros(length(M_i), length(cosphi_i));
u_dc_frms_sq     = zeros(length(M_i), length(cosphi_i));
i_c_rms_sq       = zeros(length(M_i), length(Theta_u_i), length(cosphi_i));
i_dc_total = zeros(length(M_i), length(Theta_u_i), length(cosphi_i), 8);
u_dc_total = zeros(length(M_i), length(Theta_u_i), length(cosphi_i), 8);
i_ph_total = zeros(length(M_i), length(Theta_u_i), length(cosphi_i), 3);
u_dc_rms_sq      = zeros(length(M_i), length(Theta_u_i), length(cosphi_i));

%---------------------------------------------------
% transformations
%---------------------------------------------------
Tc_inv=inv(2/3*[1,  -1/2,       -1/2;
                0,   sqrt(3)/2, -sqrt(3)/2;
                1/2, 1/2,        1/2]);                                     % inverse clark transformation            

%---------------------------------------------------
% Select on times
%---------------------------------------------------
if R == 1
    dt_total = d.R1.dt_total;
elseif R == 2
    dt_total = d.R2.dt_total;
elseif R == 3
    dt_total = d.R3.dt_total;
elseif R == 4
    dt_total = d.R4.dt_total;
elseif R == 5
    dt_total = d.R5.dt_total;
else
    dt_total = d.R6.dt_total;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculations Currents and Voltages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(M_i)
   for ii = 1:length(Theta_u_i)     
       for iii = 1:length(cosphi_i)
            %---------------------------------------------------
            % prior calculations
            %---------------------------------------------------
            if(M_i(i) < 0.952)
                Theta_i = Theta_u_i(ii) - acos(cosphi_i(iii));
            else
                Theta_i = Theta_over(i) - acos(cosphi_i(iii));
            end
            
            %---------------------------------------------------
            % calculations current
            %---------------------------------------------------
            i_ph = setup.normIp*Tc_inv*[cos(Theta_i);sin(Theta_i); 0];
            [i_dc] = createIdc(R,i_ph,setup);
            i_dc_total(i,ii,iii,:) = i_dc;
            i_ph_total(i,ii,iii,:) = i_ph;
            
            %---------------------------------------------------
            % calculations voltage
            %---------------------------------------------------
            u_dc_h = (1/setup.C)*u_dc(i_dc, dt_total(:,i,ii));
            u_dc_total(i,ii,iii,:) = u_dc_h;
        
            %---------------------------------------------------
            % rms calculation
            %---------------------------------------------------
            if(k(i,ii) == 0.0 || k(i,ii) == 1)
                u_dc_rms_sq(i,ii,iii) = lamda_rms_sq(u_dc_h, dt_total(:,i,ii))/k_f(i,ii)^2;
                [i_c_rms_sq(i,ii,iii)] = function_idc_rms_sq(i_dc, dt_total(:,i,ii))/k_f(i,ii)^2;
            else
                u_dc_rms_sq(i,ii,iii) = lamda_rms_sq(u_dc_h, dt_total(:,i,ii));
                [i_c_rms_sq(i,ii,iii)]  = function_idc_rms_sq(i_dc, dt_total(:,i,ii));
            end
       end
   end
   
   %---------------------------------------------------
   % frms calculation
   %---------------------------------------------------
   i_c_frms_sq(i,:)  = sum(i_c_rms_sq(i, :, :))/length(Theta_u_i);
   u_dc_frms_sq(i,:) = sum(u_dc_rms_sq(i, :, :))/length(Theta_u_i);
   
end
end