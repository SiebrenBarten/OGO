function [poisson] = Poisson_calc(info)
% This function calculates the mean Poisson's ratio of samples tested in
% the tensile test
%   The input variable should be a datafile with 4 columns: 1. the
%   orginal lateral lenghts, 2. the end lateral lengths, 3. the orginal
%   transversal lengths, 4. the end transversal lengths. The output will be
%   the average Poisson's ratio.

%% Import the information of the lateral and transversal length changes
measure = load(info); % load meassurements
lateral_orig = measure(:,1); % isolate all the orginal lateral lengths 
lateral_after = measure(:,2); % isolate all the end lateral lengths
transversal_orig = measure(:,3); % isolate all the orginal transversal lengths
transversal_after = measure(:,4); % Isolate all the end transversal lengths

%% Calculate the lateral and transversal strain
% Calculate the lateral length changes and transversal length changes for all the samples
lateral_changes = lateral_after - lateral_orig;
transversal_changes = transversal_after - transversal_orig;

% Calculate the strains
lateral_strain = lateral_changes ./ lateral_orig;
transversal_strain = transversal_changes ./ transversal_orig;

%% Calculate the average poisson's ratio
% Calculate the Poisson's ratio for each sample
poissons_ratios = -(lateral_strain ./ transversal_strain);

% Calculate the average Poisson's ratio of all the samples
poisson = mean(poissons_ratios);

end