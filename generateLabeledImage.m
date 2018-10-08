function labeled_img = generateLabeledImage(gray_img, threshold)%
  
    bwimg = im2bw(gray_img, threshold)
    bwprocessed = bwmorph(bwimg, 'erode', 3);
    bwprocessed = bwmorph(bwprocessed, 'dilate', 3);   
    labelmatrix = bwlabel(bwprocessed, 4);

   