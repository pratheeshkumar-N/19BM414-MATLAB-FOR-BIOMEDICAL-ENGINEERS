## EXPERIMENT 3: Tumor Segmentation Using Thresholding and Region Growing

## AIM:
To segment a tumor-like region from a medical image using thresholding and region growing.

## INPUT:
A de-identified teaching medical image such as tumor_sample.png. It may be grayscale or RGB

## INPUT FILE/PARAMETERS:
File name/model: tumor_sample.png

## THEORY/PRINCIPLE:
Thresholding separates pixels by intensity. Region growing begins from a seed pixel and adds 
neighbouring pixels whose intensity is sufficiently similar. The two methods illustrate different 
approaches to image segmentation.

## PROCESSING FLOWCHART:
<img width="1900" height="532" alt="image" src="https://github.com/user-attachments/assets/0ee62663-62df-40a9-aed6-b38228de6d66" />

## PROCEDURE:
1. Read the image.
2. Convert to grayscale and normalize.
3. Smooth the image.
4. Apply global thresholding and morphological cleaning.
5. Select a seed point.
6. Perform four-connected region growing.
7. Display both masks and the boundary overlay.
8. Calculate segmented areas.

## OBSERVATION:
1. Input file = tumor_sample.mat
2. Image dimensions = 256 x 256 pixels
3. Threshold value = 0.62
4. Region-growing threshold = 0.62
5. Seed point = (165, 110)

## RESULT:
The experiment was performed successfully using MATLAB. The input was processed according to the 
stated method and the expected biomedical output was obtained.
## FINAL VALUE:
1. Thresholding segmented area = 1139 pixels
2. Region-growing segmented area = 1121 pixels
