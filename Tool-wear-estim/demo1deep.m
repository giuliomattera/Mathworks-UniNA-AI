%% Import dataset and split training-test
X = datatoolwear(:, 1:20);
Y = datatoolwear(:,21);

holes = linspace(1, size(X,1) , size(X,1))';

X = [X , holes];

PD = 0.1;

cv = cvpartition(size(X,1), 'Holdout', PD);

X_train = X(cv.training, :);
X_test = X(cv.test, :);

Y_train = Y(cv.training, :);
Y_test = Y(cv.test, :);

%% Define Network architecture
layers = [
    featureInputLayer(21,"Name","featureinput")
    %layerNormalizationLayer("Name","layernorm")
    fullyConnectedLayer(63,"Name","fc_1")
    tanhLayer("Name","tanh")
    fullyConnectedLayer(42,"Name","fc_2")
    tanhLayer("Name","tanh")
    fullyConnectedLayer(1,"Name","fc_3")
    regressionLayer("Name","regressionoutput")];

%% Select training's hyperparameters
options = trainingOptions("adam", MaxEpochs = 25000, ...
                           InitialLearnRate = 0.00002, ...
                           Plots = "training-progress", ...
                           Verbose = 1)
                       
net = trainNetwork(X_train, Y_train, layers, options);

%% Plot results
plot(Y)
hold on
plot(predict(net, X))
xlabel('Hole number')
ylabel('Tool wear')
legend('Target wear', 'Predicted wear')

%%
