%% EXPERIMENT 4 - DICOM IMAGE ANALYSIS
% Generates a synthetic CT-like image, saves and reloads it,
% performs windowing, selects an ROI and calculates statistics.
% This educational example does not use a real patient scan.

clear;
close all;
clc;

%% 1. GENERATE INPUT IMAGE
fprintf('EXPERIMENT 4: DICOM IMAGE ANALYSIS\n');

imageSize = 256;
[X, Y] = meshgrid(1:imageSize, 1:imageSize);

% Synthetic CT-like background in approximate Hounsfield Units (HU)
ctImage = -100 * ones(imageSize, imageSize);

% Body region
bodyMask = ((X - 128).^2 / 90^2 + ...
            (Y - 128).^2 / 105^2) <= 1;
ctImage(bodyMask) = 35;

% Simulated internal tissue regions
organ1 = ((X - 100).^2 / 30^2 + ...
          (Y - 120).^2 / 42^2) <= 1;
ctImage(organ1) = 65;

organ2 = ((X - 158).^2 / 25^2 + ...
          (Y - 145).^2 / 32^2) <= 1;
ctImage(organ2) = 90;

% Simulated high-density region
bone1 = ((X - 128).^2 + (Y - 65).^2) <= 15^2;
ctImage(bone1) = 500;

% Add small random variation
rng(4);
noise = 8 * randn(imageSize, imageSize);
ctImage(bodyMask) = ctImage(bodyMask) + noise(bodyMask);

% Example image metadata (educational values)
pixelSpacing = [0.7 0.7];   % mm per pixel
sliceThickness = 1.0;       % mm
rescaleSlope = 1;
rescaleIntercept = 0;

% Save input data
save('dicom_sample.mat', 'ctImage', 'pixelSpacing', ...
    'sliceThickness', 'rescaleSlope', 'rescaleIntercept');

fprintf('Synthetic input saved as dicom_sample.mat\n');

%% 2. LOAD INPUT IMAGE
S = load('dicom_sample.mat');

storedImage = double(S.ctImage);
pixelSpacing = S.pixelSpacing;
sliceThickness = S.sliceThickness;
rescaleSlope = S.rescaleSlope;
rescaleIntercept = S.rescaleIntercept;

% Convert stored pixel values to HU
HU = storedImage * rescaleSlope + rescaleIntercept;

fprintf('\n===== IMAGE INFORMATION =====\n');
fprintf('Image dimensions: %d x %d pixels\n', ...
    size(HU,1), size(HU,2));
fprintf('Pixel spacing: %.2f x %.2f mm\n', ...
    pixelSpacing(1), pixelSpacing(2));
fprintf('Slice thickness: %.2f mm\n', sliceThickness);
fprintf('Minimum intensity: %.2f HU\n', min(HU(:)));
fprintf('Maximum intensity: %.2f HU\n', max(HU(:)));

%% 3. DISPLAY ORIGINAL IMAGE
figure('Name','Experiment 4 - DICOM Image Analysis');

subplot(2,2,1);
imagesc(HU);
axis image;
colormap gray;
colorbar;
title('Original Synthetic CT-like Image');
xlabel('Column (pixels)');
ylabel('Row (pixels)');

%% 4. CT WINDOWING
% Example soft-tissue window
windowLevel = 40;      % HU
windowWidth = 400;     % HU

windowMin = windowLevel - windowWidth/2;
windowMax = windowLevel + windowWidth/2;

% Clip intensities to the selected window
windowedImage = min(max(HU, windowMin), windowMax);

% Scale intensities to the range 0 to 1
windowedImage = (windowedImage - windowMin) / windowWidth;

subplot(2,2,2);
imagesc(windowedImage, [0 1]);
axis image;
colormap gray;
colorbar;
title('Windowed Image');
xlabel('Column (pixels)');
ylabel('Row (pixels)');

%% 5. SELECT REGION OF INTEREST (ROI)
% Fixed rectangular ROI so the script runs without manual selection
rowStart = 105;
rowEnd = 145;
colStart = 105;
colEnd = 150;

ROI = HU(rowStart:rowEnd, colStart:colEnd);

% ROI mask for visualization
roiMask = false(size(HU));
roiMask(rowStart:rowEnd, colStart:colEnd) = true;

subplot(2,2,3);
imagesc(HU);
axis image;
colormap gray;
colorbar;
hold on;

% Draw ROI rectangle
rectangle('Position', ...
    [colStart, rowStart, colEnd-colStart+1, rowEnd-rowStart+1], ...
    'EdgeColor','r', 'LineWidth',2);

title('Selected Region of Interest');
xlabel('Column (pixels)');
ylabel('Row (pixels)');

%% 6. ROI STATISTICAL ANALYSIS
roiPixelCount = numel(ROI);
roiMean = mean(ROI(:));
roiStd = std(ROI(:));
roiMin = min(ROI(:));
roiMax = max(ROI(:));

% Approximate physical area of ROI
pixelArea = pixelSpacing(1) * pixelSpacing(2);
roiArea = roiPixelCount * pixelArea;

subplot(2,2,4);
histogram(ROI(:), 20);
title('Intensity Distribution Within ROI');
xlabel('Intensity (HU)');
ylabel('Pixel Count');
grid on;

%% 7. DISPLAY ROI STATISTICS
fprintf('\n===== ROI ANALYSIS =====\n');
fprintf('ROI rows: %d to %d\n', rowStart, rowEnd);
fprintf('ROI columns: %d to %d\n', colStart, colEnd);
fprintf('ROI pixel count: %d\n', roiPixelCount);
fprintf('Approximate ROI area: %.2f mm^2\n', roiArea);
fprintf('ROI mean intensity: %.2f HU\n', roiMean);
fprintf('ROI standard deviation: %.2f HU\n', roiStd);
fprintf('ROI minimum intensity: %.2f HU\n', roiMin);
fprintf('ROI maximum intensity: %.2f HU\n', roiMax);

%% 8. SAVE RESULTS
save('Exp4_results.mat', 'HU', 'windowedImage', 'ROI', ...
    'roiPixelCount', 'roiMean', 'roiStd', 'roiMin', 'roiMax', ...
    'roiArea', 'pixelSpacing', 'sliceThickness', ...
    'windowLevel', 'windowWidth');

fprintf('\nResults saved as Exp4_results.mat\n');
fprintf('Experiment 4 completed successfully.\n');
