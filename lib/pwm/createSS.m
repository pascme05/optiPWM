%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: invNorm                                                           %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pwmPara] = createSS(inp, setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Inputs
%---------------------------------------------------
M_i = inp.M_i;
theta_u_i = inp.theta_u_i;
cosphi_i = inp.cosphi_i;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(setup.SEQ == 127) %0127
        if(strcmp(setup.MOD,'SVPWM'))
            k = 0.5*ones(length(M_i),length(theta_u_i));                            % k=0 -> d0=0 | k=1 -> d7=0
            k_total = [k,fliplr(k),k,fliplr(k),k,fliplr(k)];
        elseif(strcmp(setup.MOD,'DPWM0'))
            k = 0*ones(length(M_i),length(theta_u_i));                              % k=0 -> d0=0 | k=1 -> d7=0
            k1 = 1*ones(length(M_i),length(theta_u_i));                              % k=0 -> d0=0 | k=1 -> d7=0
            k_total = [k,k1,k,k1,k,k1];
        elseif(strcmp(setup.MOD,'DPWM1'))
            k = 1*ones(length(M_i),length(theta_u_i));                              % k=0 -> d0=0 | k=1 -> d7=0
            k(:,theta_u_i<pi/6,:)=0;
            k_total = [k,fliplr(k),k,fliplr(k),k,fliplr(k)];
        elseif(strcmp(setup.MOD,'DPWM2'))
            k = 1*ones(length(M_i),length(theta_u_i));                              % k=0 -> d0=0 | k=1 -> d7=0
            k1 = 0*ones(length(M_i),length(theta_u_i));                              % k=0 -> d0=0 | k=1 -> d7=0
            k_total = [k,k1,k,k1,k,k1];
        elseif(strcmp(setup.MOD,'DPWM3'))
            k = 1*ones(length(M_i),length(theta_u_i));                              % k=0 -> d0=0 | k=1 -> d7=0
            k(:,theta_u_i>pi/6,:)=0;
            k_total = [k,fliplr(k),k,fliplr(k),k,fliplr(k)];
        elseif(strcmp(setup.MOD,'DPWMMIN'))
            k = 1*ones(length(M_i),length(theta_u_i));                              % k=0 -> d0=0 | k=1 -> d7=0
            k_total = [k,fliplr(k),k,fliplr(k),k,fliplr(k)];
        elseif(strcmp(setup.MOD,'DPWMMAX'))
            k = 0*ones(length(M_i),length(theta_u_i));                              % k=0 -> d0=0 | k=1 -> d7=0
            k_total = [k,fliplr(k),k,fliplr(k),k,fliplr(k)];
        elseif(strcmp(setup.MOD,'OZP'))
            [I1,~,~] = createOZP(M_i, theta_u_i, cosphi_i(end), setup);
            % machine side
            k = I1;
            % DC-Link
            %k = I2;
            k_total = [k,fliplr(k),k,fliplr(k),k,fliplr(k)];
        end
    elseif(setup.SEQ == 12) %012
        k = 1*ones(length(M_i),length(theta_u_i));                              % k=0 -> d0=0 | k=1 -> d7=0
        k1 = 0*ones(length(M_i),length(theta_u_i));                              % k=0 -> d0=0 | k=1 -> d7=0
        k_total = [k,k1,k,k1,k,k1];
    elseif(setup.SEQ == 721) %721
        k = 0*ones(length(M_i),length(theta_u_i));                              % k=0 -> d0=0 | k=1 -> d7=0
        k1 = 1*ones(length(M_i),length(theta_u_i));                              % k=0 -> d0=0 | k=1 -> d7=0
        k_total = [k,k1,k,k1,k,k1];
    elseif(setup.SEQ == 121) %0121
        k = 1*ones(length(M_i),length(theta_u_i));
        k(:,theta_u_i<pi/6,:)=0;
        k_total = [k,fliplr(k),k,fliplr(k),k,fliplr(k)];
    elseif(setup.SEQ == 7212) %7212
        k = 0*ones(length(M_i),length(theta_u_i));
        k(:,theta_u_i>pi/6,:)=1;
        k_total = [k,fliplr(k),k,fliplr(k),k,fliplr(k)];
    elseif(setup.SEQ == 1012) %1012
        k = 1*ones(length(M_i),length(theta_u_i));
        k(:,theta_u_i<pi/6,:)=0;
        k_total = [k,fliplr(k),k,fliplr(k),k,fliplr(k)];
    elseif(setup.SEQ == 2721) %2721
        k = 0*ones(length(M_i),length(theta_u_i));
        k(:,theta_u_i>pi/6,:)=1;
        k_total = [k,fliplr(k),k,fliplr(k),k,fliplr(k)];
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pwmPara.k = k; 
pwmPara.k_total = k_total;
end