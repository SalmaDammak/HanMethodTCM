%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Author: Wenchao Han, University of Toronto, Sunnybrook institute, Toronto, Canada.
Contact: whan25@uwo.ca

________
This folder provides code for implementing tissue component segmentation. The main function(ComputeTCM_main) demonstrates how to computes the adaptive thresholding algorithm, and how
to use the algorithm to label the tissue image as three class tissue component maps(black-nuclei, grey-stroma/other, white-lumen). 
The code uses one whole-mount WSI from our center for demonstration purpose.
This image shall not be transferred/edited/redistributed without the permission from the author. 

To run the code, reader needs to download the function "Decovolve.mat" at https://warwick.ac.uk/fac/sci/dcs/research/tia/software/sntoolbox/, and put the function in the folder "TissueComponentSegmentation/functions" for implementing the color deconvolution algorithm. THe reader needs to download the WSI at https://drive.google.com/drive/folders/1fFc1Rad7-8H78fnP-6MA6gGUcL_P3rDi. Uncompressing the image to the path"TissueComponentSegmentatio/functions".
Then, opening "ComputeTCM_main.mat" with Matlab to run the code. 

