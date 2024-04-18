% Define the directory where the files are located
folder = 'F:\Beng_Project\Dataset_result\no_noise\output_within1';

% Get a list of all files with the pattern 'epochs_s*.csv' in the folder
filePattern = fullfile(folder, 'epochs_s*.csv');
csvFiles = dir(filePattern);

% Initialize a variable to accumulate the values for each row
sumValues = zeros(19, 1);

% Initialize a count of valid files that have at least 20 rows
validFilesCount = 0;

% Loop through each file
for k = 1:length(csvFiles)
    % Get the full path to the file
    fullFileName = fullfile(csvFiles(k).folder, csvFiles(k).name);
    
    % Read the data from the CSV file
    data = readtable(fullFileName);
    
    % Check if the file has at least 20 rows
    if height(data) >= 20
        % Increment the count of valid files
        validFilesCount = validFilesCount + 1;
        
        % Loop through rows 2 to 20
        for row = 2:20
            % Add the value from the 5th column of the current row to the accumulator
            sumValues(row-1) = sumValues(row-1) + data{row, 5};
        end
    else
        % If the file does not have 20 rows, skip it
        continue;
    end
end

% Calculate the average values for each row
% Only divide by the number of valid files
averageValues = sumValues / validFilesCount;

% Output the average values for each row
for row = 2:20
    disp([num2str(averageValues(row-1))]);
end