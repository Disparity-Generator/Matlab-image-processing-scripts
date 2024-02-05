close all
% clear

blocksize = 5;

% packedImage = readmatrix("C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\disparity_generator\disparity.csv");
% packedImage = readmatrix("C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\RAW2RGB\out.csv");
packedImage = packedImage_lr;
packedDimensions = size(packedImage);

packedImageHeight = packedDimensions(1);
packedImageWidth = packedDimensions(2);

resultImageHeight = packedDimensions(1) * blocksize;
resultImageWidth = packedDimensions(2) * blocksize;

resultImage1 = zeros(resultImageHeight, resultImageWidth);

for packedRow = 1:packedImageHeight
    for unpackedRow = 1:blocksize
        for packedCol = 1:packedImageWidth
            for unpackedCol = 1:blocksize
                resultImage1((packedRow - 1) * blocksize + unpackedRow, (packedCol - 1) * blocksize + unpackedCol) = packedImage(packedRow, packedCol);
            end
        end
    end
end
imshow(resultImage, [0 255]);