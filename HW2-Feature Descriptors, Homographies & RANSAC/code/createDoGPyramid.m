function [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels)
%%Produces DoG Pyramid
% inputs
% Gaussian Pyramid - A matrix of grayscale images of size
%                    (size(im), numel(levels))
% levels      - the levels of the pyramid where the blur at each level is
%               outputs
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
%               created by differencing the Gaussian Pyramid input


% % test
% load('GaussianPyramid.mat');
% levels = [-1, 0, 1, 2, 3, 4];

% fectch dimension
[H, W] = deal(size(GaussianPyramid, 1), size(GaussianPyramid, 2));

% initialize matries
DoGLevels = zeros(length(levels)-1, 1);
DoGPyramid = zeros(H, W, length(DoGLevels));

for l = 2:length(levels)
    DoGPyramid(:,:,l - 1) = GaussianPyramid(:,:,l) - GaussianPyramid(:,:,l - 1);
    DoGLevels(l - 1) = levels(l);
end 

% save('DoGPyramid.mat');
% save('DoGLevels.mat');

