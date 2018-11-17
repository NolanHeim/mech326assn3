%% Determines the Critical Speed of the Shaft
% Inputs:
% y - Function of xi for the deflections.
% rho - density of material
% xj - section boundary points
% dj - diameters between xj's
% Ni - Number of elements for each section (j) (integer)

function omega1 = CriticalSpeed(y, rho, xj, dj, Ni)
    g = 9.81; %Gravitational Constant
    sum_wjyj = 0;
    for j = 1:5
        d = dj(j);
        xi = linspace(xj(j), xj(j+1), Ni);
        mi = (rho*pi*(d^2)*xi)/4;
        wi = g*mi;
        yi = y(xi);
        sum_wjyj = sum_wjyj + sum(yi.*wi); 
    end
    omega1 = sqrt((g*sum_wjyj)/(sum_wjyj));
end

