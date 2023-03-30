function [C_edges] = SecondaryFiberMesh(E_eff, V_f_lim)

%% Parameters for Meshgrid

% Parameters (Young's modulus)
nu_m = 0.14;          % [-], Poisson's ratio of the matrix  %functie
E_fiber =  5.35e+08;  % [Pa], Young's modulus for fiber (PCL) 
E_matrix = 1.18e+06;  % [Pa], Young's modulus for matrix (silicon
E_base = 2.89e+06;    % [Pa], Young's modulus of the sample with 9 PCL fibers and silicon matrix at 0-degree angle

% Parameters (Orientations)
theta = linspace(0, 90, 100);  % [degrees], Matrix with ange of angles between the primary (at 0 degrees)

% Parameter (Volume Fractions) 
V_fiber2 = linspace(0, V_f_lim, 100); % [-], Matrix with range of volume fraction of the secondary fibers

%% Parameters for reference surfaces in Meshgrid
% Parameters (Young's modulus of the real pleura) 
E_effective = E_eff * ones(100,100);

%% Determine the Effective Young's modulus of the primary + secondary fibers

% Create meshgrid of the volume fraction and and orientation of the secondary fiber
[V_f2_mesh, theta_mesh] = meshgrid(V_fiber2, theta);

% Calculate the Effective Young's Modulus for the secondary fiber set
E_eff2 = E_matrix .* (1 + nu_m .* (V_f2_mesh .* E_fiber ./ E_matrix - 1) .* cosd(theta_mesh).^2) ./ (1 - V_f2_mesh .* nu_m .* cosd(theta_mesh).^2);

% Calculate new total Effective Young's Modulus
E_eff_total = (E_base + E_eff2) ./ 2;

%% Plot the Meshgrid
% Plot the surface plot
surf(V_f2_mesh, theta_mesh, E_eff_total);   % Make the Meshgrid and define te axises
xlabel('V_f');                              % Name the x-axis
ylabel('theta (degrees)');                  % Name the y-axis
zlabel('E_{eff}');                          % Name the z-axis
title('Effective Modulus vs. Fiber Volume Fraction and Angle'); % Add a title to the graph

hold on; 
surf(V_f2_mesh, theta_mesh, E_effective); 

%% Determine the intersection of the graphs 

%idx = find(abs(E_eff_total - E_eff0) == 0);
%[V_f_intersect, theta_intersect] = ind2sub(size(E_eff_total), idx);

E_diff = E_eff_total - E_effective;
C = contours(V_f2_mesh, theta_mesh, E_diff, [0 0]);

% Extract the x- and y-locations from the contour matrix C.
V_f_L = C(1, 2:end); % All the V_f intersection coordinates
theta_L = C(2, 2:end); % All the theta intersection coordinates

% Interpolate on the first surface to find z-locations for the intersection line.
ELoc = interp2(V_f2_mesh, theta_mesh, E_eff_total, V_f_L, theta_L)

line(V_f_L, theta_L, ELoc, 'Color', 'r', 'LineWidth', 3);

%% Get the equation for the line
p = polyfit(V_f_L, theta_L, 2); % Fit a second-order polynomial 

% Get slope and intercept
slope_2 = p(1);
slope = p(2);
intercept = p(3);

% Print equation of the line
fprintf('Correlation: theta = %.2f*V_f^2 + %.2f*V_f + %.2f\n', slope_2, slope, intercept);

%% Define the ranges
% Extract the extremes in a table
C_edges = [C(:,2), C(:,(length(C)))];
V_f_min = C_edges(1,1);
fprintf('Volume fraction range = %.4f : %.4f', V_f_min, V_f_lim);
fprintf('\n');
theta_max = C_edges(2,2);
fprintf('Fiber angle range = 0 : %.4f', theta_max);
