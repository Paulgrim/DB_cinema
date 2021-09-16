/* commandes pour supprimer les tables*/
DROP VIEW IF EXISTS vDistributeur;
DROP VIEW IF EXISTS vContrainteRecharge;
DROP VIEW IF EXISTS vRevenu_Seven;
DROP VIEW IF EXISTS vStatOccupation_03_06;
DROP VIEW IF EXISTS vNote_Film;
DROP VIEW IF EXISTS vPlace_abo_restante;
DROP VIEW IF EXISTS vPlaceRestante_3_06;
DROP VIEW IF EXISTS vProduitEnStock;
DROP VIEW IF EXISTS vSeance_dispo_1juin_7juin;
DROP TABLE IF EXISTS vend_produit;
DROP TABLE IF EXISTS vend_abonnement;
DROP TABLE IF EXISTS vend_entree;
DROP TABLE IF EXISTS vend_recharge;
DROP TABLE IF EXISTS  acheter_ticket_abo;
DROP TABLE IF EXISTS Vendeur;
DROP TABLE IF EXISTS Recharge;
DROP TABLE IF EXISTS Abonnement;
DROP TABLE IF EXISTS Entree;
DROP TABLE IF EXISTS Produire;
DROP TABLE IF EXISTS Realise;
DROP TABLE IF EXISTS Realisateur;
DROP TABLE IF EXISTS Producteur;
DROP TABLE IF EXISTS Seance;
DROP TABLE IF EXISTS Salle;
DROP TABLE IF EXISTS Produit;
DROP TABLE IF EXISTS est_Genre;
DROP TABLE IF EXISTS Gere_Film;
DROP TABLE IF EXISTS Note;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS Film;
DROP TABLE IF EXISTS Distributeur;
DROP TYPE IF EXISTS Type_tarif;
DROP TYPE IF EXISTS Ticket;
DROP TYPE IF EXISTS Type_aliment;
DROP TYPE IF EXISTS Type_contrat;
DROP TYPE IF EXISTS Type_doublage;

/********************** CREATE Les différentes tables**************************/
CREATE TABLE Distributeur(
  nom VARCHAR PRIMARY KEY,
  numero_tel VARCHAR NOT NULL UNIQUE,
  adresse JSON NOT NULL
);

CREATE TABLE Genre(
  nom_genre VARCHAR PRIMARY KEY
);

CREATE TABLE Film(
  titre VARCHAR NOT NULL,
  date_sortie DATE NOT NULL,
  resume TEXT NOT NULL,
  duree INTEGER NOT NULL,
  age_min INTEGER NOT NULL,
  notes JSON,
  PRIMARY KEY (titre, date_sortie, duree)
);

CREATE TABLE Gere_Film(
  titre_Film VARCHAR NOT NULL,
  date_Film DATE NOT NULL,
  duree_Film INTEGER NOT NULL,
  nom_distrib VARCHAR NOT NULL,
  FOREIGN KEY (titre_Film, date_Film, duree_Film) REFERENCES Film(titre, date_sortie, duree),
  FOREIGN KEY (nom_distrib) REFERENCES Distributeur(nom),
  PRIMARY KEY (titre_Film, date_Film, duree_Film, nom_distrib)
);

CREATE TABLE est_Genre(
  titre_Film VARCHAR NOT NULL,
  date_Film DATE NOT NULL,
  duree_Film INTEGER NOT NULL,
  nom_genre VARCHAR NOT NULL,
  FOREIGN KEY (titre_Film, date_Film, duree_Film) REFERENCES Film(titre, date_sortie, duree),
  FOREIGN KEY (nom_genre) REFERENCES Genre(nom_genre),
  PRIMARY KEY(titre_Film, date_Film, duree_Film, nom_genre)
);

CREATE TYPE Type_aliment AS ENUM ('alimentaire', 'boisson');

CREATE TABLE Produit(
    id_produit INTEGER PRIMARY KEY,
    nom VARCHAR NOT NULL,
    prix FLOAT NOT NULL,
    type Type_aliment NOT NULL,
    CHECK (prix > 0)
);

CREATE TABLE Salle(
  numero_salle INTEGER PRIMARY KEY,
  nb_place INTEGER NOT NULL
);

