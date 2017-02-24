function [] = testMatch(im1, im2)

% load images and compute feature mathces
%
% INPUTS
% im1, im2 - images to test feature matches using BRIEF descriptors
%

% test
im1 = imread('../data/model_chickenbroth.jpg');
im2 = imread('../data/chickenbroth_01.jpg');

% im1 = imread('../data/incline_L.png');
% im2 = imread('../data/incline_R.png');

% im1 = imread('../data/pf_scan_scaled.jpg');
% im2 = imread('../data/pf_floor.jpg');


% turn the images into gray scale
im1 = im2double(im1);
im2 = im2double(im2);
if size(im1, 3) == 3
    im1 = rgb2gray(im1);
end
if size(im2, 3) == 3
    im2 = rgb2gray(im2);
end

% compute descriptors for both images
[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);

% compute feature matches of two images
[matches] = briefMatch(desc1, desc2, 0.8);

% plot the matches 
plotMatches(im1, im2, matches, locs1, locs2);

end