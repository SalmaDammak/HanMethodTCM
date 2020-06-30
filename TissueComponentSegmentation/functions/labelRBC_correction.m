%% this function built based on labelRBC. labelRBC would label all the pixels by thresholding
%% in HSV color space. This function would only label RBC that mistakely labeled as nuclei
function I_Label = labelRBC_correction(img,I_Label,idx_nuclei)
         %% set up parameters for this function
         thresh_H = 0.95;
         thresh_S = 0.72;
         thresh_V = 0.6;
         diskRadius = 8;
         img_hsv = rgb2hsv(img);
         h = img_hsv(:,:,1);
         s = img_hsv(:,:,2);
         v = img_hsv(:,:,3);
         idx_h = find( h >= thresh_H);
         idx_s = find( s >= thresh_S);
         idx_v = find(v >= thresh_V);
         idx_hs  =  intersect(idx_h,idx_s);
         idx_hs = intersect(idx_hs,idx_v);
         mask = zeros(size(img_hsv,1),size(img_hsv,2));
         mask(idx_hs) = 1;
         se = strel('disk',diskRadius);  %%Red blood cells(RBC's) can vary in size due to pathologies but for the most part are consistently 7.5-8 micrometers in diameter. 
         mask = imdilate(mask,se);
         idx_rbc = find(mask==1);
         idx_remove = intersect(idx_rbc, idx_nuclei);
         I_Label(idx_remove) = 1;   %% label all the RBCs which mistakely labeled as nuclei as lumen
end