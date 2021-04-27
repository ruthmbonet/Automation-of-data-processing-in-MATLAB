function [data,nSujets,nFichiers] = ChercherFichier()

repertoryFolder = pwd; %je garde la position actuelle
cd Donees\             %je vais au fichier donnees ou j'ai tous la data
dataFolder = pwd;      %je garde ma position actuelle


sujets = dir(dataFolder); % je garde le contenu du fichier "Donnees", ou j'ai tous les donnees a analiser

sujets=sujets(~ismember({sujets.name},{'.','..'})); % j'efase les fichier de "." et ".." que la fonction dir  
                                                   % me donne qui correspondent au dossier actuel et au
                                                   % dossier parent, parce fichiers "Sujet1" "Sujet2" et "sujet3"
                                                 
nSujets = length(sujets); %je calcul le nombre de sujets que j'ai


for i = 1 : nSujets
  
  cd(sujets(i).name);
  
  dataFichiers = pwd;                                   %pareil q'avec les sujets
  Fichiers = dir(dataFichiers);
  Fichiers=Fichiers(~ismember({Fichiers.name},{'.','..'}));
  nFichiers = length(Fichiers);
  
  for j = 1 : nFichiers                                     %je cherche chaque fichier de chaque sujet
    nomFichier = strcat('S0',num2str(i),'_E0',num2str(j),'.csv');  %je garde le nom de chaque fichier
    data{j,i} = csvread(nomFichier,8,0);               %je cherche le fichier et le garde en "data"
    clc
  end
  
  cd(dataFolder)           %je retourne a le file Donees
end

cd(repertoryFolder)        %je retourne au file principal

end
