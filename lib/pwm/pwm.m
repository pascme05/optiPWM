%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: pwm                                                               %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pwmPara, v_out] = pwm(inp, pwmPara, setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Inputs
%---------------------------------------------------
R = inp.R;
M_i = inp.M_i;
Theta_u_i = inp.Theta_u_i;
k = pwmPara.k_total;

%---------------------------------------------------
% General
%---------------------------------------------------
T_s = 1/setup.fs;                                                           % Carrier switching time in [s]
k_f = ones(length(M_i),length(Theta_u_i));                                  % frequency division factor according to [1]
v_al = zeros(length(M_i),length(Theta_u_i));                                % alpha voltage 
v_be = zeros(length(M_i),length(Theta_u_i));                                % beta voltage
v_0 = zeros(length(M_i),length(Theta_u_i));                                 % zero voltage

%---------------------------------------------------
% Pwm times
%---------------------------------------------------
t1 = zeros(length(M_i),length(Theta_u_i));
t2 = zeros(length(M_i),length(Theta_u_i));
t7 = zeros(length(M_i),length(Theta_u_i));
t07 = zeros(length(M_i),length(Theta_u_i));
t0 = zeros(length(M_i),length(Theta_u_i));
d1 = zeros(length(M_i),length(Theta_u_i));
d2 = zeros(length(M_i),length(Theta_u_i));
d7 = zeros(length(M_i),length(Theta_u_i));
d0 = zeros(length(M_i),length(Theta_u_i));
dt = zeros(length(M_i),length(Theta_u_i),5);
ds = zeros(length(M_i),length(Theta_u_i),4);
dt_total = zeros(8,length(M_i),length(Theta_u_i));

%---------------------------------------------------
% tranformations
%---------------------------------------------------
Tc = zeros(2,2,6);                                                          % pre-allocation for clark-transforms R(iii)=1-6
Tc(:,:,1) = [1 0.5; 0 sqrt(3)/2];                                           % clark-transform R(iii)=1
Tc(:,:,2) = [0.5 -0.5; sqrt(3)/2 sqrt(3)/2];                                % clark-transform R(iii)=2
Tc(:,:,3) = [-0.5 -1; sqrt(3)/2 0];                                         % clark-transform R(iii)=3
Tc(:,:,4) = [-1 -0.5; 0 -sqrt(3)/2];                                        % clark-transform R(iii)=4
Tc(:,:,5) = [-0.5 0.5; -sqrt(3)/2 -sqrt(3)/2];                              % clark-transform R(iii)=5
Tc(:,:,6) = [0.5 1; -sqrt(3)/2 0];                                          % clark-transform R(iii)=6

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(M_i)
    for ii = 1:length(Theta_u_i)
        %--------------------------------------------------
        % Undermodulation
        %--------------------------------------------------
        [t0(i,ii), t1(i,ii), t2(i,ii), t7(i,ii), t07(i,ii), k_f(i,ii)] = pwmUM(M_i(i), Theta_u_i(ii), R(ii), k(i,ii), setup);

        %--------------------------------------------------
        % Overmodulation
        %--------------------------------------------------
        if t07(i,ii) < 0 && M_i(i) > pi/(sqrt(3)*2)  
            [t0(i,ii), t1(i,ii), t2(i,ii), t7(i,ii), k_f(i,ii)] = pwmOM(M_i(i), Theta_u_i(ii), t07(i,ii), R(ii), setup);
        end

        %--------------------------------------------------
        % Normalization
        %--------------------------------------------------
        d0(i,ii) = t0(i,ii)/T_s;
        d1(i,ii) = t1(i,ii)/T_s;
        d2(i,ii) = t2(i,ii)/T_s;
        d7(i,ii) = t7(i,ii)/T_s;

        %--------------------------------------------------
        % Voltages
        %--------------------------------------------------
        dt_v = [d1(i,ii);d2(i,ii)];
        v = setup.normDC*squeeze(Tc(:,:,R(ii)))*dt_v;
        v_al(i,ii) = 2/3*v(1);
        v_be(i,ii) = 2/3*v(2);
        v_0(i,ii) = setup.normDC*0.5*(-d0(i,ii)-(-1)^(R(ii)+1)*d1(i,ii)/3+(-1)^(R(ii)+1)*d2(i,ii)/3+d7(i,ii));

        %--------------------------------------------------
        % Switching Sequence
        %--------------------------------------------------
        [dt(i,ii,:),dt_total(:,i,ii),ds(i,ii,:)] = createSEQ(d0(i,ii),d1(i,ii),d2(i,ii),d7(i,ii),setup);
    
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------
% Sector R=1
%--------------------------------------------------
d.R1.d0 = d0(:,1:length(R)/6);
d.R1.d1 = d1(:,1:length(R)/6);
d.R1.d2 = d2(:,1:length(R)/6);
d.R1.d7 = d7(:,1:length(R)/6);
d.R1.dt = dt(:,1:length(R)/6,:);
d.R1.ds = ds(:,1:length(R)/6,:);
d.R1.dt_total = dt_total(:,:,1:length(R)/6);

%--------------------------------------------------
% Sector R=2
%--------------------------------------------------
d.R2.d0 = d0(:,1+length(R)/6:2*length(R)/6);
d.R2.d2 = d1(:,1+length(R)/6:2*length(R)/6);
d.R2.d3 = d2(:,1+length(R)/6:2*length(R)/6);
d.R2.d7 = d7(:,1+length(R)/6:2*length(R)/6);
d.R2.dt = dt(:,1+length(R)/6:2*length(R)/6,:);
d.R2.ds = ds(:,1+length(R)/6:2*length(R)/6,:);
d.R2.dt_total = dt_total(:,:,1+length(R)/6:2*length(R)/6);

%--------------------------------------------------
% Sector R=3
%--------------------------------------------------
d.R3.d0 = d0(:,1+2*length(R)/6:3*length(R)/6);
d.R3.d3 = d1(:,1+2*length(R)/6:3*length(R)/6);
d.R3.d4 = d2(:,1+2*length(R)/6:3*length(R)/6);
d.R3.d7 = d7(:,1+2*length(R)/6:3*length(R)/6);
d.R3.dt = dt(:,1+2*length(R)/6:3*length(R)/6,:);
d.R3.ds = ds(:,1+2*length(R)/6:3*length(R)/6,:);
d.R3.dt_total = dt_total(:,:,1+2*length(R)/6:3*length(R)/6);

%--------------------------------------------------
% Sector R=4
%--------------------------------------------------
d.R4.d0 = d0(:,1+3*length(R)/6:4*length(R)/6);
d.R4.d4 = d1(:,1+3*length(R)/6:4*length(R)/6);
d.R4.d5 = d2(:,1+3*length(R)/6:4*length(R)/6);
d.R4.d7 = d7(:,1+3*length(R)/6:4*length(R)/6);
d.R4.dt = dt(:,1+3*length(R)/6:4*length(R)/6,:);
d.R4.ds = ds(:,1+3*length(R)/6:4*length(R)/6,:);
d.R4.dt_total = dt_total(:,:,1+3*length(R)/6:4*length(R)/6);

%--------------------------------------------------
% Sector R=5
%--------------------------------------------------
d.R5.d0 = d0(:,1+4*length(R)/6:5*length(R)/6);
d.R5.d5 = d1(:,1+4*length(R)/6:5*length(R)/6);
d.R5.d6 = d2(:,1+4*length(R)/6:5*length(R)/6);
d.R5.d7 = d7(:,1+4*length(R)/6:5*length(R)/6);
d.R5.dt = dt(:,1+4*length(R)/6:5*length(R)/6,:);
d.R5.ds = ds(:,1+4*length(R)/6:5*length(R)/6,:);
d.R5.dt_total = dt_total(:,:,1+4*length(R)/6:5*length(R)/6);

%--------------------------------------------------
% Sector R=6
%--------------------------------------------------
d.R6.d0 = d0(:,1+5*length(R)/6:length(R));
d.R6.d6 = d1(:,1+5*length(R)/6:length(R));
d.R6.d1 = d2(:,1+5*length(R)/6:length(R));
d.R6.d7 = d7(:,1+5*length(R)/6:length(R));
d.R6.dt = dt(:,1+5*length(R)/6:length(R),:);
d.R6.ds = ds(:,1+5*length(R)/6:length(R),:);
d.R6.dt_total = dt_total(:,:,1+5*length(R)/6:length(R));

%--------------------------------------------------
% Variables
%--------------------------------------------------
pwmPara.d = d;
pwmPara.kf = k_f(:,1:length(R)/6);
v_out.v_al = v_al;
v_out.v_be = v_be;
v_out.v_0 = v_0;
end