% load frames
load('../data/carseq.mat')
[H W T] = size(frames);

% implementation
target = [2 100 200 300 400];
rect = [60; 117; 146; 152];
rects = zeros(T, 4);
rects(1, :) = rect; 
imgs = cell(1, length(target));
idx = 1

for i = 2: T
    % compute u, v vector and update 
    [prev, curr] = deal(frames(:,:,i-1), frames(:,:,i));
    [u,v] = LucasKanadeInverseCompositional(prev, curr, rect);
    rect = rect + [u; v; u; v];
    rects(i, :) = rect;
    
    % report the frame and rectange if it's the target
    if ~isempty(find(target == i))
        [width height] = deal(rect(3) - rect(1), rect(4) - rect(2));
        img = insertShape(curr,'Rectangle',[rect(1), rect(2), width, height],'LineWidth',5);
        imshow(img);
        title(sprintf('Frame %d', i));
        imgs{idx} = img;
    end 
    
end

% write the images into file
imwrite(imgs, '../results/q_1.3.jpg')

% save the rects
save carseqrects.mat rects
