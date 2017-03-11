function [u,v] = LucasKanadeInverseCompositional(It, It1, rect)

% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [u,v] in the x- and y-directions.

% initialize the coordinates and threshold
[x1 y1 x2 y2] = deal(rect(1), rect(2), rect(3), rect(4));
[p, threshold] = deal([0; 0], 0.01);

% template generation
[X, Y] = meshgrid(x1: ceil(x2), y1: ceil(y2));
[It, It1] = deal(im2double(It), im2double(It1));
template = interp2(It, X, Y);

% pre-compute the inverse Hessian matrix 
[Fx, Fy] = gradient(template);
% H = [Fx, Fy]' * [Fx, Fy];
H = [Fx(:), Fy(:)]' * [Fx(:), Fy(:)];

% iteratively minimize error
converge = false;
while converge ~= true
   
    % warp and compute error image, update p 
    [X1, Y1] = meshgrid(x1+p(1): ceil(x2+p(1)), y1+p(2): ceil(y2+p(2)));
    corr = [x1+p(1), x2+p(1), y1+p(2), y2+p(2)];

    errorImg = interp2(It1, X1, Y1) - template;
    delta = H \ ([Fx(:), Fy(:)]' * errorImg(:));
    p = p - delta;
    converge = norm(delta) < threshold;
end 

[u v] = deal(p(1), p(2));

end
