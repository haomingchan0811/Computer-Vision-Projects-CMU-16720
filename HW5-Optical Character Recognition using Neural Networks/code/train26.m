num_epoch = 50;
classes = 26;
layers = [32*32, 400, classes];
learning_rate = 0.01;

load('../data/nist26_train.mat', 'train_data', 'train_labels');
load('../data/nist26_test.mat', 'test_data', 'test_labels');
load('../data/nist26_valid.mat', 'valid_data', 'valid_labels');

[W, b] = InitializeNetwork(layers);

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

save('nist26_model.mat', 'W', 'b')

% plot the accuracy and loss of each epoch
figure; hold on
title('Accuracy over epochs')
xlabel('Number of Epoch')
ylabel('Accuracy')
a1 = plot(1:num_epoch, Train_Accuracy'); 
a2 = plot(1:num_epoch, Valid_Accuracy'); 
legend([a1; a2], ['Training  '; 'Validation']);
saveas(gcf,sprintf('Q3.1.1_accuracy_VS_epoch_%.4f.png', learning_rate))

% plot the accuracy and loss of each epoch
figure; hold on
title('Loss over epochs')
xlabel('Number of Epoch')
ylabel('Loss')
a1 = plot(1:num_epoch, Train_Loss'); 
a2 = plot(1:num_epoch, Valid_Loss'); 
legend([a1; a2], ['Training  '; 'Validation']);
saveas(gcf,sprintf('Q3.1.1_loss_VS_epoch_%.4f.png', learning_rate))



