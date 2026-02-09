-- ============================================
-- PROJET SQL B1 - cIAra Mobility
-- ============================================

-- Suppression des tables si elles existent déjà (pour pouvoir relancer le script)
DROP TABLE IF EXISTS location CASCADE;
DROP TABLE IF EXISTS client CASCADE;
DROP TABLE IF EXISTS vehicule CASCADE;
DROP TABLE IF EXISTS station CASCADE;

-- ============================================
-- CRÉATION DES TABLES
-- ============================================

-- Table STATION
CREATE TABLE station (
    id_station SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    ville VARCHAR(50) NOT NULL
);

-- Table VEHICULE
CREATE TABLE vehicule (
    id_vehicule SERIAL PRIMARY KEY,
    marque VARCHAR(50) NOT NULL,
    modele VARCHAR(50) NOT NULL,
    type_vehicule VARCHAR(20) NOT NULL,
    autonomie_km INTEGER NOT NULL,
    etat VARCHAR(20) NOT NULL,
    ville VARCHAR(50) NOT NULL
);

-- Table CLIENT
CREATE TABLE client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- Table LOCATION
CREATE TABLE location (
    id_location SERIAL PRIMARY KEY,
    date_debut DATE NOT NULL,
    date_fin DATE,
    id_client INTEGER NOT NULL,
    id_vehicule INTEGER NOT NULL,
    id_station_depart INTEGER NOT NULL,
    id_station_arrivee INTEGER,
    FOREIGN KEY (id_client) REFERENCES client(id_client),
    FOREIGN KEY (id_vehicule) REFERENCES vehicule(id_vehicule),
    FOREIGN KEY (id_station_depart) REFERENCES station(id_station),
    FOREIGN KEY (id_station_arrivee) REFERENCES station(id_station)
);

-- ============================================
-- INSERTION DES DONNÉES FICTIVES
-- ============================================

-- Insertion des STATIONS (15 stations dans 5 villes)
INSERT INTO station (nom, ville) VALUES
    -- Paris (5 stations)
    ('Station République', 'Paris'),
    ('Station Bastille', 'Paris'),
    ('Station Montparnasse', 'Paris'),
    ('Station Champs-Élysées', 'Paris'),
    ('Station Nation', 'Paris'),
    
    -- Lyon (3 stations)
    ('Station Part-Dieu', 'Lyon'),
    ('Station Bellecour', 'Lyon'),
    ('Station Vieux Lyon', 'Lyon'),
    
    -- Marseille (3 stations)
    ('Station Vieux-Port', 'Marseille'),
    ('Station Canebière', 'Marseille'),
    ('Station Prado', 'Marseille'),
    
    -- Toulouse (2 stations)
    ('Station Capitole', 'Toulouse'),
    ('Station Jean Jaurès', 'Toulouse'),
    
    -- Bordeaux (2 stations)
    ('Station Victoire', 'Bordeaux'),
    ('Station Quinconces', 'Bordeaux');

-- Insertion des VÉHICULES (30 véhicules variés)
INSERT INTO vehicule (marque, modele, type_vehicule, autonomie_km, etat, ville) VALUES
    -- Voitures électriques
    ('Tesla', 'Model 3', 'Voiture', 580, 'disponible', 'Paris'),
    ('Renault', 'Zoe', 'Voiture', 395, 'disponible', 'Paris'),
    ('Peugeot', 'e-208', 'Voiture', 340, 'disponible', 'Paris'),
    ('Nissan', 'Leaf', 'Voiture', 270, 'en_location', 'Paris'),
    ('BMW', 'i3', 'Voiture', 310, 'disponible', 'Paris'),
    ('Volkswagen', 'ID.3', 'Voiture', 420, 'disponible', 'Lyon'),
    ('Hyundai', 'Kona Electric', 'Voiture', 484, 'disponible', 'Lyon'),
    ('Fiat', '500e', 'Voiture', 320, 'en_location', 'Lyon'),
    ('Tesla', 'Model Y', 'Voiture', 533, 'disponible', 'Marseille'),
    ('Renault', 'Megane E-Tech', 'Voiture', 450, 'disponible', 'Marseille'),
    ('Peugeot', 'e-2008', 'Voiture', 340, 'maintenance', 'Marseille'),
    ('Audi', 'e-tron', 'Voiture', 436, 'disponible', 'Toulouse'),
    ('Kia', 'EV6', 'Voiture', 528, 'disponible', 'Toulouse'),
    ('Opel', 'Corsa-e', 'Voiture', 337, 'disponible', 'Bordeaux'),
    
    -- Scooters électriques
    ('Yamaha', 'Neo', 'Scooter', 68, 'disponible', 'Paris'),
    ('NIU', 'NQi GTS', 'Scooter', 80, 'disponible', 'Paris'),
    ('Super Soco', 'CPx', 'Scooter', 75, 'en_location', 'Paris'),
    ('Peugeot', 'e-Ludix', 'Scooter', 60, 'disponible', 'Lyon'),
    ('Vespa', 'Elettrica', 'Scooter', 100, 'disponible', 'Lyon'),
    ('BMW', 'CE 04', 'Scooter', 130, 'disponible', 'Marseille'),
    ('Silence', 'S01', 'Scooter', 93, 'disponible', 'Toulouse'),
    
    -- Trottinettes électriques
    ('Xiaomi', 'Pro 2', 'Trottinette', 45, 'disponible', 'Paris'),
    ('Segway', 'Ninebot Max', 'Trottinette', 65, 'disponible', 'Paris'),
    ('Dualtron', 'Thunder', 'Trottinette', 85, 'disponible', 'Lyon'),
    ('Kaabo', 'Mantis', 'Trottinette', 70, 'en_location', 'Marseille'),
    
    -- Vélos électriques
    ('Decathlon', 'Elops 920E', 'Vélo', 90, 'disponible', 'Paris'),
    ('Giant', 'Quick-E+', 'Vélo', 110, 'disponible', 'Lyon'),
    ('Trek', 'Verve+', 'Vélo', 80, 'disponible', 'Marseille'),
    ('Specialized', 'Turbo Vado', 'Vélo', 130, 'disponible', 'Toulouse'),
    ('Cannondale', 'Canvas Neo', 'Vélo', 100, 'disponible', 'Bordeaux');

