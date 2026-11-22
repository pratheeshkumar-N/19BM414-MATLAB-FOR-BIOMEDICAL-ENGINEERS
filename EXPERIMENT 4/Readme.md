## EXPERIMENT 4: DICOM Image Analysis

## AIM
    To read, visualize and quantitatively analyse a DICOM medical image using MATLAB.

## INPUT
    A de-identified DICOM file such as sample_ct.dcm. Patient identifiers must not be copied into the 
    report.
## THEORY / PRINCIPLE
    DICOM stores image pixels together with acquisition and technical metadata. dicominfo reads the 
    header and dicomread reads the image. For CT, rescale slope and intercept may be used to obtain 
    physical CT values.

## PROCESSING FLOWCHART
<img width="1900" height="532" alt="image" src="https://github.com/user-attachments/assets/dba463ce-3ea8-4dfb-b266-8287cb4c80ac" />

## PROCEDURE
    1. Read DICOM metadata.
    2. Display selected technical metadata.
    3. Read the pixel array.
    4. Display original and normalized images.
    5. If applicable, convert CT values using rescale slope/intercept.
    6. Apply an illustrative window.
    7. Draw an ROI and calculate mean, standard deviation, minimum and maximum.

## OBSERVATION
 ## IMAGE INFORMATION
    1. Image dimensions: 256 x 256 pixels
    2. Pixel spacing: 0.70 x 0.70 mm
    3. Slice thickness: 1.00 mm
    4. Minimum intensity: -100.00 HU
    5. Maximum intensity: 520.00 HU

## ROI ANALYSIS
    1. ROI rows: 105 to 145
    2. ROI columns: 105 to 150
    3. ROI pixel count: 1886
    4. Approximate ROI area: 924.14 mm^2
    5. ROI mean intensity: 62.33 HU
    6. ROI standard deviation: 20.63 HU
    7. ROI minimum intensity: 15.79 HU
    8. ROI maximum intensity: 110.55 HU

## RESULT
    The experiment was performed successfully using MATLAB. The input was processed according to the 
    stated method and the expected biomedical output was obtained.
