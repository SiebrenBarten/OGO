% COPY THIS: [youngs_modulus_matrix, youngs_modulus_PCL, matrix_plot, PCL_plot] = EffYoung('Data silicon matrix test 2% strain.txt', 'Data single PCL fiber test 2% strain.txt')

function [youngs_modulus_matrix, youngs_modulus_PCL, matrix_plot, PCL_plot] = EffYoung(filename_matrix, filename_PCL)
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
fid = fopen(filename_matrix);

% Skip the first 9 lines
for i = 1:9
    fgetl(fid);
end

% Read in the data as a matrix
data = dlmread(filename_matrix, '\t', 9, 0);

% Extract the columns into separate lists
def_matrix = data(:,1);
deformation_matrix = def_matrix / 1000;
force_matrix = data(:,2);
%time_matrix = data(:,3);

% Close the file
fclose(fid);

%% Extract PCL data tensile test
fid = fopen(filename_PCL);

% Skip the first 9 lines
for i = 1:9
    fgetl(fid);
end

% Read in the data as a matrix
data = dlmread(filename_PCL, '\t', 9, 0);

% Extract the columns into separate lists
def_PCL = data(:,1);
deformation_PCL = def_PCL / 1000;
force_PCL = data(:,2);
%time_PCL = data(:,3);

% Close the file
fclose(fid);

%% Extract sample measurements
load("Data synthetic tissue.mat");

% Extracting the matrix data
matrix_thickness = Matrix(1,1) / 1000; % in [m]
matrix_width = Matrix(1,2) / 1000; % in [m]
matrix_gripsep = Matrix(1,3) / 1000; % in [m]
%matrix_final_width = Matrix(1,4) / 1000; % in [m]

% Extracting the fiber data
PCL_thickness = PCL(1,1) / 1000; % in [m]
PCL_width = PCL(1,2) / 1000; % in [m]
PCL_gripsep = PCL(1,3) / 1000; % in [m]
%PCL_final_width = PCL(1,4) / 1000; % in [m]

%% Calculating the stress and strain
% For the matrix
surface_area_matrix = matrix_thickness * matrix_width; % [m^2]
stress_matrix = force_matrix ./ surface_area_matrix;
engineering_strain_matrix = (deformation_matrix-matrix_gripsep)/matrix_gripsep;

% For the fibers
surface_area_PCL = PCL_thickness * PCL_width; % [m^2]
stress_PCL = force_PCL ./ surface_area_PCL;
engineering_strain_PCL = (deformation_PCL-PCL_gripsep)/PCL_gripsep;

%% Plotting the stress-strain curves
% Of the fibers
PCL_plot = figure(1);
ax1 = axes('parent', PCL_plot);
PCL_p = plot(ax1, engineering_strain_PCL, stress_PCL, 'b-');
xlabel(ax1, 'strain');
ylabel(ax1, 'Stress');
title(ax1, "Stress-strain curve of PCL fibers");

% Of the matrix
matrix_plot = figure(2);
ax2 = axes('parent', matrix_plot);
matrix_p = plot(ax2, engineering_strain_matrix, stress_matrix, 'r-');
xlabel(ax2, 'strain');
ylabel(ax2, 'Stress');
title(ax2, "Stress-strain curve of silicon matrix");

%% Calculating the young's modulus of the PCL and silicon
% fit a first-order polynomial to the stress-strain of the matrix
p_matrix = polyfit(engineering_strain_matrix, stress_matrix, 1);
% extract the slope of the polynomial (i.e., the Young's modulus)
youngs_modulus_matrix = p_matrix(1)

% fit a first-order polynomial to the stress-strain of the fibers
p_PCL = polyfit(engineering_strain_PCL, stress_PCL, 1);
% extract the slope of the polynomial (i.e., the Young's modulus)
youngs_modulus_PCL = p_PCL(1)

end


