SELECT
  (marque || ' ' || modele) AS "Véhicule",
  location.*
FROM vehicule
JOIN location ON vehicule.id_vehicule = location.id_vehicule;
