function I_TCM = converLabeltoRGB(I_Label)
        idx_nuclei = find(I_Label==0);
        idx_stroma = find(I_Label==128);
        Idx_lumen = find(I_Label== 255);
        I = zeros(size(I_Label,1), size(I_Label,2));
        I_r = I;
        I_g = I;
        I_b = I;
        I_r(idx_nuclei) = 255;
        I_g(idx_stroma) = 255;
        I_b(Idx_lumen) = 255;
        I_TCM = cat(3, I_r, I_g, I_b);
end