%Function to calculate the Youngs Modulus. With as input the data file of the tensile test. 

function [youngs_modulus] = EYM(filename)

load(filename, '-mat'); % Load file in 

Dist = Data(:, 1).*1e-3; % distance in [m]
Force = Data(:, 2); % force in [N]
Time = Data(:, 3); % time in [s]

Sample_X = 10*1e-3; % [m] thickness
Sample_Y = 2*1e-3; % [m] width
Sample_Z = 25.2*1e-3; % [m] lenght

surface_area = Sample_X * Sample_Y; %[m^2]
stress = Force ./ surface_area;

engineering_strain = (Dist-Sample_Z)/Sample_Z; 
plot(engineering_strain, stress, 'b-');
xlabel('strain');
ylabel('stress');
title('Strain-Stress');

% plot the data and select the outlier using getpts
plot(stress);
[x, y] = getpts;
[~, idx] = min(abs(x-(1:length(stress))')); % find the index of the outlier
% replace the outlier with the average of its two neighboring values
if idx > 1 && idx < length(stress)
    stress(idx) = (stress(idx-1) + stress(idx+1))/2; %rekend gemiddeld uit van putnen rondom de outlier
end

stressReg = stress; % new name, for array without outlier
% plot updated data
figure;
plot(stressReg);

% generate a noisy stress signal
signalNosy = stressReg;

% define the weight array for filtering
L = 11; 
weights = ones(L,1)/L;

% apply the filter using convolution
signalFilt = conv(signalNosy, weights, 'same');

% plot the original and filtereed signals
figure;
plot(signalNosy, 'b'); hold on; 
plot(signalFilt, 'r'); hold off;

% fit a first-order polynomial to the stress-strain
p = polyfit(engineering_strain, stressReg, 1);
% extract the slope of the polynomial (i.e., the Young's modulus)
youngs_modulus = p(1)
