%{
Generate Shear Bending Moment diagrams
Inputs: x - distance along shaft (meters)
        D - Diameter at each point x (meters)
        E - Young's Modulus (Pascals)
        do_plot - plot the diagrams if 1
Outputs: y - deflection at each point x (meters)
         theta - slope at each point x (rad)
         M_z - Bending moment at each point x
         V_y - Shear at each point x
         T - Torque at each point x
         F - Force at each point x
%}
function [y, theta, M_z, V_y, T, F] = gen_shear_bending(x, D, E, do_plot)
    len_x = length(x);
    
    % Force
    F = zeros(1, len_x);
    F(450:525) = 22.4;
    
    % Torque
    T = zeros(1, len_x);
    T(100:525) = 540;

    % Shear
    V_y = zeros(1, len_x);
    V_y(1:100) = 1591.45;
    V_y(101:450) = 1591.45 - 2400 - 48.2*9.81;
    V_y(451:end) = 1591.45 - 2400 - 48.2*9.81 + 5181.27;

    % Bending
    M_z = zeros(1, len_x);
    M_z1 = V_y(100)*0.1;
    M_z2 = M_z1 + V_y(450)*0.35;
    M_z(1:100) = polyval(polyfit([0, .099], [0, M_z1], 1), x(1:100));
    M_z(101:450) = polyval(polyfit([0.1, .449], [M_z1, M_z2], 1), x(101:450));
    M_z(451:end) = polyval(polyfit([.45, x(end)], [M_z2, 0], 1), x(451:len_x));

    % M/EI
    M_over_EI = M_z ./ (inertia(D) * E);

    % Integrate to get slopes and deflections
    theta = cumtrapz(x/1000, M_over_EI);
    y = cumtrapz(x/1000, theta);
    
    if do_plot
        figure;
        subplot(2, 1, 1); 
        plot([-20, 0, x*1000, 600, 620], [0, 0, F, 0, 0]); grid('on');
        xlabel('x (mm)'); ylabel('F (kN)'); title('Compressive Force vs. x');
        axis([-50, 650, -5, 25]);
        
        subplot(2, 1, 2); 
        plot([-20, 0, x*1000, 600, 620], [0, 0, T, 0, 0]); grid('on');
        xlabel('x (mm)'); ylabel('T (Nm)'); title('Torque vs. x');
        axis([-50, 650, -50, 700]);
        
        figure;
        subplot(2, 1, 1); 
        plot([-20, 0, x*1000, 600, 620], [0, 0, V_y / 1000, 0, 0]); grid('on');
        xlabel('x (mm)'); ylabel('V_y (kN)'); title('Transverse Shear vs. x');
        axis([-50, 650, -2, 4.5]);
        
        subplot(2, 1, 2); 
        plot([-20, 0, x*1000, 600, 620], [0, 0, M_z, 0, 0]); grid('on');
        xlabel('x (mm)'); ylabel('M_z (unit)'); title('Bending Moment vs. x');
        axis([-50, 650, -400, 400]);
        
        figure;
        subplot(2, 1, 1);
        plot(x*1000, theta); grid('on');
        xlabel('x (mm)'); ylabel('\theta (rad)'); title('Slope vs. x');
        
        subplot(2, 1, 2);
        plot(x*1000, y); grid('on');
        xlabel('x (mm)'); ylabel('Deflection (m)'); title('Deflection vs. x');
    end
end