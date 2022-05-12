%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: createClamp                                                       %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [n_a,v_al_star] = createClamp(Theta_u_i,v_al_star,setup)
    %---------------------------------------------------
    % 0127
    %---------------------------------------------------
    if(setup.SEQ == 127)
        psi = -length(v_al_star)/4;
        n_a = ones(1,length(Theta_u_i));
    %---------------------------------------------------
    % 012
    %---------------------------------------------------
    elseif(setup.SEQ == 12)
        psi = 0;
        n_a = ones(1,length(Theta_u_i));
    %---------------------------------------------------
    % 721
    %---------------------------------------------------
    elseif(setup.SEQ == 721)
        psi = 0;
        n_a = ones(1,length(Theta_u_i));
    %---------------------------------------------------
    % 0121
    %---------------------------------------------------
    elseif(setup.SEQ == 121)
        psi = length(v_al_star)/6;
        n_a = [2*ones(1,length(Theta_u_i)/12),ones(1,length(Theta_u_i)/3),...
               2*ones(1,length(Theta_u_i)/6),ones(1,length(Theta_u_i)/3),...
               2*ones(1,length(Theta_u_i)/12)];
        n_a = fliplr(n_a);
    %---------------------------------------------------
    % 7212
    %---------------------------------------------------
    elseif(setup.SEQ == 7212)
        psi = -length(v_al_star)/6;
        n_a = [2*ones(1,length(Theta_u_i)/12),ones(1,length(Theta_u_i)/3),...
               2*ones(1,length(Theta_u_i)/6),ones(1,length(Theta_u_i)/3),...
               2*ones(1,length(Theta_u_i)/12)];
    %---------------------------------------------------
    % 1012
    %---------------------------------------------------
    elseif(setup.SEQ == 1012)
        psi = length(v_al_star)/6;
        n_a = [ones(1,length(Theta_u_i)/12),2*ones(1,length(Theta_u_i)/6),...
               ones(1,length(Theta_u_i)/3),2*ones(1,length(Theta_u_i)/6),...
               ones(1,length(Theta_u_i)/4)];
        n_a = fliplr(n_a);
    %---------------------------------------------------
    % 2721
    %---------------------------------------------------
    elseif(setup.SEQ == 2721)
        psi = -length(v_al_star)/6;
        n_a = [ones(1,length(Theta_u_i)/12),2*ones(1,length(Theta_u_i)/6),...
               ones(1,length(Theta_u_i)/3),2*ones(1,length(Theta_u_i)/6),...
               ones(1,length(Theta_u_i)/4)];
    end
    v_al_star = circshift(v_al_star,psi);
end