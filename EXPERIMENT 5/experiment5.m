%% EXPERIMENT 5 - DISEASE CLASSIFICATION USING BIOMEDICAL DATASETS
% Complete runnable example
% Generates synthetic biomedical data, saves and reloads it,
% trains a decision tree, and evaluates test predictions.

clear;
close all;
clc;

rng(10);

fprintf('EXPERIMENT 5: DISEASE CLASSIFICATION\n');

%% 1. GENERATE SAMPLE BIOMEDICAL DATASET
% Features:
% Age, Glucose, Cholesterol, BMI, BloodPressure
%
% Class labels:
% Healthy, ModerateRisk, HighRisk
%
% These are synthetic teaching data, not real patient measurements.

nPerClass = 100;
n = 3 * nPerClass;

Age = zeros(n,1);
Glucose = zeros(n,1);
Cholesterol = zeros(n,1);
BMI = zeros(n,1);
BloodPressure = zeros(n,1);
Disease = cell(n,1);

% Healthy group
idx1 = 1:nPerClass;
Age(idx1) = 25 + 10*randn(nPerClass,1);
Glucose(idx1) = 85 + 8*randn(nPerClass,1);
Cholesterol(idx1) = 170 + 18*randn(nPerClass,1);
BMI(idx1) = 22 + 2.5*randn(nPerClass,1);
BloodPressure(idx1) = 112 + 8*randn(nPerClass,1);
Disease(idx1) = {'Healthy'};

% Moderate-risk group
idx2 = nPerClass+1:2*nPerClass;
Age(idx2) = 45 + 10*randn(nPerClass,1);
Glucose(idx2) = 120 + 12*randn(nPerClass,1);
Cholesterol(idx2) = 205 + 20*randn(nPerClass,1);
BMI(idx2) = 28 + 3*randn(nPerClass,1);
BloodPressure(idx2) = 130 + 10*randn(nPerClass,1);
Disease(idx2) = {'ModerateRisk'};

% High-risk group
idx3 = 2*nPerClass+1:3*nPerClass;
Age(idx3) = 58 + 9*randn(nPerClass,1);
Glucose(idx3) = 165 + 18*randn(nPerClass,1);
Cholesterol(idx3) = 240 + 22*randn(nPerClass,1);
BMI(idx3) = 34 + 4*randn(nPerClass,1);
BloodPressure(idx3) = 150 + 12*randn(nPerClass,1);
Disease(idx3) = {'HighRisk'};

% Keep generated values within plausible teaching ranges
Age = min(max(Age,18),85);
Glucose = min(max(Glucose,60),250);
Cholesterol = min(max(Cholesterol,100),350);
BMI = min(max(BMI,15),50);
BloodPressure = min(max(BloodPressure,80),220);

% Combine features and label
T = table(Age, Glucose, Cholesterol, BMI, ...
    BloodPressure, categorical(Disease), ...
    'VariableNames', {'Age','Glucose','Cholesterol', ...
    'BMI','BloodPressure','Disease'});

% Add a few missing feature values to demonstrate cleaning
T.Glucose([12 145 278]) = NaN;
T.BMI([45 198]) = NaN;

%% 2. SAVE AND RELOAD THE DATASET
writetable(T, 'biomedical_dataset.csv');
fprintf('Dataset saved as biomedical_dataset.csv\n');

T = readtable('biomedical_dataset.csv');

fprintf('Number of samples: %d\n', height(T));
fprintf('Number of variables: %d\n', width(T));

disp('First five rows of the dataset:');
disp(T(1:5,:));

%% 3. SEPARATE FEATURES AND LABELS
X = [T.Age, T.Glucose, T.Cholesterol, ...
     T.BMI, T.BloodPressure];

%Y = T.Disease;
Y = categorical(T.Disease);
% ...
classes = categories(Y);


featureNames = {'Age','Glucose','Cholesterol', ...
                'BMI','BloodPressure'};

%% 4. SPLIT INTO TRAINING AND TEST SETS
% Stratified split: each disease class contributes approximately
% 80% of its observations to training and 20% to testing.

trainIdx = false(height(T),1);
testIdx = false(height(T),1);

classes = categories(Y);

for c = 1:numel(classes)
    classIdx = find(Y == classes{c});
    classIdx = classIdx(randperm(numel(classIdx)));

    nTrain = floor(0.80 * numel(classIdx));

    trainIdx(classIdx(1:nTrain)) = true;
    testIdx(classIdx(nTrain+1:end)) = true;
end

XTrain = X(trainIdx,:);
YTrain = Y(trainIdx);

XTest = X(testIdx,:);
YTest = Y(testIdx);

fprintf('\nTraining samples: %d\n', sum(trainIdx));
fprintf('Testing samples: %d\n', sum(testIdx));

