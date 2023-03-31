clear all; % clear all variables

%% Parameters for the Model
[youngs_modulus_matrix, youngs_modulus_PCL] = EffYoung('Data silicon matrix test 2% strain.txt', 'Data single PCL fiber test 2% strain.txt');
V_f = 0.01:0.001:0.1;
nu_m = 0.14; % Poisson's ratio of the matrix
alpha = 20; % angle of the fibers with respect to the applied load (berekenen, via weefsel snijden)
theta_range = 0:10:90; % Range of angles to plot (in degrees)

%% Formula effective Young's Modulus
E_eff = zeros(length(V_f), length(theta_range)); % preallocate memory for E_eff
for i = 1:length(theta_range)
    theta = theta_range(i);
    E_eff(:,i) = youngs_modulus_matrix * (1 + nu_m * (V_f * youngs_modulus_PCL / youngs_modulus_matrix - 1) * cosd(theta).^2) ./ (1 - V_f * nu_m * cosd(theta).^2);
end

%% Plot the curves
figure;
plot(V_f, E_eff/1e9, 'LineWidth', 2);
xlabel('Angle of fibers with respect to applied load (degrees)');
ylabel('Effective Young''s modulus (GPa)');
title('Relationship between effective Young''s modulus and fiber angle');
legend(cellstr(num2str(theta_range', 'theta=%-g')),'Location','eastoutside');