% Read data for session1 and session2 from the Excel file
[cspcv, ~, ~] = xlsread('C:\Users\Z\OneDrive - University of Edinburgh\Desktop\cspdata.xlsx', 'Sheet3', 'AB3:AB56');
[other_method, ~, ~] = xlsread('C:\Users\Z\OneDrive - University of Edinburgh\Desktop\cspdata.xlsx', 'Sheet3', 'Y3:Y56');

% Calculate number of points where session2 > session1 (above y=x), session2 < session1 (below y=x), and session2 = session1 (on y=x)
num_points_above = sum(other_method > cspcv);
num_points_below = sum(other_method < cspcv);
num_points_on = sum(other_method == cspcv);

% Read content of cells 'D2' 
%[~, customTitlePart1, ~] = xlsread('C:\Users\Z\OneDrive - University of Edinburgh\Desktop\cspdata.xlsx', 'Sheet3', 'D1:D1');
%[~, customTitlePart2, ~] = xlsread('C:\Users\Z\OneDrive - University of Edinburgh\Desktop\cspdata.xlsx', 'Sheet3', 'J1:J1');
fullTitle = ' ML method average vs. Subj-Indp CNN with 25dB noise addition';

% Create a scatter plot
figure;
scatter(cspcv, other_method, 20, 'k', 'o', 'filled');
hold on;

% Add a reference line x = y
plot([0, 1], [0, 1], 'k--', 'LineWidth', 2); % Plotting line from (0,0) to (1,1)

% Customize the plot
title(fullTitle);
xlabel('accuracy of ML method average');
ylabel('accuracy of Subj-Indp CNN with 25dB noise addition');
axis([0.4 1 0.4 1]); % Set the limits of the axes
grid on;

% Annotate the number of points above, below, and on y=x
text(0.41, 0.99, ['y>x count: ' num2str(num_points_above)], 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', 'FontSize', 10, 'BackgroundColor', 'white');
text(0.98, 0.41, ['y<x count: ' num2str(num_points_below)], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 10, 'BackgroundColor', 'white');
text(0.41, 0.41, ['y=x count: ' num2str(num_points_on)], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'FontSize', 10, 'BackgroundColor', 'white');

% Define the filename
filename = 'x';

% Define the folder path where you want to save the figure
folderPath = 'F:\Beng_Project\figure';

% Check if the folder exists, and if not, create it
if ~exist(folderPath, 'dir')
    mkdir(folderPath);
end

% Combine the folder path and filename
fullFilePath = fullfile(folderPath, [filename, '.png']);  % Specifies that the file is saved as a PNG

% Set the figure properties
set(gcf, 'Units', 'inches', 'Position', [0, 0, 6, 5]);

% Save the plot with high resolution
print(gcf, fullFilePath, '-dpng', '-r300');

% Inform the user
disp(['Figure saved to: ' fullFilePath]);