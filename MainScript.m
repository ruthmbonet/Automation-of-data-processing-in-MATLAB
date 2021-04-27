clear all  %j'efase le workspace 
clc        %j'efase la command window


%cherche des fichiers
[allData,nSujets,nFichiers] = ChercherFichier();
%segmentation des fichiers
segments = SegmentationFichier(allData,nSujets,nFichiers);
%calcule de parametres
parametres = CalculParametres(segments);
clc
%%
for i = 1 : 18
    for j = 1 : 20
        segments_parametres{j,i} = {segments{j,i},parametres{j,i}};   %union des sujets avec ses parametres calcules
    end
end


clear i j
%division de trois sujets
sujet01 = segments_parametres(:,1:6); 
sujet02 = segments_parametres(:,7:12);
sujet03 = segments_parametres(:,13:18);

%%
%je garde mes mouvements et ses parametres dans des fichiers excels
ExcelGenerator(sujet01,sujet02,sujet03);










