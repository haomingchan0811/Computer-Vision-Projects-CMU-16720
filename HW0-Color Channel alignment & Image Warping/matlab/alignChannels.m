function [rgbResult] = alignChannels(red, green, blue)
% alignChannels - Given 3 images corresponding to different channels of a
%       color image, compute the best aligned result with minimum
%       aberrations
% Args:
%   red, green, blue - each is a matrix with H rows x W columns
%       corresponding to an H x W image
% Returns:
%   rgb_output - H x W x 3 color image output, aligned as desired

%% Write code here
% record the minimal score of allignment and 
%        the correspoding shift of dimensions
[minGreen, minRed] = deal(intmax('int64'));
[xGreen, yGreen, xRed, yRed] = deal(0);

% shift and calculate the ssd scores, update
%       the best coordinate shifts
for i = -30 : 30
    for j = -30 : 30
        % find the best alignment of blue and green
        newGreen = circshift(green, [i, j]);
        error = (blue - newGreen).^2;
        ssd_GreenBlue = sum(error(:));
        if ssd_GreenBlue < minGreen
            minGreen = ssd_GreenBlue;
            [xGreen, yGreen] = deal(i, j);
        end
        % find the best alignment of blue and red
        newRed = circshift(red, [i, j]);
        error = (blue - newRed).^2;
        ssd_RedBlue = sum(error(:));
        if ssd_RedBlue < minRed
            minRed = ssd_RedBlue;
            [xRed, yRed] = deal(i, j);
        end
    end
end

% reconstruct RGB image
rgbResult = blue;
rgbResult(:, :, 2) = circshift(green, [xGreen, yGreen]);
rgbResult(:, :, 3) = circshift(red, [xRed, yRed]);

end
