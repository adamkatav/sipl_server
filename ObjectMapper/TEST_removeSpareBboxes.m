clear variables; close all; clc;

load('selectbboxExample.mat');

fig = figure('Units', 'Normalized');
subplot(121);
imshow(picture); hold on;
set(fig, 'Position', [0.3 0.3 0.4 0.5]);
ColOrd = get(gca,'ColorOrder');
colorsNum = size(ColOrd, 1);

for ii=1:size(bboxes, 1)
    rectColor = ColOrd(mod(ii-1, colorsNum)+1, :);
    rectangle('Position', bboxes(ii, :), 'LineWidth', 1.5, 'EdgeColor', rectColor);
end

[bboxesR, labelsR] = removeSpareBboxes(bboxes, labels, precision, 0.6);

subplot(122);
imshow(picture); hold on;
for ii=1:size(bboxesR, 1)
    rectColor = ColOrd(mod(ii-1, colorsNum)+1, :);
    rectangle('Position', bboxesR(ii, :), 'LineWidth', 1.5, 'EdgeColor', rectColor);
end




