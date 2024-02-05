function [disparity_image, disparityImageCompressed, disparity_image_coordinates] = calcDisparity_RL(i_left, i_right, blocksize, minimumDisparity, maximumDisparity, colorThreshold, rightStart)

image1_sw = im2gray(i_left);
image2_sw = im2gray(i_right);

[imageheight, imagewidth] = size(image1_sw);

blockImage1 = zeros(blocksize, blocksize);
blockImage2 = zeros(blocksize, blocksize);

differenceBlock = zeros(blocksize, blocksize);

disparity_image = zeros(imageheight, imagewidth);
disparityImageCompressed = zeros(round(imageheight/blocksize), round(imagewidth/blocksize));
disparity_image_sad = zeros(round(imageheight/blocksize), round(imagewidth/blocksize));
disparity_image_coordinates = strings(round(imageheight/blocksize), round(imagewidth/blocksize));
% disparity_image_coordinates = zeros(round(imageheight/blocksize), round(imagewidth/blocksize));

rowImage2 = 1;
colImage2 = imagewidth - blocksize - rightStart;

colImage1 = imagewidth - blocksize + 1;

disparityrowImage2 = 1;
disparitycolImage2 = imagewidth / blocksize;



sad = 0;
lowestSAD = 9999999999999;
currentDisparity = 0;
coordinates = "";

lowestSAD_wholeRow = 9999999999999;


% Iteration durch erstes Bild (verschachtelte Schleife für Zeilen & Spalten)
% Die Iteration erfolgt nicht in Einserschritten, sondern entspricht der
% Blockgröße

while rowImage2 < imageheight - blocksize
    while colImage2 > rightStart

        % Zunächst muss der Block mit dem im zweiten Bild alle Blöcke
        % verglichen werden sollen, gebildet werden.
        for rowBlock = 0:blocksize - 1
            for colBlock = 0:blocksize - 1
                blockImage2(rowBlock + 1, colBlock + 1) = image2_sw(rowBlock + rowImage2, colBlock + colImage2);
            end 
        end


        % In Bild zwei bleiben wir in der gleichen Zeile, iterieren aber
        % durch die Spalten. Diesmal Pixel für Pixel. 

        while colImage1 > 1

            % Die entsprechende Zeile in Bild zwei muss nun Block für Block mit
            % dem aktuellen Vergleichsblock aus Bild 1 verglichen werden. 
            % Hierfür muss zunächst in Bild 2 ebenfalls ein Block gebildet
            % werden. 
            for rowBlock = 0:blocksize - 1
                for colBlock = 0:blocksize - 1
                    blockImage1(rowBlock + 1, colBlock + 1) = image1_sw(rowBlock + rowImage2, colBlock + colImage1);
                end 
            end

            % Bilden der Betragsdifferenzen zwischen den jeweiligen Pixeln von
            % Bild 1 und Bild 2
            for rowBlock = 0:blocksize - 1
                for colBlock = 0:blocksize - 1
                    differenceBlock(rowBlock + 1, colBlock + 1) = abs(blockImage2(rowBlock + 1, colBlock + 1) - blockImage1(rowBlock + 1, colBlock + 1));
                end 
            end



            % Berechnen der Summe der Betragsdifferenzen
            for rowBlock = 0:blocksize - 1
                for colBlock = 0:blocksize - 1
                    sad = sad + differenceBlock(rowBlock + 1, colBlock + 1);
                end 
            end

            % Prüfen, ob die aktuelle Summe kleiner ist als die bisher kleinste. 
            % Wenn das der Fall ist, muss außerdem die dazugehörige
            % Disparität gespeichert werden. 
            % Hierfür muss die Distanz zwischen der aktuellen Spalte in
            % Bild 1 und der passenden Spalte in Bild 2 gefunden werden.
            if sad < lowestSAD
                lowestSAD = sad;
                currentDisparity = abs(colImage2 - colImage1);
                x = 0;
                coordinates = string(colImage2) + "; " + string(colImage1);
                %summen = string()
            end

            colImage1 = colImage1 - 1;
            sad = 0;
        end

        % Bevor der nächste Vergleichsblock in Bild 1 geladen wird, muss
        % das aktuelle Feld auf den besten Disparitätswert gesetzt werden. 
        for rowBlock = 0:blocksize - 1
            for colBlock = 0:blocksize - 1

                if(currentDisparity <= maximumDisparity && currentDisparity >= minimumDisparity )
                    disparity_image(rowImage2 + rowBlock, colImage2 + colBlock) = currentDisparity;
                else
                    disparity_image(rowImage2 + rowBlock, colImage2 + colBlock) = 0;
                end
            end 
        end

        if(currentDisparity <= maximumDisparity && currentDisparity >= minimumDisparity )
            disparityImageCompressed(disparityrowImage2, disparitycolImage2) = currentDisparity;
        else
            disparityImageCompressed(disparityrowImage2, disparitycolImage2) = 0;
        end

            disparity_image_sad(disparityrowImage2, disparitycolImage2) = lowestSAD;
            disparity_image_coordinates(disparityrowImage2, disparitycolImage2) = coordinates;


        % Betreten des nächsten Blocks der aktuellen Zeile in Bild 1: 

        % Wenn der nächste Block der aktuellen Zeile in Bild 1 geladen wird, muss die Spalte in
        % Bild 2 wieder zurückgesetzt werden. 



        % colImage2 = 1;
        colImage2 = colImage2 - blocksize;
        colImage1 = colImage2;

        disparitycolImage2 = disparitycolImage2 - 1;

        lowestSAD = 9999999999999;
        currentDisparity = 0;
    end 

    % Wenn die nächste Zeile in Bild 1 geladen wird, muss die aktuelle
    % Spalte in Bild 1 wieder zurückgesetzt werden. 
    colImage2 = imagewidth - blocksize;
    disparitycolImage2 = imagewidth / blocksize;
    rowImage2 = rowImage2 + blocksize;
    disparityrowImage2 = disparityrowImage2 + 1;
end

end