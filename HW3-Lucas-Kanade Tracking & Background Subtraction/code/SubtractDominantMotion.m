function mask = SubtractDominantMotion(image1, image2)

% input - image1 and image2 form the input image pair
% output - mask is a binary image of the same size

% initialize the coordinates
[height width] = deal(size(image2, 1), size(image2, 2));

% compute affine transformation matrix M 
M = LucasKanadeAffine(image1, image2);

% warp image and compute mask  
warpedImg = warpH(image1, M, size(image2));
mask = zeros(size(image2));  % initialize

for i = 1: height
    for j = 1: width
        if ~isnan(warpedImg(i, j))
            mask(i,j) = abs(image2(i,j) - warpedImg(i,j));
        end 
    end
end 

% dilate and erode the mask
mask = im2bw(medfilt2(mask), graythresh(mask));
se = strel('disk', 7);
mask = imdilate(mask, se);
mask = imerode(mask, se);

% remove patches
patch = bwareaopen(mask, 400);
mask = mask - patch;

end