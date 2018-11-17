%% Determines the factor of safety for yeild for the shaft at a point.
% Inputs: d - diameter (m), M - Bending moment (Nm)
%         T - Torque (Nm), Sy - Yeild Strength (Pa)
function n = yeild(d, M, T, Sy)
sigma = (32*M)/(pi*(d^3));
tau = (16*T)/(pi*(d^3));
vonMises = sqrt((sigma^2) + 3*(tau^2));

n = Sy/vonMises;
end
