function [wordMap] = getVisualWords(img, filterBank, dictionary)
% Compute visual words mapping for the given image using the dictionary of visual words.

% Inputs:
% 	img: Input RGB image of dimension (h, w, 3)
% 	filterBank: a cell array of N filters
% Output:
%   wordMap: WordMap matrix of same size as the input image (h, w)

    % TODO Implement your code here

%     % test data
%     img = imread('../data/tennis_court/sun_bnqplteihhyjtglu.jpg');
%     filterBank = createFilterBank();
%     load('dictionary.mat')
    
    % fectch the dimension of image
    [H, W] = deal(size(img, 1), size(img, 2));
    
    % initialize the wordMap
    wordMap = zeros(H, W);
    
    % if it's grey scale, duplicate into RGB channels
    if size(img, 3) == 1
        img = repmat(img, 1, 1, 3);
    end
    
    % Extract filter responses for the given image.
    responses = extractFilterResponses(img, filterBank);
    
    % reshape to match dimensions
    responses = reshape(responses, [], size(responses, 3));
    
    % compute the euclidean distance 
    distance = pdist2(responses, dictionary', 'euclidean'); % bug: need to transpose dict again!
    
    % retrieve the minial distance to assign the closest visual words
    [minDist, wordMap] = min(distance, [], 2);
    
    % reshape to match dimension
    wordMap = reshape(wordMap, H, W);
    
%     % visualization 
%     image(img)
%     imagesc(wordMap)
    
end
