% load frames
load('../data/carseq.mat')
frame1 = frames(:,:,1);
frame2 = frames(:,:,2);
frame100 = frames(:,:,100);
frame200 = frames(:,:,200);
frame300 = frames(:,:,300);
frame400 = frames(:,:,400);

% implementation
rect = [60; 117; 146; 152];



% save the rects
save carseqrects.mat rects
