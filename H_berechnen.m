close all
clear

% Load images and convert them to grayscale
image1 = imread("C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\Arbeitsgrundlage\ba-abschlussarbeit-82fce4c4335d9903de9860b0ec53b58b20120cf0\pyUartReceive\empfangeneBilder\Bild_links_1.png");
image1_sw = im2gray(image1);

image2 = imread("C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\Arbeitsgrundlage\ba-abschlussarbeit-82fce4c4335d9903de9860b0ec53b58b20120cf0\pyUartReceive\empfangeneBilder\Bild_rechts_1.png");
image2_sw = im2gray(image2);

[imageHeight, imageWidth] = size(image1_sw);

[pointsImage1, checkerboardSize1] = detectCheckerboardPoints(image1_sw);
[pointsImage2, checkerboardSize2] = detectCheckerboardPoints(image2_sw);

% clear errornous values from each coordinate vector
% This is done because sometimes, although all points were
pointsImage1_NaN = any(isnan(pointsImage1), 2);
pointsImage2_NaN = any(isnan(pointsImage2), 2);

pointsImage1 = pointsImage1(~pointsImage1_NaN & ~pointsImage2_NaN, :);
pointsImage2 = pointsImage2(~pointsImage1_NaN & ~pointsImage2_NaN, :);

amountOfPoints = size(pointsImage1);
amountOfPoints = amountOfPoints(1);

figure(Name="Erkannte Punkte Bild 1")
detectedImage1 = insertMarker(image1_sw,pointsImage1,'o','MarkerColor','red','Size',5);
imshow(detectedImage1);
title(sprintf('Schachbrett mit %d x %d Punkten erkannt',checkerboardSize1));

figure(Name="Erkannte Punkte Bild 2")
detectedImage2 = insertMarker(image2_sw,pointsImage2,'o','MarkerColor','red','Size',5);
imshow(detectedImage2);
title(sprintf('Schachbrett mit %d x %d Punkten erkannt',checkerboardSize2));

A1 = [];
A2 = [];

x_Punkte_Referenz = [];
y_Punkte_Referenz = [];

for row = 1:amountOfPoints
    A1 = [A1;
    pointsImage1(row, 1) pointsImage1(row, 2) 1 0 0 0 -pointsImage2(row, 1)*pointsImage1(row, 1) -pointsImage2(row, 1)*pointsImage1(row, 2) -pointsImage2(row, 1);    
    0 0 0 pointsImage1(row, 1) pointsImage1(row, 2) 1 -pointsImage2(row, 2)*pointsImage1(row, 1) -pointsImage2(row, 2)*pointsImage2(row, 2) -pointsImage2(row, 2)
    ];
end


[eigenvectors1, eigenvalues1] = eig(A1' * A1);

min_eigenvalue1 = min(eigenvalues1(eigenvalues1 ~= 0));
[row1, column1] = find(eigenvalues1==min_eigenvalue1);

h1 = eigenvectors1(:, column1);

H1 = [h1(1) h1(2) h1(3);
     h1(4) h1(5) h1(6);
     h1(7) h1(8) h1(9);
];

u_l_min1 = calcPos(H1, 1, 1);
u_l_min2 = calcPos(H1, 1, 480);

u_l_max1 = calcPos(H1, 640, 1);
u_l_max2 = calcPos(H1, 640, 480);

u_r_min1 = 1;
u_r_min2 = 640;

u_r_max1 = 1;
u_r_max2 = 640;

u_l_min = min([u_l_min1 u_l_min2]);
u_l_max = max([u_l_max1 u_l_max2]);

u_r_min = min([u_r_min1 u_r_min2]);
u_r_max = max([u_r_max1 u_r_max2]);

v_l_min1 = calcPos(H1, 1, 1);
v_l_min2 = calcPos(H1, 640, 1);

v_l_max1 = calcPos(H1, 1, 480);
v_l_max2 = calcPos(H1, 640, 480);

v_r_min1 = 1;
v_r_min2 = 480;

v_r_max1 = 1;
v_r_max2 = 480;

v_l_min = min([v_l_min1 v_l_min2]);
v_l_max = max([v_l_max1 v_l_max2]);

v_r_min = min([v_r_min1 v_r_min2]);
v_r_max = max([v_r_max1 v_r_max2]);

v_final = min([v_l_min v_r_min]);

T1 = [1 0 -u_l_min;
      0 1 -v_final;
      0 0 1
      ];

H1 = T1 *H1;

H1_inv = inv(H1);

fprintf("G_H_11 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n", H1(1, 1));
fprintf("G_H_12 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n", H1(1, 2));
fprintf("G_H_13 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n\n", H1(1, 3));
fprintf("G_H_21 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n", H1(2, 1));
fprintf("G_H_22 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n", H1(2, 2));
fprintf("G_H_23 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n\n", H1(2, 3));
fprintf("G_H_31 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n", H1(3, 1));
fprintf("G_H_32 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n", H1(3, 2));
fprintf("G_H_33 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n\n", H1(3, 3));

fprintf("G_H_INV_11 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n", H1_inv(1, 1));
fprintf("G_H_INV_12 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n", H1_inv(1, 2));
fprintf("G_H_INV_13 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n\n", H1_inv(1, 3));
fprintf("G_H_INV_21 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n", H1_inv(2, 1));
fprintf("G_H_INV_22 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n", H1_inv(2, 2));
fprintf("G_H_INV_23 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n\n", H1_inv(2, 3));
fprintf("G_H_INV_31 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n", H1_inv(3, 1));
fprintf("G_H_INV_32 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15);\n", H1_inv(3, 2));
fprintf("G_H_INV_33 : sfixed(16 downto -15) := to_sfixed(%.8f, 16, -15)\n", H1_inv(3, 3))