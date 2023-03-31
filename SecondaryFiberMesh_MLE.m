function [C_edges] = SecondaryFiberMesh_MLE(E_eff, V_f_lim)

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

set(gca, 'FontSize', 14); 
xlabel('V_{f}','fontsize',20);                              % Name the x-axis
ylabel('Theta (degrees)','fontsize',20);                  % Name the y-axis
zlabel('E_{eff} (Pa)', 'fontsize',20);                          % Name the z-axis
title('Effective Modulus vs. Fiber Volume Fraction and Angle','fontsize', 24); % Add a title to the graph

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
ELoc = interp2(V_f2_mesh, theta_mesh, E_eff_total, V_f_L, theta_L);

line(V_f_L, theta_L, ELoc, 'Color', 'r', 'LineWidth', 3);
%% Get the equation for the line
xdata = V_f_L; 
ydata = theta_L;

fun = @(b, x) b(1)*log(b(2)*x+b(3));

x0 = [1, 1, 1];

options = statset('MaxIter', 10000, 'TolX', 1e-10, 'Display', 'off');

% Fit the model to the data
[beta, resid, J, COVB, MSE] = nlinfit(xdata, ydata, fun, x0, 'Options', options);

% Evaluate the fitted function
xfit = linspace(0, 1, 100)';
yfit = fun(beta, xfit);

% Plot the data and the fitted function
plot3(xfit, yfit, E_effective(1,:), 'y-', 'LineWidth', 3);

xlim([0 1])
ylim([0 90])

disp(['Estimated parameters: a = ', num2str(beta(1)), ', b = ', num2str(beta(2)), ', c = ', num2str(beta(3))]);
fprintf('Estimated parameters:\n a = %.4f \n b = %.4f\n c = %.4f\n' , beta(1), beta(2), beta(3));

end