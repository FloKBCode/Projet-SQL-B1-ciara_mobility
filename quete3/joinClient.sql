SELECT DISTINCT
 (prenom || ' ' || nom)as Client,
 location.*
FROM client   
JOIN location ON client.id_client = location.id_client;