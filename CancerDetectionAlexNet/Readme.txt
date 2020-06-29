%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Author: Wenchao Han, University of Toronto, Sunnybrook institute, Toronto, Canada.
Contact: whan25@uwo.ca

________
This folder provides a demo code using AlexNet to train a model, and using the model to predict the testing sample as cancer/non-cancer. The samples are in folder "SamplesData". 
Those samples are tissue component maps calculated from our tissue component segmentation algorithm. The tissue component maps (grey-level image maps) were conversted into 
RGB color channel: red-nuclei, green-stroma/other, blue-lumen and down-sampled to 25% in size. 

Open "CancerDetect_AlexNet_main.mat" with matlab to run the demo. The predicting labels on the testing samples might have low accuracy as the training samples have a 
very small sample size. The reader can adapt this code and folder structure for their own implementation.

Running requirement: the code needs to have minimal requirements that Matlab indicated for deep learning implementations, and to have AlexNet downloaded via Matlab.

