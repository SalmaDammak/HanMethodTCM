% the script uses the train data to train the model, and the model was used
% to predict the labels for the testing samples. The results shall be bad as
% a very samll sample size is used to train. This is a demo, and the 
% readers can always adapt the code for other implementation using their 
% data set.

clear;
main_path = pwd;
Path_ImgsTrain = fullfile(main_path, 'SampleData\TrainData\');    %% training dataset path
Path_ImgsTest = fullfile(main_path, 'SampleData\TestData\');
net = alexnet;

WSINameList_train = {'Patient 1'};   % putting a list of patient ids here for training
WSINameList_test = {'Patient 2'};    % put a list of test patient ids here for testing

%% building training data
imds_train = buildImgs(Path_ImgsTrain,WSINameList_train); 

%% building testing data
imds_test = buildImgs(Path_ImgsTest,WSINameList_test);

%% Grouping data for training, testing, and validation
[imdsTrain,imdsValidation] = splitEachLabel(imds_train,0.7,'randomized');

%% setup the network  
inputSize = net.Layers(1).InputSize;
layersTransfer = net.Layers(1:end-3);

numClasses = numel(categories(imdsTrain.Labels));
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain);
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);
augimdsTesting = augmentedImageDatastore(inputSize(1:2),imds_test);
TrainingFileNames = imdsTrain.Files;
TestingFileNames = imds_test.Files;

options = trainingOptions('adam', ...
'MiniBatchSize',200, ...                                       
'MaxEpochs',10, ...
'InitialLearnRate',1e-4, ...
'ValidationData',augimdsValidation, ...
'ValidationFrequency',90, ...                                  
'ValidationPatience',Inf, ...
'Verbose',false, ...
'Plots','training-progress'); 

layers = [
layersTransfer
fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
softmaxLayer
classificationLayer];

netTransfer = trainNetwork(augimdsTrain,layers,options);
%% using trainged claasifier to guess
[YPred,scores] = classify(netTransfer,augimdsTesting);




