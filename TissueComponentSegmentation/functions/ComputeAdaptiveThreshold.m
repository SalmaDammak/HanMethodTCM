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
    load(tilenumPoolName); % this shows which tiles in this slide are non-background
    
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
    NO_Total = sum(NO_Table);%/size(NO_Table,1);
    ax = size(NO_Total,2);
    
    % instead of using the actual threshold values, we're replacing them with
    % placeholder integers, then we'll convert back at the end
    x = 1:1:ax;
        
    % fit 20th degree polynomial to number of connected components (y) vs
    % threshold (x)
    dPolynomialDegree = 20;
    vdCoeffientsp = polyfit(x,NO_Total,dPolynomialDegree);  
    
    % evaluate polynomial at all x values
    vdConnectedComponentCurve = polyval(vdCoeffientsp,x);
    
    % take the first and secodn derivatives 
    vdFirstDerivative = diff(vdConnectedComponentCurve);       
    vdSecondDerivative = diff(diff(vdConnectedComponentCurve)); 
    
%     % Plot
%     figure; subplot(1,3,1); plot(x,vdConnectedComponentCurve)
%     grid on
%     subplot(1,3,2); plot(vdFirstDerivative)
%     grid on
%     subplot(1,3,3); plot(vdSecondDerivative)
%     grid on
    
    % find the peaks in all curves. Not sure why the x values are truncated
    % that way.... 
    [vdPeaks_y,vdPeaks_x] = findpeaks(vdConnectedComponentCurve,x);  
    [~,vdPeaksFirstDerivative_x] = findpeaks(vdFirstDerivative,x(1,1:end-1));
    [vdPeaksSecondDerivative_y,vdPeaksSecondDerivative_x] = findpeaks(vdSecondDerivative,x(1,2:end-1)); % x values +1?? why?
    
    % find the x-axis value for the largest peak of the the second derivative    
    dLargestPeakOfSecondDerivative_x = vdPeaksSecondDerivative_x(find(vdPeaksSecondDerivative_y == max(vdPeaksSecondDerivative_y)));
    
    % if the x-axis value of the largest peak in the second derivative is
    % less than the x-axis value (i.e. happens at a lower threshold) of the original curve
    % check the next largest peak, and keep going until you find a peak
    % that is at a threshold lower than that of the largest peak of the
    % original curve
    while dLargestPeakOfSecondDerivative_x < vdPeaks_x(find(vdPeaks_y == max(vdPeaks_y)))
        
        % Zero out the largest peak in the second derivative curve
        vdPeaksSecondDerivative_y(find(vdPeaksSecondDerivative_x == dLargestPeakOfSecondDerivative_x)) = 0;
        
        % Look for the next largest one
        dLargestPeakOfSecondDerivative_x = vdPeaksSecondDerivative_x(find(vdPeaksSecondDerivative_y == max(vdPeaksSecondDerivative_y)));   
    end
    
    % Take the first peak in the first derivative that is at a threshold
    % above the second derivative peak
    % this is the first major dip in the connected component curve after
    % the largest amount of connected components is reached. At this point,
    % we loose a lot of small pieces, making way for the nuclei
    vdFirstDerivativePeaksAboveLargestPeak_x = vdPeaksFirstDerivative_x(vdPeaksFirstDerivative_x > dLargestPeakOfSecondDerivative_x);
    locs_thresh = vdFirstDerivativePeaksAboveLargestPeak_x(1,1);
    threshold = (locs_thresh-1)*0.1;   %% threshold value starts from zero while location value from 1
      
end