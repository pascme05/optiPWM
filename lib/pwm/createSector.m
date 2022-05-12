%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: createSector                                                      %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [R] = createSector(R,Theta_u_i)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Definitions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v_c_be = sin(Theta_u_i);                                                    % arbitrary beta voltage
v_c_al = cos(Theta_u_i);                                                    % arbitrary alpha voltage
v_c = sqrt(v_c_al.^2 + v_c_be.^2);                                          % amplitude arbitrary phase voltage
Theta_0 = asin(v_c_be./v_c);                                                % phase arbitrary phase voltage

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Precalculation of Theta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% determine Theta
%---------------------------------------------------
for i = 1:length(Theta_0)
    if(v_c_al(i) >= 0 && v_c_be(i) >= 0)
        Theta_u_i(i) = Theta_0(i);
    elseif(v_c_al(i) >= 0 && v_c_be(i) < 0)
        Theta_u_i(i) = 2*pi + Theta_0(i);
    elseif(v_c_al(i) < 0)
        Theta_u_i(i) = pi - Theta_0(i);
    end
end

%---------------------------------------------------
% determine sector
%---------------------------------------------------
for i = 1:length(Theta_u_i)
    if(Theta_u_i(i) <= pi/3)
        R(i) = 1;
    elseif(Theta_u_i(i) > pi/3 && Theta_u_i(i) <= 2/3*pi)
        R(i) = 2;
    elseif(Theta_u_i(i) > 2/3*pi && Theta_u_i(i) <= pi)
        R(i) = 3;
    elseif(Theta_u_i(i) > pi && Theta_u_i(i) <= 4/3*pi)
        R(i) = 4;
    elseif(Theta_u_i(i) > 4/3*pi && Theta_u_i(i) <= 5/3*pi)
        R(i) = 5;
    elseif(Theta_u_i(i) > 5/3*pi && Theta_u_i(i) <= 2*pi)
        R(i) = 6;
    end
end
end