CREATE TYPE Type_doublage AS ENUM ('VF','VOSTFR', 'VO');
CREATE TABLE Seance(
  id_seance INTEGER UNIQUE NOT NULL,
  horaire_projection TIMESTAMP NOT NULL,
  titre_Film VARCHAR NOT NULL,
  date_Film DATE NOT NULL,
  duree_Film INTEGER NOT NULL,
  id_salle INTEGER NOT NULL,
  doublage Type_doublage NOT NULL,
  FOREIGN KEY (titre_Film, date_Film, duree_Film) REFERENCES Film(titre, date_sortie, duree),
  FOREIGN KEY (id_salle) REFERENCES Salle(numero_salle),
  PRIMARY KEY(id_seance, titre_Film, date_Film, duree_Film)
);

CREATE TABLE Realisateur(
  id_artiste INTEGER PRIMARY KEY,
  nom VARCHAR NOT NULL,
  prenom VARCHAR NOT NULL,
  date_naissance DATE NOT NULL
);

CREATE TABLE Producteur(
  id_artiste INTEGER PRIMARY KEY,
  nom VARCHAR NOT NULL,
  prenom VARCHAR NOT NULL,
  date_naissance DATE NOT NULL
);

CREATE TABLE Realise(
  id_realisateur INTEGER NOT NULL,
  titre_Film VARCHAR NOT NULL,
  date_Film DATE NOT NULL,
  duree_Film INTEGER NOT NULL,
  FOREIGN KEY (titre_Film, date_Film, duree_Film) REFERENCES Film(titre, date_sortie, duree),
  FOREIGN KEY (id_realisateur) REFERENCES Realisateur(id_artiste),
  PRIMARY KEY (id_realisateur, titre_Film, date_Film, duree_Film)
);

CREATE TABLE Produire(
  id_producteur INTEGER NOT NULL,
  titre_Film VARCHAR NOT NULL,
  date_Film DATE NOT NULL,
  duree_Film INTEGER NOT NULL,
  FOREIGN KEY (titre_Film, date_Film, duree_Film) REFERENCES Film(titre, date_sortie, duree),
  FOREIGN KEY (id_producteur) REFERENCES Producteur(id_artiste),
  PRIMARY KEY (id_producteur, titre_Film, date_Film, duree_Film)
);

CREATE TYPE Type_tarif AS ENUM ('enfant','adulte','etudiant','senior','dimanche');
CREATE TYPE Ticket AS ENUM ('abonnement','unitaire');
CREATE TABLE Entree(
  id_entree INTEGER UNIQUE NOT NULL,
  prix FLOAT NOT NULL,
  tarif Type_tarif,
  type_ticket Ticket NOT NULL,
  id_seance INTEGER NOT NULL,
  id_abonnement INTEGER,
  FOREIGN KEY (id_seance) REFERENCES Seance(id_seance),
  PRIMARY KEY(id_seance, id_entree),
  CHECK (prix > 0),
  CHECK((type_ticket = 'unitaire' AND id_abonnement IS NULL AND tarif IS NOT NULL)
  OR (type_ticket = 'abonnement' AND id_abonnement IS NOT NULL AND tarif IS NULL))
);

CREATE TABLE Abonnement(
  id_abonnement INTEGER PRIMARY KEY,
  prix FLOAT NOT NULL,
  CHECK (prix > 0)
);

CREATE TABLE Recharge(
  id_recharge INTEGER NOT NULL UNIQUE,
  nb_ticket INTEGER NOT NULL,
  prix FLOAT NOT NULL,
  id_abonnement INTEGER NOT NULL,
  FOREIGN KEY (id_abonnement) REFERENCES Abonnement(id_abonnement),
  PRIMARY KEY (id_recharge, id_abonnement),
  CHECK (prix > 0)
);

CREATE TYPE Type_contrat AS ENUM ('CDD', 'CDI');

CREATE TABLE Vendeur(
  nom VARCHAR NOT NULL,
  prenom VARCHAR NOT NULL,
  date_naissance DATE NOT NULL,
  numero_tel VARCHAR PRIMARY KEY,
  contrat Type_contrat NOT NULL
);

CREATE TABLE vend_recharge(
  id_vendeur VARCHAR NOT NULL,
  id_recharge INTEGER NOT NULL,
  date_vente DATE NOT NULL,
  FOREIGN KEY (id_vendeur) REFERENCES Vendeur(numero_tel),
  FOREIGN KEY (id_recharge) REFERENCES Recharge(id_recharge),
  PRIMARY KEY (id_recharge, id_vendeur)
);

