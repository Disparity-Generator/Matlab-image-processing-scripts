close all
% clear

bild = imread("C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\Person_Counter\Zaehltest.png");
% bild = disparitaetsBild_komprimiert;
bild = im2gray(bild);

bild = bild == 255;
bild = uint8(bild);

bild2 = bild;

writematrix(bild, "C:\Users\Schul\Entwicklung\QuartusProjekte\Abschlussprojekt\Element_Counter\zaehltest.csv");

% bild = floor(bild .* (255 / max(bild, [], "all")));

zaehlwert = 0;
zeile = 2;
spalte = 2;

equivalence = zeros(1, 500);
equivalence(2) = 2;

regionsizes = zeros(1, 500);

Grenzwert = 60;
counter = 0;

currentRegion = 2;

[bildhoehe, bildbreite] = size(bild);

while zeile < bildhoehe - 1

    while spalte < bildbreite - 1

        links = bild2(zeile, spalte - 1);
        oben = bild2(zeile - 1, spalte);
        muster = bild2(zeile, spalte);

        if(muster == 1)
            % Neue Region gefunden
            if(oben < 2 && links < 2)
                muster = currentRegion;
                currentRegion = currentRegion + 1;
                equivalence(currentRegion) = currentRegion;
            end

            % Muster gehört zu aktueller Region
            if(oben > 1 || links > 1)
                if(oben == links)
                    muster = links;
                end

                if(oben > 1 && links < 2)
                    muster = oben;
                end

                if(oben < 2 && links > 1)
                    muster = links;
                end
            end

            % Muster verbindet zwei Regionen
            % Das Muster wird der kleineren Region zugeordnet, 
            % Die größere Region wird als äquivalent zur kleineren
            % markiert.
            if(oben > 1 && links > 1 && oben ~= links)
                if(oben < links)
                    muster = oben;
                    equivalence(links) = oben;
                else
                    muster = links;
                    equivalence(oben) = links;
                end
            end
        end

        bild2(zeile, spalte) = muster;

        spalte = spalte + 1;
    end

    spalte = 2;
    zeile = zeile + 1;

end

bild3 = bild2;

zeile = 1;
spalte = 1;

while zeile < bildhoehe

    while spalte < bildbreite

        if(bild3(zeile, spalte) > 1)
            bild3(zeile, spalte) = equivalence(bild3(zeile, spalte));
            regionsizes(bild3(zeile, spalte)) = regionsizes(bild3(zeile, spalte)) + 1;
        end
        spalte = spalte + 1;
    end

    spalte = 1;
    zeile = zeile + 1;

end

% Mengen zählen

for j = 2:500
    if(regionsizes(j)) > Grenzwert
      counter = counter + 1;
    end
end

figure
imshow(bild3, [0, max(bild3, [], "all")], colormap=jet);

fprintf("Menge unabhängiger Gruppen: %d \n", counter);

% figure
% imshow(bild3);