function [filterResponses] = extractFilterResponses(img, filterBank)
% Extract filter responses for the given image.
%
% Inputs: 
%   img:                a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
%
% Outputs:
%   filterResponses:    a W x H x N*3 matrix of filter responses

    % TODO Implement your code here

    % test data
%     img = imread('../data/art_gallery/sun_afyisxfqpfufwuxe.jpg');
%     filterBank = createFilterBank();

    % width and height of the matrix , filterBank
    [H, W] = deal(size(img, 1), size(img, 2));
    N = size(filterBank, 1);

    % convert the img matrix into floating point type
    img = double(img);

    % if it's grey scale, duplicate into RGB channels
    if size(img, 3) == 1
        img = repmat(img, 1, 1, 3);
    end

    % convert from RGB into Lab space using the RGB2Lab function
    [R, G, B] = deal(img(:,:,1), img(:,:,2), img(:,:,3));
    [L, a, b] = RGB2Lab(R, G, B);

    % initialize filterResponses and output Lab images
    filterResponses = zeros(H, W, N * 3);
%     Lab = cat(N - 1, zeros(H, W, 3));

    % apply filters on the image
    for i = 1: N
        % retrieve the current filter
        filter = filterBank{i};

        % apply the filter to each channel
        L1 = imfilter(L, filter, 'same');
        a1 = imfilter(a, filter, 'same');
        b1 = imfilter(b, filter, 'same'); 

        % store filtered images into response
        index = i * 3 - 2;
        filterResponses(:, :, index) = L1;
        filterResponses(:, :, index + 1) = a1;
        filterResponses(:, :, index + 2) = b1;
        
%         
%         filterResponses(:, :, index) = imfilter(L, filter, 'same');
%         filterResponses(:, :, index + 1) = imfilter(a, filter, 'same');
%         filterResponses(:, :, index + 2) = imfilter(b, filter, 'same');

%         % create a Lab image 
%         temp = zeros(H, W, 3);
%         temp(:, :, 1) = L1;
%         temp(:, :, 2) = a1;
%         temp(:, :, 3) = b1;
%         Lab(:, :, :, i) = temp;
    end
    
%     % collage images 
%     montage(Lab, 'Size', [4, 5])

end
