function [W, b] = Train(W, b, train_data, train_label, learning_rate)
% [W, b] = Train(W, b, train_data, train_label, learning_rate) trains the network
% for one epoch on the input training data 'train_data' and 'train_label'. This
% function should returned the updated network parameters 'W' and 'b' after
% performing backprop on every data sample.

% This loop template simply prints the loop status in a non-verbose way.
% Feel free to use it or discard it

% retrieve parameters
num_class = length(train_label, 2);  
num_data = size(train_data,1);
size = length(W);

% shuffle the training data randomly
order = randperm(num_data)';
train_data = train_data(order, :);
train_label = train_label(order, :);

% perform stochastic gradient descent for training 
for i = 1:num_data
    X = train_data(i, :)';
    Y = train_label(i, :)';
    [~, act_h, act_a] = Forward(W, b, X);
    [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a);
    [W, b] = UpdateParameters(W, b, grad_W, grad_b, learning_rate);
    
    if mod(i, 100) == 0
        fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b')
        fprintf('Done %.2f %%', i / num_data * 100)
    end
end
fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b')


end
