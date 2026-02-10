# 📘 Projet SQL B1 - cIAra Mobility

**Membres du binôme :**
- Florence KORE-BELLE (Bachelor 1 Informatique)
- Sarah BOUHADRA (Bachelor 1 Cybersécurité)

---

## 📋 Sommaire

1. [Contexte du projet](#contexte)
2. [Structure de la base de données](#structure-bdd)
3. [Rapport d'Analyse Technique](#rapport-analyse)
   - [A. Organisation du travail en binôme](#organisation)
   - [B. Analyse du Modèle de Données](#analyse-modele)
   - [C. Choix Techniques et Syntaxe SQL](#choix-techniques)
   - [D. Difficultés rencontrées et Solutions](#difficultes)

---

## <a name="contexte"></a>🏢 Contexte du projet

L'entreprise **cIAra Mobility** est une société spécialisée dans la location de véhicules électriques partagés (voitures, scooters, trottinettes et vélos électriques) dans plusieurs grandes villes françaises.

Notre mission en tant que techniciennes data juniors consiste à interroger la base de données de l'entreprise pour répondre à des besoins métier concrets à travers **5 quêtes SQL** progressives.

---

## <a name="structure-bdd"></a>🗄️ Structure de la base de données

### Vue d'ensemble

La base de données contient **4 tables principales** :

| Table | Description | Nombre d'enregistrements |
|-------|-------------|--------------------------|
| `station` | Stations de location/restitution | 15 stations |
| `vehicule` | Flotte de véhicules électriques | 30 véhicules |
| `client` | Clients inscrits | 20 clients |
| `location` | Historique des locations | 25 locations |

### Schéma des tables

#### Table `station`
```sql
CREATE TABLE station (
    id_station SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    ville VARCHAR(50) NOT NULL
);
```
**Villes couvertes :** Paris, Lyon, Marseille, Toulouse, Bordeaux

#### Table `vehicule`
```sql
CREATE TABLE vehicule (
    id_vehicule SERIAL PRIMARY KEY,
    marque VARCHAR(50) NOT NULL,
    modele VARCHAR(50) NOT NULL,
    type_vehicule VARCHAR(20) NOT NULL,
    autonomie_km INTEGER NOT NULL,
    etat VARCHAR(20) NOT NULL,
    ville VARCHAR(50) NOT NULL
);
```
**Types de véhicules :** Voiture, Scooter, Trottinette, Vélo  
**États possibles :** disponible, en_location, maintenance

#### Table `client`
```sql
CREATE TABLE client (
    id_client SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);
```

#### Table `location`
```sql
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
```

### Relations entre les tables

```
┌─────────┐
│ client  │
└────┬────┘
     │
     │ id_client (FK)
     │
     ▼
┌──────────┐      id_vehicule (FK)     ┌──────────┐
│ location │◄─────────────────────────│ vehicule │
└────┬─────┘                          └──────────┘
     │
     │ id_station_depart (FK)
     │ id_station_arrivee (FK)
     │
     ▼
┌─────────┐
│ station │
└─────────┘
```

---

## <a name="rapport-analyse"></a>📊 Rapport d'Analyse Technique

### <a name="organisation"></a>A. Organisation du travail en binôme

#### Méthodologie de travail

Nous avons adopté une approche de **travail en autonomie avec entraide ponctuelle** :

- **Travail individuel** : Chacune a réalisé ses quêtes de manière autonome
- **Entraide sur demande** : Nous nous sommes mutuellement aidées lorsque l'une rencontrait une erreur ou avait une question
- **Pas de code review formelle** : Validation informelle lors des discussions

**Répartition des tâches :**
- **Sarah BOUHADRA** : Quêtes 1, 2 et 4 (requêtes de base, filtres, tris, agrégations simples)
- **Florence KORE-BELLE** : Quêtes 3 et 5 (jointures complexes, LEFT JOIN, HAVING) + création de la base de données

#### Gestion de version (Git/GitHub)

**Workflow Git :**
- **Fréquence des commits** : À la fin de chaque quête terminée
- **Nommage des commits** : Format standardisé "réalisation de la quête X"
- **Gestion des branches** : Travail directement sur la branche `main`
- **Synchronisation** : Commits réguliers après validation des requêtes

**Statistiques Git :**
```
Total : 7 commits
- Florence : 4 commits (BDD + quête 3 + quête 5 + création structure)
- Sarah : 3 commits (quête 1 + quête 2 + quête 4)
```

**Historique des commits :**
1. Initial commit
2. Initialisation et début quête 3 (Florence)
3. Réalisation de la quête 1 (Sarah)
4. Réalisation de la quête 2 (Sarah)
5. Réalisation de la quête 3 (Florence)
6. Réalisation de la quête 4 (Sarah)
7. Réalisation de la quête 5 (Florence)

#### Environnement de travail

**Configuration technique :**
- **SGBD** : PostgreSQL 18
- **Interfaces** : 
  - pgAdmin 4 (interface graphique principale)
  - SQL Tools (extension VS Code)
- **Éditeur** : Visual Studio Code
- **Système d'exploitation** : Windows
- **Communication** : 
  - Présentiel (sessions de travail ensemble)
  - Discord (échanges à distance)

---

### <a name="analyse-modele"></a>B. Analyse du Modèle de Données (MCD)

#### Structure de la base

La base de données suit une **architecture relationnelle normalisée** avec 4 tables interconnectées :

**1. Tables de référence** (données relativement stables) :
- **`station`** : 15 points de retrait/dépôt répartis dans 5 villes (Paris, Lyon, Marseille, Toulouse, Bordeaux)
- **`vehicule`** : 30 véhicules de 4 types différents (Voiture, Scooter, Trottinette, Vélo)
- **`client`** : 20 clients enregistrés avec leurs informations de contact

**2. Table transactionnelle** (données évolutives) :
- **`location`** : Enregistre chaque transaction de location avec ses dates, véhicule, client et stations

#### Relations entre les tables

**Clés primaires :**
- Chaque table possède une clé primaire auto-incrémentée (`id_*`) générée par `SERIAL`
- Garantit l'unicité de chaque enregistrement

**Clés étrangères dans la table `location` :**

La table `location` possède **plusieurs clés étrangères** car elle centralise les informations provenant de différentes tables pour constituer une transaction complète :

1. **`id_client`** → `client.id_client` 
   - *Répond à la question* : Quel client a effectué cette location ?
   
2. **`id_vehicule`** → `vehicule.id_vehicule` 
   - *Répond à la question* : Quel véhicule a été loué ?
   
3. **`id_station_depart`** → `station.id_station` 
   - *Répond à la question* : Où le véhicule a-t-il été récupéré ?
   
4. **`id_station_arrivee`** → `station.id_station` *(peut être NULL)*
   - *Répond à la question* : Où le véhicule a-t-il été déposé ?
   - **Valeur NULL** : Indique que la location est **toujours en cours** et que le véhicule n'a pas encore été restitué dans une station

**Cardinalités :**
- Un client peut avoir **plusieurs locations** (relation 1:N)
- Un véhicule peut être loué **plusieurs fois** (relation 1:N)
- Une station peut être **point de départ ou d'arrivée** pour plusieurs locations (relation 1:N)

#### Pertinence métier

Cette structuration répond parfaitement aux besoins de cIAra Mobility :

**1. Gestion de flotte optimisée :**
- Suivi en temps réel de l'état de chaque véhicule (disponible, en_location, maintenance)
- Répartition géographique pour optimiser la disponibilité par ville
- Données d'autonomie pour informer les clients et planifier les recharges

**2. Suivi complet des locations :**
- Historique exhaustif des transactions
- Traçabilité client-véhicule pour chaque location
- Gestion des trajets inter-stations (permettant le libre-service)
- Distinction entre locations terminées et en cours (via `date_fin` et `id_station_arrivee`)

**3. Analyse métier et reporting :**
- Identification des véhicules les plus/moins loués
- Analyse de la performance par ville
- Suivi du comportement et de la fidélité client
- Détection des véhicules nécessitant une maintenance

**4. Évolutivité :**
- Structure normalisée évitant la redondance des données
- Facilité d'ajout de nouvelles villes ou types de véhicules
- Possibilité d'extensions futures (tarifs, abonnements, incidents, etc.)

---

### <a name="choix-techniques"></a>C. Choix Techniques et Syntaxe SQL

#### Stratégie de construction des requêtes

Nous avons adopté une **approche progressive et méthodique** pour construire nos requêtes SQL :

**Étapes de construction :**
1. **Analyse du besoin métier** : Comprendre exactement ce qui est demandé
2. **Identification des tables** : Déterminer quelles tables contiennent les informations nécessaires
3. **Requête de base** : Commencer par un `SELECT * FROM table` simple
4. **Ajout des filtres** : Utiliser `WHERE` pour filtrer les données
5. **Jointures si nécessaire** : Ajouter les `JOIN` pour relier plusieurs tables
6. **Agrégations et groupements** : Utiliser `GROUP BY` et fonctions d'agrégation (`COUNT`, `AVG`, etc.)
7. **Tri et limitation** : Ajouter `ORDER BY` et `LIMIT` pour le résultat final
8. **Tests et validation** : Vérifier que les résultats correspondent au besoin

#### Justification des commandes SQL utilisées

##### 1. Types de JOIN utilisés

**INNER JOIN (Quête 3)** :

Nous avons utilisé `INNER JOIN` pour **relier les locations aux clients et véhicules** car nous voulions uniquement afficher les locations qui ont **effectivement** un client **ET** un véhicule associés.

```sql
-- Exemple : Afficher les locations avec les informations du client
SELECT 
    DISTINCT (prenom || ' ' || nom) AS Client,
    location.*
FROM client   
JOIN location ON client.id_client = location.id_client;
```

**Pourquoi INNER JOIN et pas LEFT JOIN ?**
- Toutes les locations ont obligatoirement un client (contrainte NOT NULL)
- Nous voulons seulement les clients **qui ont loué**, pas tous les clients
- `INNER JOIN` garantit qu'on ne récupère que les associations existantes

**LEFT JOIN (Quête 5)** :

Pour trouver les **véhicules jamais loués**, nous avons utilisé `LEFT JOIN` car nous voulions **TOUS les véhicules**, même ceux qui n'ont **aucune location** correspondante.

```sql
-- Trouver les véhicules qui n'ont jamais été loués
SELECT 
    vehicule.id_vehicule, 
    (vehicule.marque || ' ' || vehicule.modele) AS "Véhicule"
FROM vehicule 
LEFT JOIN location ON vehicule.id_vehicule = location.id_vehicule
WHERE location.id_location IS NULL;
```

**Fonctionnement du LEFT JOIN ici :**
1. `LEFT JOIN` récupère **tous les véhicules** (table de gauche)
2. Pour chaque véhicule, cherche s'il existe une location associée
3. Si aucune location n'existe, les colonnes de `location` sont remplies avec `NULL`
4. `WHERE location.id_location IS NULL` filtre uniquement les véhicules où **aucune jointure n'a été trouvée**

**Différence critique :**
- `INNER JOIN` → Seulement ce qui existe dans **les deux tables**
- `LEFT JOIN` → Tout ce qui existe dans la **table de gauche**, même sans correspondance dans la droite

##### 2. Utilisation d'alias de tables

**Problème rencontré (Quête 3)** :

Pour afficher les **stations de départ ET d'arrivée** d'une location, nous devions joindre la table `station` **deux fois** à la table `location`.

**Solution avec alias :**

```sql
SELECT
    d.nom || ' - ' || d.ville AS "Station de Départ",
    a.nom || ' - ' || a.ville AS "Station d'Arrivée"
FROM location
JOIN station AS d ON d.id_station = location.id_station_depart
JOIN station AS a ON a.id_station = location.id_station_arrivee;
```

**Explication :**
- `d` et `a` sont des **alias différents** pour la même table `station`
- `d` (départ) se joint sur `id_station_depart`
- `a` (arrivée) se joint sur `id_station_arrivee`
- Sans les alias, PostgreSQL ne saurait pas quelle station référencer

**Pourquoi c'est nécessaire :**
- Une même table peut apparaître plusieurs fois dans une requête
- Les alias permettent de **différencier** chaque utilisation de la table
- Rend le code plus **lisible** (`d.nom` vs `a.nom` au lieu de répéter `station.nom`)

##### 3. GROUP BY et Fonctions d'agrégation

**GROUP BY (Quête 4/5)** :

Utilisé pour **regrouper les données** et calculer des statistiques par catégorie.

```sql
-- Nombre de véhicules disponibles par ville
SELECT 
    ville AS Ville, 
    COUNT(*) AS "Nombre de Véhicule Disponible"
FROM vehicule
WHERE etat = 'disponible'
GROUP BY ville
ORDER BY "Nombre de Véhicule Disponible" DESC
LIMIT 1;
```

**Fonctionnement :**
1. `WHERE` filtre d'abord les véhicules disponibles
2. `GROUP BY ville` regroupe tous les véhicules de la même ville ensemble
3. `COUNT(*)` compte le nombre de véhicules dans chaque groupe
4. `ORDER BY ... DESC` trie les villes par nombre de véhicules (du plus grand au plus petit)
5. `LIMIT 1` ne garde que la ville avec le plus de véhicules

**HAVING (Quête 5)** :

Contrairement à `WHERE` qui filtre les **lignes individuelles**, `HAVING` filtre les **groupes** après agrégation.

```sql
-- Clients ayant effectué au moins 2 locations
SELECT 
    client.id_client, 
    (client.prenom || ' ' || client.nom) AS "Client",
    COUNT(location.id_location) AS "Nombre de Location"
FROM client 
JOIN location ON client.id_client = location.id_client
GROUP BY client.id_client, client.nom, client.prenom
HAVING COUNT(location.id_location) >= 2
ORDER BY COUNT(location.id_location) DESC;
```

**Différence WHERE vs HAVING :**

| Critère | WHERE | HAVING |
|---------|-------|--------|
| **Moment d'application** | AVANT le regroupement | APRÈS le regroupement |
| **Filtre sur** | Lignes individuelles | Groupes agrégés |
| **Peut utiliser fonctions d'agrégation** | ❌ NON | ✅ OUI |
| **Position dans la requête** | Avant GROUP BY | Après GROUP BY |

**Exemple concret :**
```sql
-- ❌ ERREUR : WHERE ne peut pas filtrer sur COUNT
SELECT client.nom, COUNT(*) 
FROM location
JOIN client ON location.id_client = client.id_client
WHERE COUNT(*) >= 2  -- ❌ Erreur: "aggregate functions are not allowed in WHERE"
GROUP BY client.nom;

-- ✅ CORRECT : HAVING filtre après le regroupement
SELECT client.nom, COUNT(*) 
FROM location
JOIN client ON location.id_client = client.id_client
GROUP BY client.nom
HAVING COUNT(*) >= 2;  -- ✅ Fonctionne correctement
```

**Ordre d'exécution SQL :**
1. `FROM` / `JOIN` → Récupération et jonction des tables
2. `WHERE` → Filtrage des lignes
3. `GROUP BY` → Regroupement
4. `HAVING` → Filtrage des groupes
5. `SELECT` → Sélection des colonnes
6. `ORDER BY` → Tri
7. `LIMIT` → Limitation du nombre de résultats

##### 4. Fonctions de concaténation et alias de colonnes

**Concaténation avec l'opérateur `||` :**

PostgreSQL utilise `||` pour concaténer (assembler) des chaînes de caractères :

```sql
-- Afficher le nom complet du client
SELECT (prenom || ' ' || nom) AS Client
FROM client;

-- Afficher le véhicule avec marque et modèle
SELECT (marque || ' ' || modele) AS "Véhicule"
FROM vehicule;

-- Station avec nom et ville
SELECT (nom || ' - ' || ville) AS "Station de Départ"
FROM station;
```

**Alias de colonnes avec `AS` :**
- Renomme les colonnes dans le résultat
- Rend les résultats plus **lisibles** pour l'utilisateur
- **Guillemets nécessaires** si l'alias contient des espaces ou accents : `AS "Véhicule"` vs `AS Client`

##### 5. Tri et limitation des résultats

**ORDER BY :**

```sql
-- Tri décroissant par autonomie (du plus grand au plus petit)
SELECT (marque || ' ' || modele) AS "Véhicule",
       autonomie_km AS "Autonomie disponible (km)"
FROM vehicule
WHERE etat = 'disponible'
ORDER BY autonomie_km DESC;
```

**LIMIT :**

```sql
-- Ne garder que les 3 premiers résultats
LIMIT 3;

-- Ne garder que le premier résultat (ville avec le plus de véhicules)
LIMIT 1;
```

**Combinaison ORDER BY + LIMIT** :
- Très utile pour obtenir des "TOP N" (top 3, top 10, etc.)
- L'ordre du tri détermine quels résultats seront gardés

#### Logique de filtrage et traduction des besoins métier

**Besoin métier 1** : "Trouver les 3 véhicules disponibles avec la plus grande autonomie"

**Traduction SQL** :
```sql
SELECT (marque || ' ' || modele) AS "Véhicule",
       autonomie_km AS "Autonomie disponible (km)"
FROM vehicule
WHERE etat = 'disponible'      -- Condition 1 : seulement les disponibles
ORDER BY autonomie_km DESC     -- Tri : du plus grand au plus petit
LIMIT 3;                       -- Ne garder que les 3 premiers
```

**Raisonnement :**
1. `FROM vehicule` → On cherche dans la table des véhicules
2. `WHERE etat = 'disponible'` → Exclut les véhicules en location ou en maintenance
3. `ORDER BY autonomie_km DESC` → Tri décroissant pour avoir les plus grandes autonomies en premier
4. `LIMIT 3` → Ne conserve que les 3 meilleurs

---

**Besoin métier 2** : "Trouver la ville avec le plus de véhicules disponibles"

**Traduction SQL** :
```sql
SELECT ville AS Ville, 
       COUNT(*) AS "Nombre de Véhicule Disponible"
FROM vehicule
WHERE etat = 'disponible'                       -- Filtrage : seulement les disponibles
GROUP BY ville                                  -- Regroupement par ville
ORDER BY "Nombre de Véhicule Disponible" DESC  -- Tri : ville avec le plus de véhicules en premier
LIMIT 1;                                        -- Ne garder que la première ville
```

**Raisonnement :**
1. Filtrer d'abord les véhicules disponibles (`WHERE`)
2. Regrouper par ville pour compter (`GROUP BY`)
3. Trier par nombre de véhicules décroissant (`ORDER BY ... DESC`)
4. Ne garder que la ville avec le maximum (`LIMIT 1`)

---

**Besoin métier 3** : "Trouver les clients ayant effectué au moins 2 locations"

**Traduction SQL** :
```sql
SELECT client.id_client, 
       (client.prenom || ' ' || client.nom) AS "Client",
       COUNT(location.id_location) AS "Nombre de Location"
FROM client 
JOIN location ON client.id_client = location.id_client
GROUP BY client.id_client, client.nom, client.prenom
HAVING COUNT(location.id_location) >= 2        -- Filtrage sur le nombre de locations
ORDER BY COUNT(location.id_location) DESC;
```

**Raisonnement :**
1. Joindre les tables `client` et `location` pour avoir les locations de chaque client
2. Regrouper par client (`GROUP BY client.id_client, ...`)
3. Compter les locations pour chaque client (`COUNT(location.id_location)`)
4. Filtrer pour ne garder que ceux avec ≥ 2 locations (`HAVING COUNT(...) >= 2`)
5. Trier par nombre de locations décroissant pour voir les plus actifs en premier

**Note importante** : `GROUP BY` doit inclure **toutes les colonnes non agrégées** du `SELECT` :
- `client.id_client` ✅
- `client.nom` ✅
- `client.prenom` ✅
- `COUNT(...)` ❌ (fonction d'agrégation, pas dans GROUP BY)

---

### <a name="difficultes"></a>D. Difficultés rencontrées et Solutions

#### Difficulté 1 : Confusion WHERE vs HAVING

**Problème rencontré :**

Lors de la Quête 5, nous avons initialement essayé de filtrer les clients ayant au moins 2 locations en utilisant `WHERE` :

```sql
SELECT client.nom, COUNT(*) 
FROM location 
JOIN client ON location.id_client = client.id_client
WHERE COUNT(*) >= 2  -- ❌ ERREUR
GROUP BY client.nom;
```

**Message d'erreur obtenu :**
```
ERROR: aggregate functions are not allowed in WHERE
```

**Solution trouvée :**

Après recherche dans la documentation PostgreSQL et sur Stack Overflow, nous avons compris la différence fondamentale :

- **`WHERE`** filtre les lignes **AVANT** le regroupement (sur les données brutes)
- **`HAVING`** filtre les groupes **APRÈS** le regroupement (sur les résultats agrégés)

**Requête correcte :**
```sql
SELECT client.nom, COUNT(*) 
FROM location 
JOIN client ON location.id_client = client.id_client
GROUP BY client.nom
HAVING COUNT(*) >= 2;  -- ✅ CORRECT
```

**Leçon retenue :**

Toujours utiliser `HAVING` pour filtrer sur des **fonctions d'agrégation** (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`).

**Règle mnémotechnique :**
- **WHERE** = filtre les **lignes** (What data to include)
- **HAVING** = filtre les **groupes** (How many in each group)

---

#### Difficulté 2 : Jointure double sur la même table (stations départ/arrivée)

**Problème rencontré :**

Pour afficher à la fois la **station de départ** ET la **station d'arrivée** d'une location, nous étions bloquées. Notre première tentative :

```sql
SELECT l.id_location, s.nom
FROM location l
JOIN station s ON l.id_station_depart = s.id_station
-- ❓ Comment ajouter la station d'arrivée sans écraser la station de départ ?
```

Le problème : si on fait un deuxième `JOIN station`, PostgreSQL ne sait pas si on parle de la station de départ ou d'arrivée.

**Solution trouvée :**

Utiliser des **alias de table** pour joindre la même table **deux fois** avec des noms différents :

```sql
SELECT 
    l.id_location,
    d.nom || ' - ' || d.ville AS "Station de Départ",
    a.nom || ' - ' || a.ville AS "Station d'Arrivée"
FROM location l
JOIN station AS d ON l.id_station_depart = d.id_station   -- d = départ
LEFT JOIN station AS a ON l.id_station_arrivee = a.id_station  -- a = arrivée
```

**Explication technique :**
- `d` et `a` sont des **alias** (surnoms) pour la table `station`
- `d.nom` fait référence à la station de départ
- `a.nom` fait référence à la station d'arrivée
- Les alias permettent de **différencier** les deux jointures sur la même table

**Amélioration apportée :**

Nous avons aussi utilisé `LEFT JOIN` pour la station d'arrivée car certaines locations sont encore **en cours** (pas encore de station d'arrivée) :

```sql
JOIN station AS d ON l.id_station_depart = d.id_station      -- INNER JOIN : toujours une station de départ
LEFT JOIN station AS a ON l.id_station_arrivee = a.id_station -- LEFT JOIN : peut être NULL si en cours
```

**Leçon retenue :**

Une table peut être jointe **plusieurs fois** dans la même requête en utilisant des alias. C'est particulièrement utile pour les relations **auto-référentielles** ou les **relations multiples** vers la même table.

---

#### Difficulté 3 : Différences de syntaxe entre PostgreSQL et SQLite

**Problème rencontré :**

Pendant nos tests, certaines requêtes qui fonctionnaient en SQLite (que nous avions vu dans des tutoriels) ne fonctionnaient pas en PostgreSQL.

**Exemples de différences rencontrées :**

1. **Guillemets pour les alias** :
   - SQLite : Accepte les guillemets simples ou doubles
   - PostgreSQL : Préfère les guillemets doubles `"Nom Colonne"` pour les identifiants

2. **Fonction de concaténation** :
   - SQLite : Peut utiliser `||` ou `CONCAT()`
   - PostgreSQL : Utilise principalement `||`

3. **AUTO_INCREMENT vs SERIAL** :
   - SQLite : `id INTEGER PRIMARY KEY AUTOINCREMENT`
   - PostgreSQL : `id SERIAL PRIMARY KEY`

**Solution trouvée :**

- Toujours se référer à la **documentation officielle** de PostgreSQL
- Tester les requêtes directement dans **pgAdmin 4**
- Comprendre que chaque SGBD a ses **spécificités**

**Leçon retenue :**

Le SQL est un langage standardisé, mais chaque SGBD (PostgreSQL, MySQL, SQLite, SQL Server) a ses **particularités syntaxiques**. Il faut toujours vérifier la documentation du SGBD utilisé.

---

#### Difficulté 4 : Ordre des clauses dans une requête SQL

**Problème rencontré :**

Au début, nous mettions parfois les clauses dans le mauvais ordre et obtenions des erreurs :

```sql
-- ❌ ERREUR : ORDER BY avant GROUP BY
SELECT ville, COUNT(*) 
FROM vehicule
ORDER BY COUNT(*) DESC
GROUP BY ville;  -- Erreur de syntaxe
```

**Solution trouvée :**

Apprendre l'**ordre obligatoire** des clauses SQL :

```sql
-- ✅ ORDRE CORRECT
SELECT     -- 1. Sélection des colonnes
FROM       -- 2. Table source
JOIN       -- 3. Jointures (si nécessaire)
WHERE      -- 4. Filtrage des lignes
GROUP BY   -- 5. Regroupement
HAVING     -- 6. Filtrage des groupes
ORDER BY   -- 7. Tri
LIMIT      -- 8. Limitation du nombre de résultats
```


**Leçon retenue :**

L'ordre des clauses SQL est **strictement défini** et ne peut pas être modifié. Comprendre cet ordre aide à éviter les erreurs de syntaxe.

---

#### Difficulté 5 : Installation et configuration de PostgreSQL

**Problème rencontré :**

L'installation de PostgreSQL sur Windows a présenté quelques défis :
- Configuration du mot de passe superutilisateur
- Configuration du port (5432 par défaut)
- Connexion à pgAdmin 4 la première fois

**Solution trouvée :**

- Suivre attentivement l'assistant d'installation de PostgreSQL
- Noter le mot de passe du superutilisateur (`postgres`)
- Vérifier que le service PostgreSQL est bien démarré dans les services Windows
- Utiliser pgAdmin 4 pour créer une nouvelle base de données
- Tester la connexion avec une requête simple : `SELECT version();`

**Leçon retenue :**

L'installation d'un SGBD nécessite de bien **noter les informations de connexion** (utilisateur, mot de passe, port) et de vérifier que le **service est actif** avant de pouvoir l'utiliser.

---

#### Difficulté 6 : Comprendre les messages d'erreur PostgreSQL

**Problème rencontré :**

Au début, les messages d'erreur de PostgreSQL étaient difficiles à comprendre et ne nous aidaient pas immédiatement à trouver la solution.

**Exemples de messages rencontrés :**

```sql
-- Erreur : colonne ambiguë
ERROR: column reference "id_station" is ambiguous
LINE 1: SELECT id_station, nom FROM location JOIN station...

-- Erreur : fonction d'agrégation dans WHERE
ERROR: aggregate functions are not allowed in WHERE

-- Erreur : colonne absente du GROUP BY
ERROR: column "client.nom" must appear in the GROUP BY clause or be used in an aggregate function
```

**Solution trouvée :**

- **Lire attentivement** le message d'erreur
- **Identifier la ligne** où se trouve l'erreur (`LINE 1:`)
- **Rechercher le message** sur Google ou Stack Overflow avec le mot-clé "PostgreSQL"
- **Comprendre** le concept sous-jacent (ambiguïté, agrégation, groupement)

**Stratégie adoptée :**

1. Lire le message d'erreur complètement
2. Identifier le type d'erreur (syntaxe, logique, ambiguïté)
3. Chercher dans la documentation ou en ligne
4. Tester des corrections progressives
5. Comprendre **pourquoi** c'était une erreur (pas juste copier la solution)

**Leçon retenue :**

Les messages d'erreur sont des **indices précieux** pour corriger le code. Prendre le temps de les comprendre aide à progresser et à éviter de refaire les mêmes erreurs.

---

## 📁 Organisation du dépôt

```
Projet-SQL-B1-ciara_mobility/
├── README.md
├── BDD/
│   └── 01_creation_base_donnees.sql
├── quete1/
│   ├── q1_01_tous_les_clients.sql
│   ├── q1_02_vehicules_disponibles.sql
│   ├── q1_03_voitures_electriques.sql
│   ├── q1_04_stations_paris.sql
│   └── q1_05_locations_en_cours.sql
├── quete2/
│   ├── q2_01_vehicules_par_autonomie.sql
│   ├── q2_02_clients_ordre_alphabetique.sql
│   ├── q2_03_vehicules_grande_autonomie.sql
│   ├── q2_04_voitures_ou_scooters_paris.sql
│   └── q2_05_locations_fevrier_2024.sql
├── quete3/
│   ├── q3_01_locations_avec_client.sql
│   ├── q3_02_locations_avec_vehicule.sql
│   └── q3_03_stations_depart_arrivee.sql
├── quete4/
│   ├── q4_01_nombre_total_vehicules.sql
│   ├── q4_02_nombre_vehicules_par_type.sql
│   ├── q4_03_autonomie_moyenne_par_type.sql
│   ├── q4_04_nombre_vehicules_par_ville.sql
│   ├── q4_05_nombre_locations_par_client.sql
│   └── q4_06_etat_vehicules_repartition.sql
└── quete5/
    ├── q5_01_top3_autonomie_disponible.sql
    ├── q5_02_ville_plus_vehicules_disponibles.sql
    ├── q5_03_clients_min_2_locations.sql
    └── q5_04_vehicules_jamais_loues.sql

```
---

## 🎯 Compétences développées

Au cours de ce projet, nous avons développé les compétences techniques suivantes :

### Compétences SQL
- ✅ Compréhension d'un modèle relationnel normalisé
- ✅ Maîtrise des requêtes `SELECT` de base avec projections et filtres
- ✅ Utilisation des opérateurs de comparaison et logiques (`=`, `>`, `>=`, `AND`, `OR`)
- ✅ Utilisation des clauses de tri (`ORDER BY ASC/DESC`)
- ✅ Limitation des résultats avec `LIMIT`
- ✅ Réalisation de jointures internes (`INNER JOIN`)
- ✅ Réalisation de jointures externes (`LEFT JOIN`)
- ✅ Utilisation d'alias de tables pour jointures multiples sur la même table
- ✅ Utilisation des fonctions d'agrégation (`COUNT`, `AVG`, `SUM`, `MAX`, `MIN`)
- ✅ Regroupement de données avec `GROUP BY`
- ✅ Filtrage des groupes avec `HAVING`
- ✅ Concaténation de chaînes avec l'opérateur `||`
- ✅ Création d'alias de colonnes avec `AS`
- ✅ Compréhension de l'ordre d'exécution des clauses SQL

### Compétences en bases de données
- ✅ Compréhension des clés primaires et étrangères
- ✅ Compréhension des relations 1:N (un-à-plusieurs)
- ✅ Gestion des valeurs `NULL` et leur signification métier
- ✅ Création de tables avec contraintes d'intégrité
- ✅ Insertion de données fictives cohérentes
- ✅ Utilisation de PostgreSQL et pgAdmin 4

### Compétences transversales
- ✅ Gestion de versions avec Git (commits, push, pull)
- ✅ Organisation du travail en binôme
- ✅ Rédaction de documentation technique
- ✅ Résolution de problèmes par la recherche (documentation, Stack Overflow)
- ✅ Lecture et compréhension des messages d'erreur
- ✅ Tests et débogage de requêtes SQL
- ✅ Communication et entraide dans un projet collaboratif

---

## 📚 Ressources utilisées

### Documentation officielle
- [Documentation PostgreSQL 14](https://www.postgresql.org/docs/14/)
- [pgAdmin 4 Documentation](https://www.pgadmin.org/docs/)

### Outils en ligne
- [Stack Overflow](https://stackoverflow.com/) - Résolution de problèmes spécifiques

---

## 👥 Contributeurs

### Équipe de développement

**Florence KORE-BELLE**  
*Bachelor 1 Informatique - Paris Ynov Campus*
- Création de la base de données et script d'initialisation
- Réalisation des Quêtes 3 et 5 (jointures et agrégations avancées)
- Structuration du dépôt Git

**Sarah BOUHADRA**  
*Bachelor 1 Cybersécurité - Paris Ynov Campus*
- Réalisation des Quêtes 1, 2 et 4 (requêtes de base et agrégations simples)
- Tests et validation des requêtes

---

## 📅 Informations du projet

**Date de réalisation :** 9 et 19 février 2025  
**Établissement :** Paris Ynov Campus  
**Formations :**
- Bachelor 1 Informatique (Florence)
- Bachelor 1 Cybersécurité (Sarah)

**Module :** SQL  
**Contexte :** Projet SQL B1 - Interrogation d'une base de données métier

---

## 📝 Notes de fin de projet

### Points forts du projet
- Base de données bien structurée et normalisée
- Requêtes fonctionnelles répondant aux besoins métier
- Bonne répartition du travail entre les membres du binôme
- Documentation complète et détaillée

### Axes d'amélioration possibles
- Ajouter des index pour optimiser les performances sur les grandes tables
- Créer des vues pour simplifier les requêtes complexes fréquentes
- Ajouter des contraintes `CHECK` pour valider les données (ex: autonomie_km > 0)
- Ajouter une table `tarif` pour gérer la facturation des locations

### Perspectives d'évolution
Ce projet pourrait être étendu avec :
- Une interface web pour gérer les locations (PHP/Python + PostgreSQL)
- Un système d'authentification pour les clients
- Un tableau de bord d'analyse pour l'entreprise
- Une API REST pour exposer les données
- Integration avec un système de paiement

---

**Merci d'avoir consulté notre documentation ! 🚀**