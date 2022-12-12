%% Import dataset and splitting
data = load('dataWeld_err.mat').data;
X = data(:,1:4);
Y = data(:,5);
PD = 0.1;
cv = cvpartition(size(X,1), 'Holdout', PD);
X_train = X(cv.training, :);
X_test = X(cv.test, :);
Y_train = Y(cv.training, :);
Y_test = Y(cv.test, :);

%% Define Network architecture
layers = [
    featureInputLayer(4,"Name","featureinput")
    layerNormalizationLayer("Name","layernorm")
    fullyConnectedLayer(300,"Name","fc_1")
    tanhLayer("Name","tanh")
    fullyConnectedLayer(100,"Name","fc_2")
    tanhLayer("Name","tanh")
    fullyConnectedLayer(1,"Name","fc_3")
    sigmoidLayer("Name","softmax")
    regressionLayer("Name","classoutput")
    ]
%% Select training's hyperparameters
options = trainingOptions("rmsprop", MaxEpochs = 500, ...
                           InitialLearnRate = 0.001, ...
                           Plots = "training-progress", ...
                           MiniBatchSize = 64, ...
                        Verbose = 1)
net = trainNetwork(X_train, Y_train, layers, options);

%% Visualize results
Y = predict(net, X_test);
for i=1:size(Y,1)
    if Y(i,1) > 0.5
        Y(i,1) = 1;
    else
        Y(i,1) = 0;
    end
end

c = confusionmat(Y_test, double(Y));
c = (c/size(Y,1).*100);
c = round(c)
confusionchart(c)
accuracy = (c(1,1) + c(2,2))

%%