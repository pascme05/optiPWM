function [i_c_rms_sq] = function_idc_rms_sq(i_dc, dt)
% function_idc_rms_sq(u_albe, dt, Theta_I)
% Berechnet den quadrierten Zwischenkreisstrom in Abhängigkeit der
% Sollspannung und des Stromwinkels im alpha, beta-Raum.
i_dc_avg_sq=(i_dc(1:end-1)*diff(dt)/(max(dt)-min(dt)))^2;
i_dc_rms_sq=sum(i_dc(1:end-1).^2*diff(dt))/(max(dt)-min(dt));
i_c_rms_sq = i_dc_rms_sq - i_dc_avg_sq;