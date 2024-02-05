function [disparity_image, disparityImageCompressed, disparity_image_coordinates] = calcDisparity_LR(i_left, i_right, blocksize, minimumDisparity, maximumDisparity, colorThreshold, leftStart)

image1_sw = im2gray(i_left);
image2_sw = im2gray(i_right);

[imageheight, imagewidth] = size(image1_sw);

blockImage1 = zeros(blocksize, blocksize);
blockImage2 = zeros(blocksize, blocksize);

differenzBlock = zeros(blocksize, blocksize);

disparity_image = zeros(imageheight, imagewidth);
disparityImageCompressed = zeros(round(imageheight/blocksize), round(imagewidth/blocksize));
disparity_image_sad = zeros(round(imageheight/blocksize), round(imagewidth/blocksize));

rowImage1 = 1;
colImage1 = leftStart;

disparityrowImage1 = 1;
disparitycolImage1 = 1;

colImage2 = 1;

sad = 0;
lowestSAD = 9999999999999;
currentDisparity = uint32(0);
coordinates = "";

lowestSAD_wholeRow = 9999999999999;

% Iteration durch erstes Bild (verschachtelte Schleife für Zeilen & Spalten)
% Die Iteration erfolgt nicht in Einserschritten, sondern entspricht der
% Blockgröße

while rowImage1 < imageheight - blocksize
    while colImage1 < imagewidth - blocksize - leftStart

        % Zunächst muss der Block mit dem im zweiten Bild alle Blöcke
        % verglichen werden sollen, gebildet werden.
        for rowBlock = 0:blocksize - 1
            for colBlock = 0:blocksize - 1
                blockImage1(rowBlock + 1, colBlock + 1) = image1_sw(rowBlock + rowImage1, colBlock + colImage1);
            end 
        end

        blockImage1_mean = mean(blockImage1, "all");
        % blockImage1 = blockImage1 - blockImage1_mean;

        image1_meaned(rowImage1 : rowImage1 + blocksize - 1 , colImage1 : colImage1 + blocksize - 1) = blockImage1;


        % In Bild zwei bleiben wir in der gleichen Zeile, iterieren aber
        % durch die Spalten. Diesmal Pixel für Pixel. 

        while colImage2 <= imagewidth - blocksize + 1

            % Die entsprechende Zeile in Bild zwei muss nun Block für Block mit
            % dem aktuellen Vergleichsblock aus Bild 1 verglichen werden. 
            % Hierfür muss zunächst in Bild 2 ebenfalls ein Block gebildet
            % werden. 
            for rowBlock = 0:blocksize - 1
                for colBlock = 0:blocksize - 1
                    blockImage2(rowBlock + 1, colBlock + 1) = image2_sw(rowBlock + rowImage1, colBlock + colImage2);
                end 
            end

            blockImage2_mean = mean(blockImage2, "all");
            % blockImage2 = blockImage2 - blockImage2_mean;
            image2_meaned(rowImage1 : rowImage1 + blocksize - 1 , colImage2 : colImage2 + blocksize - 1) = blockImage2;


            % Bilden der Betragsdifferenzen zwischen den jeweiligen Pixeln von
            % Bild 1 und Bild 2
            for rowBlock = 0:blocksize - 1
                for colBlock = 0:blocksize - 1
                    differenzBlock(rowBlock + 1, colBlock + 1) = abs(blockImage1(rowBlock + 1, colBlock + 1) - blockImage2(rowBlock + 1, colBlock + 1));
                end 
            end

            % Berechnen der Summe der Betragsdifferenzen
            for rowBlock = 0:blocksize - 1
                for colBlock = 0:blocksize - 1
                    sad = sad + differenzBlock(rowBlock + 1, colBlock + 1);
                end 
            end

            % Prüfen, ob die aktuelle Summe kleiner ist als die bisher kleinste. 
            % Wenn das der Fall ist, muss außerdem die dazugehörige
            % Disparität gespeichert werden. 
            % Hierfür muss die Distanz zwischen der aktuellen Spalte in
            % Bild 1 und der passenden Spalte in Bild 2 gefunden werden.
            if sad < lowestSAD
                lowestSAD = sad;
                currentDisparity = abs(colImage1 - colImage2);
                x = 0;
                coordinates = string(colImage1) + "; " + string(colImage2);
                %summen = string()
            end

            colImage2 = colImage2 + 1;
            sad = 0;
        end

        % Bevor der nächste Vergleichsblock in Bild 1 geladen wird, muss
        % das aktuelle Feld auf den besten Disparitätswert gesetzt werden. 
        for rowBlock = 0:blocksize - 1
            for colBlock = 0:blocksize - 1

                if(currentDisparity <= maximumDisparity && currentDisparity >= minimumDisparity )
                    disparity_image(rowImage1 + rowBlock, colImage1 + colBlock) = currentDisparity;
                else
                    disparity_image(rowImage1 + rowBlock, colImage1 + colBlock) = 0;
                end
            end 
        end

        if(currentDisparity <= maximumDisparity && currentDisparity >= minimumDisparity )
            disparityImageCompressed(disparityrowImage1, disparitycolImage1) = currentDisparity;
        else
            disparityImageCompressed(disparityrowImage1, disparitycolImage1) = 0;
        end

            disparity_image_sad(disparityrowImage1, disparitycolImage1) = lowestSAD;
            disparity_image_coordinates(disparityrowImage1, disparitycolImage1) = coordinates;


        % Betreten des nächsten Blocks der aktuellen Zeile in Bild 1: 

        % Wenn der nächste Block der aktuellen Zeile in Bild 1 geladen wird, muss die Spalte in
        % Bild 2 wieder zurückgesetzt werden. 
        colImage1 = colImage1 + blocksize;
        colImage2 = colImage1;

        disparitycolImage1 = disparitycolImage1 + 1;

        lowestSAD = 9999999999999;
        currentDisparity = 0;
    end 

    % Wenn die nächste Zeile in Bild 1 geladen wird, muss die aktuelle
    % Spalte in Bild 1 wieder zurückgesetzt werden. 
    colImage1 = leftStart;
    disparitycolImage1 = 1;
    rowImage1 = rowImage1 + blocksize;
    disparityrowImage1 = disparityrowImage1 + 1;
end

min1 = min(image1_meaned, [],'all');
min2 = min(image2_meaned, [],'all');
min_f = abs(min([min1 min2]));

image1_meaned = image1_meaned + min_f;
image2_meaned = image2_meaned + min_f;

image1_meaned = uint32(image1_meaned);
image2_meaned = uint32(image2_meaned);

figure("Name", "Bild 1 Mittelwert")
imshow(uint32(image1_meaned));

figure("Name", "Bild 2 Mittelwert")
imshow(uint32(image2_meaned));
end