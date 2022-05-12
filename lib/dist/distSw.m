%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: distSw                                                            %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p] = distSw(v_in, inp, pwmPara, setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Inputs
%---------------------------------------------------
Theta_u_i = inp.Theta_u_i;
v_al_star = v_in.v_al + v_in.v_0;
kf = pwmPara.kf;
Vnorm = setup.normDC;

%---------------------------------------------------
% General
%---------------------------------------------------
cosphi_i = linspace(-pi/2,pi/2,length(Theta_u_i));
v_al_star = v_al_star(end/2,:);
kf = [kf,kf,kf,kf,kf,kf];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Preprocessing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Current
%---------------------------------------------------
I_a = zeros(length(cosphi_i),length(Theta_u_i));
for i = 1:length(cosphi_i)
    for ii = 1:length(Theta_u_i)
        I_a(i,ii) = setup.normIp*sin(Theta_u_i(ii)+cosphi_i(i));            % ideal current wavefrom
    end
end

%---------------------------------------------------
% Variables
%---------------------------------------------------
I_a_SVPWM = I_a;
P_loss = zeros(1,length(cosphi_i));
P_loss_SVPWM = zeros(1,length(cosphi_i));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% clamping
%---------------------------------------------------
[n_a, v_al_star] = createClamp(Theta_u_i, v_al_star, setup);

%---------------------------------------------------
% Calculating current wave form
%---------------------------------------------------
for i = 1:length(cosphi_i)
    for ii = 1:length(Theta_u_i)
        if((v_al_star(ii) > -0.5*Vnorm - 1e-5) && (v_al_star(ii) < -0.5*Vnorm + 1e-5)  || (v_al_star(ii) > 0.5*Vnorm - 1e-5) && (v_al_star(ii) < 0.5*Vnorm + 1e-5))
            I_a(i,ii) = 0;
        else
        end
    end
end

%---------------------------------------------------
% integral waveforms
%---------------------------------------------------
P_loss_rms_a = n_a.*abs(I_a).*kf(1,:);
for i = 1:length(cosphi_i)
    P_loss(i) = sum(P_loss_rms_a(i,:))/length(Theta_u_i);
    P_loss_SVPWM(i) = sum(abs(I_a_SVPWM(i,:)))/length(Theta_u_i);
end

%---------------------------------------------------
% normalisation
%---------------------------------------------------
SLF = P_loss./P_loss_SVPWM;
cosphi_SLF = cosphi_i;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p.SLF = SLF;
p.cosphi_SLF = cosphi_SLF;
p.P_loss_rms_a = P_loss_rms_a;

end