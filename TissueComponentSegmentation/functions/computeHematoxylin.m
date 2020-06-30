function H = computeHematoxylin(Img)
    stains = Deconvolve(Img, [], 0 );
    H = stains(:,:,1);
    H = H-min(H(:));
end



