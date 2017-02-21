function [h] = getImageFeatures(wordMap, dictionarySize)
% Compute histogram of visual words
%
% Inputs:
% 	wordMap: WordMap matrix of size (h, w)
% 	dictionarySize: the number of visual words, dictionary size
%
% Output:
%   h: vector of histogram of visual words of size dictionarySize (l1-normalized, ie. sum(h(:)) == 1)

	% TODO Implement your code here
	
%     % test data
%     dictionarySize = 128;
%     load('../data/computer_room/sun_aagspgyvjmoiytfb.mat');
    
    % fetch the dimension of wordMap
    [H, W] = deal(size(wordMap, 1), size(wordMap, 2));
        
    % generate the histogram for BOW model
    wordMap = reshape(wordMap, 1, []);
    h = hist(wordMap, dictionarySize);
    
    % L1-normalized the histogram
    totalCnt = sum(h(:));
    h = (h ./ totalCnt)'; 
            
	assert(numel(h) == dictionarySize);
   
end