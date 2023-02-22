Filename = 
width = 
thickness = 

% Load the data file into a variable called data
Data = load(Filename);

% Extract the three columns from the data variable
Dist = Data(:,1);
Force = Data(:,2);
Time = Data(:,3);

% Calculate the surface area in m^2
act_width = width / 1000; % Convert width from mm to m
act_thickness = thickness / 1000; % Convert thickness from mm to m
surface = act_width * act_thickness; % Calculate surface area in m^2

% Calculate the estimated stress in Pa
stress = Force ./ surface; % Divide force by surface area

% Convert the original distance from mm to m
orig_dist = 25.2; % Convert from mm to m

% Calculate the engineering strain
delta_dist = Dist - orig_dist; % Calculate the change in distance
strain = delta_dist ./ orig_dist; % Divide by the original distance