CREATE TABLE vend_abonnement(
  id_vendeur VARCHAR NOT NULL,
  id_abonnement INTEGER NOT NULL,
  date_vente DATE NOT NULL,
  FOREIGN KEY (id_vendeur) REFERENCES Vendeur(numero_tel),
  FOREIGN KEY (id_abonnement) REFERENCES Abonnement(id_abonnement),
  PRIMARY KEY (id_abonnement, id_vendeur)
);

CREATE TABLE vend_entree(
  id_vendeur VARCHAR NOT NULL,
  id_entree INTEGER NOT NULL,
  date_vente DATE NOT NULL,
  FOREIGN KEY (id_vendeur) REFERENCES Vendeur(numero_tel),
  FOREIGN KEY (id_entree) REFERENCES Entree(id_entree),
  PRIMARY KEY (id_entree, id_vendeur)
);

CREATE TABLE vend_produit(
  id_vendeur VARCHAR NOT NULL,
  id_produit INTEGER NOT NULL,
  date_vente DATE NOT NULL,
  FOREIGN KEY (id_vendeur) REFERENCES Vendeur(numero_tel),
  FOREIGN KEY (id_produit) REFERENCES Produit(id_produit),
  PRIMARY KEY (id_produit, id_vendeur)
);

/***************** Insert pour tester la base de données *********************/
INSERT INTO Film (titre, date_sortie, resume, duree, age_min, notes) VALUES (
'Le Prestige',
'2006-11-15',
'Deux magiciens du 19e siècle s''engagent dans une lutte sans merci non seulement pour se surpasser l''un l''autre, mais pour détruire l''adversaire.',
 130,
 12,
 '{"note" : [5, 4, 5]}'
);

INSERT INTO Film (titre, date_sortie, resume, duree, age_min, notes) VALUES (
 'Seven',
 '1996-01-31',
 'Peu avant sa retraite, l''inspecteur William Somerset, un flic désabusé, est chargé de faire équipe avec un jeune idéaliste, David Mills.',
  128,
  16,
  '{"note" : [3, 2]}'
);

INSERT INTO Film (titre, date_sortie, resume, duree, age_min, notes) VALUES (
  'Interstellar',
  '2014-11-05',
  'Dans un futur proche, la Terre est de moins en moins accueillante pour l''humanité qui connaît une grave crise alimentaire. ',
   169,
   8,
   '{"note" : [5, 5]}'
 );

INSERT INTO Realisateur (id_artiste, nom, prenom, date_naissance) VALUES (1, 'Fincher', 'David', '1962-08-28');
INSERT INTO Realisateur (id_artiste, nom, prenom, date_naissance) VALUES (2, 'Nolan', 'Christopher', '1970-07-30');
INSERT INTO Realisateur (id_artiste, nom, prenom, date_naissance) VALUES (3, 'Bigelow', 'Kathryn', '1951-11-27');

INSERT INTO Producteur (id_artiste, nom, prenom, date_naissance) VALUES (2, 'Nolan', 'Christopher', '1970-07-30');
INSERT INTO Producteur (id_artiste, nom, prenom, date_naissance) VALUES (4, 'Spielberg', 'Steven', '1946-12-18');

INSERT INTO Distributeur (nom, numero_tel, adresse) VALUES ('Disney', '0614157382', '{"numéro" : 7, "nom_rue" : "boulevard G", "ville" :"Paris", "CP" : 92000}');
INSERT INTO Distributeur (nom, numero_tel, adresse) VALUES ('Universal', '0612121212','{"numéro" : 18, "nom_rue" : "rue A", "ville" :"Paris", "CP" : 92000}');

INSERT INTO Gere_Film (titre_Film, date_Film, duree_Film, nom_distrib) VALUES ('Le Prestige','2006-11-15',130, 'Universal');
INSERT INTO Gere_Film (titre_Film, date_Film, duree_Film, nom_distrib) VALUES ('Interstellar','2014-11-05',169, 'Universal');
INSERT INTO Gere_Film (titre_Film, date_Film, duree_Film, nom_distrib) VALUES ('Seven','1996-01-31',128, 'Disney');

INSERT INTO Genre(nom_genre) VALUES ('Thriller');
INSERT INTO Genre(nom_genre) VALUES ('SF');
INSERT INTO Genre(nom_genre) VALUES ('Policier');
INSERT INTO Genre(nom_genre) VALUES ('Aventure');
INSERT INTO Genre(nom_genre) VALUES ('Romantic');

