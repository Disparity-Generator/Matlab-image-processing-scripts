function [disparityImage] = calcDisparity(image1, image2, blockSize, maxDisparity)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[imageHeight, imageWidth] = size(image1);

disparityImage = zeros(imageHeight, imageWidth);

currentColumnIndexLeftImage = 1;
currentRowIndexLeftImage = 1;
currentBlockIndex = 1;

currentColumnIndexRightImage = 1;

allSads = [];



currentBlock1 = zeros(blockSize);
currentBlock2 = zeros(blockSize);

differenceBlock = zeros(blockSize);

lowestSum = 9999;
bestDisparity = 0;

%%%% Ablauf 
% Im linken Bild wird ein quadratischer Block mit blockSize x blockSize
% Feldern als Vergleichsblock gebildet. 

% Im rechten Bild wird in der gleichen Zeile ein gleichgroßer Block gebildet.
% Für jedes Pixel in beiden Blöcken wird die Betragsdifferenz gebildet. 
% Die Differenzen jedes Pixels wird addiert. 

% Das wird für jede Spalte im rechten Bild wiederholt. 
% Der Block mit der geringsten Differenzsumme gilt als Treffer. 

% Im linken Bild wird der nächste Block in der Zeile gebildet. 
% Wenn alle Blöcke im linken Bild verglichen wurden, wird die nächste Zeile
% geöffnet. 

% Iteration durch Zeilen im 1. Bild
while currentRowIndexLeftImage < imageHeight-blockSize
    % Iteration durch Blöcke im 1. Bild
    while currentColumnIndexLeftImage < imageWidth-blockSize
        % Musterblock bauen
        for zeile = 0:blockSize - 1
            for spalte = 0:blockSize - 1
                currentBlock1(zeile + 1, spalte + 1) = image1(zeile + currentRowIndexLeftImage, spalte + currentColumnIndexLeftImage);
            end 
        end

        % Iteration durch Spalten im 2. Bild
        while currentColumnIndexRightImage < imageWidth - blockSize

            % Differenzmatrix berechnen
            for zeile = 0:blockSize - 1
                for spalte = 0:blockSize - 1
                    differenceBlock(zeile + 1, spalte + 1) = abs(int16(currentBlock1(zeile + 1, spalte + 1)) - int16(image2(zeile + currentRowIndexLeftImage, spalte + currentColumnIndexRightImage)));
                end 
            end

            sad = 0;

            % Summe der Betragsdifferenzen berechnen
            for zeile = 0:blockSize - 1
                for spalte = 0:blockSize - 1
                    sad = sad + differenceBlock(zeile + 1, spalte + 1);
                end 
            end

            if sad < lowestSum
                lowestSum = sad;
                bestDisparity = currentColumnIndexRightImage - currentColumnIndexLeftImage;
            end

            allSads(end + 1) = sad;

            currentColumnIndexRightImage = currentColumnIndexRightImage + 1;
            sad = 0;
        end

        for zeile = 0:blockSize - 1
            for spalte = 0:blockSize - 1
                disparityImage(currentRowIndexLeftImage + zeile, currentColumnIndexLeftImage + spalte) = bestDisparity;
            end 
        end

        currentColumnIndexRightImage = 1;
        currentColumnIndexLeftImage = currentColumnIndexLeftImage + blockSize;
        lowestSum = 9999;
        allSads = [];
    end

    currentRowIndexLeftImage = currentRowIndexLeftImage + blockSize;
    currentColumnIndexLeftImage = 1;
end
end