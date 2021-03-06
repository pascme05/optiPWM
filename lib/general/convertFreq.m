%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: convertFreq                                                       %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [i_in, v_in, fsTs] = convertFreq(i_in, v_in, fsTs, setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Inputs
%---------------------------------------------------
i_a = i_in.i_a_rms;
i_c = i_in.i_c;
i_dc = i_in.i_dc;
u_dc = v_in.u_dc;

%---------------------------------------------------
% General
%---------------------------------------------------
L = length(i_c);
L2 = length(i_a);
Fs = setup.fs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I_c = abs(fft(i_c))/L;
I_a = abs(fft(i_a))/L2;
I_dc = abs(fft(i_dc))/L;
U_dc = abs(fft(u_dc))/L;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Post-Processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I_a = I_a(1:L2/2+1);
I_a(2:end-1) = 2*I_a(2:end-1);
I_dc = I_dc(1:L/2+1);
I_dc(2:end-1) = 2*I_dc(2:end-1);
I_c = I_c(1:L/2+1);
I_c(2:end-1) = 2*I_c(2:end-1);
U_dc = U_dc(1:L/2+1);
U_dc(2:end-1) = 2*U_dc(2:end-1);
f = Fs*(0:(L/2))/L;
f2 = Fs*(0:(L2/2))/L2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i_in.I_a = I_a;
i_in.I_c = I_c;
i_in.I_dc = I_dc;
v_in.U_dc = U_dc;
fsTs.f = f*8;
fsTs.f2 = f2*5;

end