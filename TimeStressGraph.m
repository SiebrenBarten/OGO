% Load the data file into a variable called data
load('TensileTest.mat');

% Extract the three columns from the data variable
Dist = Data(:,1);
Force = Data(:,2);
Time = Data(:,3);

% Calculate the surface area in m^2
width = 2; % Convert width from mm to m
thickness = 10; % Convert thickness from mm to m
surface = width * thickness; % Calculate surface area in m^2

% Calculate the estimated stress in Pa
stress = Force ./ surface; % Divide force by surface area

% Plot stress as a function of time
figure();
plot(Time, stress)
xlabel('Time [s]')
ylabel('Stress [Pa]')
title('Stress as a function of time')

% Use getpts to locate the outlier and replace it with the average of its two adjacent values
outliers = getpts(gca);

q = prctile(y, [25 50 75]);
iqr = q(3) - q(1);
low_thresh = q(2) - 1.5*iqr;
high_thresh = q(2) + 1.5*iqr;
outlier_idx = (y < low_thresh) | (y > high_thresh);

hold on;
plot(x(outlier_idx), y(outlier_idx), 'ro');
hold off;
