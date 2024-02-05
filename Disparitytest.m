close all;
clear all;

bild1 = imread("C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\Arbeitsgrundlage\ba-abschlussarbeit-82fce4c4335d9903de9860b0ec53b58b20120cf0\pyUartReceive\empfangeneBilder\Bild_rektifiziert_1_geschnitten.png");
% bild1 = imread("C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\Arbeitsgrundlage\ba-abschlussarbeit-82fce4c4335d9903de9860b0ec53b58b20120cf0\pyUartReceive\empfangeneBilder\Bild_links_3.png");
% bild1 = original1;
bild1_sw = im2gray(bild1) * 2;
% bild1 = int16(dst1 * 2);
bild1 = int32(bild1_sw);
bild2 = imread("C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\Arbeitsgrundlage\ba-abschlussarbeit-82fce4c4335d9903de9860b0ec53b58b20120cf0\pyUartReceive\empfangeneBilder\Bild_rechts_1_geschnitten.png");
% bild2 = original2;
bild2_sw = im2gray(bild2) * 2;
bild2 = int32(bild2_sw);
% bild2 = im2gray(bild2);

figure(Name="Bild 1 aufgehellt");
imshow(bild1_sw);

figure(Name="Bild 2 aufgehellt");
imshow(bild2_sw);

bild1_mean = round(mean(bild1, "all"));
bild2_mean = round(mean(bild2, "all"));

bild1_neu = (bild1 - round(bild1_mean));
bild2_neu = (bild2 - round(bild2_mean));

minDisparity = 60;
maxDisparity = 150;
blockgroesse = 5;

% figure
% imshow(uint8(bild2_neu_shifted));

[disparity_image_LR, disparityImageCompressed_LR, coordinates_LR] = calcDisparity_LR(bild1, bild2, blockgroesse, minDisparity, maxDisparity, 256, 1);
% [disparity_image_RL, disparityImageCompressed_RL, coordinates_RL] = calcDisparity_RL(bild1, bild2, blockgroesse, minDisparity, maxDisparity, 256, 1);

[disparity_image_LR_mittelwert, disparityImageCompressed_LR_mittelwert, coordinates_LR_mittelwert] = calcDisparity_LR(bild1_neu, bild2_neu, blockgroesse, minDisparity, maxDisparity, 256, 1);

% [disparity_image_RL_mittelwert, disparityImageCompressed_RL_mittelwert, coordinates_RL_mittelwert] = calcDisparity_RL(bild1_neu, bild2_neu, blockgroesse, minDisparity, maxDisparity, 256, 1);

disparity_image_LR = uint8(disparity_image_LR);
% disparity_image_RL = uint8(disparity_image_RL);
disparity_image_LR_mittelwert = uint8(disparity_image_LR_mittelwert);
disparity_image_LR_bereinigt = uint8(disparity_image_LR_mittelwert);
% disparity_image_RL_mittelwert = uint8(disparity_image_RL_mittelwert);

disparityImageCompressed_LR = uint8(disparityImageCompressed_LR);

differenzen = zeros(480, 640);

% [disparity_image_LR, disparityImageCompressed_LR, coordinates_LR] = calcDisparity_LR(bild1, bild2, 10, 0, 200, 256);
% [disparity_image_RL, disparityImageCompressed_RL, coordinates_RL] = calcDisparity_RL(bild1, bild2, 5, 0, 150, 256);

% for i = 1:480
%     for j = 1:640
%         differenz_abs = abs(int16(disparity_image_LR_mittelwert(i, j)) - int16(disparity_image_RL_mittelwert(i, j + int16(disparity_image_LR_mittelwert(i, j)))));
%         differenz = int16(disparity_image_LR_mittelwert(i, j)) - int16(disparity_image_RL_mittelwert(i, j + int16(disparity_image_LR_mittelwert(i, j))));
%         differenzen(i, j) = differenz;
%         differenzen_abs(i, j) = differenz_abs;
% 
%         wertLR = disparity_image_LR_mittelwert(i, j);
%         wertRL = disparity_image_RL_mittelwert(i, j + int16(disparity_image_LR_mittelwert(i, j)));
% 
%         if(differenz_abs) > 20
%             disparity_image_LR_bereinigt(i, j) = 0;
%             fehler(i, j) = 1;
%         else
%             fehler(i, j) = 0;
%         end
%     end
% end

x = mean(differenzen, "all")

figure("Name", "Disparity original, LR")
imshow(disparity_image_LR);
colorbar

% figure("Name", "Disparity original, RL")
% imshow(disparity_image_RL);
% colorbar

figure("Name", "Disparity mittelwertfrei, LR")
imshow(disparity_image_LR_mittelwert);
colorbar

% figure("Name", "Disparity mittelwertfrei, RL")
% imshow(disparity_image_RL_mittelwert);
% colorbar

figure("Name", "Disparity mittelwertfrei, bereinigt")
imshow(disparity_image_LR_bereinigt);
colorbar

figure("Name", "Disparity Fehler")
imshow(fehler);
colorbar

fig = figure(); 
tlo = tiledlayout(fig,1,2,'TileSpacing','None');
    ax = nexttile(tlo); 
    imshow(uint8(bild1), 'Parent',ax)
    title('Bild 1')

    ax = nexttile(tlo); 
    imshow(uint8(bild2), 'Parent',ax)
    title('Bild 2')
    colorbar

A = stereoAnaglyph(uint8(bild1), uint8(bild2));

% A = stereoAnaglyph(uint8(disparity_image_LR_mittelwert), uint8(disparity_image_RL_mittelwert));