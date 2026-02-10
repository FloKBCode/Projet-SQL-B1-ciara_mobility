SELECT 
  ville AS Ville, 
  COUNT(*) AS "Nombre de Véhicule Disponible"
FROM vehicule
WHERE etat = 'disponible'
GROUP BY ville
ORDER BY "Nombre de Véhicule Disponible" DESC
LIMIT 1;
