num_epoch = 5;
classes = 36;  % 26 letters + 10 digits
learning_rate = 0.01;

load('../data/nist26_model_60iters.mat', 'W', 'b');
load('../data/nist36_train.mat', 'train_data', 'train_labels')
load('../data/nist36_test.mat', 'test_data', 'test_labels')
load('../data/nist36_valid.mat', 'valid_data', 'valid_labels')

% modify the loaded data to match matrix size
num = length(W);
for i = 1:num
    W{i} = W{i}';
    b{i} = b{i}';
end

% add 10 more weights and biases to the output layer
dim_prevL = size(W{num}, 1);
% temp = 0.01 * rand(dim_prevL, 10) ./ sqrt(dim_prevL);
temp = 0.01 * rand(dim_prevL, 10);
W{num} = horzcat(W{num}, temp);
b{num} = horzcat(b{num}, zeros(1, 10));


Train_Accuracy = zeros(num_epoch, 1);
Valid_Accuracy = zeros(num_epoch, 1);
Train_Loss = zeros(num_epoch, 1);
Valid_Loss = zeros(num_epoch, 1);

for j = 1:num_epoch
    [W, b] = Train(W, b, train_data, train_labels, learning_rate);

    [Train_Accuracy(j), Train_Loss(j)] = ComputeAccuracyAndLoss(W, b, train_data, train_labels);
    [Valid_Accuracy(j), Valid_Loss(j)] = ComputeAccuracyAndLoss(W, b, valid_data, valid_labels);

    fprintf('Epoch %d - accuracy: %.5f, %.5f \t loss: %.5f, %.5f \n', j, ...
        Train_Accuracy(j), Valid_Accuracy(j), Train_Loss(j), Valid_Loss(j))
end

save('nist36_model.mat', 'W', 'b')


% plot the accuracy and loss of each epoch
figure; hold on
title('Accuracy over epochs')
xlabel('Number of Epoch')
ylabel('Accuracy')
a1 = plot(1:num_epoch, Train_Accuracy'); 
a2 = plot(1:num_epoch, Valid_Accuracy'); 
legend([a1; a2], ['Training  '; 'Validation']);
saveas(gcf, 'Q3.2.1_accuracy_VS_epoch_%.4f.png');

% plot the accuracy and loss of each epoch
figure; hold on
title('Loss over epochs')
xlabel('Number of Epoch')
ylabel('Loss')
a1 = plot(1:num_epoch, Train_Loss'); 
a2 = plot(1:num_epoch, Valid_Loss'); 
legend([a1; a2], ['Training  '; 'Validation']);
saveas(gcf, 'Q3.2.1_loss_VS_epoch.png');



