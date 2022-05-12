%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: pwmOM                                                             %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [t0, t1, t2, t7, k_f] = pwmOM(M_i, Theta_u_i, t07, R, setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_s = 1/setup.fs;                                                           % Carrier switching time in [s]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------
% First Region
%--------------------------------------------------
if(t07 < 0 && M_i > pi/(sqrt(3)*2) && M_i < 0.952)
    t1 = ((sqrt(3)*cos(Theta_u_i-(R-1)*pi/3) - sin(Theta_u_i-(R-1)*pi/3))./(sqrt(3)*cos(Theta_u_i-(R-1)*pi/3) + sin(Theta_u_i-(R-1)*pi/3))).*T_s;
    t2 = T_s - t1;
    t0 = 0;
    t7 = 0;
    k_f = 2.0;
end

%--------------------------------------------------
% Second Region
%--------------------------------------------------
if(t07 < 0 && M_i >= 0.952 && M_i < 1.000)
    if(M_i < 0.980)
        Theta_h = 6.40*M_i - 6.09;
    elseif(M_i >= 0.980 && M_i < 0.9975)
        Theta_h = 11.75*M_i - 11.34;
    elseif(M_i >= 0.9975 && M_i < 1.000)
        Theta_h = 48.96*M_i - 48.43;
    end

    if(Theta_u_i <= (Theta_h + (R-1)*pi/3))
        Theta_over = (R-1)*pi/3;
        k_f = 1.0;
    elseif(Theta_u_i > (Theta_h + (R-1)*pi/3) && Theta_u_i <= (R*pi/3 - Theta_h))
        Theta_over = (R-1)*pi/3 + (pi/6)*((Theta_u_i - (Theta_h + (R-1)*pi/3))/(pi/6 - Theta_h));
        k_f = 2.0;
    elseif(Theta_u_i > (R*pi/3 - Theta_h))
        Theta_over = R*pi/3;
        k_f = 1.0;
    end

    t1 = ((sqrt(3)*cos(Theta_over-(R-1)*(pi/3)) - sin(Theta_over - (R-1)*(pi/3)))/(sqrt(3)*cos(Theta_over-(R-1)*(pi/3)) + sin(Theta_over - (R-1)*(pi/3))))*T_s;
    t2 = T_s - t1;
    t0 = 0;
    t7 = 0;
end

%--------------------------------------------------
% Third Region
%--------------------------------------------------
if(M_i == 1.000)
    if(M_i < 0.980)
        Theta_h = 6.40*M_i - 6.09;
    elseif(M_i >= 0.980 && M_i < 0.9975)
        Theta_h = 11.75*M_i - 11.34;
    elseif(M_i >= 0.9975 && M_i < 1.000)
        Theta_h = 48.96*M_i - 48.43;
    elseif(M_i == 1.000)
        Theta_h = pi/6;
    end

    if(Theta_u_i <= (Theta_h + (R-1)*pi/3))
        Theta_over = (R-1)*pi/3;
    elseif(Theta_u_i > (Theta_h + (R-1)*pi/3) && Theta_u_i <= (R*pi/3 - Theta_h))
        Theta_over = (R-1)*pi/3 + (pi/6)*((Theta_u_i - (Theta_h + (R-1)*pi/3))/(pi/6 - Theta_h));
    elseif(Theta_u_i > (R*pi/3 - Theta_h))
        Theta_over = R*pi/3;
    end

    t1 = ((sqrt(3)*cos(Theta_over-(R-1)*(pi/3)) - sin(Theta_over - (R-1)*(pi/3)))/(sqrt(3)*cos(Theta_over-(R-1)*(pi/3)) + sin(Theta_over - (R-1)*(pi/3))))*T_s;
    t2 = T_s - t1;
    t0 = 0;
    t7 = 0;
    k_f = 1.0;
end

%--------------------------------------------------
% Fourth Region
%--------------------------------------------------
if(M_i > 1.000)
   if(t07 < 0)
        t_ges = (t1+t2);
        t1 = T_s*t1/t_ges;
        t2 = T_s*t2/t_ges;
        t0 = 0;
        t7 = 0; 
   elseif(Theta_u_i < pi/6 + (R-1)*pi/3)
        t1 = T_s*1;
        t2 = 0;
        t0 = 0;
        t7 = 0;
   elseif(Theta_u_i > (pi/3-pi/6) + (R-1)*pi/3)
        t1 = 0;
        t2 = T_s*1;
        t0 = 0;
        t7 = 0;
   end
end

end