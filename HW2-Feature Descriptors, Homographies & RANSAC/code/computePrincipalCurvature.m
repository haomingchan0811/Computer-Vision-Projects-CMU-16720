function PrincipalCurvature = computePrincipalCurvature(DoGPyramid)
%%Edge Suppression
% Takes in DoGPyramid generated in createDoGPyramid and returns
% PrincipalCurvature,a matrix of the same size where each point contains the
% curvature ratio R for the corresponding point in the DoG pyramid
%
% INPUTS
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
%
% OUTPUTS
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix where each 
%                      point contains the curvature ratio R for the 
%                      corresponding point in the DoG pyramid

% % test
% load('DoGPyramid.mat');

% fectch dimension
[H, W, L] = size(DoGPyramid);

% initialize matrix
PrincipalCurvature = zeros([H, W, L]);

for i = 1:L
    % compute hessian (2x2 gradient matrix)
    [Dx, Dy] = gradient(DoGPyramid(:,:,i));
    [Dxx, Dxy] = gradient(Dx);
    [Dyx, Dyy] = gradient(Dy);
    
    % compute trace and determinant
    Tr = (Dxx + Dyy).^2;
    Det = Dxx .* Dyy - Dxy.^2;
    
    PrincipalCurvature(:,:,i) = Tr ./ Det;
end 
% 
% % test
% save('PrincipalCurvature.mat');

