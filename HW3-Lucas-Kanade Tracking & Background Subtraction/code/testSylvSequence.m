% load frames
load('../data/sylvseq.mat')
load('../data/sylvbases.mat')
[H W T] = size(frames);

% implementation
target = [2 200 300 350 400];
rect = [102; 62; 156; 108];
rects = zeros(T, 4);
rects(1, :) = rect; 
imgs = cell(1, length(target));
frameIdx = zeros(1, length(target));
timeStamp = zeros(1, length(target));
idx = 1;

% start the clock
startTime = tic;
for i = 2: T
    % compute u, v vector and update 
    [prev, curr] = deal(frames(:,:,i-1), frames(:,:,i));
    [u,v] = LucasKanadeBasis(prev, curr, rect, bases);
    rect = rect + [u; v; u; v];
    rects(i, :) = rect;
    
    % report the frame and rectange if it's the target
    if ~isempty(find(target == i))
        [width height] = deal(rect(3) - rect(1), rect(4) - rect(2));
        img = insertShape(curr,'Rectangle',[rect(1), rect(2), width, height],'LineWidth',5);
        imgs{idx} = img;
        frameIdx(idx) = i;
        timeStamp(idx) = toc(startTime) * 1000;
        idx = idx + 1;
    end 
    
end

% plot and write figure the images into file
for i = 1: length(target)
    subplot(1,5,i);       % add i-th plot in 5 x 1 grid
    imshow(imgs{i});
    title(sprintf('%d (%.4f ms) ', frameIdx(i), timeStamp(i)), 'fontsize', 8);
end

% save the rects
save sylvseqrects.mat rects