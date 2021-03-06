function [u,v] = LucasKanadeBasis(It, It1, rect, bases)

% input - image at time t, image at t+1, rectangle (top left, bot right
% coordinates), bases 
% output - movement vector, [u,v] in the x- and y-directions.

% initialize the coordinates and threshold
[x1 y1 x2 y2] = deal(rect(1), rect(2), rect(3), rect(4));
[p, threshold] = deal([0; 0], 0.01);
num_bases = size(bases, 3);
bases = reshape(bases, size(bases,1) * size(bases,2), num_bases);
bases = bases';

% template generation
[X, Y] = meshgrid(x1: ceil(x2), y1: ceil(y2));
[It, It1] = deal(im2double(It), im2double(It1));
template = interp2(It, X, Y);

% unweighted steepest descent image
[Fx, Fy] = gradient(template);
SD = [Fx(:), Fy(:)];

% pre-compute the inverse Hessian matrix 
H = SD' * SD - (bases * SD)' * bases * SD;


% iteratively minimize error
converge = false;
while converge ~= true
   
    % warp and compute error image, update p 
    [X1, Y1] = meshgrid(x1+p(1): ceil(x2+p(1)), y1+p(2): ceil(y2+p(2)));
    corr = [x1+p(1), x2+p(1), y1+p(2), y2+p(2)];

    errorImg = interp2(It1, X1, Y1) - template;
    errorImg = errorImg(:);
    Q = SD' * errorImg - (bases * SD)' * bases * errorImg;
    delta = H \ Q;
    
    p = p - delta;
    converge = norm(delta) < threshold;
end 

[u v] = deal(p(1), p(2));

end