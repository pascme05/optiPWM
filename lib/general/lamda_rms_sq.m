function [lmd_rms_sq] = lamda_rms_sq(lmd_h, dt)
% Berechnet den quadrierten Effektivwert des harmonischen Flusses
for oi=2:length(lmd_h)
    frac=(lmd_h(oi)-lmd_h(oi-1))/(dt(oi)-dt(oi-1));
    if(isnan(frac) || isinf(frac))
        lmd_rms_seq(oi) = 0;
    else
    lmd_rms_seq(oi) = (lmd_h(oi-1)-frac*dt(oi-1))^2 *(dt(oi)-dt(oi-1))+...
    (lmd_h(oi-1)*frac-dt(oi-1)*frac^2)*(dt(oi)^2-dt(oi-1)^2)+...
    frac^2/3*(dt(oi)^3-dt(oi-1)^3);
    end
end
lmd_rms_sq=sum(lmd_rms_seq)/(max(dt)-min(dt));