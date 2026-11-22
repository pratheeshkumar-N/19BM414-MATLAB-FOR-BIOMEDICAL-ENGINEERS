## EXPERIMENT 5: Disease Classification Using Biomedical Datasets

## AIM
To classify biomedical observations into disease classes using supervised machine learning.

## INPUT
A CSV dataset with rows as samples, numerical biomedical predictors and one categorical class column 
named Disease. Example: biomedical_dataset.csv.

## INPUT FILE / PARAMETERS
File name / model: biomedical_dataset.csv 

## THEORY / PRINCIPLE
Biomedical classification uses measured features to predict predefined classes. This experiment 
demonstrates data cleaning, missing-value imputation, train/test separation, decision-tree training, 
prediction and performance evaluation.

## PROCESSING FLOWCHART
<img width="916" height="281" alt="image" src="https://github.com/user-attachments/assets/f0fb6a2b-d261-4c6f-9c30-3638bdde3339" />

## PROCEDURE
1. Load and inspect the dataset.
2. Separate the disease label from predictors.
3. Select numerical predictors.
4. Impute missing values using the median.
5. Partition data into training and test sets.
6. Train a decision tree.
7. Predict the test set.
8. Calculate accuracy and class-wise metrics.
9. Display the confusion matrix and tree.

## Observation
1. Total samples : 300	Samples
2. Number of predictors :	5	Features
3. Training/test sample counts :	240 / 60	Training / Testing
4. Test accuracy : 95.00%	Percentage
5. Precision, recall and F1 for a class	Healthy : 0.952, 1.000, 0.976	Precision, Recall, F1-score


- Healthy: P = 0.952, R = 1.000, F1 = 0.976
- HighRisk: P = 0.950, R = 0.950, F1 = 0.950
- ModerateRisk: P = 0.947, R = 0.900, F1 = 0.923

## RESULT

The experiment was performed successfully using MATLAB. The input was processed according to the 
stated method and the expected biomedical output was obtained.

**Final Result / Value**

1. Correct predictions: 57 
2. Total test samples: 60
3. Test accuracy: 95.00%

## Conclusion:

Thus, disease classification was successfully performed using MATLAB Decision Tree classification. The model classified Healthy, HighRisk and ModerateRisk categories with good accuracy.
