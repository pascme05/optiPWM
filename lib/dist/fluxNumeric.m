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
function [lmd_rms_sq, lmd_frms_sq,lambda_h_total] = fluxNumeric(R,R_val,P_harmonic,M_i,Theta_u_i,k_f,d,k,setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Inits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Init pwm times
%---------------------------------------------------
d0 = squeeze(d.(R).ds(:,:,1));
d1 = squeeze(d.(R).ds(:,:,2));
d2 = squeeze(d.(R).ds(:,:,3));
d7 = squeeze(d.(R).ds(:,:,4));
dt = d.(R).dt;

%---------------------------------------------------
% prior-definitions variables
%---------------------------------------------------
lmd_frms_sq      = zeros(length(M_i), 1);
lmd_rms_sq       = zeros(length(M_i), length(Theta_u_i));
lambda_h_al = zeros(length(M_i),length(Theta_u_i),5);
lambda_h_be = zeros(length(M_i),length(Theta_u_i),5);
lambda_rms_sq_al = zeros(length(M_i),length(Theta_u_i),5);
lambda_rms_sq_be = zeros(length(M_i),length(Theta_u_i),5);
lambda_h = zeros(length(M_i),length(Theta_u_i),5);
lambda_h_total = zeros(length(M_i),length(Theta_u_i)*5);

%---------------------------------------------------
% Transforms
%---------------------------------------------------
Tc_inv=inv(2/3*[1,  -1/2,       -1/2;
                0,   sqrt(3)/2, -sqrt(3)/2;
                1/2, 1/2,        1/2]);                                     % inverse clark transformation  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(M_i)
    for ii = 1:length(Theta_u_i)
                
        %--------------------------------------------------
        % definitions for numeric solution
        %--------------------------------------------------
        [slope_al,slope_be,y_axis_al,y_axis_be] = createLmd(R_val, M_i(i), Theta_u_i(ii), d0(i,ii), d1(i,ii), d2(i,ii), d7(i,ii), setup);
            
        %--------------------------------------------------
        % lambda_h
        %--------------------------------------------------
        lmd_abc = zeros(5,3);
        for iii = 2:length(slope_al)+1
            lambda_h_al(i,ii,iii) = slope_al(iii-1).*dt(i,ii,iii) + y_axis_al(iii-1); 
            lambda_h_be(i,ii,iii) = slope_be(iii-1).*dt(i,ii,iii) + y_axis_be(iii-1);
            lmd_abc(iii,:) = Tc_inv*[lambda_h_al(i,ii,iii);lambda_h_be(i,ii,iii); 0];
        end 
        lambda_h(i,ii,:) = sqrt(lambda_h_al(i,ii,:).^2 + lambda_h_be(i,ii,:).^2);
        lambda_h_total(i,(ii-1)*5+1:ii*5) = lmd_abc(:,1);
        
        %--------------------------------------------------
        % alha-beta rms flux
        %--------------------------------------------------
        [lambda_rms_sq_al(i,ii)] = lamda_rms_sq(squeeze(lambda_h_al(i,ii,:)), dt(i,ii,:));
        [lambda_rms_sq_be(i,ii)] = lamda_rms_sq(squeeze(lambda_h_be(i,ii,:)), dt(i,ii,:));

        %--------------------------------------------------
        % considering frequency factor
        %--------------------------------------------------
        if(k(i,ii) == 0.0 || k(i,ii) == 1)
            lmd_rms_sq(i,ii) = (sum(lambda_rms_sq_al(i,ii,:)) + sum(lambda_rms_sq_be(i,ii,:)))/k_f(i,ii)^2;
        else
            lmd_rms_sq(i,ii) = (sum(lambda_rms_sq_al(i,ii,:)) + sum(lambda_rms_sq_be(i,ii,:)));
        end
    
    end
    
    %-------------------------------------------------- 
    % frms calculation
    %--------------------------------------------------
    lmd_frms_sq(i)    = sum(lmd_rms_sq(i, :))/length(Theta_u_i)*288/pi^2;
   
end
lmd_frms_sq = lmd_frms_sq.*P_harmonic;

end