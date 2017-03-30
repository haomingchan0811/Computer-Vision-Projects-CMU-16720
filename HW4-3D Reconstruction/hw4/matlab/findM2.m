% Q2.5 - Todo:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       3. Save the correct M2, p1, p2, R and P to q2_5.mat

% load two views 
I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');

% Load point correspondences and camera intrinsics
load('../data/some_corresp.mat');
load('../data/intrinsics.mat');
[p1, p2] = deal(pts1, pts2);

% compute related matrices 
M = max(size(I1, 1), size(I1, 2));  % scalar M
F = eightpoint(pts1, pts2, M);      % fundamental matrix F
E = essentialMatrix(F, K1, K2);     % essential matrix E
P = zeros(size(pts1, 1), 3);        % initialize 3D points  
    
% compute the 4 candidates of M2s 
M2s = camera2(E);
M2 = M2s(:,:,1);            % initialize correct M2
M1 = [eye(3), zeros(3, 1)];
C1 = K1 * M1;               % first camera matrix

for i = 1: 4
    C2 = K2 * M2s(:,:,i);   % second camera matrix
    [p, ~] = triangulate(C1, pts1, C2, pts2);
    
    % Find the correct M2 by ensuring all 3D points in front of camera
    if all(p(:, 3) > 0)
        M2 = M2s(:,:,i);
        P = p;
        break;
    end   
end 

save('../results/q_2.5.mat', 'M2', 'p1', 'p2', 'P')