INSERT INTO est_Genre(titre_Film, date_Film, duree_Film, nom_genre) VALUES ('Le Prestige','2006-11-15',130, 'Policier');
INSERT INTO est_Genre(titre_Film, date_Film, duree_Film, nom_genre) VALUES ('Interstellar','2014-11-05',169, 'Thriller');
INSERT INTO est_Genre(titre_Film, date_Film, duree_Film, nom_genre) VALUES ('Interstellar','2014-11-05',169, 'Aventure');
INSERT INTO est_Genre(titre_Film, date_Film, duree_Film, nom_genre) VALUES ('Seven','1996-01-31',128,'Policier');

INSERT INTO Produire(id_producteur, titre_Film, date_Film , duree_Film) VALUES (2 ,'Interstellar','2014-11-05',169);
INSERT INTO Produire(id_producteur, titre_Film, date_Film , duree_Film) VALUES (2 ,'Le Prestige','2006-11-15',130);
INSERT INTO Produire(id_producteur, titre_Film, date_Film , duree_Film) VALUES (4 ,'Seven','1996-01-31',128);

INSERT INTO Realise(id_realisateur, titre_Film, date_Film , duree_Film) VALUES (2 ,'Le Prestige','2006-11-15',130);
INSERT INTO Realise(id_realisateur, titre_Film, date_Film , duree_Film) VALUES (2 ,'Interstellar','2014-11-05',169);
INSERT INTO Realise(id_realisateur, titre_Film, date_Film , duree_Film) VALUES (1 ,'Seven','1996-01-31',128);

INSERT INTO Produit(id_produit, nom, prix, type) VALUES (1, 'KitKat', 2.10, 'alimentaire');
INSERT INTO Produit(id_produit, nom, prix, type) VALUES (2, 'M&MS', 3.40, 'alimentaire');
INSERT INTO Produit(id_produit, nom, prix, type) VALUES (3, 'Sprite 30cl', 2.10, 'boisson');
INSERT INTO Produit(id_produit, nom, prix, type) VALUES (4, 'Coca 30cl', 2.10, 'boisson');
INSERT INTO Produit(id_produit, nom, prix, type) VALUES (5, 'Popcorn 300g', 3.50, 'alimentaire');
INSERT INTO Produit(id_produit, nom, prix, type) VALUES (6, 'Popcorn 300g', 3.50, 'alimentaire');
INSERT INTO Produit(id_produit, nom, prix, type) VALUES (7, 'Popcorn 300g', 3.50, 'alimentaire');

INSERT INTO Salle(numero_salle, nb_place) VALUES (1, 50);
INSERT INTO Salle(numero_salle, nb_place) VALUES (2, 80);
INSERT INTO Salle(numero_salle, nb_place) VALUES (3, 10);
INSERT INTO Salle(numero_salle, nb_place) VALUES (4, 30);

INSERT INTO Seance(id_seance, horaire_projection, titre_Film, date_Film, duree_Film, id_salle, doublage) VALUES (
  1, '2020-06-03 14:15','Le Prestige','2006-11-15',130, 1, 'VF');
INSERT INTO Seance(id_seance, horaire_projection, titre_Film, date_Film, duree_Film, id_salle, doublage) VALUES (
  2, '2020-06-03 17:15','Le Prestige','2006-11-15',130, 1, 'VF');
INSERT INTO Seance(id_seance, horaire_projection, titre_Film, date_Film, duree_Film, id_salle, doublage) VALUES (
  3, '2020-06-03 14:15','Interstellar','2014-11-05',169, 2, 'VOSTFR');
INSERT INTO Seance(id_seance, horaire_projection, titre_Film, date_Film, duree_Film, id_salle, doublage) VALUES (
  4, '2020-06-04 14:15','Interstellar','2014-11-05',169, 2, 'VOSTFR');
INSERT INTO Seance(id_seance, horaire_projection, titre_Film, date_Film, duree_Film, id_salle, doublage) VALUES (
  5, '2020-06-04 17:15','Interstellar','2014-11-05',169, 3, 'VOSTFR');
INSERT INTO Seance(id_seance, horaire_projection, titre_Film, date_Film, duree_Film, id_salle, doublage) VALUES (
  6, '2020-06-03 20:15','Seven','1996-01-31',128, 4, 'VO');
