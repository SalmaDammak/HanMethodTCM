%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Author: Wenchao Han, University of Toronto, Sunnybrook institute, Toronto, Canada.
Contact: whan25@uwo.ca

________
This folder provides a demo code using AlexNet to train a model, and using the model to predict the testing sample as cancer/non-cancer. 

Open "CancerDetect_AlexNet_main.mat" with matlab to run the demo. The predicting labels on the testing samples might have low accuracy as the training sample is very small. The reader can adapt this code and the data folder structure for their own implementation.

In the folder "SamplesData", there are training and testing sample images, which are color tissue component maps(red-nuclei, green-stroma/other, blue-lumen). Those tissue component maps were converted (converting to RGB color maps, and down-sampling to 25%) from the grey-level tissue component maps, which were calculated from our tissue component segmentation algorithm.

Running requirement: the code needs to have minimal requirements that Matlab indicated for deep learning implementations, and to have AlexNet downloaded via Matlab.

