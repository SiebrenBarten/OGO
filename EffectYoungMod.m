%% Import and process sample measurements                  
sample_width = 
sample_thickness = 
sample_length_orig = 

% Calculate the surface area perpendicular to stress direction in m^2
act_width = width / 1000; % Convert width from mm to m
act_thickness = thickness / 1000; % Convert thickness from mm to m
surface = act_width * act_thickness; % Calculate surface area in m^2

% Convert the original distance from mm to m
orig_dist = sample_length_orig / 1000; % Convert from mm to m

%% Import tensile test measurements
% File with 3 columns containing the lentgh, force and time
Measurements = ; 

% Load the measurement file into a variable called Data
Data = load(Measurements);

% Extract the columns from Data into arrays
Dist = Data(:,1);
Force = Data(:,2);
Time = Data(:,3);

% Calculate the estimated stress in Pa
stress = Force ./ surface; % Divide force by surface area

% Calculate the engineering strain
delta_dist = Dist - orig_dist; % Calculate the change in distance
strain = delta_dist ./ orig_dist; % Divide by the original distance
