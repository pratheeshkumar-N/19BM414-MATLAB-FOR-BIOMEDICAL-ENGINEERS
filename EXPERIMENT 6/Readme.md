## EXPERIMENT 6: Simulation of Heart Dynamics

## AIM
To simulate simplified cardiac activation and pressure dynamics in MATLAB.

## INPUT
No external dataset is required. Inputs are heart rate, time step, time constant, baseline pressure and peak
pressure.

## INPUT FILE / PARAMETERS
Variable(s): 
1. HR=72; % beats/min
2. tau=0.20; % time constant (s)
3. Tend=10; % simulation time
4. dt=0.001; % step size
5. baseline=40; % mmHg
6. peak=120; % mmHg
7. t=0:dt:Tend;
8. f=HR/60;

## THEORY / PRINCIPLE
A dynamic physiological system describes how a variable changes over time. A periodic cardiac 
activation signal is used to drive a first-order pressure response. This is a simplified educational model, 
not a clinical patient model.

## PROCESSING FLOWCHART
<img width="777" height="261" alt="image" src="https://github.com/user-attachments/assets/575e443e-c34a-4376-9dd3-b2395c72bcac" />

## PROCEDURE
1. Set heart-rate and model parameters.
2. Generate a periodic cardiac activation signal.
3. Initialize pressure.
4. Use a first-order difference equation to simulate pressure.
5. Plot activation and pressure.
6. Compare activation at different heart rates.
7. Record numerical model outputs.

## OBSERVATION
1. Heart rate	: 72.0	bpm
2. Time constant : 0.200	s
3. Mean simulated pressure : 55.97	mmHg
4. Maximum simulated pressure : 86.07	mmHg
5. Minimum simulated pressure : 40.00	mmHg

## RESULT
The experiment was performed successfully using MATLAB. The input was processed according to the 
stated method and the expected biomedical output was obtained.

**Final result / value:** 
Heart rate = 72 bpm; Mean pressure = 55.97 mmHg.

**Conclusion:**
The heart dynamics simulation was successfully performed using MATLAB. The heart rate, time constant, and simulated pressure values were obtained and analysed. Thus, the heart activation and pressure response were successfully simulated.
