function [sigma, epsi, EffYoung] = CalcEYM(filename,width,thickness,zero_length)
%CalcEYM calculates the Effective Young's Modulus and plots this per time
%   Filename is a table of 3 colums with the length and force at different 
%   time instances, the other 3 parameters descibe the dimentions of the sample.

%% Import and process sample measurements                  
sample_width = width; % Detemines the width of the sample in mm
sample_thickness = thickness; % Detemines the thickness of the sample in mm
sample_length_orig = zero_length; % Determines the original length of the sample in mm

% Calculate the surface area perpendicular to stress direction in m^2
act_width = sample_width / 1000; % Convert width from mm to m
act_thickness = sample_thickness / 1000; % Convert thickness from mm to m
surface = act_width * act_thickness; % Calculate surface area in m^2

% Convert the original distance from mm to m
orig_dist = sample_length_orig / 1000; % Convert from mm to m

%% Import and process tensile test measurements
Measurements = filename; % Import tensile test information

% Load the measurement file into a variable called Data
Data = load(Measurements);

% Extract the columns from Data into arrays
Dist = Data(:,1); % Array with the sample lengths
Force = Data(:,2); % Array with the applied force
Time = Data(:,3); % Array with the time instances

% Calculate the stress in Pa
stress = Force ./ surface; % Divide force by surface area
sigma - stress

% Calculate the strain 
delta_dist = Dist - orig_dist; % Calculate the change in distance
strain = delta_dist ./ orig_dist; % Divide by the original distance
epsi = strain

%% Determine te Effective Young's Modulus
EYM = stress ./ strain; % Divide the stress by the strain
EffYoung = EYM;

%% Plot Effective Young's Modulus against time
figure("Effective Young's Modulus per time");
plot(Time, EYM, 'b')

end