-- Insertion des CLIENTS (20 clients)
INSERT INTO client (nom, prenom, email) VALUES
    ('Dupont', 'Marie', 'marie.dupont@email.com'),
    ('Martin', 'Lucas', 'lucas.martin@email.com'),
    ('Bernard', 'Sophie', 'sophie.bernard@email.com'),
    ('Dubois', 'Thomas', 'thomas.dubois@email.com'),
    ('Moreau', 'Emma', 'emma.moreau@email.com'),
    ('Laurent', 'Hugo', 'hugo.laurent@email.com'),
    ('Simon', 'Léa', 'lea.simon@email.com'),
    ('Michel', 'Nathan', 'nathan.michel@email.com'),
    ('Lefebvre', 'Chloé', 'chloe.lefebvre@email.com'),
    ('Garcia', 'Alexandre', 'alexandre.garcia@email.com'),
    ('Rodriguez', 'Camille', 'camille.rodriguez@email.com'),
    ('Martinez', 'Louis', 'louis.martinez@email.com'),
    ('Sanchez', 'Manon', 'manon.sanchez@email.com'),
    ('Lopez', 'Arthur', 'arthur.lopez@email.com'),
    ('Gonzalez', 'Clara', 'clara.gonzalez@email.com'),
    ('Perez', 'Gabriel', 'gabriel.perez@email.com'),
    ('Robert', 'Alice', 'alice.robert@email.com'),
    ('Richard', 'Jules', 'jules.richard@email.com'),
    ('Petit', 'Inès', 'ines.petit@email.com'),
    ('Durand', 'Adam', 'adam.durand@email.com');

-- Insertion des LOCATIONS (25 locations variées)
INSERT INTO location (date_debut, date_fin, id_client, id_vehicule, id_station_depart, id_station_arrivee) VALUES
    -- Locations terminées
    ('2024-01-15', '2024-01-15', 1, 1, 1, 2),
    ('2024-01-20', '2024-01-22', 2, 3, 1, 3),
    ('2024-02-01', '2024-02-03', 3, 6, 6, 7),
    ('2024-02-10', '2024-02-10', 1, 15, 2, 4),
    ('2024-02-14', '2024-02-14', 4, 22, 3, 1),
    ('2024-03-01', '2024-03-05', 5, 2, 1, 5),
    ('2024-03-10', '2024-03-12', 2, 7, 6, 8),
    ('2024-03-15', '2024-03-15', 6, 18, 7, 6),
    ('2024-04-01', '2024-04-03', 7, 9, 9, 10),
    ('2024-04-10', '2024-04-11', 1, 5, 2, 3),
    ('2024-04-20', '2024-04-20', 8, 26, 1, 2),
    ('2024-05-01', '2024-05-04', 9, 12, 12, 13),
    ('2024-05-15', '2024-05-16', 2, 14, 14, 15),
    ('2024-06-01', '2024-06-02', 10, 27, 6, 7),
    ('2024-06-10', '2024-06-10', 11, 23, 1, 4),
    
    -- Locations en cours (sans date_fin ni station d'arrivée)
    ('2025-02-08', NULL, 12, 4, 1, NULL),
    ('2025-02-08', NULL, 13, 8, 7, NULL),
    ('2025-02-08', NULL, 14, 17, 2, NULL),
    ('2025-02-09', NULL, 15, 25, 10, NULL),
    
    -- Locations à venir (dates futures)
    ('2025-02-12', '2025-02-13', 16, 10, 9, 11),
    ('2025-02-14', '2025-02-15', 17, 13, 12, 13),
    ('2025-02-15', '2025-02-15', 18, 19, 6, 8),
    ('2025-02-16', '2025-02-18', 19, 21, 9, 10),
    ('2025-02-18', '2025-02-20', 20, 28, 11, 9),
    ('2025-02-20', '2025-02-21', 1, 29, 14, 15);

-- ============================================
-- VÉRIFICATION DES DONNÉES
-- ============================================

-- Affichage du nombre d'enregistrements par table
SELECT 'Stations' as table_name, COUNT(*) as nombre FROM station
UNION ALL
SELECT 'Véhicules', COUNT(*) FROM vehicule
UNION ALL
SELECT 'Clients', COUNT(*) FROM client
UNION ALL
SELECT 'Locations', COUNT(*) FROM location;

-- Message de confirmation
SELECT 'Base de données cIAra Mobility créée avec succès !' as status;
