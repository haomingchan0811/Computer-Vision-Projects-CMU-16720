layers = [256, 128, 32, 5];

train_data = rands(1, 256);       % input: D x N (D = 1 for simplicity) 
N = size(train_data, 2);
train_label = [0, 0, 1, 0, 0];    % label: 1 x C 

learning_rate = 0.01;
epsilon = 0.0001;             
num_epochs = 10;
errorThres = 0.0001;          % accepted threshold of error

% initialize the weights and biases
[W, b] = InitializeNetwork(layers);
sizeL = size(W, 1);

% training phase
for epoch = 1 : num_epochs
    X = train_data(1, :)';
    Y = train_label(1,:)';
    outlier = 0;          % number of outlier gradient (error > 1e-4)
    
    % perform forward propagation 
    [output, act_h, act_a] = Forward(W, b, X);
    
    % perform backward propagation to compute gradient
    [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a);
    
    for l = 1 : sizeL
        p_W = prod(size(W{l}));
        sample_W = randsample(p_W, round(p_W / 3));
        p_b = prod(size(b{l}));
        sample_b = randsample(p_b, round(p_b / 3));
        [I, J] = ind2sub(size(W{l}), sample_W);

        % verify the gradient for weights W
        for i = 1 : size(I, 1)
            % numerically approximate the derivative
            [W1, W2] = deal(W, W);  % initialize
            W1{l}(I(i), J(i)) = W1{l}(I(i), J(i)) + epsilon;
            W2{l}(I(i), J(i)) = W2{l}(I(i), J(i)) - epsilon;
            
            % compute the derivative
            [accuracy, loss1] = ComputeAccuracyAndLoss(W1, b, train_data, train_label);
            [accuracy, loss2] = ComputeAccuracyAndLoss(W2, b, train_data, train_label);
            g = (loss1 - loss2) / 2 / epsilon;
            
            % compute the error
            error = abs(grad_W{l}(I(i), J(i)) - g);
            if error < errorThres
                continue
            else
                outlier = outlier + 1;
                fprintf('Layer%d, Weight(%d, %d), Error = %8f\n',l, I(i), J(i), error);
            end
        end

        % verify the gradient for biases b
        for j = 1 : size(sample_b, 1)
            % numerically approximate the derivative
            [b1, b2, k] = deal(b, b, sample_b(j));
            b1{l}(k) = b1{l}(k) + epsilon;
            b2{l}(k) = b2{l}(k) - epsilon;
            
            % compute the derivative
            [accuracy, loss1] = ComputeAccuracyAndLoss(W, b1, train_data, train_label);
            [accuracy, loss2] = ComputeAccuracyAndLoss(W, b2, train_data, train_label);
            g = (loss1 - loss2) / 2 / epsilon;
            
            % compute the error
            error = abs(grad_b{l}(sample_b(j)) - g);      
            if error < errorThres
                continue
            else
                outlier = outlier + 1;
                fprintf('Layer%d, Bias%d, Error = %f\n',l, k, error);
            end
        end
    end
    
    % update weights and biases
    [W, b] = UpdateParameters(W, b, grad_W, grad_b, learning_rate);
    [accuracy, loss] = ComputeAccuracyAndLoss(W, b, train_data, train_label);
    fprintf('Epoch%d - loss: %.5f\tDeviated Gradients: %d\n', epoch, loss, outlier)
    
end