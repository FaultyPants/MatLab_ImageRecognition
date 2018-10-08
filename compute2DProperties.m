function [db, out_img] = compute2DProperties(orig_img, labeled_img)

    labeled_img = imread('labeled_objects.png');
    
    [labeled_img, numObj] = bwlabel(im2bw(labeled_img));
   
    obj_db = zeros(6 , numObj);
    
    %%Identifies the object number, placing it in the top of the matrix%%
    for i = 1:numObj
        obj_db(1, i) = i;
    end
    
    for i = 1:numObj
    [row, col] = find(labeled_img == i);
    obj_db(2, i) = mean(row);
    obj_db(3, i) = mean(col);
    end
    
    disp(obj_db);
    