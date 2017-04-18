% % visualize the initail first layer weights for Q3.1
% layers = [32*32, 400, 26];
% [W, ~] = InitializeNetwork(layers);


% % visualize the learned first layer weights for Q3.1
% load('nist26_model.mat')


% % visualize the learned first layer weights for Q3.2
% load('nist36_model.mat')


% % visualize the initail first layer weights for Q3.2
% load('../data/nist26_model_60iters.mat', 'W', 'b');
% % modify the loaded data to match matrix size
% num = length(W);
% for i = 1:num
%     W{i} = W{i}';
%     b{i} = b{i}';
% end
% % add 10 more weights and biases to the output layer
% dim_prevL = size(W{num}, 1);
% temp = 0.01 * rand(dim_prevL, 10) ./ sqrt(dim_prevL);
% W{num} = horzcat(W{num}, temp);
% b{num} = horzcat(b{num}, zeros(1, 10));


% % concatenating images
% weights = cell(400, 1);
% W = W{1};
% 
% for i = 1:400
%     V = reshape(W(:, i), 32, 32);
%     fileName = sprintf('img%d.png', i);
%     imwrite(mat2gray(V), fileName);
%     weights{i} = fileName;
% end
% 
% montage(weights, 'Size', [20 20]);
   

% -------------------- Confusion Plot ----------------------

% % visualize the confusion matrix for Q3.1
% load('nist26_model.mat')
% load('../data/nist26_test.mat', 'test_data', 'test_labels')


% visualize the confusion matrix for Q3.2
load('nist36_model.mat');
load('../data/nist36_test.mat', 'test_data', 'test_labels');

% plot confusion matrix 
[outputs] = Classify(W, b, test_data);
outputs = outputs';
targets = test_labels';
plotconfusion(targets, outputs);



