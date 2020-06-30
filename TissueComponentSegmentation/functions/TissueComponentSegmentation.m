function I_Label = TissueComponentSegmentation(Img,threshold)    
            H = computeHematoxylin(Img); %% color deconvolution operation
            indx_H = find(H>=threshold);  %% find nuclei %%
            [R,C] = size(H);
            Img_sample = ones(R,C)*0.5;  %% set all other tissues as stroma %%
            Img_sample(indx_H) = 0;       %% set all the nuclei to '0' %%              
            Img_sample = labelLumen(Img,Img_sample);  
            Img_sample = labelRBC_correction(Img,Img_sample,indx_H);
            I_Label = im2uint8(Img_sample);
end

