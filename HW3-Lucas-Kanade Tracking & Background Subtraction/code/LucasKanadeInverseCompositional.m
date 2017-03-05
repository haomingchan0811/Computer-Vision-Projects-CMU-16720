function [u,v] = LucasKanadeInverseCompositional(It, It1, rect)

% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [u,v] in the x- and y-directions.

% initialize the coordinates and threshold
[x1 y1 x2 y2] = deal(rect(1), rect(2), rect(3), rect(4));
[p, threshold] = deal([0; 0], 0.05);

% template generation
[X, Y] = meshgrid(x1: x2, y1: y2);
[It, It1] = deal(im2double(It), im2double(It1));
template = interp2(It, X, Y);

% pre-compute the inverse Hessian matrix 
[Fx, Fy] = gradient(template);
% H = [Fx, Fy]' * [Fx, Fy];
H = [Fx(:), Fy(:)]' * [Fx(:), Fy(:)];

% iteratively minimize error
converge = false;
while converge ~= true
    % update warp
    warpX = [x1 x2] + p(1);
    warpY = [y1 y2] + p(2);
    
    % compute error image and update p 
    [X1, Y1] = meshgrid(warpX(1): warpX(2), warpY(1): warpY(2));
    errorImg = interp2(It1, X1, Y1) - template;
    delta = H \ ([Fx(:), Fy(:)]' * errorImg(:));
    p = p - delta;
    converge = norm(delta) < threshold;
end 

[u v] = deal(p(1), p(2));

end


