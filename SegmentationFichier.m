function[segmentation] = SegmentationFichier(allData,nSujets,nFichiers)

%segmentation fichier
fichier = 0; %variable qui indique le nombre de mouvement (20 pour chaque fichier)

for suj = 1 : nSujets

    for fich = 1 : nFichiers
 fichier = fichier + 1;       
seg = allData{fich,suj}; %je prende un par un les fichiers des donnees de trois sujets 

time1 = seg(1:end,1);  %je garde le temps
fingerX1 = seg(1:end,2); %je garde la position X du doigt

%je calcule la vitesse du doigt en x
v = diff(fingerX1);
%calcule de piques et ses positions 
absV = abs(v); 
[picos,locPicos] = findpeaks(absV,0.6,500,20);  
 
  timePlot1 = time1(locPicos);
% 
%    figure(fichier)
%     plot(timePlot1,picos,'r+')
%     hold on
%     plot(time1(1:(end-1)),absV,'b')
%     hold off

   %je cherche la difference entre piques pour faire la segmentation apres
 t= numel(locPicos);
% on initialise le tableau des vitesses
dif= zeros(t-1,1);
for i =1:t-1    
dif(i)= (locPicos(i+1)-locPicos(i)) ; %differences entre 2 positions
end

difMin = (min(dif))/2;  %je calcule la difference minime et la divise en 2 pour faire la segmentation


 for i = 1 : length(locPicos)  %je fait la segmentation

     %je prendre une intervale ou je suis sure que mon mouvement se trouve
   loc = locPicos(i);   
   avant = loc - difMin;
   arriere= loc + difMin;
   
   if(i==1) %pour le premier fichier
    %je mets cette intervale sur le foonction coupvitesse et je prendre que
    %le mouvement desire
     [debut,fin,vcoupe] = coupvitesse(absV(1:arriere));
     %je calcule les indice pour faire la segmentacion
      debut = 1 + debut;
      fin = 1 + fin;
     segmentation{i,fichier} = (seg(debut:fin,:));   
    
   else %pour tous les autres
     [debut,fin,vcoupe] = coupvitesse(absV(avant:arriere));
     debut = avant + debut;
      fin = avant + fin;
      segmentation{i,fichier} = (seg(debut:fin,:)) ;
   end
 end
 clear nPicos  movimientos locPicos picos  time1 fingerX1 Mov time1 timePlot seg loc avant arriere
    end
end
clc
end



















