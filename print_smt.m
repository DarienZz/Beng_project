% Load the .mat file
data = load('C:\Users\Z\OneDrive - University of Edinburgh\Desktop\notthis_Beng_Project\no_noise\sess01_subj01_EEG_MI.mat');

% Assuming 'EEG_MI_train.smt' is the variable name inside the .mat file
% Select the first 'slice' of the third dimension
selected_data = data.EEG_MI_train.smt(:, :, 13);

% Now 'selected_data' is a 4000x100 matrix corresponding to the first of the 62 channels