INSERT INTO Seance(id_seance, horaire_projection, titre_Film, date_Film, duree_Film, id_salle, doublage) VALUES (
  7, '2020-06-03 22:15','Seven','1996-01-31',128, 2, 'VOSTFR');

INSERT INTO Abonnement(id_abonnement, prix) VALUES (1, 10.90);
INSERT INTO Abonnement(id_abonnement, prix) VALUES (2, 10.90);
INSERT INTO Abonnement(id_abonnement, prix) VALUES (3, 10.90);
INSERT INTO Abonnement(id_abonnement, prix) VALUES (4, 10.90);

/*ticket abonnement à 5€ par exemple */
INSERT INTO Recharge(id_recharge,  nb_ticket, prix, id_abonnement) VALUES (1, 4, 5*4, 1);
INSERT INTO Recharge(id_recharge,  nb_ticket, prix, id_abonnement) VALUES (2, 1, 5*1, 1);
INSERT INTO Recharge(id_recharge,  nb_ticket, prix, id_abonnement) VALUES (3, 1, 5*1, 3);
INSERT INTO Recharge(id_recharge,  nb_ticket, prix, id_abonnement) VALUES (4, 2, 5*2, 2);
INSERT INTO Recharge(id_recharge, nb_ticket, prix, id_abonnement) VALUES (5, 3, 5*3, 1);

INSERT INTO Vendeur(nom, prenom, date_naissance, numero_tel, contrat) VALUES ('Bastahh', 'Ilan', '22-07-2000', '0708909272', 'CDD');
INSERT INTO Vendeur(nom, prenom, date_naissance, numero_tel, contrat) VALUES ('Penverne', 'Leonard', '13-02-1995', '0618181818', 'CDI');

INSERT INTO vend_recharge(id_vendeur, id_recharge, date_vente) VALUES ('0708909272', 1, '2020-05-12');
INSERT INTO vend_recharge(id_vendeur, id_recharge, date_vente) VALUES ('0708909272', 2, '2020-05-19');
INSERT INTO vend_recharge(id_vendeur, id_recharge, date_vente) VALUES ('0618181818', 3, '2020-06-01');
INSERT INTO vend_recharge(id_vendeur, id_recharge, date_vente) VALUES ('0618181818', 4, '2020-04-18');
INSERT INTO vend_recharge(id_vendeur, id_recharge, date_vente) VALUES ('0708909272', 5, '2020-05-30');

INSERT INTO vend_abonnement(id_vendeur, id_abonnement, date_vente) VALUES ('0618181818', 1, '2020-05-12');
INSERT INTO vend_abonnement(id_vendeur, id_abonnement, date_vente) VALUES ('0708909272', 2, '2020-04-18');
INSERT INTO vend_abonnement(id_vendeur, id_abonnement, date_vente) VALUES ('0708909272', 3, '2020-05-25');
INSERT INTO vend_abonnement(id_vendeur, id_abonnement, date_vente) VALUES ('0708909272', 4, '2020-05-25');

INSERT INTO vend_produit(id_produit, id_vendeur, date_vente) VALUES (1, '0618181818', '2020-05-25');
INSERT INTO vend_produit(id_produit, id_vendeur, date_vente) VALUES (6, '0618181818', '2020-04-12');
INSERT INTO vend_produit(id_produit, id_vendeur, date_vente) VALUES (3, '0708909272', '2020-06-02');
INSERT INTO vend_produit(id_produit, id_vendeur, date_vente) VALUES (2, '0708909272', '2020-06-03');

/*tarif adulte 10.50, senior 9 */
INSERT INTO Entree(id_entree, id_seance, prix, tarif, type_ticket, id_abonnement) VALUES (1, 5, 5, NULL, 'abonnement',1);
INSERT INTO Entree(id_entree, id_seance, prix, tarif, type_ticket, id_abonnement) VALUES (2, 1, 5, NULL, 'abonnement' , 1);
INSERT INTO Entree(id_entree, id_seance, prix, tarif, type_ticket, id_abonnement) VALUES (3, 6, 5, NULL, 'abonnement', 1);
INSERT INTO Entree(id_entree, id_seance, prix, tarif, type_ticket, id_abonnement) VALUES (4, 6, 5, NULL, 'abonnement', 2);
INSERT INTO Entree(id_entree, id_seance, prix, tarif, type_ticket, id_abonnement) VALUES (5, 7, 5, NULL, 'abonnement', 1);
INSERT INTO Entree(id_entree, id_seance, prix, tarif, type_ticket, id_abonnement) VALUES (6, 7, 5, NULL, 'abonnement', 3);

