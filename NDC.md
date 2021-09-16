# Note De Clarification - Complexe Cinématographique

[TOC]

## 1. Contexte du projet  et objectif:

Un nouveau complexe cinématographique va ouvrir ses portes. Celui-ci souhaite se doter d'une base de données afin de gérer son fonctionnement.

## 2. Objectif

Il s'agit de créer une base de données performantes capable de gérer efficacement le fonctionnement quotidien du cinéma. Le livrable devra prendre précisément ces objectifs en comptes :

- Gérer les films et le entrées
- Gestions des différents produits à la vente (aliment, boisson, ticket)
- Obtenir différentes statistiques (pourcentage d'occupation des séances, mesure du succès du film, part des abonnés, recette, nombre de spectateur, ...)
- Gérer le bon fonctionnement du cinéma (séance, film projeté, ....)

## 3. Acteur

Client : Université de Technologie de Compiègne.

Maître d’Ouvrage : CORREA-VICTORINO Alessandro.

La maîtrise œuvre est réalisée par GRIMAL Paul.

## 4. Livrables

Les livrables attendus pour ce projet sont :

1. Une Note De Clarification(**NDC**) au format mark down
2. Un Modèle Conceptuel de Données (**MCD**) au format plantuml
3. Un Modèle Logique de Données (**MLD**)
4. Une Base de Données (**BD**) avec CREATE, INSERT, VUES.

## 5. Risques

Les risques suivants ont été identifié :

- Mauvaise gestion des délais pour chaque rendu
- Une mauvaise modélisation conceptuelle qui pourrait entraîner une corruption des données (pertes d’informations, une base de donnée non fonctionnelle).
- Des mauvais choix lors du passages aux relationnels qui complexifieront le problème. 

## 6. Reformulation du cahier des charges

Dans cette partie nous allons détaillés les différents objets qui devront être gérés dans la base de données, les propriétés associés à ces objets et les contraintes associés à ces objets. 

### Les différents objets

- Film
- Genre
- Note
- Artiste (Producteur, Réalisateur)
- Distributeur
- Séance
- Salle
- Vendeur
- Entrée (Ticket_unitaire ou Ticket_abonnement)
- Abonnement
- Recharge
- Produit (alimentaire ou boisson)

### Hypothèse

On suppose que pour noter un film à la fin d'une séance, le spectateur devra insérer dans la borne prévu à cet effet son ticket. Cela permettra de vérifier que la personne a assisté à la séance de cinéma et éviter qu'elle vote plusieurs fois.

On associe pas un tarif (senior, enfant,...) à un prix car si on veut changer le tarif, toutes les anciennes recettes seront faussées. 

Quand on achète une carte abonnement, elle ne possède aucun ticket. Il faut ensuite la recharger d'un certain nombre de tickets.  La carte d'abonnement permettra ensuite de payer des Ticket_abonnement.

On suppose qu'un film a au moins un genre, mais il peut en avoir plusieurs.

Il existe des producteurs réalisateurs comme par exemple Nolan.

On considère qu'il peut y avoir deux film avec un même nom et une même date de sortie. On considère que la combinaison de titre , date de sortie et le résumé est unique.

Un film est toujours géré par un distributeur. Si jamais le film tombe dans le domaine public, il sera géré par un distributeur nommé domaine_public.

### Propriétés pour les objets

Nous allons lister les propriétés des différents objets.

- Film

  - Titre (chaîne de caractère, obligatoire)
  - Date de sortie (Date, obligatoire)
  - Résumé (Texte, obligatoire)
  - Durée (Temps, obligatoire)
  - Âge minimum (Entier, obligatoire)

- Genre

  - nom de genre (chaîne de caractère , obligatoire et unique)

- Note

  - étoile (Entier de 1 à 5, obligatoire)

- Artiste (objet abstrait)

  - Nom (chaîne de caractère, obligatoire)
  - Prénom (chaîne de caractère, obligatoire)
  - Date de naissance (chaîne de caractère, obligatoire)

  **Producteur** et **Réalisateur** sont des précisions de l'objet abstrait Personne. Ils ne possèdent pas d'attribut particulier.

- Distributeur
  
  - Nom (chaîne de caractère, obligatoire, unique)
  
  - numéro de téléphone (chaîne de caractère, obligatoire, unique)
  
    On prend l'adresse du siège du distributeur.
  
  - Numéro de rue (entier, obligatoire)
  
  - Rue (chaîne de caractère, obligatoire)
  
  - Ville (chaîne de caractère, obligatoire)
  
  - Code postale (entier, obligatoire)
  
- Séance
  - Horaire et date de projection (une date et un temps, obligatoire)
  - doublage (type énuméré {VF = version française, VOSTFR = version originale sous titré, VO = version originale}, obligatoire)

- Salle

  - numéro de salle (entier , obligatoire, unique)
  - nombre de place(entier supérieur à 0, obligatoire)

- Vendeur

  - Nom (chaîne de caractère, obligatoire)
  - Prénom (chaîne de caractère, obligatoire)
  - Date de naissance (chaîne de caractère, obligatoire)
  - numéro de téléphone (chaîne de caractère, obligatoire, unique)

- Entrée(objet abstrait)

  - prix (nombre décimal supérieur à 0, obligatoire)

  **Ticket_unitaire** et **Ticket_abonnement** sont des précisions du type Entrée.

- Ticket_unitaire

  - tarif(type énuméré {enfant, étudiant,adulte,senior,dimanche})

- Abonnement

  - prix (nombre décimal supérieur à 0, obligatoire) Représente le prix de la carte d'abonnement.

- Recharge

  - nombre de ticket rechargé (entier supérieur à 0, obligatoire)
  - prix (nombre décimal supérieur à 0, obligatoire)²

- Produit (objet abstrait) 

  - prix (nombre décimal supérieur à 0, obligatoire)
  - nom (chaîne de caractère, obligatoire, unique)

  **Alimentaire** et **Boisson** sont des précisions de l'objet abstrait Produit. Ils ne possèdent pas d'attribut particulier.

### Choix des associations et des transformations

Dans cette partie nous allons détaillé le choix des associations ainsi que les transformations choisis pour les héritages et agrégations.

- Un distributeur gère des films, et un film est géré par un unique distributeur. On a une relation 1 - * entre Distributeur et Film.
- Un film possède un ou plusieurs genre, un genre est présent lié à des films. On a une relation 1..* - 0..* entre Genre et Film.
- Un Film est noté par des Notes, une Note concerne un film. On a une relation de composition. Un film est composé de 0 ou plusieurs Notes.
- Un Film est réalisé par un Réalisateur. Un film est produit par un à plusieurs réalisateurs. Un réalisateur peut avoir réaliser un a plusieurs film. Il y a donc une relation 1..* - 1..* entre Film et Réalisateur.  
- Un Film est produit par un Réalisateur. Un film est produit par un à plusieurs producteurs. Un producteur peut avoir produit un à plusieurs film. Il y a donc une relation 1..* - 1..* entre Film et Réalisateur. 
- Une Séance projette un film. Un Film est projeté pendant une Séance. Il y a un lien de vie entre Film et Séance : si le Film est supprimé la séance ne peut pas avoir lieu. Nous avons donc une composition entre Film et Séance. Un Film peut être composé de 0..* Séance.
- Une Séance a lieu dans une Salle. Une Salle peut accueillir 0 à * Séance (mais pas en même temps). On a une relation 1 - 0..* entre Salle et Séance.
- Un Vendeur vend des Produits. Un Produit est vendu par un Vendeur, et un Vendeur peut vendre de 0 à plusieurs Produits. On a donc une relation 1 - 0..* entre Vendeur et Produit.
- Un Vendeur vend aussi des Abonnements, des Entrées, et des Recharges. On aura en suivant la justification entre Vendeur et Produit. On aura une relation 1 - 0..* entre Vendeur et Abonnement/Entrée/Recharge. On ajoute une **classe d'association dans les ventes** pour prendre en compte la date des achats et ainsi pouvoir calculer une recette en fonction d'une date.
- Une Recharge recharge un Abonnement. Un Abonnement est composé 0 à * Recharge.
- Un Abonnement permet d'acheter des Tickets d'abonnements. Un Ticket d'abonnement est acheté par un Abonnement. On aura donc une composition 1-  0..* entre Abonnement et Ticket Abonnement. 
- Une Séance est composé d'Entrées.  Si une séance est supprimé, les tickets d'entrées sont supprimés. Une Séance peut être composée de 0 à * Entrées. 

## 7. Rôle des différents utilisateurs

Nous avons identifié 4 rôles : 

- Le distributeur : il doit pouvoir renseigner des informations sur un film et consulter les informations du succès de ses films (étoiles).
- Les vendeurs : ils doivent pouvoir indiquer la vente de produit, la vente de ticket et d'abonnement. Ils doivent pouvoir consulter les produits en stocks (gestion des stocks). Ils doivent pouvoir créer un ticket pour une séance
- Les spectateurs : ils doivent pouvoir consulter les séances et les films à l'affiche. Ils doivent pouvoir consulter les notes des films. Ils doivent pouvoir consulter les informations relatives aux films (producteurs, réalisateurs).
- L'administrateur : il doit pouvoir gérer l'ensemble de la base de donnée

## 8. Fonctionnalité du produit

Le produit permettra de gérer les films et leurs projection ainsi que la vente de produits.

On pourra facilement consulter les films par genre, par producteur, réalisateur. 

En particulier :

-  une vue permettant de voir le pourcentage d'occupation des séances d'un film
- une vue qui montre les places restantes pour les séances du jour
- une vue montrant les tickets restants sur une carte d'abonnement
- une vue montrant les étoiles récoltées par un film
- Une vue montrant les produits en stocks
- Une vue calculant le revenu généré par un film