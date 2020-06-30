function I_Label = labelLumen(Img,I_Label)
         R = Img(:,:,1);
         G = Img(:,:,2);
         B = Img(:,:,3);
         indx_R = find(R>=220);
         indx_G = find(G>=180);
         indx_B = find(B>=210);
         indx_RG = intersect(indx_R,indx_G);
         indx_RGB = intersect(indx_RG,indx_B);
         I_Label(indx_RGB) = 1;
end