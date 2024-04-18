% Initialize a struct to store the ranks and values from column E
results = struct();

% Base directory pattern
baseDirPattern = 'F:\\Beng_Project\\Dataset_result\\no_noise\\output_base1\\fold%d\\best';

% Process folds from 0 to 53
for foldNum = 0:53
    % Create the directory path for the current fold
    foldDir = sprintf(baseDirPattern, foldNum);
    
    % Find the .csv file in the current directory
    csvFiles = dir(fullfile(foldDir, '*.csv'));
    % Find the .json file in the current directory
    jsonFiles = dir(fullfile(foldDir, '*.json'));

    % Check if there is exactly one .csv file and one .json file
    if length(csvFiles) == 1 && length(jsonFiles) == 1
        % Construct the full filename for the .csv file
        csvFilename = fullfile(foldDir, csvFiles(1).name);
        % Read the .csv file into a table
        data = readtable(csvFilename);
        
        % Extract the rank from the .json filename
        jsonFilename = jsonFiles(1).name;
        rankStr = regexp(jsonFilename, 's(\d+)_', 'tokens');
        if ~isempty(rankStr) && ~isempty(rankStr{1})
            rank = str2double(rankStr{1}{1});
        else
            error('Could not extract rank from JSON filename: %s', jsonFilename);
        end
        
        % Get the value in the last row of column E by index
        columnIndex = 5; % Assuming 'E' is the fifth column
        columnEValue = data{end, columnIndex};
        
        % Store the extracted rank and its corresponding value
        results(foldNum + 1).rank = rank;
        results(foldNum + 1).value = columnEValue;
    else
        % Handle the case where the .csv file or .json file is not found, or multiples are found
        warning('There should be exactly one CSV file and one JSON file in the directory: %s. Skipping this directory.', foldDir);
        results(foldNum + 1).rank = NaN;
        results(foldNum + 1).value = NaN;
    end
end

% Sort the results based on the rank
[~, order] = sort([results.rank]);
sortedResults = results(order);

% Extract the sorted values
sortedValues = [sortedResults.value]';

% Display the sorted values
disp(sortedValues);