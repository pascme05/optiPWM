function [u_dc_h]=u_dc(i_dc, dt)
% Berechnet die harmonische Spannung im Zwischenkreis
i_dc_avg=(i_dc(1:end-1)*diff(dt))/(max(dt)-min(dt));
u_dc_h=zeros(1,length(dt));
for oi=2:length(dt)
   u_dc_h(oi)=u_dc_h(oi-1)+(i_dc(oi-1)-i_dc_avg)*(dt(oi)-dt(oi-1)); 
end