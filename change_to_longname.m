% MATLAB script to rename and transfer .mat files with a known file name

% Define the base directory
baseDir = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\Beng Project\5dB_noise';

% Specify the number of sessions and the number of subjects per session
numSessions = 2;
numSubjectsPerSession = 54;

% Loop over each session and subject
for sessionNum = 1:numSessions
    for subjectNum = 1:numSubjectsPerSession
        % Construct the source directory path
        sourceDir = fullfile(baseDir, sprintf('session%d', sessionNum), sprintf('s%d', subjectNum));
        
        % Define the known source file name
        sourceFileName = 'EEG_MI.mat';
        
        % Define the source file path
        sourceFilePath = fullfile(sourceDir, sourceFileName);
        
        % Check if the source file exists
        if exist(sourceFilePath, 'file')
            % Define the new file name
            newFileName = sprintf('sess%02d_subj%02d_EEG_MI.mat', sessionNum, subjectNum);
            
            % Define the destination file path
            destFilePath = fullfile(baseDir, newFileName);
            
            % Rename and move the file
            movefile(sourceFilePath, destFilePath);
        else
            % If the source file does not exist, print an error message
            fprintf('Error: File does not exist: %s\n', sourceFilePath);
        end
    end
end

% Display completion message
disp('All files have been renamed and transferred successfully.');