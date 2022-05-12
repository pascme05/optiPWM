%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Init
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
omega_1 = linspace(0,2*pi,length(i.i_a));
omega_2 = linspace(0,2*pi,length(i.i_c));
omega_3 = linspace(0,2*pi,length(i.i_a_rms)); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting Time and Frequency domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------------------------------
% Time domain
%---------------------------------------------------
if setup.plotTime == 1
    % References Phase U
    figure;
    subplot(5,2,[1, 2]);
    hold on;
    grid on;
    title('Referenz signals phase U');
    plot(omega_1, v.v_al(setup.plot_Mi,:));
    plot(omega_1, (v.v_al(setup.plot_Mi,:)+v.v_0(setup.plot_Mi,:)));
    ylabel('v_a and v_0 (V)')
    yyaxis right
    plot(omega_1, i.i_a);
    xlabel('\omega (1/s)')
    ylabel('i_a (A)')
    xlim([0 6.2832])

    % Phase Current
    subplot(5,2,3);
    hold on;
    grid on;
    title('Phase Current (time)');
    plot(omega_3, i.i_a_rms);
    xlabel('\omega (1/s)')
    ylabel('i_a (A)')
    xlim([0 6.2832])

    % Inverter Current 
    subplot(5,2,5);
    hold on;
    grid on;
    title('Inverter Current (time)');
    stairs(omega_2, i.i_dc);
    xlabel('\omega (1/s)')
    ylabel('i_{dc} (A)')
    xlim([0 6.2832])

    % DC-Link Current
    subplot(5,2,7);
    hold on;
    grid on;
    title('DC-Link Current (time)');
    stairs(omega_2, i.i_c);
    xlabel('\omega (1/s)')
    ylabel('i_c (A)')
    xlim([0 6.2832])

    % DC-Link Voltage
    subplot(5,2,9);
    hold on;
    grid on;
    title('DC-Link Voltage (time)');
    stairs(omega_2, v.u_dc);
    xlabel('\omega (1/s)')
    ylabel('v_{dc} (V)')
    xlim([0 6.2832])

    %---------------------------------------------------
    % Frequenzy domain
    %---------------------------------------------------
    % Phase Current 
    subplot(5,2,4);
    hold on;
    grid on;
    title('Phase Current (freq)');
    plot(fsTs.f2, i.I_a);
    xlabel('f (Hz)')
    ylabel('I_a (A)')

    % Inverter Current
    subplot(5,2,6);
    hold on;
    grid on;
    title('Inverter Current (freq)');
    plot(fsTs.f, i.I_dc);
    xlabel('f (Hz)')
    ylabel('I_{dc} (A)')

    % DC-Link Current
    subplot(5,2,8);
    hold on;
    grid on;
    title('DC-Link Current (freq)');
    plot(fsTs.f, i.I_c);
    xlabel('f (Hz)')
    ylabel('I_c (A)')

    % DC-Link Voltage
    subplot(5,2,10);
    hold on;
    grid on;
    title('DC-Link Voltage (freq)');
    plot(fsTs.f, v.U_dc);
    xlabel('f (Hz)')
    ylabel('V_{dc} (V)')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting RMS Values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if setup.plotRMS == 1
    figure
    subplot(1,3,1);
    surf(inp.theta_u_i, inp.M_i, lmd.lmd_rms_sq);
    xlabel('\theta (rad)')
    ylabel('M_{i}')
    zlabel('\lambda_{rms}^{2} (As/As)^{2}')
    title('RMS Flux Phase');
    xlim([0 6.2832/6])

    subplot(1,3,2);
    surf(inp.theta_u_i, inp.M_i, squeeze(i.i_c_rms_sq(:,:,setup.plot_cosphi)));
    xlabel('\theta (rad)')
    ylabel('M_{i}')
    zlabel('I_{dc,rms}^{2} (A/A)^{2}')
    title('RMS Current Capacitor');
    xlim([0 6.2832/6])

    subplot(1,3,3);
    surf(inp.theta_u_i, inp.M_i, squeeze(v.u_dc_rms_sq(:,:,setup.plot_cosphi)));
    xlabel('\theta (rad)')
    ylabel('M_{i}')
    zlabel('V_{dc,rms}^{2} (V/V)^{2}')
    title('RMS Voltage Capacitor');
    xlim([0 6.2832/6])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting FRMS Values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if setup.plotFRMS == 1
    figure
    subplot(2,2,1);
    hold on;
    plot(inp.M_i,[lmd.lmd_frms_sq,lmd.lmd_frms_sq_fs,lmd.lmd_frms_sq_Ts]);
    xlabel('M_{i}')
    ylabel('HDF')
    title({'FRMS Current/Flux Phase'});
    grid on;
    legend('\lambda_{1,frms}^2','\lambda_{1,frms}^2 with f_{s,avg} = const.','\lambda_{1,frms}^2 with T_{s,avg} = const.')

    subplot(2,2,2);
    plot(p.cosphi_SLF,p.SLF);
    xlabel('\theta (rad)');
    ylabel('SLF')
    title('Normalised IGBT losses');
    grid on;

    subplot(2,2,3);
    plot(inp.M_i, i.i_c_frms_sq);
    xlabel('M_{i}')
    ylabel('I_{c,frms}^{2} (A/A)^{2}')
    title('FRMS Current Capacitor');
    grid on;
    legend('cos(\phi) = 0.00','cos(\phi) = 0.25','cos(\phi) = 0.50','cos(\phi) = 0.75','cos(\phi) = 1.00')

    subplot(2,2,4);
    plot(inp.M_i, v.u_dc_frms_sq);
    xlabel('M_{i}')
    ylabel('V_{dc,frms}^{2} (V/V)^{2}')
    title('FRMS Voltage Capacitor');
    grid on;
    legend('cos(\phi) = 0.00','cos(\phi) = 0.25','cos(\phi) = 0.50','cos(\phi) = 0.75','cos(\phi) = 1.00')
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting Losses
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if setup.plotLoss == 1
    figure;
    subplot(2,2,1);
    [C,h] = contourf(inp.n,inp.T,p.P_EMA,15);
    clabel(C,h);
    xlabel('n in [1/min]');
    title({'Normalised losses EMA'});
    ylabel('M in [Nm]');
    grid on;

    subplot(2,2,2);
    [C,h] = contourf(inp.n,inp.T,p.P_IGBT,15);
    clabel(C,h);
    xlabel('n in [1/min]');
    title({'Normalised losses IGBT'});
    ylabel('M in [Nm]');
    grid on;

    subplot(2,2,3);
    [C,h] = contourf(inp.n,inp.T,p.P_DCI,15);
    clabel(C,h);
    xlabel('n in [1/min]');
    title({'Normalised current losses DC-Link'});
    ylabel('M in [Nm]');
    grid on;

    subplot(2,2,4);
    [C,h] = contourf(inp.n,inp.T,p.P_loss,15);
    clabel(C,h);
    xlabel('n in [1/min]');
    title({'Normalised total losses'});
    ylabel('M in [Nm]');
    grid on;
end