INSERT INTO Entree(id_entree, id_seance, prix, tarif, type_ticket, id_abonnement) VALUES (7, 1, 10.50, 'adulte', 'unitaire', NULL);
INSERT INTO Entree(id_entree, id_seance, prix, tarif, type_ticket, id_abonnement) VALUES (8, 1, 9, 'senior', 'unitaire', NULL);
INSERT INTO Entree(id_entree, id_seance, prix, tarif, type_ticket, id_abonnement) VALUES (9, 6, 9, 'senior', 'unitaire', NULL);
INSERT INTO Entree(id_entree, id_seance, prix, tarif, type_ticket, id_abonnement) VALUES (10, 6, 10.50, 'adulte', 'unitaire', NULL);
INSERT INTO Entree(id_entree, id_seance, prix, tarif, type_ticket, id_abonnement) VALUES (11, 7, 9, 'senior', 'unitaire', NULL);

INSERT INTO vend_entree(id_vendeur, id_entree, date_vente) VALUES ('0618181818', 1, '2020-06-03');
INSERT INTO vend_entree(id_vendeur, id_entree, date_vente) VALUES ('0618181818', 2, '2020-06-03');
INSERT INTO vend_entree(id_vendeur, id_entree, date_vente) VALUES ('0618181818', 3, '2020-06-03');
INSERT INTO vend_entree(id_vendeur, id_entree, date_vente) VALUES ('0708909272', 4, '2020-06-03');
INSERT INTO vend_entree(id_vendeur, id_entree, date_vente) VALUES ('0708909272', 5, '2020-06-03');
INSERT INTO vend_entree(id_vendeur, id_entree, date_vente) VALUES ('0708909272', 6, '2020-06-03');

INSERT INTO vend_entree(id_vendeur, id_entree, date_vente) VALUES ('0618181818', 7, '2020-06-03');
INSERT INTO vend_entree(id_vendeur, id_entree, date_vente) VALUES ('0618181818', 8, '2020-06-03');
INSERT INTO vend_entree(id_vendeur, id_entree, date_vente) VALUES ('0708909272', 9, '2020-06-03');
INSERT INTO vend_entree(id_vendeur, id_entree, date_vente) VALUES ('0708909272', 10, '2020-06-03');
INSERT INTO vend_entree(id_vendeur, id_entree, date_vente) VALUES ('0708909272',11, '2020-06-03');


/**********************Exemple de vue  ****************************************/
/* produit en stock */
CREATE VIEW vProduitEnStock AS
SELECT p.nom, p.id_produit
FROM Produit p LEFT JOIN vend_produit v ON v.id_produit = p.id_produit
WHERE v.date_vente IS NULL;

/* Programmation du 1 juin au jusqu'au 7 juin*/
CREATE VIEW vSeance_dispo_1juin_7juin AS
SELECT titre_Film AS "titre", horaire_projection AS "horaire", doublage, duree_Film AS "duree (min)", id_salle AS "salle"
FROM Seance
WHERE horaire_projection <= '2020-06-08' AND horaire_projection >= '2020-06-01';


/* une vue qui montre les places restantes pour les séances du jour (3 juin)*/
CREATE VIEW vPlaceRestante_3_06 AS
SELECT occupe.titre_Film, Salle.nb_place - occupe.place AS "Place_restante"
FROM(
  SELECT ticket.id_seance, s.titre_Film, s.id_salle, COUNT(*) AS place
  FROM (
      SELECT id_seance, id_entree FROM Entree) ticket
  INNER JOIN Seance s
  ON s.id_seance = ticket.id_seance
  WHERE s.horaire_projection < '2020-06-04'
  AND s.horaire_projection >= '2020-06-03'
  GROUP BY ticket.id_seance, s.titre_Film, s.id_salle) occupe
INNER JOIN Salle
ON Salle.numero_salle = occupe.id_salle;

/* une vue montrant les étoiles récoltées par les films*/
CREATE VIEW vNote_Film AS
SELECT f.titre, f.date_sortie, f.duree, avg(x::text::numeric) AS etoile
FROM  Film f,
      json_array_elements(notes->'note') x
