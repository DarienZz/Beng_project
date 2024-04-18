% Base directory where the files are located
baseDir = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\Beng Project\5dB_noise';

% List of subject folders
subjects = 1:54;

% Loop over each subject folder
for subj = subjects
    % Define the current file path (change the session number)
    currentFilePath = fullfile(baseDir, sprintf('sess02_subj%02d_EEG_MI.mat', subj));
    
    % Define the new file path (change the session number)
    newFilePath = fullfile(baseDir, '\session2', sprintf('s%d', subj), 'EEG_MI.mat');
    
    % Check if the current file exists
    if exist(currentFilePath, 'file')
        % Rename the file to EEG_MI.mat
        movefile(currentFilePath, newFilePath);
    else
        % Display a warning if the file does not exist
        warning('File does not exist: %s', currentFilePath);
    end
end

disp('Renaming completed.');