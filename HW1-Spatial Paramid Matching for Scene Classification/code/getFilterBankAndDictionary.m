function [filterBank, dictionary] = getFilterBankAndDictionary(imPaths)
% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image (or relative path wrt the working directory.
%
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.

    filterBank  = createFilterBank();

    % TODO Implement your code here
    
    % initialize parameters
    K = 128;
    alpha = 128;
    T = length(imPaths);
    filter_responses = zeros(alpha * T, size(filterBank, 1) * 3);
    
    
    % load image files
    for i = 1: T
        fprintf('image %d out of %d\n', i, T);
        
        % fetch the current image and its dimension
        img = imread(imPaths{i});
%         [H, W] = deal(size(img, 1), size(img, 2));
        
        % Extract filter responses for the given image.
        responses_i = extractFilterResponses(img, filterBank);
        
        % select random pixels' index from the given image
        vecIndex = randperm(size(responses_i, 1) * size(responses_i, 2), alpha);
        
        % reshape to match dimensions
        responses_i = reshape(responses_i, [], size(responses_i, 3));
%         size(filter_responses((alpha * (i - 1) + 1): (alpha * i), :))
%         size(responses_i(vecIndex, :))
        filter_responses((alpha * (i - 1) + 1): (alpha * i), :) = responses_i(vecIndex, :);
    end
 
    % k-means to generate visual words
    [~, dictionary] = kmeans(filter_responses, K, 'EmptyAction', 'drop');
    
    % transpose the dictionary to be column-wise
    dictionary = dictionary';
    
end
