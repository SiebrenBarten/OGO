clear all; % Clear the workspace 

%% Parameters

% Parameters (Young's modulus)
nu_m = 0.14;          % [-], Poisson's ratio of the matrix  %functie
E_fiber1 =  5.35e+08; % [Pa], Young's modulus for fiber (PCL) 
E_matrix = 1.18e+06;  % [Pa], Young's modulus for matrix 
E_fiber2 = E_fiber1;     % [Pa], Young's modulus of the second fiber

% Parameters (Young's modulus of the real pleura) 
E_eff0 = ones(100,100) .* 2.04e7;  % [Pa], Young's modulus for 0 degrees
E_eff30 = ones(100,100) .* 5.58e6; % [Pa], Young's modulus for 30 degrees
E_eff60 = ones(100,100) .* 5.3e6;  % [Pa], Young's modulus for 60 degrees
E_eff90 = ones(100,100) .* 1.28e7; % [Pa], Young's modulus for 90 degrees

% Parameters (Orientations)
theta = linspace(0, 90, 100);  % [degrees], Range of angles to plot, with respect to the load. 
alpha = 0;        % [degrees], (Theta-Angle = angle of fiber 1 [PCL]) 
alpha_fiber2 = 90; % angle of the second fiber with respect to the applied load

% Parameters (Volume Fractions) 
V_fiber1 = 0.7;  % [-], Volume fraction of the first fiber (PCL fiber)
V_fiber2 = linspace(0, 0.7, 100); % [-], Volume fraction of the second fiber

%% Formula's Effective Young's modulus

%create meshgrid of V_f and theta
[V_f2_mesh, theta_mesh] = meshgrid(V_fiber2, theta);

% Effective Young's Modulus for each fiber
E_eff_total = E_matrix .* (1 + nu_m .* ((V_fiber1 + V_f2_mesh) .* (E_fiber1 + E_fiber2) ./ E_matrix - 1) .* cosd(theta_mesh).^2) ./ (1 - (V_fiber1 + V_fiber2) .* nu_m .* cosd(theta_mesh).^2);

% plot the surface plot
surf(V_f2_mesh, theta_mesh, E_eff_total);
xlabel('V_f');
ylabel('theta (degrees)');
zlabel('E_{eff}');

title('Effective Modulus vs. Fiber Volume Fraction and Angle');

hold on; 
surf(V_f2_mesh, theta_mesh, E_eff0);

hold on; 
surf(V_f2_mesh, theta_mesh, E_eff30);

hold on; 
surf(V_f2_mesh, theta_mesh, E_eff60);

hold on; 
surf(V_f2_mesh, theta_mesh, E_eff90);
%hold off;

