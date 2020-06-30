%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Author: Wenchao Han, University of Toronto, Sunnybrook institute, Toronto, Canada.
Contact: whan25@uwo.ca

________
This folder provides code for implementing tissue component segmentation. The main function(ComputeTCM_main) demonstrates how to computes the adaptive thresholding algorithm, and how to use the algorithm to label the tissue image as three class tissue component maps(black-nuclei, grey-stroma/other, white-lumen). 
The code uses one whole-mount WSI from our center for demonstration purpose, please see the link below to download.
This image shall not be transferred/edited/redistributed without the permission from the author. 

To run the code, reader needs to download the function "Decovolve.m" at https://warwick.ac.uk/fac/sci/dcs/research/tia/software/sntoolbox/, and put the function in the folder "TissueComponentSegmentation/functions" for implementing the color deconvolution algorithm. The reader needs to download the WSI at https://drive.google.com/file/d/1wAte2t5n0j2_PYY_-tvGki7_GWvFdY5N/view?usp=sharing. Uncompressing the image to the path"TissueComponentSegmentatio/functions".
Then, opening "ComputeTCM_main.mat" with Matlab to run the code. To generate color tissue component maps, read the comments in "testthresholdexamples.m".

