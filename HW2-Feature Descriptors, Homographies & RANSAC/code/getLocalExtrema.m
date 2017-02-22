function locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, ...
                        PrincipalCurvature, th_contrast, th_r)
%%Detecting Extrema
% INPUTS
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
% DoG Levels  - The levels of the pyramid where the blur at each level is
%               outputs
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix contains the
%                      curvature ratio R
% th_contrast - remove any point that is a local extremum but does not have a
%               DoG response magnitude above this threshold
% th_r        - remove any edge-like points that have too large a principal
%               curvature ratio
%
% OUTPUTS
% locsDoG - N x 3 matrix where the DoG pyramid achieves a local extrema in both
%           scale and space, and also satisfies the two thresholds.

% % test
% load('PrincipalCurvature.mat');
% load('DoGPyramid.mat');
% load('DoGLevels.mat');
% [th_r, th_contrast] = deal(12, 0.03);

% initialize dimension
[H, W, L] = size(DoGPyramid);
locsDoG = zeros(H * W * L, 3);
index = 1;

for l = 1:L
    for x = 1:W
        for y = 1:H
            
            % filter out as it doesn't qualify the threshold
            R = PrincipalCurvature(y,x,l);
            if R <= 0 || R > th_r 
                continue;
            end
            
            currDoG = DoGPyramid(y,x,l);
            % check whether it's the local extrema (maxima/minima) in scale
            isExtrema_scale = 0;
            if(l==1 || DoGPyramid(y,x,l-1) < currDoG) && ...
              (l==L || DoGPyramid(y,x,l+1) < currDoG)
                isExtrema_scale = 1;
            end
            if(l==1 || DoGPyramid(y,x,l-1) >= currDoG) && ...
              (l==L || DoGPyramid(y,x,l+1) >= currDoG)
                isExtrema_scale = 1;
            end
            
            % skip non-scale_extrema and skip boundries 
            if(isExtrema_scale == 0 || x < 3 || x > W - 2 || y < 3 || y > H - 2)  
                continue;
            end 
            % check whether it's the local extrema (maxima/minima) in space
            [isMaxima, isMinima] = deal(1, 1);
            for i = -1:1
                for j = -1:1
                    [x1, y1] = deal(x+i, y+j);
                    if(isMaxima) 
                        isMaxima = (currDoG >= DoGPyramid(y1,x1,l));
                    end
                    if(isMinima)
                        isMinima = (currDoG <= DoGPyramid(y1,x1,l));
                    end
                end
            end

            % insert the newly found extrema into the matrix
            if((isMaxima || isMinima) && abs(currDoG) > th_contrast)
                locsDoG(index,:) = [x, y, DoGLevels(l)];
                index = index + 1;
            end
        end
    end
end

% resize the matrix to eliminate all-zero rows
locsDoG = locsDoG(1:index - 1,:);
index
