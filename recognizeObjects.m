function output_img = recognizeObjects(orig_img, labeled_img, obj_db)

catalog_db = compute2DProperties(orig_img, labeled_img);

for i = 1: length(obj_db)
    for j = 1: length(catalog_db)
        hold on
        orientation = obj_db(5, i) + catalog_db(5, j);
        imrotate(orig_img, orientation);
        if obj_db(6, i) == new_db(6, j)
            plot(new_db(2, j), new_db(3, j), 'm', 30);
            plot([new_db(2, j) new_db(3, j)], [new_db(2, j + 4),... 
                new_db(3, j + 4)], 'm', 30);
        end
        hold off
    end
end