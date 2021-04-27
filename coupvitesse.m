function [debut,fin,vcoupe] = coupvitesse(v)

%COUPEVITESSE coupe un profil de vitesse
% v = profil devitesse d'entree
% vcoupee = vitesse coupee
% dimensions du vecteur vitesse

%%
[r,~] = size(v);

%valeur max et indice ou v atteint son maximum
[vmax,imax] = max(v);

%seuil avec lequel on coup
seuil = vmax*5/100; %seuil de 10%

%coeur de l'argorithme
i=imax;
k=imax;

%on redescend du pic en revenant vers la gauche

while(v(i) > seuil && i>1)
    
    i=i-1;
end

%on redescend du pic en revenant vers la droit

while(v(k) > seuil && k<r)
    
    k=k+1;
end


debut = max(1,i);
fin = min(k,r);

vcoupe = v(debut:fin);

end
