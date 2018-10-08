function [obj_db, out_img] = compute2DProperties(gray_img, labeled_img)
[labeled_img, obj_num] = bwlabel(im2bw(labeled_img));

obj_db = zeros(6, obj_num); %creates an empty 6 x obj_num array
fh1 = figure();
imshow(labeled_img);

for r = 1:obj_num
    
    obj_db(1,r) = r; %labels the first row with object labels
    [row, col] = find(labeled_img == r); %finds each labeled object inside the image
    area = sum(sum(labeled_img));
    meanx = 0;
    meany = 0;
    for i = 1:row
        for j = 1:col
            meanx = meanx + labeled_img(i,j)*j;
        end
    end
    xAvg = meanx/area; %computes centroid in horizontal direction
    for k = 1:col
        for l = 1:row
            meany = meany + labeled_img(l,k)*l;
        end
    end
    yAvg = meany/area; %computes the centroid in the vertical direction
    rowSumSq = zeros(1, length(row)); %creates a zero array to add each (rowValue - rowAvg)^2
    colSumSq = zeros(1, length(col)); %creates a zero array to add each (colValue - colAvg)^2
    rowSum = zeros(1, length(row)); %creates a zero array to get the centroid coordinate system rowSum
    colSum = zeros(1, length(col)); %creates a zero array to get the centroid coordinate system colSum
    bSum = zeros(1, length(col)); %creates a zero array to add the numbers for b
    obj_db(2,r) = yAvg; %the mean of the 1D row vector is the center
    obj_db(3,r) = xAvg; %the mean of the 1D col vector is the center
    for m = 1:length(row)
        rowSumSq(m) = (row(m) - yAvg).^2; %places (y - yavg)^2 for centroid coordinates in rowSum
    end
    for n = 1:length(col)
        colSumSq(n) = (col(n) - xAvg).^2; %places (x - xavg)^2 for centroid coordinates in colSum
    end
    for o = 1:length(row)
        rowSum(o) = (row(o) - yAvg); %places (y - yavg) to calculate b in centroid coordinates
    end
    for p = 1:length(col)
        colSum(p) = (col(p) - xAvg); %places (x - xavg) to calculate b in centroid coordinates
    end
    c = sum(rowSumSq); %c is the sum of rowSum
    a = sum(colSumSq); %a is the sum of colSum
    sumRow = sum(rowSum);
    for t = 1:length(colSum)
        sumCol = colSum(t) .* sumRow; %each colSum is multiplied by sumRow in centroid coordinates
    end
    b = 2 .* sumCol; %b is 2 * the colSum * rowSum in centroid coordinates
    eMin = 0.5 * (a + c - (sqrt(b.^2 + (a - c).^2))); %equation for Emin
    obj_db(4,r) = eMin; %places eMin in the object db
    theta = atan2(b,a-c)./2; %equation for theta
    obj_db(5,r) = theta; %places theta in the object db
    eMax = 0.5 .* (a + c + (sqrt(b.^2 + (a - c).^2))); %equation for Emax
    obj_db(6,r) = eMin./eMax; %places roundedness in the object db
    line_length = 100;
    y1coord = line_length .* sin(theta) + mean(row);
    y2coord = line_length .* sin(theta + pi) + mean(row);
    x1coord = line_length .* cos(theta) + mean(col);
    x2coord = line_length .* cos(theta + pi) + mean(col);
    hold on;
    linexy = [[mean(row) mean(col)]; [y1coord x1coord]; [y2coord x2coord]];
    line(linexy(1:3, 1), linexy(1:3,2), 'LineWidth', 2, 'Color', [0,0,1]);
end
out_img = saveAnnotatedImg(fh1);