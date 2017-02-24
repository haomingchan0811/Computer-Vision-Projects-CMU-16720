function [locs, desc] = briefLite(im)
% INPUTS
% im - gray image with values between 0 and 1
%
% OUTPUTS
% locs - an m x 3 vector, where the first two columns are the image coordinates 
% 		 of keypoints and the third column is the pyramid level of the keypoints
% desc - an m x n bits matrix of stacked BRIEF descriptors. 
%		 m is the number of valid descriptors in the image and will vary
% 		 n is the number of bits for the BRIEF descriptor

% % test 
% im = imread('../data/model_chickenbroth.jpg');

% initialize
[sigma0, k] = deal(1, sqrt(2));
levels = [-1, 0, 1, 2, 3, 4];
[th_r, th_contrast] = deal(12, 0.03);

% fetch results from part1 (keypoints)
[locsDoG, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r)

% compute BRIEF descriptors
load('testPattern.mat');

end
[locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, levels, compareA, compareB);