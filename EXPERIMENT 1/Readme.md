## EXPERIMENT 1: ECG Noise Removal and QRS Detection

## AIM:
To remove noise from an ECG signal and detect QRS complexes using MATLAB.

## INPUT FILE/PARAMETERS:
File name/model:ecg_sample.mat

## THEORY/PRINCIPLE:
ECG contains characteristic P, QRS and T waves and may be contaminated by baseline wander, powerline interference 
and high-frequency noise. A band-pass filter is used to emphasize QRS energy.Differentiation, squaring and moving-window
integration further enhance the QRS complexes before peak detection.

## PROCESSING FLOWCHART:
<img width="1900" height="532" alt="image" src="https://github.com/user-attachments/assets/ca82a830-2c48-4da5-bdbe-3fda0846ccd5" />

## PROCEDURE
1. Load the ECG and inspect its duration and amplitude.
2. Remove the DC component.
3. Design and apply a 5–15 Hz Butterworth band-pass filter
4. Differentiate and square the filtered ECG.
5. Apply a 150 ms moving-window integration.
6. Detect QRS candidates using minimum height and minimum distance.
7. Calculate RR intervals and estimated heart rate.

## OBSERVATIONS:
1. Sampling frequency = 360Hz
2. Signal Duration =10.00 seconds
3. Detected QRS Complexes = 12
4. Estimated heart rate/ mean RR interval= 75.19 bpm

## RESULT:
The experiment was performed successfully using MATLAB. The input was processed according to the 
stated method and the expected biomedical output was obtained.
