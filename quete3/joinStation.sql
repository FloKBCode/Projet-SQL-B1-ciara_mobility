SELECT
  d.nom || ' - ' || d.ville AS "Station de Départ",
  a.nom || ' - ' || a.ville AS "Station d'Arrivée"
FROM location
JOIN station AS d ON d.id_station = location.id_station_depart
JOIN station AS a ON a.id_station = location.id_station_arrivee;