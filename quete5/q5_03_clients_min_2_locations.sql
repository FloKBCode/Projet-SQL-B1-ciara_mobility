SELECT 
  client.id_client, (client.prenom || ' '|| client.nom) AS "Client"
  , COUNT(location.id_location) AS " Nombre de Location"
FROM client 
JOIN location ON client.id_client = location.id_client
GROUP BY client.id_client, client.nom, client.prenom
HAVING COUNT(location.id_location) >= 2
ORDER BY COUNT(location.id_location) DESC;
