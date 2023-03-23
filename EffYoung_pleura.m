
function [youngs_modulus_pleura] = EffYoung_pleura(tensile_data, sample_thickness, sample_width, sample_gripsep)
% Reads in a text file with 9 header lines and 3 columns of floating point numbers
% separated by tabs and spaces, extracts the numbers in each column, and returns
% them as separate lists.
%
% Inputs:
%   filename: the name of the text file to read in
%
% Outputs:
%   deformation: a list of the numbers in the first column of the file
%   force: a list of the numbers in the second column of the file
%   time: a list of the numbers in the third column of the file

%% Extract matrix data tensile test
fid = fopen(tensile_data);

% Skip the first 9 lines
for i = 1:9
    fgetl(fid);
end

% Read in the data as a matrix
data = dlmread(tensile_data, '\t', 9, 0);

% Extract the columns into separate lists
def = data(:,1);
deformation = def / 1000;
force = data(:,2);

% Close the file
fclose(fid);

%% Extract sample measurements

sample_thickness = sample_thickness / 1000; % in [m]
sample_width = sample_width / 1000; % in [m]
sample_gripsep = sample_gripsep / 1000; % in [m]

%% Calculating the stress and strain
surface_area = sample_thickness * sample_width; % [m^2]
stress = force ./ surface_area;
engineering_strain = (deformation-sample_gripsep)/sample_gripsep;

%% Calculating the young's modulus of the PCL and silicon
% fit a first-order polynomial to the stress-strain of the matrix
p = polyfit(engineering_strain, stress, 1);
% extract the slope of the polynomial (i.e., the Young's modulus)
youngs_modulus_pleura = p(1);

end
