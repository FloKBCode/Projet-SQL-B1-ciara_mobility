SELECT 
  (marque || ' ' || 
  modele) AS "Véhicule",
  autonomie_km AS "Autonomie disponible (km)"
FROM vehicule
WHERE etat = 'disponible'
ORDER BY autonomie_km DESC
LIMIT 3;
