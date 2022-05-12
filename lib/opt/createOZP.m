function [I1,I2,I3] = createOZP(M_i,Theta_u_i,cosphi_i,setup)
%% Definitions and variables
R = 1;
f_s = setup.fs;                                                             % Carrier switching frequency in [1/s]
T_s = 1/f_s;                                                                % inverter state times in [s]
k = linspace(0,1,1000);                                                     % variation of inverter-zero-states
c = pi/3;                                                                   % substitution
k_f = 1.5;                                                                  % frequency division factor DPWM/CPWM

% tranformations    
Tc_inv=inv(2/3*[1,  -1/2,       -1/2;
                0,   sqrt(3)/2, -sqrt(3)/2;
                1/2, 1/2,        1/2]);                                     % inverse clark transformation
            
% prior-definitions variables
lmd_rms_sq       = zeros(length(M_i),length(Theta_u_i),length(k));          % rms value harmonic flux machine side
i_c_rms_sq       = zeros(length(M_i),length(Theta_u_i),length(k));          % rms value capacitor current
u_dc_rms_sq      = zeros(length(M_i),length(Theta_u_i),length(k));          % rms value capacitor voltage
lmd_rms_sq_min   = zeros(length(M_i),length(Theta_u_i));                    % minimum value rms harmonic flux machine side
i_c_rms_sq_min   = zeros(length(M_i),length(Theta_u_i));                    % minimum rms value capacitor current
u_dc_rms_sq_min  = zeros(length(M_i),length(Theta_u_i));                    % minimum rms value capacitor voltage
lmd_frms_sq      = zeros(length(M_i),length(k));                            % frms value harmonic flux machine side
i_c_frms_sq      = zeros(length(M_i),length(k));                            % frms value capacitor current
u_dc_frms_sq     = zeros(length(M_i),length(k));                            % frms value capacitor voltage
t1 = zeros(length(M_i),length(Theta_u_i));                                  % inverter-state-time t1
t2 = zeros(length(M_i),length(Theta_u_i));                                  % inverter-state-time t2
t07 = zeros(length(M_i),length(Theta_u_i));                                 % total inverter-zero-state-time
t7 = zeros(length(M_i),length(Theta_u_i),length(k));                        % inverter-state-time t7
t0 = zeros(length(M_i),length(Theta_u_i),length(k));                        % inverter-state-time t0
d1 = zeros(length(M_i),length(Theta_u_i),length(k));                        % normalised inverter-state-time d1
d2 = zeros(length(M_i),length(Theta_u_i),length(k));                        % normalised inverter-state-time d2
d7 = zeros(length(M_i),length(Theta_u_i),length(k));                        % normalised inverter-state-time d7
d0 = zeros(length(M_i),length(Theta_u_i),length(k));                        % normalised inverter-state-time d0
lmd_rms_sq_zero = zeros(length(M_i),length(Theta_u_i),length(k));           % analytic solution rms flux value zero-inverter-state
lmd_rms_sq_active1 = zeros(length(M_i),length(Theta_u_i),length(k));        % analytic solution rms flux value active1-inverter-state
lmd_rms_sq_active2 = zeros(length(M_i),length(Theta_u_i),length(k));        % analytic solution rms flux value active2-inverter-state
I1 = zeros(length(M_i),length(Theta_u_i));                                  % optimised inverter-zero-ratios machine side
I2 = zeros(length(M_i),length(Theta_u_i));                                  % optimised inverter-zero-ratios capacitor voltage
I3 = zeros(length(M_i),length(Theta_u_i));                                  % optimised inverter-zero-ratios capacitor current


            
%% Calculations
% Inverter state time lengths
for i = 1:length(M_i)
    for ii = 1:length(Theta_u_i)
        for iii = 1:length(k)
        
            % prior calculations
            Theta_i = Theta_u_i(ii)-acos(cosphi_i(1));
        
            % inverter state times
            t1(i,ii) = (2*sqrt(3))/pi * M_i(i) * (sin(R*(pi/3) - Theta_u_i(ii))).*T_s;
            t2(i,ii) = (2*sqrt(3))/pi * M_i(i) * (sin(Theta_u_i(ii) - (R-1)*(pi/3))).*T_s;
            t07(i,ii) = T_s - t1(i,ii) - t2(i,ii);
            t0(i,ii,iii) = t07(i,ii).*k(iii);
            t7(i,ii,iii) = t07(i,ii).*(1-k(iii));

            % Normalised state times
            d0(i,ii,iii) = t0(i,ii,iii)/T_s;
            d1(i,ii,iii) = t1(i,ii)/T_s;
            d2(i,ii,iii) = t2(i,ii)/T_s;
            d7(i,ii,iii) = t7(i,ii,iii)/T_s;
            dt_total = [0,d0(i,ii,iii),d0(i,ii,iii)+d1(i,ii),1-d7(i,ii,iii),1+d7(i,ii,iii),1+d7(i,ii,iii)+d2(i,ii),2-d0(i,ii,iii),2]';
            
            % flux calculation
            lmd_rms_sq_zero(i,ii,iii) = (1/3*M_i(i)^2*(d0(i,ii,iii)^3 + d7(i,ii,iii)^3));
            lmd_rms_sq_active1(i,ii,iii) = 1/3*(c^2+M_i(i)^2)*d2(i,ii)^3 + M_i(i)^2*d2(i,ii)*...
                                          d7(i,ii,iii)*(d7(i,ii,iii) + d2(i,ii)) - d2(i,ii)^2*c^2*...
                                          (d1(i,ii)/2 + d2(i,ii))*(2/3*d2(i,ii)+d7(i,ii,iii));
            lmd_rms_sq_active2(i,ii,iii) = 1/3*c^2*d1(i,ii)^3*(1-d1(i,ii))^2 + c^2*...
                                          d2(i,ii)^2*d0(i,ii,iii)*d1(i,ii)*(d0(i,ii,iii)+d1(i,ii)) -...
                                          c^2*d0(i,ii,iii)*d1(i,ii)^3*(1-d1(i,ii)-d0(i,ii,iii)) -...
                                          1/3*c^2*d1(i,ii)^3*d2(i,ii)*(1-d1(i,ii)-d2(i,ii))+...
                                          1/2*c^2*d0(i,ii,iii)*d1(i,ii)^2*d2(i,ii)*...
                                          (2*d0(i,ii,iii)-1+2*d1(i,ii));

            
            % calculations current
            i_ph = Tc_inv*[cos(Theta_i);sin(Theta_i); 0];                       % phase current
            i_dc = [0, i_ph(1), -i_ph(3),0,  -i_ph(3),i_ph(1),   0,    0];      % dc link current

            % dc-link calculations
            u_dc_h = u_dc(i_dc, dt_total);
            
            % rms values
            if(k(iii) == 0 || k(iii) == 1)
                lmd_rms_sq(i,ii,iii) = (lmd_rms_sq_zero(i,ii,iii) + lmd_rms_sq_active1(i,ii,iii) + lmd_rms_sq_active2(i,ii,iii))/k_f^2;
                u_dc_rms_sq(i,ii,iii) = lamda_rms_sq(u_dc_h, dt_total)/k_f^2;
                i_c_rms_sq(i,ii,iii)  = function_idc_rms_sq(i_dc, dt_total)/k_f^2;
            else
                lmd_rms_sq(i,ii,iii) = (lmd_rms_sq_zero(i,ii,iii) + lmd_rms_sq_active1(i,ii,iii) + lmd_rms_sq_active2(i,ii,iii));
                u_dc_rms_sq(i,ii,iii) = lamda_rms_sq(u_dc_h, dt_total);
                i_c_rms_sq(i,ii,iii)  = function_idc_rms_sq(i_dc, dt_total);
            end
            
            % frms values
            if(ii == length(Theta_u_i))
                lmd_frms_sq(i,iii) = sum(lmd_rms_sq(i,:,iii))/length(Theta_u_i)*288/pi^2;
                i_c_frms_sq(i,iii) = sum(i_c_rms_sq(i, :, iii))/length(Theta_u_i);
                u_dc_frms_sq(i,iii)= sum(u_dc_rms_sq(i, :, iii))/length(Theta_u_i);
            end

        end
    end
end

%% Optimisation
% finding optimal values
for i = 1:length(M_i)
    for ii = 1:length(Theta_u_i)
        [lmd_rms_sq_min(i,ii),I1(i,ii)] = min(lmd_rms_sq(i,ii,:));
        [u_dc_rms_sq_min(i,ii),I2(i,ii)] = min(u_dc_rms_sq(i,ii,:));
        [i_c_rms_sq_min(i,ii),I3(i,ii)] = min(i_c_rms_sq(i,ii,:));
    end
end

% recreating zero patterns
I1(I1==1)=0;
I2(I2==1)=0;
I3(I3==1)=0;
I1 = I1/length(k);
I2 = I2/length(k);
I3 = I3/length(k);

end

