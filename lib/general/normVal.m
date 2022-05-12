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
function [setup] = normVal(setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if setup.norm == 1
%---------------------------------------------------
% PWM
%---------------------------------------------------
setup.fs = 1;                                                               % switching frequency in (Hz)
setup.f_el = 50;                                                            % electrical frequency in (Hz)
setup.Ts = 1/setup.fs;                                                      % switching time in (s)

%---------------------------------------------------
% Hardware Config
%---------------------------------------------------
% INV
setup.normDC = 1;                                                           % nominal dc link voltage in (V)
setup.C = 1;                                                                % dc link capactiance C in [F]

% EMA
setup.normIp = 1;                                                           % peak phase current in (A)
setup.L = 1;                                                                % stator inductance L in [H]
setup.P_max = 1;                                                            % normalised maximum power

end
end