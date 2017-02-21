function [ warp_im ] = warpA(im, A, out_size)
% warp_im=warpAbilinear(im, A, out_size)
% Warps (w,h,1) image im using affine (3,3) matrix A 
% producing (out_size(1),out_size(2)) output image warp_im
% with warped  = A*input, warped spanning 1..out_size
% Uses nearest neighbor mapping.
% INPUTS:
%   im : input image
%   A : transformation matrix 
%   out_size : size the output image should be
% OUTPUTS:
%   warp_im : result of warping im by A

% fetch the height, width and coordinates
[h, w] = deal(out_size(1), out_size(2));
[X, Y] = meshgrid(1:w, 1:h);

% initialize the source coordinates
dummy = ones(h * w, 1);
destination = ([X(:), Y(:), dummy])';

% compute the warp coordinates
source = (inv(A) * destination);  % bug: should not use A' instead of inv(A)
s = round(source(1:2, :));

% boundary check and produce the warped image
warp_im = zeros(h, w);
for i = 1 : h * w
   if(s(1, i) > 0 && s(1, i) <= w && s(2, i) > 0 && s(2, i) <= h)
       warp_im(i) = im(s(2, i), s(1, i));
   end
end

end
