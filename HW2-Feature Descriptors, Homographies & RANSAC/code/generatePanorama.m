function [im3] = generatePanorama(im1, im2)
%
% INPUT
% im1, im2 - a M x N x 3 matrix of RGB images
%
% OUTPUT
% Blends img1 and warped img2 and outputs the panorama image

% % test
% im1 = imread('../data/incline_L.png');
% im2 = imread('../data/incline_R.png');

% initialize parameters 
[nIter, tol] = deal(1000, 4);

% turn the images into gray scale
img1 = im2double(im1);
img2 = im2double(im2);
if size(img1, 3) == 3
    img1 = rgb2gray(img1);
end
if size(img2, 3) == 3
    img2 = rgb2gray(img2);
end

% compute descriptors for both images
[locs1, desc1] = briefLite(img1);
[locs2, desc2] = briefLite(img2);

% compute feature matches of two images
matches = briefMatch(desc1, desc2, 0.8);

% compute H matrix
H2to1 = ransacH(matches, locs1, locs2, nIter, tol);

% generate Panorama image
im3 = imageStitching_noClip(im1, im2, H2to1);
imwrite(im3, '../results/q6_3.jpg');

end

