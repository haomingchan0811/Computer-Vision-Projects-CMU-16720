% Q2.7 - Todo:
% Integrating everything together.
% Loads necessary files from ../data/ and visualizes 3D reconstruction
% using scatter3

% load two views 
I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');

% Load point correspondences and camera intrinsics
load('../data/some_corresp.mat');
load('../data/intrinsics.mat');
load('../data/templeCoords.mat');
num_points = size(x1, 1);

% compute related matrices 
M = max(size(I1, 1), size(I1, 2));  % scalar M
F = eightpoint(pts1, pts2, M);      % fundamental matrix F
E = essentialMatrix(F, K1, K2);     % essential matrix E
P = zeros(size(pts1, 1), 3);        % initialize 3D points  
    
% compute cooresponding points in image2
[x2, y2] = deal(zeros(size(x1)), zeros(size(y1)));
for i = 1: num_points
    [x2(i), y2(i)] = epipolarCorrespondence1(I1, I2, F, x1(i), y1(i));
end

% compute the 4 candidates of M2s 
M2s = camera2(E);
M2 = M2s(:,:,1);            % initialize correct M2
M1 = [eye(3), zeros(3, 1)];
C1 = K1 * M1;               % first camera matrix

% select the correct M2
for i = 1: 4
    C2 = K2 * M2s(:,:,i);   % second camera matrix
    [pts1, pts2] = deal([x1, y1], [x2, y2]);   % forming points
    [p, ~] = triangulate(C1, pts1, C2, pts2);
    
    % Find the correct M2 by ensuring all 3D points in front of camera
    if all(p(:, 3) > 0)
        M2 = M2s(:,:,i);
        P = p;
        break;
    end   
end 

% generate 3D visualization 
[X, Y, Z] = deal(P(:,1), P(:,2), P(:,3));
scatter3(X, Y, Z);

save('../results/q_2.7.mat', 'M2', 'M1', 'M2')
