clear all; % Clear the workspace 

%% Parameters

% Parameters (Young's modulus)
nu_m = 0.14;          % [-], Poisson's ratio of the matrix  %functie
E_fiber1 =  5.35e+08; % [Pa], Young's modulus for fiber (PCL) 
E_matrix = 1.18e+06;  % [Pa], Young's modulus for matrix 
E_fiber2 = E_fiber1;     % [Pa], Young's modulus of the second fiber

% Parameters (Young's modulus of the real pleura) 
E_eff0 = 2.04e7;  % [Pa], Young's modulus for 0 degrees
E_eff30 = 5.58e6; % [Pa], Young's modulus for 30 degrees
E_eff60 = 5.3e6;  % [Pa], Young's modulus for 60 degrees
E_eff90 = 1.28e7; % [Pa], Young's modulus for 90 degrees

% Parameters (Orientations)
theta = 0:1:180;  % [degrees], Range of angles to plot, with respect to the load. 
alpha = 0;        % [degrees], (Theta-Angle = angle of fiber 1 [PCL]) 
alpha_fiber2 = 90; % angle of the second fiber with respect to the applied load

% Parameters (Volume Fractions) 
V_fiber1 = 0.00;  % [-], Volume fraction of the first fiber (PCL fiber)
V_fiber2 = 0.0; % [-], Volume fraction of the second fiber

% Formula's Effective Young's modulus

% Effective Young's Modulus for each fiber
E_eff1 = E_matrix * (1 + nu_m * (V_fiber1 * E_fiber1 / E_matrix - 1) * cosd(theta - alpha).^2) ./ (1 - V_fiber1 * nu_m * cosd(theta - alpha).^2);
E_eff2 = E_matrix * (1 + nu_m * (V_fiber2 * E_fiber2 / E_matrix - 1) * cosd(theta - alpha_fiber2).^2) ./ (1 - V_fiber2 * nu_m * cosd(theta - alpha_fiber2).^2);

% Total Effective Young's Modulus
E_eff_total = E_matrix * (1 + nu_m * ((V_fiber1 + V_fiber2) * (E_fiber1 + E_fiber2) / E_matrix - 1) * cosd(theta).^2) ./ (1 - (V_fiber1 + V_fiber2) * nu_m * cosd(theta).^2);

% Plot graph  

figure; 
plot(theta, E_eff1, '--', 'LineWidth', 2); hold on; % Plot fiber1
plot(theta, E_eff2, '-.', 'LineWidth', 2);  % Plot fiber2
plot(theta, E_eff_total, 'LineWidth', 2);   % Plot total
%plot([min(theta), max(theta)], [E_eff0, E_eff0], 'k--');    % point 0 degrees
%plot([min(theta), max(theta)], [E_eff30, E_eff30], 'k--');   % point 30 degrees
plot([min(theta), max(theta)], [E_eff60, E_eff60], 'k--');  % point 60 degrees
plot([min(theta), max(theta)], [E_eff90, E_eff90], 'k--');  % point 90 degrees
xlabel('Angle with respect to applied load (degrees)');
ylabel('Effective Young''s modulus (GPa)');
title('Relationship between effective Young''s modulus and fiber angle');
legend('Fiber 1', 'Fiber 2', 'Total', '0 degrees', '30 degrees', '60 degrees', '90 degrees');
hold off; 
