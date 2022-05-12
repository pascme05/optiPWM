%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Optimisation in electric drives and inverters                    %
% Topic: Power Electronics, Distortions                                   %
% File: createSEQ                                                              %
% Date: 05.11.2021                                                        %
% Author: Dr. Pascal A. Schirmer                                          %
% Version: V.0.1                                                          %
% Copyright: Pascal Schirmer                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dt,dt_total,ds] = createSEQ(d0,d1,d2,d7,setup)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ds = [d0; d1; d2; d7];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% 0127
%---------------------------------------------------
if(setup.SEQ == 127)
    dt = [0;d7; d2+d7; d7+d2+d1; d7+d2+d1+d0];
    dt_total = [0;d0;d0+d1;1-d7;1+d7;1+d7+d2;2-d0;2];
%---------------------------------------------------
% 012
%---------------------------------------------------
elseif(setup.SEQ == 12) 
    dt = [0;d0; d0+d1; d0+d1+d2; d0+d1+d2+d7];
    dt_total = [0;d0;d0+d1;1-d7;1+d7;1+d7+d2;2-d0;2];
%---------------------------------------------------
% 721
%---------------------------------------------------
elseif(setup.SEQ == 721) 
    dt = [0;d7; d7+d2; d7+d2+d1; d7+d2+d1+d0];
    dt_total = [0;d7;d7+d2;1-d0;1+d0;1+d0+d1;2-d7;2]; 
%---------------------------------------------------
% 0121
%---------------------------------------------------
elseif(setup.SEQ == 121)
    d1 = d1/2;
    dt = [0;d0; d0+d1; d0+d1+d2; d0+d1+d2+d1];
    dt_total = [0;d0;d0+d1;1-d1;1+d1;1+d1+d2;2-d0;2];
%---------------------------------------------------
% 7212
%---------------------------------------------------
elseif(setup.SEQ == 7212)
    d2 = d2/2;
    dt = [0;d7; d7+d2; d7+d2+d1; d7+d2+d1+d2];
    dt_total = [0;d7;d7+d2;1-d2;1+d2;1+d2+d1;2-d7;2];
%---------------------------------------------------
% 1012
%---------------------------------------------------
elseif(setup.SEQ == 1012)
    d1 = d1/2;
    dt = [0;d1; d1+d0; d1+d0+d1; d1+d0+d1+d2];
    dt_total = [0;d1;d1+d0;1-d2;1+d2;1+d2+d1;2-d1;2];
%---------------------------------------------------
% 2721
%---------------------------------------------------
elseif(setup.SEQ == 2721)
    d2 = d2/2;
    dt = [0;d2; d2+d7; d2+d7+d2; d2+d7+d2+d1];
    dt_total = [0;d2;d2+d7;1-d1;1+d1;1+d1+d2;2-d2;2];
end
end