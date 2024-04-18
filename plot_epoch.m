% Error rates for each epoch
error_rates = [
    0.43842;
    0.43316;
    0.42895;
    0.43632;
    0.40789;
    0.41053;
    0.41474;
    0.40632;
    0.41579;
    0.38842;
    0.41;
    0.39368;
    0.39474;
    0.38947;
    0.36895;
    0.38684;
    0.37842;
    0.38368;
    0.38053
];

accuracy_rates = [
    0.43842;
    0.43316;
    0.42895;
    0.43632;
    0.40789;
    0.41053;
    0.41474;
    0.40632;
    0.41579;
    0.38842;
    0.41;
    0.39368;
    0.39474;
    0.38947;
    0.36895;
    0.38684;
    0.37842;
    0.38368;
    0.38053
];
% Convert error rates to accuracy rates
accuracy_rates = 1 - error_rates;

% Generate epoch numbers based on the length of the error_rates array
epochs = 1:length(error_rates);

% Create the plot
plot(epochs, accuracy_rates, '-o');

% Add title and axis labels
title('Accuracy Rate vs. Epochs');
xlabel('Epoch');
ylabel('Accuracy Rate');

% Enable grid
grid on;

% Optionally, limit the y-axis to range from 0 to 1
ylim([0 1]);