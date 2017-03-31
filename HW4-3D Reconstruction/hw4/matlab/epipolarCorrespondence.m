function [x2, y2] = epipolarCorrespondence(im1, im2, F, x1, y1)

% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q2.6 - Todo:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q2_6.mat
%
%           Explain your methods and optimization in your writeup

    % define patch in an image (bug: flip x, y coordinates)
    function [patch] = computePatch(img, x, y, window)
        boundry_x = (x - window): (x + window);
        boundry_y = (y - window): (y + window);
        patch = img(boundry_y, boundry_x);
    end 

    % find the valid point sets for later search 
    function [X, Y] = pointSet(X1, Y1, X2, Y2, offset, ratio, H, W)
        [X, Y] = deal(X1, Y1);      % initialize point sets
        if ratio > 1
            [X, Y] = deal(X2, Y2); 
        end 
        withBoundary = (X - offset) > 0 & (X + offset) <= W & ...
                       (Y - offset) > 0 & (Y + offset) <= H;
        [X, Y] = deal(X(withBoundary), Y(withBoundary)); 
    end

% initialize parameters
% im1 = imread('../data/im1.png');
% im2 = imread('../data/im2.png');

[im1, im2] = deal(double(im1), double(im2));
[x1, y1] = deal(ceil(x1), ceil(y1));
[x2, y2] = deal(0, 0);   % initialize P2
[H, W] = deal(size(im1, 1), size(im1, 2));

winSize = 7;    % the window size of the patch around a possible point
winOffset = (winSize - 1) / 2;
sigma = 3;
minError = Inf;

% convert to homogeneous coord & compute epipolar line
p1 = [x1, y1, 1]';  
epiLine = F * p1;
patch_im1 = computePatch(im1, x1, y1, winOffset);

% find search grids
[Y1, X2] = deal(1:H, 1:W);
X1 = ceil(-(epiLine(2) * Y1 + epiLine(3)) / epiLine(1));
Y2 = ceil(-(epiLine(1) * X2 + epiLine(3)) / epiLine(2));
ratio = epiLine(1) / epiLine(2);
[X, Y] = pointSet(X1, Y1, X2, Y2, winOffset, ratio, H, W);

% filter out points that are too far away
thres = 250;    % sqaure distance threshold from p1 
nearP1 = ((X - x1).^2 + (Y - y1).^2) < thres;
[X, Y] = deal(X(nearP1), Y(nearP1)); 
num_points = size(X, 2);

% guassian weighting of the window
w = fspecial('gaussian', [winSize winSize], sigma);

%compute Euclidean distance between pixel intensities
for i = 1:num_points
   patch_im2 = computePatch(im2, X(i), Y(i), winOffset);
   diff = (patch_im2 - patch_im1).^2;
   error = sum(sum(diff .* w));
   if error < minError
       minError = error;
       [x2, y2] = deal(X(i), Y(i));
   end 
end

% % test correspondence
% epipolarMatchGUI(im1, im2, F);

% save F, M, pts1, pts2 to q2_6.mat
% save('q2_6.mat', 'F', 'pts1', 'pts2');

end

