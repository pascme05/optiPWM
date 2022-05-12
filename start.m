%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: main                                                              %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Introduction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following script calculates the current distortions on the machine
% side, as well as the current- and voltage distortions on the DC-Link, for
% a standard 3-phase machine with voltage soure inverter (B6-VSI).
% Apart from that, fundamental losses for the IGBT are evaluated. The 
% calculations are subsequent to the following papers [1], [2] and [3].
% Additionally for the overmodulation region [4] and [5] are utilised.
% The transformation between the triangle-carrier-method and the space-
% vector approach is done accordingly to [6]
% The following boundary conditions are set for the calculations:
%
% * Valid for high switching frequencies $f_s >> f_el$
% * Semiconductors are ideal (linear commutation)
% * the machine is modelled as a pure inductive load

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Formating
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear variables
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Add paths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('data'))
addpath(genpath('lib'))
addpath(genpath('mdl'))
addpath(genpath('results'))
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setting Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% General
%---------------------------------------------------
setup.Numeric = 1;                                                          % if 1 numeric calcualtion will be used
setup.plot_Mi = 80;                                                         % value for plotting time domain of M_i
setup.plot_cosphi = 5;                                                      % value for plotting time domain of M_i

%---------------------------------------------------
% PWM
%---------------------------------------------------
setup.fs = 20000;                                                           % switching frequency in (Hz)
setup.f_el = 500;                                                           % electrical frequency in (Hz)
setup.Ts = 1/setup.fs;                                                      % switching time in (s)
setup.M_i_max = 0.906;                                                      % select maximum M_i
setup.SEQ = 127;                                                            % switching sequence (127, 012, 721, 0121, 7212, 1012, 2721)
setup.MOD = 'SVPWM';                                                        % zero vector separation (SVPWM DPWM0, DWPM1, DPWM2, DPWM3, DPWMMIN, DPWMMAX, OZP)

%---------------------------------------------------
% Resolution
%---------------------------------------------------
setup.N_Mi = 80;                                                            % resolution M_i (devisable by 2)
setup.N_theta = setup.fs/setup.f_el;                                        % resolution theta (equal to pulse number)
setup.N_cosphi = 5;                                                         % resolution cosphi

%---------------------------------------------------
% Hardware Config
%---------------------------------------------------
% INV
setup.normDC = 560;                                                         % nominal dc link voltage in (V)
setup.C = 1;                                                                % dc link capactiance C in (F)

% EMA
setup.normIp = 20;                                                          % peak phase current in (A)
setup.L = 5e-4;                                                             % stator inductance L in (H)
setup.P_max = 1;                                                            % normalised maximum power
setup.n_1 = 1.0;                                                            % normalised start of field-weaking area $n_1$
setup.n_2 = 1.5;                                                            % normalised end of field-weaking area $n_0$

%---------------------------------------------------
% Plotting
%---------------------------------------------------
setup.plotTime = 1;                                                         % if 1 plot time domain values
setup.plotRMS = 1;                                                          % if 1 plot rms values
setup.plotFRMS = 1;                                                         % if 1 plot frms values
setup.plotLoss = 1;                                                         % if 1 plot loss values

%---------------------------------------------------
% Normalization values
%---------------------------------------------------
setup.norm = 1;                                                             % apply normalization

%---------------------------------------------------
% Normalization losses
%---------------------------------------------------
setup.k1_EMA = 8e-2;                                                        % possibly stator resistance in [Ohm]
setup.k2_DCI = 5e-2;                                                        % possibly ESR DC-Link in [Ohm]
setup.k3_IGBT = 2e-2;                                                       % possibly on resistance in [Ohm]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
main

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Literature
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1] Simple Analytical and Graphical Methods for Carrier-Based PWM-VSI
% Drives, Ahmet M. Hava, Russel J. Kerkman, and Thomas A. Lipo, 
% IEEE TRANSACTIONS ON POWER ELECTRONICS, VOL. 14, NO. 1, JANUARY 1999
%
% [2] Space Vector PWM Control of Dual Three-phase Induction Machine Using
% Vector Space Decomposition, Yifan Zhao, Thomas A. Lipo, IEEE TRANSACTIONS
% ON INDUSTRY APPLICATIONS, VOL. 31, NO. 5, SEPTEMBER/OCTOBER 1995
% 
% [3] Analytical calculation of the RMS current stress on the DC-link 
% capacitor of voltage-PWM converter systems, J.W. Kolar, and S.D. Round, 
% IEE Proceedings - Electronic Power Applications, Vol. 153, No. 4, 
% July 2006
%
% [4] J. Holtz, W. Lotzkat, and A. M. Khambadkone. “On continuous control 
% of PWM inverters in the overmodulation range including the six-step mode”.
% In: IEEE Transactions on Power Electronics 8.4 (1993),
% pp. 546–553. ISSN: 0885-8993.
%
% [5] Khanh NGUYEN THAC. “A SIMPLE WIDE RANGE SPACE VECTORPWM
% A SIMPLE WIDE RANGE SPACE VECTOR PWM CONTROLLER ALGORITHM
% FOR VOLTAGE-FED INVERTER INDUCTION MOTOR DRIVE INCLUDING
% SIX-STEP MODE”.
%
% [6] Felix Jenni, Dieter Wüest
% 1. Auflage 1995; 368 Seiten, Format 16 x 23 cm, broschiert mit 
% zahlreichen grafischen Darstellungen, ISBN 978-3-7281-2141-7