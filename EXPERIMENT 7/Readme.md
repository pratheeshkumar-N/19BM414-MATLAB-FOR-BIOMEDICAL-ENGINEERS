## EXPERIMENT 7: Blood Pressure Regulation Models

## AIM
To simulate simplified negative-feedback regulation of blood pressure and study disturbance rejection.

## INPUT
No external dataset is required. Inputs are reference BP, initial BP, controller gain, time constant and 
disturbance.

## INPUT FILE / PARAMETERS
Variable(s): 
1. dt=0.01;
2. t=0:dt:60;
3. Pref=100; % reference BP
4. P0=90; % initial BP
5. K=2; % feedback gain
6. tau=5; % time constant

## THEORY / PRINCIPLE
A feedback controller compares measured pressure with a desired reference. The controller produces a 
compensatory signal. A temporary disturbance demonstrates how the closed loop responds and returns 
toward the reference.

## PROCESSING FLOWCHART
<img width="768" height="238" alt="image" src="https://github.com/user-attachments/assets/fc7fa164-ff40-4c1b-af65-b88829802cc3" />

## PROCEDURE
1. Set reference and initial pressure.
2. Create a temporary disturbance.
3. Calculate pressure error.
4. Generate a proportional control signal.
5. Simulate the physiological plant.
6. Plot reference and controlled pressure.
7. Compare several controller gains.

## OBSERVATION
1. Reference BP :	100.0	mmHg
2. Controller gain :	2.00	Gain
3. Minimum pressure during disturbance : 95.01	mmHg
4. Final pressure :	100.00	mmHg
5. Effect of gain	 : Faster pressure correction	Stable response

## RESULT
The experiment was performed successfully using MATLAB. The input was processed according to the 
stated method and the expected biomedical output was obtained.

**Final result / value:** 
Reference BP = 100 mmHg; Final BP = 100 mmHg.

**Conclusion:** 
The blood pressure regulation model was successfully simulated using MATLAB. The controller responded to the disturbance and restored the blood pressure to the reference value of 100 mmHg. Thus, the feedback control system maintained stable blood pressure regulation.