GROUP BY f.titre, f.date_sortie, f.duree;


/* une vue montrant les tickets restants sur une carte d'abonnement */
CREATE VIEW vPlace_abo_restante AS
SELECT a.id_abonnement,  COALESCE(calcul.restant, 0) AS restant
FROM Abonnement a
LEFT JOIN (
  SELECT recharge.id_abonnement, ticket - nb AS restant
  FROM (
    SELECT id_abonnement, COUNT(*) AS nb
    FROM Entree
    WHERE type_ticket = 'abonnement'
    GROUP BY id_abonnement) t
  INNER JOIN (
    SELECT r.id_abonnement, sum(r.nb_ticket) AS ticket
    FROM Recharge r
    GROUP BY r.id_abonnement) recharge
  ON recharge.id_abonnement = t.id_abonnement) calcul
ON a.id_abonnement = calcul.id_abonnement
ORDER BY a.id_abonnement;

/* pourcentage d'occupation des séances d'un film le 3-06 */
CREATE VIEW vStatOccupation_03_06 AS
SELECT occupe.id_seance, occupe.titre_Film, (occupe.place * 100)/(Salle.nb_place)  AS "% occupation"
FROM(
  SELECT ticket.id_seance, s.titre_Film, s.id_salle, COUNT(*) AS place
  FROM (
      SELECT id_seance, id_entree FROM Entree) ticket
  INNER JOIN Seance s
  ON s.id_seance = ticket.id_seance
  WHERE s.horaire_projection < '2020-06-04'
  AND s.horaire_projection >= '2020-06-03'
  GROUP BY ticket.id_seance, s.titre_Film, s.id_salle) occupe
INNER JOIN Salle
ON Salle.numero_salle = occupe.id_salle;

/*revenu genere par le film seven */
CREATE VIEW vRevenu_Seven AS
SELECT SUM(e.prix) AS recette
FROM (
  SELECT titre_Film, id_seance
  FROM seance
  WHERE titre_Film = 'Seven'
  AND date_Film = '1996-01-31'
  AND duree_Film = 128 ) seance
INNER JOIN Entree e
ON e.id_seance = seance.id_seance
GROUP BY seance.titre_Film;

/* vue pour voir les distributeurs*/
CREATE VIEW vDistributeur AS
SELECT d.nom, d.numero_tel, CAST(d.adresse->>'numéro' AS INTEGER) AS numéro, d.adresse->>'nom_rue' AS rue, d.adresse->>'ville' AS ville, CAST(d.adresse->>'CP' AS INTEGER) AS Code_Postale
FROM Distributeur d;

/*exemple de contrainte*/
CREATE VIEW vContrainteRecharge AS
SELECT id_recharge
FROM Recharge
EXCEPT
SELECT id_recharge
FROM vend_recharge;

/*******************************************************************/
/*
CREATE USER utilisateur_vendeur;
CREATE USER utilisateur_spectateur;
CREATE USER utilisateur_vendeur;
*/
/* gestion de droit */
/*
- Les vendeurs : ils doivent pouvoir indiquer la vente de produit, la vente de ticket et d'abonnement.
 Ils doivent pouvoir consulter les produits en stocks (gestion des stocks).

 EXEMPLE :
*/

/*
GRANT SELECT, INSERT, UPDATE, DELETE
  ON TABLE vend_entree, vend_produit, vend_recharge,vend_abonnement, Entree, Produit
  TO utilisateur_vendeur;
*/

/*
- Les spectateurs : ils doivent pouvoir consulter les séances et les films à l'affiche.
Ils doivent pouvoir consulter les notes des films. Ils doivent pouvoir consulter les
informations relatives aux films (producteurs, réalisateurs).

EXEMPLE
*/
/*
  GRANT SELECT
  ON Film, Producteur, Realisateur,Produire,Realise,vNote_Film, Seance
  TO utilisateur_spectateur;
*/
/*
- L'administrateur : il doit pouvoir gérer l'ensemble de la base de donnée
EXEMPLE :
*/
/*
GRANT ALL PRIVILEGE
ON Seance, Produit, Produire, Realise, Realisateur, Producteur, Entree, Abonnement, recharge, Vendeur, Salle, Distributeur, Gere_Film, Genre, est_Genre, vend_entree, vend_produit, vend_recharge, vend_abonnement
TO utilisateur_administrateur;
*/
