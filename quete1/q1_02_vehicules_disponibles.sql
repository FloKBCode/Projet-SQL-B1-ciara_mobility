SELECT marque, modele, type_vehicule, autonomie_km, ville
FROM vehicule
WHERE etat = 'disponible'
ORDER BY ville, marque;