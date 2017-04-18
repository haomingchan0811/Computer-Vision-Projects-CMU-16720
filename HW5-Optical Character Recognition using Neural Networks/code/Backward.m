function [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a)
% [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a) computes the gradient
% updates to the deep network parameters and returns them in cell arrays
% 'grad_W' and 'grad_b'. This function takes as input:
%   - 'W' and 'b' the network parameters
%   - 'X' and 'Y' the single input data sample and ground truth output vector,
%     of sizes Nx1 and Cx1 respectively
%   - 'act_h' and 'act_a' the network layer pre and post activations when forward
%     forward propogating the input smaple 'X'

% retrieve parameters
num_class = length(Y);  
num_data = length(X);

% initialize gradients for weights and biases, and errors
sizeL = length(W);
grad_W = cell(sizeL, 1);
grad_b = cell(sizeL, 1);
errors = cell(sizeL, 1);

% perform back propagation
for i = sizeL: -1: 1
    % compute errors 
    if i == sizeL   % output layer
        errors{i} = act_h{i} - act_h{i} .* Y / (Y' * act_h{i});  
    else            % hidden layers
        errors{i} = act_h{i} .* (1 - act_h{i}) .* (W{i + 1} * errors{i + 1});
    end 
    
    % compute gradients for weights 
    if i == 1       % input layer
        grad_W{i} = (errors{i} * X')';   
    else            % hidden layers
        grad_W{i} = (errors{i} * (act_h{i - 1})')';   
    end
    
    % compute gradients for biases
    grad_b{i} = (errors{i})';
end 

end
