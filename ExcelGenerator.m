function[] = ExcelGenerator(sujet01,sujet02,sujet03)
%cree des fichiers excel:
% 1 fichier par essai ---> chaque mouvement dans 1 page
% c-a-d, j'obtienne 6 fichiers par sujet, un total de 18 fichiers excel

%nom du parametres calcules 
name = ["VITESSE MAX(mm/s)","DURATION(s)","DISTANCE(mm)","","","","","","","","","","","","",""];
%nom du donnees
labels =["Time","FINGER","","","ELBOW","","","SHOULDER","","","RIGHTHEAD","","","LEFTHEAD","","";
"s","mm","mm","mm","mm","mm","mm","mm","mm","mm","mm","mm","mm","mm","mm","mm";
"","X","Y","Z","X","Y","Z","X","Y","Z","X","Y","Z","X","Y","Z"];
  h = waitbar(0,'Atendez svp, on est en train de creer les fichiers Excel et ça va prendre beaucoup de temps');
  c = 1;
for k = 1:3 %3 sujets
for j = 1:6  %6 fichiers   
   for i = 1 :20  %20 mouvements  
       if(k==1)
        saveAs = [pwd,'\Resultats\Sujet01\'];    
        X = sujet01(i,j);
       else if (k==2)
        saveAs = [pwd,'\Resultats\Sujet02\'];    
        X = sujet02(i,j);
           else
             saveAs = [pwd,'\Resultats\Sujet03\'];    
             X = sujet03(i,j);
           end
       end
        X1 = X{1}(1,:);
        X2 = X1{1}(:,:);  %je garde ici les donnees
        X3 = X1{2}(1,:);
        X3 = cell2mat(X3); %je garde ici les parametres calcules (vitesse, distance)
        X3(4:16) = " ";
        X4 = [name;X3;labels;X2]; %je fais la concatenation pour creer un fichier dit "jolie et legible"
        nomFichier = strcat('E0',num2str(j),'.xlsx'); %je cree le nom du fichier
        nomFichier = strcat('E0',num2str(j),'.csv');
        saveAs = [saveAs,nomFichier]; 
        xlswrite(saveAs,X4,i); %je cree mon fichier excel 1 fichier par essai, chaque mouvement dans 1 page
         waitbar(c/360,h)
         c = c + 1;
        clear nomFichier saveAs X X1 X2 X3 X4
        clc
   end  
end
  
end
close(h) 
myicon = imread('landOcean.jpg');
h=msgbox('prêt! Merci d avoir attendu, vous pouvez récupérer vos résultats dans le fichier de résultats','Success','custom',myicon)
end