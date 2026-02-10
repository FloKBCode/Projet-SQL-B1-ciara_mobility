SELECT 
  vehicule.id_vehicule, 
  (vehicule.marque || ' ' || vehicule.modele) AS "Véhicule"
FROM vehicule 
LEFT JOIN location ON vehicule.id_vehicule = location.id_vehicule
WHERE location.id_location IS NULL;