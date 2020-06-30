function testthresholdexamples(Image, imagename, threshold, examplesize)
% this function is a demo script. It takes the whole slide image (WSI) and
% calculated threshold to segmente the sampled ROIs from the WSI into the 
% three class tissue components. The computed tissue component maps are
% displayed in the form of label maps(nuclei are labeled in black,
% storma/other tissues labeled in grey, and lumina labeled in white.)
% Uncomment line 49 to 51 to generate color label maps for machine
% learning. Editing out the code of line 49(down sample the label map to 
% 25%)to display the full resolution of the color label map.
    t = Tiff(imagename,'r');
    tilenumPoolName = [Image,'tilenumPool.mat'];
    load (tilenumPoolName);
    %% read img info %%
    ImgWidth = t.getTag('ImageWidth');
    ImgLength = t.getTag('ImageLength');
    numOfcols = ceil(ImgWidth/240);
    numOfrows = ceil(ImgLength/240);
    t.close();
    maxtilenum = numOfrows*numOfcols;
    tilenumTable = reshape(1:maxtilenum,[numOfcols,numOfrows])';
    Tissue_indx = find(~isnan(tilenumPool));
    tissuenum_pool = tilenumTable(Tissue_indx);
    indx_img = datasample(tissuenum_pool,examplesize);
    tissuenum_pool_rest = setdiff(tissuenum_pool,indx_img);  

    for sptilenum = 1:examplesize
        tilenum = indx_img(sptilenum);
        t = Tiff(imagename,'r');
        Img = t.readEncodedTile(tilenum);
        t.close();
        clear t;
        H = computeHematoxylin(Img);
        range = ceil(10*max(H(:)))/10; 
        while range <= 1 || range >= 6      
            indx_img_add = datasample(tissuenum_pool_rest,1);
            tissuenum_pool_rest = setdiff(tissuenum_pool_rest,indx_img_add);
            t = Tiff(imagename,'r');
            Img = t.readEncodedTile(indx_img_add);
            t.close();
            clear t;
            H = computeHematoxylin(Img);
            range = ceil(10*max(H(:)))/10;
        end
        figure, imshow(Img);
        %% for a given image, uisng the threshold computed for three class tissue component segmentation %%
        I_Label = TissueComponentSegmentation(Img,threshold);
        figure, imshow(I_Label);
%% generate image samples (downsample and converting to RGB color image) for train and test %%
%         ImgDownSampled = imresize(I_Label,0.25,'nearest');
%         I_TCM = converLabeltoRGB(ImgDownSampled);
%         figure, imshow(I_TCM);
    end
end