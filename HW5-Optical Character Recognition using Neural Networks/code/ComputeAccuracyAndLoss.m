function [accuracy, loss] = ComputeAccuracyAndLoss(W, b, data, labels)
% [accuracy, loss] = ComputeAccuracyAndLoss(W, b, X, Y) computes the networks
% classification accuracy and cross entropy loss with respect to the data samples
% and ground truth labels provided in 'data' and labels'. The function should return
% the overall accuracy and the average cross-entropy loss.

% initialize parameters
num_class = size(labels, 2);  
num_data = size(labels, 1);
correct = 0;   
loss = 0;

% perform forward propagation and classification
[outputs] = Classify(W, b, data);

% check the results and compute accuracy and loss
for i = 1:num_data
   predict = outputs(i, :);
   label = labels(i, :);
   
   % find the class with maximal probability
   [~, index] = max(predict);  
   if label(index) == 1
       correct = correct + 1;
   end 
      
   crossEntropy = -log(sum(predict .* label));
   loss = loss + crossEntropy;  
end

% averaging the results
accuracy = correct / num_data;

end
