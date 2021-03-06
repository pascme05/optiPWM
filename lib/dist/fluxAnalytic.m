%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: fluxNumeric                                                       %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ lambda_rms_sq, lambda_frms_sq ] = fluxAnalytic(P_harmonic,M_i,theta_u_i,kf,setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = sin(pi/3 + theta_u_i);
b = sin(pi/3 - theta_u_i);
lambda_frms_sq = zeros(length(M_i), 1);
lambda_rms_sq = zeros(length(M_i), length(theta_u_i));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------
% Coefficients
%--------------------------------------------------
if(setup.SEQ == 127)
    C0 = 1/12;
    C1 = (1/(3*sqrt(3)))*((32/9)*(a.*b.^4 + a.^3.*b.^2 - a.^2.*b.^3)+...
          (2/3)*(-2*b.^3 - 3*a.*b.^2 - a.^2.*b) + b-a);
    C2 = 1/9 * (4/3*(a.^3.*b - 2*a.*b.^3 - a.^2.*b.^2) + a.^2 + 4*b.^2 - 2*a.*b);
elseif(setup.SEQ == 12)
    C0 = 1/3;
    C1 = (1/(3*sqrt(3)))*((8/3)*a.^3 + 4*a.*b.^2 - 8*a.^2.*b - 4*b.^3 - 6*a + 6*b);
    C2 = 4/3 * (2/9*(-15*a.^2.*b.^2 + 11*a.*b.^3 + 14*a.^3.*b - 4*a.^4 - 4*b.^4) + (a-b).^2);
elseif(setup.SEQ == 721)
    a = sin(pi/3 + (pi/3 - theta_u_i));
    b = sin(pi/3 - (pi/3 - theta_u_i));
    C0 = 1/3;
    C1 = (1/(3*sqrt(3)))*((8/3)*a.^3 + 4*a.*b.^2 - 8*a.^2.*b - 4*b.^3 - 6*a + 6*b);
    C2 = 4/3 * (2/9*(-15*a.^2.*b.^2 + 11*a.*b.^3 + 14*a.^3.*b - 4*a.^4 - 4*b.^4) + (a-b).^2);
elseif(setup.SEQ == 121)
    C0 = 1/3;
    C1 = (1/(9*sqrt(3)))*(-b.^3 - a.*b.^2 - 2*a.^2.*b - 12*a + 3*b);
    C2 = 1/9 * (2/3*(a.^2.*b.^2 - a.*b.^3 + 2*a.^3.*b) + (4*a.^2 - 2*a.*b + b.^2));
elseif(setup.SEQ == 7212)
    a = sin(pi/3 + (pi/3 - theta_u_i));
    b = sin(pi/3 - (pi/3 - theta_u_i));
    C0 = 1/3;
    C1 = (1/(9*sqrt(3)))*(-b.^3 - a.*b.^2 - 2*a.^2.*b - 12*a + 3*b);
    C2 = 1/9 * (2/3*(a.^2.*b.^2 - a.*b.^3 + 2*a.^3.*b) + (4*a.^2 - 2*a.*b + b.^2));
elseif(setup.SEQ == 1012)
    C0 = 1/3*(1 - a.*b);
    C1 = (2/(27*sqrt(3)))*(16*a.^5 - 2*b.^5 + 20*a.*b.^4 - 56*a.^4.*b + 74*a.^3.*b.^2- ...
          60*a.^2.*b.^3 + 24*a.^2.*b - 3*a.*b.^2 - 9*b.^3 + 18*b -27*a);
    C2 = (1/9)*((2/3)*(-16*a.^4 - 6*b.^4 + 38*a.^3.*b + 25*a.*b.^3 - 41*a.^2.*b.^2)+ ...
          12*a.^2 - 18*a.*b + 7*b.^2);  
elseif(setup.SEQ == 2721)
    a = sin(pi/3 + (pi/3 - theta_u_i));
    b = sin(pi/3 - (pi/3 - theta_u_i));
    C0 = 1/3*(1 - a.*b);
    C1 = (2/(27*sqrt(3)))*(16*a.^5 - 2*b.^5 + 20*a.*b.^4 - 56*a.^4.*b + 74*a.^3.*b.^2- ...
          60*a.^2.*b.^3 + 24*a.^2.*b - 3*a.*b.^2 - 9*b.^3 + 18*b -27*a);
    C2 = (1/9)*((2/3)*(-16*a.^4 - 6*b.^4 + 38*a.^3.*b + 25*a.*b.^3 - 41*a.^2.*b.^2)+ ...
          12*a.^2 - 18*a.*b + 7*b.^2);    
end

%--------------------------------------------------
% RMS Flux
%--------------------------------------------------
for i = 1:length(M_i)
    lambda_rms_sq(i,:) =  (C0*M_i(i)^2 + C1*M_i(i)^3 + C2*M_i(i)^4);
    lambda_frms_sq(i) = sum(lambda_rms_sq(i,:))/length(theta_u_i)*(288/pi^2);
end

%--------------------------------------------------
% Scaling according to number of switchings
%--------------------------------------------------
lambda_rms_sq = lambda_rms_sq/kf(1,1)^2;
lambda_frms_sq = lambda_frms_sq/kf(1,1)^2;

%--------------------------------------------------
% Harmonic Content
%--------------------------------------------------
lambda_frms_sq = lambda_frms_sq.*P_harmonic;
end