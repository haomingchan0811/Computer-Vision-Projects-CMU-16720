function [W, b] = InitializeNetwork(layers)
% InitializeNetwork([INPUT, HIDDEN, OUTPUT]) initializes the weights and biases
% for a fully connected neural network with input data size INPUT, output data
% size OUTPUT, and HIDDEN number of hidden units.
% It should return the cell arrays 'W' and 'b' which contain the randomly
% initialized weights and biases for this neural network.

% retrieve parameters
numOfHidden = length(layers) - 2;
N = layers(1);               % size of input layer (data)
C = layers(length(layers));  % size of output layer (classes)

% initialize weights and biases
sizeL = numOfHidden + 1;
W = cell(sizeL, 1);
b = cell(sizeL, 1);

dim_prevL = N;
for i = 1:sizeL
    dim_currL = layers(i + 1);    % dimension of current layer
    b{i} = zeros(1, dim_currL);   % initialize biases to all 0
    W{i} = 0.01 * rand(dim_prevL, dim_currL) ./ sqrt(dim_prevL);  % initialize weights to random value close to 0
    dim_prevL = dim_currL;    % update layer size
end

end
