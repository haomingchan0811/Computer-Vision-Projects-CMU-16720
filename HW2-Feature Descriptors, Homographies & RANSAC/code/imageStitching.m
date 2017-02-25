function [panoImg] = imageStitching(img1, img2, H2to1)
%
% INPUT
% Warps img2 into img1 reference frame using the provided warpH() function
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear
%         equation
%
% OUTPUT
% Blends img1 and warped img2 and outputs the panorama image

% % test
% img1 = imread('../data/incline_L.png');
% img2 = imread('../data/incline_R.png');

save('q6_1.mat', 'H2to1');

% warp the image
out_size = [800 1800];
warped2 = im2double(warpH(img2, H2to1, out_size));

mask_img2 = zeros(size(img2,1), size(img2,2), size(img2,3));
mask_img2(1,:) = 1; mask_img2(end,:) = 1; mask_img2(:,1) = 1; mask_img2(:,end) = 1;
mask_img2 = bwdist(mask_img2, 'city');
mask_img2 = mask_img2/max(mask_img2(:));
mask2_warped = warpH(mask_img2, H2to1, out_size);
result2 = warped2 .* mask2_warped;

% visualize the warped image
% imshow(warped2);
imwrite(warped2, '../results/q6_1.jpg');

% stitch images together to produce panorams

warped1 = im2double(warpH(img1, eye(3), out_size));
mask_img1 = zeros(size(img1,1), size(img1,2), size(img1,3));
mask_img1(1,:) = 1; mask_img1(end,:) = 1; mask_img1(:,1) = 1; mask_img1(:,end) = 1;
mask_img1 = bwdist(mask_img1, 'city');
mask_img1 = mask_img1/max(mask_img1(:));
mask1_warped = warpH(mask_img1, eye(3), out_size);
result1 = warped1 .* mask1_warped;

panoImg = (result1 + result2) ./ (mask1_warped + mask2_warped);

imshow(panoImg);

end 
