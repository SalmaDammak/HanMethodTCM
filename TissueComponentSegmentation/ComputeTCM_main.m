clear;
close all;
Image = 'ProstateWSI';
imagename = 'ProstateWSI.tif';
samplesize = 2000;  
examplesize = 30;   
pwd;
main_path = pwd;
func_path = fullfile(main_path, 'functions');
addpath(func_path);


%% compute threshold for the WSI using adaptive threshold algorithm %%
threshold = ComputeAdaptiveThreshold(samplesize,Image);

%% visulize the computed threshold on the image samples extracted from the WSI %%
testthresholdexamples(Image, imagename, threshold, examplesize);