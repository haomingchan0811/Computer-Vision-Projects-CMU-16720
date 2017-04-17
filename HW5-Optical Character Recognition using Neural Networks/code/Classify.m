function [outputs] = Classify(W, b, data)
% [predictions] = Classify(W, b, data) should accept the network parameters 'W'
% and 'b' as well as an DxN matrix of data sample, where D is the number of
% data samples, and N is the dimensionality of the input data. This function
% should return a vector of size DxC of network softmax output probabilities.

% initialize parameters
C = size(W{length(W)}, 2);   % number of classes
num_data = size(data, 1);
outputs = zeros(num_data, C);

% iteratively compute softmax for each data point
for i = 1:num_data
    X = data(i, :)';
    % perform forward propagation: softmax output (C x 1)
    [output, ~, ~] = Forward(W, b, X);   
    outputs(i, :) = output';
end

end
