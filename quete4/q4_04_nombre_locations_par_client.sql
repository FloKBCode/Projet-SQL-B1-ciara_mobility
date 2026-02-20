SELECT client.id_client, client.nom, client.prenom, COUNT(location.id_location) AS nombre_locations
FROM client
LEFT JOIN location ON client.id_client = location.id_client
GROUP BY client.id_client, client.nom, client.prenom
ORDER BY nombre_locations DESC;