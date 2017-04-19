function [lines, bw] = findLetters(im)
% [lines, BW] = findLetters(im) processes the input RGB image and returns a cell
% array 'lines' of located characters in the image, as well as a binary
% representation of the input image. The cell array 'lines' should contain one
% matrix entry for each line of text that appears in the image. Each matrix entry
% should have size Lx4, where L represents the number of letters in that line.
% Each row of the matrix should contain 4 numbers [x1, y1, x2, y2] representing
% the top-left and bottom-right position of each box. The boxes in one line should
% be sorted by x1 value.

% test
% im = imread('../images/02_letters.jpg');
% im = imread('../images/01_list.jpg');
% im = imread('../images/03_haiku.jpg');
% im = imread('../images/04_deep.jpg');

% binarize the image with white background
im_gaussain = rgb2gray(imgaussfilt(im, 3));
im = rgb2gray(im);

bw = imcomplement(imbinarize(im));
% bw = medfilt2(bw);
bw = imdilate(bw, strel('disk', 5));
% bw_clear = imdilate(bw, strel('disk', 2));
bw_clear = imbinarize(im_gaussain);

imgSize = size(bw);

% find connected components 
cc = bwconncomp(bw);
num = cc.NumObjects;
conns = cc.PixelIdxList;
offset = 2;

% % visualize the conns
% output = cell(num, 1);
% for i = 1:num
%     obj = cc.PixelIdxList{i};
%     temp = bw;
%     temp(obj) = 0;
%     
%     fileName = sprintf('cc%d.png', i);
%     imwrite(temp, fileName);
%     output{i} = fileName;
% end
% montage(output);

% locate each object
objects = zeros(num, 4); 
for i = 1:num
    % initialize corner coordinates 
    [x1, y1, x2, y2] = deal(imgSize(2), imgSize(1), 0, 0);
    for j = 1:length(conns{i})
        [I, J] = ind2sub(imgSize, conns{i}(j));
        x1 = min(x1, J);
        x2 = max(x1, J);
        y1 = min(y1, I);
        y2 = max(y2, I);
    end
    
    % remove small component 
    if abs(x1 - x2) * abs(y1 - y2) < 1000
        continue
    end
    
    % add more space to the surroundings 
    [x1, y1] = deal(max(1, x1 - offset), max(1, y1 - offset));
    [x2, y2] = deal(min(imgSize(2), x2 + offset),min(imgSize(1), y2 + offset));
    objects(i, :) = [x1, y1, x2, y2];
%     imshow(bw(y1:y2, x1:x2));
end

objects = objects(objects(:,1) ~= 0, :);
num = size(objects, 1);

% group into lines
lines = cell(num, 1);
index = 0;
while 1
    index = index + 1;
    [y1_min, ind] = min(objects(:, 2));
    y2_min = objects(ind, 4);
    qualify = (objects(:,2) >= y1_min) & (objects(:,2) <= y2_min);
    if isempty(qualify)
        break
    end
    
    % retrieve the row 
    row = sortrows(objects(qualify, :));
    lines{index} = row;
    
%     % visualize each letter/digit
%     for j = 1:length(row)
%         obj = row(j, :);
%         imshow(bw(obj(2):obj(4), obj(1):obj(3)));
%         saveas(gcf, sprintf('line%d_%d.jpg', index, j));
%     end

    objects(qualify, :) = [];
end 

lines = lines(1:index - 1);
bw = bw_clear;
% imshow(bw);

end
