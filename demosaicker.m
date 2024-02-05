 close all
clear

% originalImage = reshape(uint8(readmatrix("C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\RAW2RGB\mosaic1.csv")), 960, 1280, 3);
originalImage = uint8(readmatrix("C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\RAW2RGB\mosaic8.csv"));


figure 
imshow(originalImage);
% 
% originalImageSize = size(originalImage);
% originalImageHeight = originalImageSize(1);
% originalImageWidth = originalImageSize(2);
% 
% mosaicImageViewable = zeros(originalImageHeight * 2, originalImageWidth * 2, originalImageSize(3), "uint8");
% mosaicImage = zeros(originalImageHeight * 2, originalImageWidth * 2, "uint16");
% 
% currentMosaicRow = 1;
% currentMosaicCol = 1;
% 
% for currentRow = 1:originalImageSize(1)
%     for currentCol = 1:originalImageSize(2)
%         %red
%         mosaicImageViewable(currentMosaicRow, currentMosaicCol + 1, 1) = originalImage(currentRow, currentCol, 1);
%         mosaicImageViewable(currentMosaicRow, currentMosaicCol + 1, 2) = 0;
%         mosaicImageViewable(currentMosaicRow, currentMosaicCol + 1, 3) = 0;
% 
%         % green
%         mosaicImageViewable(currentMosaicRow, currentMosaicCol, 1) = 0;
%         mosaicImageViewable(currentMosaicRow, currentMosaicCol, 2) = originalImage(currentRow, currentCol, 2);
%         mosaicImageViewable(currentMosaicRow, currentMosaicCol, 3) = 0;
% 
%         mosaicImageViewable(currentMosaicRow + 1, currentMosaicCol + 1, 1) = 0;
%         mosaicImageViewable(currentMosaicRow + 1, currentMosaicCol + 1, 2) = originalImage(currentRow, currentCol, 2);
%         mosaicImageViewable(currentMosaicRow + 1, currentMosaicCol + 1, 3) = 0;
% 
%         % blue
%         mosaicImageViewable(currentMosaicRow + 1, currentMosaicCol, 1) = 0;
%         mosaicImageViewable(currentMosaicRow + 1, currentMosaicCol, 2) = 0;
%         mosaicImageViewable(currentMosaicRow + 1, currentMosaicCol, 3) = originalImage(currentRow, currentCol, 3);
% 
%         % mosaicImage(currentMosaicRow, currentMosaicCol + 1) = uint16(originalImage(currentRow, currentCol, 1)) * 16.058823529411764705882352941176;
%         % mosaicImage(currentMosaicRow, currentMosaicCol) = uint16(originalImage(currentRow, currentCol, 2)) * 16.058823529411764705882352941176;
%         % mosaicImage(currentMosaicRow + 1, currentMosaicCol + 1) = uint16(originalImage(currentRow, currentCol, 2)) * 16.058823529411764705882352941176;
%         % mosaicImage(currentMosaicRow + 1, currentMosaicCol) = uint16(originalImage(currentRow, currentCol, 3)) * 16.058823529411764705882352941176;
% 
%         mosaicImage(currentMosaicRow, currentMosaicCol + 1) = int16(double(originalImage(currentRow, currentCol, 1)) * 16.058823529411764705882352941176); % 16,058823529411764705882352941176
%         mosaicImage(currentMosaicRow, currentMosaicCol) = int16(double(originalImage(currentRow, currentCol, 2)) * 16.058823529411764705882352941176);
%         mosaicImage(currentMosaicRow + 1, currentMosaicCol + 1) = int16(double(originalImage(currentRow, currentCol, 2)) * 16.058823529411764705882352941176);
%         mosaicImage(currentMosaicRow + 1, currentMosaicCol) = int16(double(originalImage(currentRow, currentCol, 3)) * 16.058823529411764705882352941176);
% 
%         if currentMosaicCol < originalImageWidth * 2 - 1
%             currentMosaicCol = currentMosaicCol + 2;
%         else
%             currentMosaicCol = 1;
%         end
%     end
% 
%     currentMosaicRow = currentMosaicRow + 2;
% end
% 
% reverse = demosaic(mosaicImage, "grbg");
% %reverse = demosaic(mosaicImage, "gbrg");
% 
% figure
% imshow(reverse);
% 
% figure
% imshow(mosaicImageViewable);
% 
% writematrix(mosaicImage, "C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\RAW2RGB\mosaic1.csv");
% writematrix(originalImage, "C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\RAW2RGB\original.csv");
% writematrix(reverse, "C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\RAW2RGB\reverse.csv");