SELECT ville, COUNT(*) AS nombre_vehicules
FROM vehicule
GROUP BY ville
ORDER BY nombre_vehicules DESC;