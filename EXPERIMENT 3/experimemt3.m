%% EXPERIMENT 3: TUMOR SEGMENTATION
% Complete program:
% 1. Generate a simulated medical image
% 2. Save and load the input image
% 3. Perform threshold-based segmentation
% 4. Perform seed-based region growing
% 5. Display segmentation results
% 6. Calculate segmented area
%
% This code does not require the Image Processing Toolbox.
% The input image is simulated for educational purposes.

clear;
close all;
clc;

%% STEP 1: GENERATE A SIMULATED MEDICAL IMAGE

imageSize = 256;
[X, Y] = meshgrid(1:imageSize, 1:imageSize);

% Simulated elliptical head/brain region
centerX = 128;
centerY = 128;

brainMask = ((X-centerX).^2 / 90^2 + ...
             (Y-centerY).^2 / 105^2) <= 1;

% Create a smooth grayscale background
brainImage = 0.30 + 0.12 * ...
    exp(-((X-125).^2 + (Y-130).^2) / (2*65^2));

% Add a subtle internal tissue pattern
brainImage = brainImage ...
    + 0.035*sin(X/12) ...
    + 0.025*cos(Y/15);

% Simulate a bright tumor-like region
tumorCenterX = 165;
tumorCenterY = 110;
tumorSigmaX = 13;
tumorSigmaY = 16;

simulatedTumor = 0.48 * exp( ...
    -(((X-tumorCenterX).^2)/(2*tumorSigmaX^2) ...
    + ((Y-tumorCenterY).^2)/(2*tumorSigmaY^2)));

brainImage = brainImage + simulatedTumor;

% Add random noise
rng(3);
brainImage = brainImage + 0.025*randn(size(brainImage));

% Set background outside the brain
brainImage(~brainMask) = 0.05;

% Keep image intensities between 0 and 1
brainImage = max(0, min(1, brainImage));

% Save the simulated input image
filename = 'tumor_sample.mat';
save(filename, 'brainImage');

fprintf('STEP 1: Simulated medical image created.\n');
fprintf('Input file saved as %s\n', filename);

%% STEP 2: LOAD THE INPUT IMAGE

S = load(filename);
brainImage = double(S.brainImage);

[rows, cols] = size(brainImage);

fprintf('\nSTEP 2: Image loaded successfully.\n');
fprintf('Image size = %d x %d pixels\n', rows, cols);

%% STEP 3: DISPLAY THE ORIGINAL IMAGE

figure('Name', 'Figure 1 - Original Image');

imagesc(brainImage);
axis image;
colormap gray;
colorbar;
title('Simulated Grayscale Brain Image');
xlabel('X pixel');
ylabel('Y pixel');

%% STEP 4: APPLY THRESHOLDING

% Threshold selected for this simulated image
threshold = 0.62;

% Candidate bright regions
thresholdMask = brainImage >= threshold;

% Exclude the background outside the brain
thresholdMask = thresholdMask & brainMask;

figure('Name', 'Figure 2 - Threshold Segmentation');

imagesc(thresholdMask);
axis image;
colormap gray;
colorbar;
title('Tumor Candidate Mask Using Thresholding');
xlabel('X pixel');
ylabel('Y pixel');

%% STEP 5: REGION GROWING FROM A SEED POINT

% Seed point placed inside the simulated tumor
seedX = tumorCenterX;
seedY = tumorCenterY;

seedIndex = sub2ind([rows, cols], seedY, seedX);

% Intensity criterion for region growing
% Neighbouring pixels must be brighter than this value.
regionThreshold = 0.62;

% Initialise the segmentation mask
regionMask = false(rows, cols);

% Queue for breadth-first region growing
maxPixels = rows * cols;
queue = zeros(maxPixels, 1);

head = 1;
tail = 1;

queue(tail) = seedIndex;
regionMask(seedIndex) = true;

while head <= tail

    currentIndex = queue(head);
    head = head + 1;

    [currentY, currentX] = ind2sub( ...
        [rows, cols], currentIndex);

    % Four-connected neighbours
    neighbours = [
        currentY-1, currentX
        currentY+1, currentX
        currentY,   currentX-1
        currentY,   currentX+1
    ];

    for n = 1:4

        ny = neighbours(n, 1);
        nx = neighbours(n, 2);

        % Check image boundaries
        if ny < 1 || ny > rows || nx < 1 || nx > cols
            continue;
        end

        neighbourIndex = sub2ind([rows, cols], ny, nx);

        % Add pixels satisfying the intensity criterion
        if ~regionMask(neighbourIndex) ...
                && brainMask(neighbourIndex) ...
                && brainImage(neighbourIndex) >= regionThreshold

            regionMask(neighbourIndex) = true;

            tail = tail + 1;
            queue(tail) = neighbourIndex;
        end
    end
end

figure('Name', 'Figure 3 - Region Growing');

imagesc(regionMask);
axis image;
colormap gray;
colorbar;
title('Tumor Candidate Mask Using Region Growing');
xlabel('X pixel');
ylabel('Y pixel');

%% STEP 6: COMPARE BOTH SEGMENTATION METHODS

figure('Name', 'Figure 4 - Segmentation Comparison');

subplot(1, 2, 1);
imagesc(thresholdMask);
axis image;
colormap gray;
title('Thresholding');
xlabel('X pixel');
ylabel('Y pixel');

subplot(1, 2, 2);
imagesc(regionMask);
axis image;
colormap gray;
title('Region Growing');
xlabel('X pixel');
ylabel('Y pixel');

%% STEP 7: OVERLAY THE SEGMENTED REGION

figure('Name', 'Figure 5 - Segmentation Overlay');

imagesc(brainImage);
axis image;
colormap gray;
colorbar;
hold on;

% Outline the region-growing mask using boundary transitions
boundaryMask = false(rows, cols);

for r = 2:rows-1
    for c = 2:cols-1

        if regionMask(r,c)

            if ~regionMask(r-1,c) || ...
               ~regionMask(r+1,c) || ...
               ~regionMask(r,c-1) || ...
               ~regionMask(r,c+1)

                boundaryMask(r,c) = true;
            end
        end
    end
end

[boundaryY, boundaryX] = find(boundaryMask);

plot(boundaryX, boundaryY, 'r.', 'MarkerSize', 5);
plot(seedX, seedY, 'go', ...
    'MarkerFaceColor', 'g', 'MarkerSize', 8);

title('Region-Growing Segmentation Overlay');
xlabel('X pixel');
ylabel('Y pixel');
legend('Tumor candidate boundary', 'Seed point');
hold off;

%% STEP 8: CALCULATE SEGMENTED AREA

thresholdArea = sum(thresholdMask(:));
regionArea = sum(regionMask(:));

% Each pixel represents one pixel-area unit
pixelArea = 1;

thresholdAreaUnits = thresholdArea * pixelArea;
regionAreaUnits = regionArea * pixelArea;

%% STEP 9: DISPLAY RESULTS

fprintf('\n========================================\n');
fprintf('       EXPERIMENT 3 RESULTS\n');
fprintf('========================================\n');

fprintf('Input file = %s\n', filename);
fprintf('Image dimensions = %d x %d pixels\n', rows, cols);
fprintf('Threshold value = %.2f\n', threshold);
fprintf('Region-growing threshold = %.2f\n', regionThreshold);
fprintf('Seed point = (%d, %d)\n', seedX, seedY);

fprintf('\nThresholding segmented area = %d pixels\n', ...
    thresholdAreaUnits);

fprintf('Region-growing segmented area = %d pixels\n', ...
    regionAreaUnits);

fprintf('========================================\n');
fprintf('Experiment 3 completed successfully.\n');
