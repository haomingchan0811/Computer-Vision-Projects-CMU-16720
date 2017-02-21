function histInter = distanceToSet(wordHist, histograms)
% Compute distance between a histogram of visual words with all training image histograms.
%
% Inputs:
% 	wordHist: visual word histogram - K * (4^(L+1) - 1 / 3) x 1 vector
% 	histograms: matrix containing T features from T training images - K * (4^(L+1) - 1 / 3) x T matrix
%
% Output:
% 	histInter: histogram intersection similarity between wordHist and each training sample as a 1 x T vector

	% TODO Implement your code here
    
%      % test data
%     wordHist = [1; 2; 3; 4; 5; 6];
%     histograms = ones(6, 3);
%     histograms(:, 2) = [0; 1; 2; 3; 7; 1];
    
    % number of training data
    T = size(histograms, 2);
    
    % duplicate to match dimenstions 
    wordHist = repmat(wordHist, 1, T);

    % compute intersection similarity
    histInter = sum(bsxfun(@min, wordHist, histograms));
	
end