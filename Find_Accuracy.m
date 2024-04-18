% Define the number of subjects
num_subjects = 54;

% Define the base directory where the CSV files are located
base_dir = 'F:\Beng_Project\Dataset_result\Frequency_Shift\output_within_fs0.5';

% Initialize an array to hold the (1 - minimum value) from column E of each CSV file
oneMinusMinValues = zeros(num_subjects, 1);

% Loop over the subject numbers
for s = 1:num_subjects
    % Create the file name based on the pattern
    csv_filename = fullfile(base_dir, sprintf('epochs_s%d.csv', s));
    
    % Check if the file exists
    if exist(csv_filename, 'file')
        % Read the entire CSV file into a table
        dataTable = readtable(csv_filename);
        
        % Check if dataTable has at least 5 columns
        if size(dataTable, 2) >= 5
            % Assuming 'E' is the 5th column, find the minimum value in that column
            minValue = min(dataTable{:, 5});
            % Calculate 1 - minimum value and store it
            oneMinusMinValues(s) = 1 - minValue;
        else
            warning('File %s does not have at least 5 columns.', csv_filename);
            oneMinusMinValues(s) = NaN;
        end
    else
        warning('File does not exist: %s', csv_filename);
        oneMinusMinValues(s) = NaN; % Use NaN to represent that the file was missing
    end
end

% Display the (1 - minimum values)
disp('1 minus the smallest numbers in the 5th column for each CSV file are:');
disp(oneMinusMinValues);