function [parametres] = CalculParametres(segments)
%j'ai calcule pour chaque mouvement la vitesse maximal, la distance et la
%duration.
%les parametres sont calcules pour le doigt tout au long de l'axe X, car le
%mouvement est fait sur cet axe.
nFichiers = size(segments);
nFichiers = nFichiers(2);
mouvement = length(segments);
for i = 1 : nFichiers
    for j = 1 : mouvement
        
        mouv = segments{j,i};        

        mouvX = mouv(:,2);     
        t = mouv(:,1);
        v = diff(mouvX);
        vmax = max(abs(v));   %vitesse maximal
        duration = t(end) - t(1); %duration du mouvement
        distance = abs(mouvX(end) - mouvX(1)); %distance
        param = [vmax,duration,distance];
        param = num2cell(param);
        
        calcule{j,i}= param;
        
    end    
end

parametres = calcule;
end