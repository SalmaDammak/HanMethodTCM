function threshold = ComputeAdaptiveThreshold(samplesize,SlideName)
% The fucntion computes threshold for nuclei segmentation for the given
% whole slide image using adpative threshold algorithm.
% Input: sample size, the number of ROIs used for sampling to compute the
% threshold for the whole slide image. SlideName, name of the whole slide
% image. In this implementation, we use bigTiff format. 
% Output: the computed threshold value for nuclei segmentation at 
% hematoxylin channel after color deconvolution
    warning('off')
    OriginalImgName = [SlideName,'.tif'];
    tilenumPoolName = [SlideName,'tilenumPool.mat'];
    load (tilenumPoolName);
    
    %% read img info %%
    t = Tiff(OriginalImgName,'r');
    ImgWidth = t.getTag('ImageWidth');
    ImgLength = t.getTag('ImageLength');
    numOfcols = ceil(ImgWidth/240);
    numOfrows = ceil(ImgLength/240);
    t.close();

    %% sampling(based on the smapling rules) for computation %%
    maxtilenum = numOfrows*numOfcols;
    tilenumTable = reshape(1:maxtilenum,[numOfcols,numOfrows])';
    Tissue_indx = find(~isnan(tilenumPool));
    tissuenum_pool = tilenumTable(Tissue_indx);
    indx_img = datasample(tissuenum_pool,samplesize);
    tissuenum_pool_rest = setdiff(tissuenum_pool,indx_img);
    j  = 1;       
    for sptilenum = 1:samplesize
        tilenum = indx_img(sptilenum);
        t = Tiff(OriginalImgName,'r');
        Img = t.readEncodedTile(tilenum);
        t.close();
        clear t;
        H = computeHematoxylin(Img);
        NO = [];
        range = ceil(10*max(H(:)))/10;   
        while range <= 1 || range >= 6     
            indx_img_add = datasample(tissuenum_pool_rest,1);
            tissuenum_pool_rest = setdiff(tissuenum_pool_rest,indx_img_add);
            t = Tiff(OriginalImgName,'r');
            Img = t.readEncodedTile(indx_img_add);
            t.close();
            clear t;
            H = computeHematoxylin(Img);
            NO = [];
            range = ceil(10*max(H(:)))/10;
        end
        for i = 0:0.1:range            
            Z = H > i;
            CC = bwconncomp(Z);
            NO = [NO CC.NumObjects]; 
        end 
        NO_Table(j,1:size(NO,2)) = NO;
        j = j+1;
    end
    
    %% compute threshold %%
    NO_Total = sum(NO_Table);
    ax = size(NO_Total,2);
    x = 1:1:ax;
    degree = 20;
    p = polyfit(x,NO_Total,degree);  
    Y = polyval(p,x);     
    Y_2 = diff(diff(Y));  
    Y_1 = diff(Y);         
    [peaks_first,locs_first] = findpeaks(Y_1,x(1,1:end-1));       
    [peaks_or,locs_or] = findpeaks(Y,x);         
    [peaks_second,locs_second] = findpeaks(Y_2,x(1,2:end-1));
    locs_value = locs_second(find(peaks_second == max(peaks_second)));      
    while locs_value < locs_or(find(peaks_or == max(peaks_or)))   
        peaks_second(find(locs_second == locs_value)) = 0;
        locs_value = locs_second(find(peaks_second == max(peaks_second)));   
    end
    locs_value_first = locs_first(locs_first > locs_value);
    locs_thresh = locs_value_first(1,1);
    threshold = (locs_thresh-1)*0.1;   %% threshold value starts from zero while location value from 1
      
end