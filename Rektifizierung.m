close all
clear

image1 = imread("Image1.png");
image1_sw = im2gray(image1) * 2;

image2 = imread("Image2.png");
image2_sw = im2gray(image2) * 2;

image1_mean = round(mean(image1_sw, "all"));
image2_mean = round(mean(image2_sw, "all"));

[ax1, ay1] = calcPos(H1, 1, 1);
[bx1, by1] = calcPos(H1, imageWidth, 1);
[cx1, cy1] = calcPos(H1, 1, imageHeight);
[dx1, dy1] = calcPos(H1, imageWidth, imageHeight);

minx1 = min([ax1 bx1 cx1 dx1]);
miny1 = min([ay1 by1 cy1 dy1]);
offsetx1 = 0;
offsety1 = 0;

if(minx1 < 1)
    offsetx1 = abs(minx1) + 1;
end

if(miny1 < 1)
    offsety1 = abs(miny1) + 1;
end

w1 = max([ax1 bx1 cx1 dx1]);
h1 = max([ay1 by1 cy1 dy1]);

dst1 = zeros(480, 640, "uint8");

mapping = zeros(480, 640, "uint8");

[originalheight1, originalwidth1] = size(dst1);
writeColumn = 1;

targetAreaYStart1 = 1;
targetAreaYEnd1 = 480;
targetAreaXStart1 = w1-639;
targetAreaXEnd1 = w1;

for i = 1:480
    for j = 1:640
        [oldx, oldy] = calcPos(H1_inv, j, i);
        if(oldx > 0 && oldy > 0 && oldx < 640 && oldy < 480)
            dst1(i, writeColumn) = image1_sw(oldy, oldx);
        end
        writeColumn = writeColumn + 1;
    end
    writeColumn = 1;
end

dst1 = dst1(1:480, 1:640);

writeColumn = 1;

image2_rektifiziert = image2_sw;

figure("Name", "Bild 1 original");
imshow(image1_sw)

figure("Name", "Bild 2");
imshow(image2_sw)

figure("Name", "Bild 1 rektifiziert")
imshow(dst1)

writematrix(dst1 * 2, "Out1.csv");
writematrix(image2_sw * 2, "Out2.csv");
