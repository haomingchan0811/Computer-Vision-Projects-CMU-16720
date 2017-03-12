% load frames
load('../data/aerialseq.mat');
[H W T] = size(frames);

% implementation
target = [30 60 90 120];
imgs = cell(1, length(target));
frameIdx = zeros(1, length(target));
idx = 1;

for i = 2: T
    
    % compute mask
    i
    [prev, curr] = deal(frames(:,:,i-1), frames(:,:,i));
    [prev, curr] = deal(im2double(prev), im2double(curr));

    mask = SubtractDominantMotion(prev, curr);
    img = zeros(H, W, 3);
    img(:,:,1) = mask * 255;
    fusedImg = imfuse(prev, img, 'blend','Scaling','joint');
    
    % report the frame if it's the target
    if ~isempty(find(target == i))
        imgs{idx} = fusedImg;
        frameIdx(idx) = i;
        idx = idx + 1;
    end 
    
end

% plot and write figure the images into file
for i = 1: length(target)
    subplot(1,5,i);       % add i-th plot in 5 x 1 grid
    imshow(imgs{i});
    title(sprintf('%d', frameIdx(i)), 'fontsize', 8);
end