%% 5. HANDLE MISSING VALUES USING TRAINING MEDIANS
% Estimate each feature's median from training data only.
% Apply those same values to training and test data.

medians = zeros(1,size(XTrain,2));

for j = 1:size(XTrain,2)
    validValues = XTrain(~isnan(XTrain(:,j)),j);

    if isempty(validValues)
        medians(j) = 0;
    else
        medians(j) = median(validValues);
    end

    missingTrain = isnan(XTrain(:,j));
    XTrain(missingTrain,j) = medians(j);

    missingTest = isnan(XTest(:,j));
    XTest(missingTest,j) = medians(j);
end

fprintf('\nMissing values handled using training medians.\n');

%% 6. TRAIN THE DECISION TREE CLASSIFIER
% Requires Statistics and Machine Learning Toolbox.

treeModel = fitctree(XTrain, YTrain, ...
    'PredictorNames', featureNames, ...
    'MaxNumSplits', 20, ...
    'MinLeafSize', 5);

fprintf('Decision tree training completed.\n');

%% 7. PREDICT THE TEST DATA
YPred = predict(treeModel, XTest);

%% 8. CALCULATE CLASSIFICATION ACCURACY
correctCount = sum(YPred == YTest);
totalTest = numel(YTest);
accuracy = 100 * correctCount / totalTest;

fprintf('\n===== CLASSIFICATION RESULTS =====\n');
fprintf('Correct predictions: %d\n', correctCount);
fprintf('Total test samples: %d\n', totalTest);
fprintf('Test accuracy: %.2f%%\n', accuracy);

%% 9. CONFUSION MATRIX
% Rows = actual class; columns = predicted class.

classNames = categories(Y);
numClasses = numel(classNames);

C = zeros(numClasses,numClasses);

for i = 1:numel(YTest)
    actual = find(strcmp(classNames, char(YTest(i))),1);
    predicted = find(strcmp(classNames, char(YPred(i))),1);

    C(actual,predicted) = C(actual,predicted) + 1;
end

figure('Name','Disease Classification Confusion Matrix');
imagesc(C);
axis image;
colorbar;

xticks(1:numClasses);
yticks(1:numClasses);
xticklabels(classNames);
yticklabels(classNames);
xlabel('Predicted Class');
ylabel('Actual Class');
title(sprintf('Confusion Matrix - Accuracy %.2f%%',accuracy));

for i = 1:numClasses
    for j = 1:numClasses
        text(j,i,num2str(C(i,j)), ...
            'HorizontalAlignment','center', ...
            'FontWeight','bold');
    end
end

%% 10. CLASS-WISE PERFORMANCE
fprintf('\n===== CLASS-WISE METRICS =====\n');

precision = zeros(numClasses,1);
recall = zeros(numClasses,1);
F1 = zeros(numClasses,1);

for c = 1:numClasses
    TP = C(c,c);
    FP = sum(C(:,c)) - TP;
    FN = sum(C(c,:)) - TP;

    if TP + FP > 0
        precision(c) = TP / (TP + FP);
    end

    if TP + FN > 0
        recall(c) = TP / (TP + FN);
    end

    if precision(c) + recall(c) > 0
        F1(c) = 2 * precision(c) * recall(c) / ...
            (precision(c) + recall(c));
    end

    fprintf('%s: Precision = %.3f, Recall = %.3f, F1 = %.3f\n', ...
        classNames{c}, precision(c), recall(c), F1(c));
end

%% 11. DISPLAY THE TRAINED DECISION TREE
figure('Name','Trained Decision Tree');
view(treeModel,'Mode','graph');
title('Decision Tree for Biomedical Classification');

%% 12. PLOT FEATURE DISTRIBUTIONS
figure('Name','Biomedical Feature Distributions');

subplot(2,2,1);
histogram(T.Age);
title('Age Distribution');
xlabel('Age (years)');
ylabel('Count');
grid on;

subplot(2,2,2);
histogram(T.Glucose);
title('Glucose Distribution');
xlabel('Glucose (synthetic units)');
ylabel('Count');
grid on;

subplot(2,2,3);
histogram(T.Cholesterol);
title('Cholesterol Distribution');
xlabel('Cholesterol (synthetic units)');
ylabel('Count');
grid on;

subplot(2,2,4);
histogram(T.BMI);
title('BMI Distribution');
xlabel('BMI (kg/m^2)');
ylabel('Count');
grid on;

%% 13. SAVE MODEL AND RESULTS
save('Exp5_results.mat', 'treeModel', 'C', 'accuracy', ...
    'precision', 'recall', 'F1', 'classNames', ...
    'featureNames', 'medians');

fprintf('\nDataset saved: biomedical_dataset.csv\n');
fprintf('Results saved: Exp5_results.mat\n');
fprintf('Experiment 5 completed successfully.\n');
