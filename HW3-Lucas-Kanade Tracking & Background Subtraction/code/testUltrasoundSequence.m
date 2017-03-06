% load frames
load('../data/usseq.mat')
[H W T] = size(frames);

% implementation
rect = [255; 105; 310; 170];
target = [5 25 50 75 100];
rects = zeros(T, 4);
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
save usseqrects.mat rects
