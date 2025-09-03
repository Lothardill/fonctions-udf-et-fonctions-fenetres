# Fonctions UDF et Fonctions Fenêtres

L’objectif est de développer une maîtrise progressive des principales notions SQL :
- Mettre en pratique la création et l’utilisation de fonctions définies par l’utilisateur (UDFs) et de fonctions de fenêtre (window functions) dans BigQuery afin de :
- Automatiser des règles de classification dans les datasets marketing et satisfaction client.
- Simplifier l’analyse en encapsulant la logique métier dans des fonctions réutilisables.
- Explorer l’apport des fonctions de fenêtre pour produire des indicateurs analytiques avancés (classements, moyennes, comparaisons globales vs locales).
- Relier ces transformations à des KPIs concrets pour l’équipe marketing et logistique.

Chaque partie correspond à une compétence ou une notion particulière, et contient les fichiers SQL et jeux de données associés.

## Partie 1 – Fonctions UDF

Objectif : découvrir comment créer et utiliser des fonctions définies par l’utilisateur (UDF) dans BigQuery afin de simplifier la logique métier, automatiser certaines classifications (ex. identifier si un mail est envoyé en Belgique, déterminer le type de campagne, calculer un score NPS), et rendre les requêtes plus lisibles et réutilisables.

Fichiers :
- `mail_nps_analysis.sql` : script SQL contenant toutes les requêtes, incluant la création des UDFs (is_mail_be, mail_type, nps, transporter_brand, delivery_mode) et l’utilisation de fonctions fenêtres (OVER, PARTITION BY, ORDER BY).
- `1-mail_campaigns.csv` et `1-nps_deliveries.csv` : datasets.

## Partie 2 – User-defined Functions

Objectif : découvrir comment créer et utiliser des fonctions définies par l’utilisateur (UDF) dans BigQuery afin de simplifier la logique métier, automatiser certaines classifications (ex. identifier si un mail est envoyé en Belgique, déterminer le type de campagne, calculer un score NPS), et rendre les requêtes plus lisibles et réutilisables.

Fichiers :
- `2-udf_basics.sql` : script SQL contenant toutes les requêtes, incluant la création des UDFs (is_mail_be, mail_type, nps, transporter_brand, delivery_mode) et l’utilisation de fonctions fenêtres (OVER, PARTITION BY, ORDER BY).

## Partie 3 – Analyse des commandes avec Window Functions

Objectif : Illustrer l’utilisation des fonctions analytiques (window functions) telles que ROW_NUMBER(), RANK() et DENSE_RANK().

Fichiers :
- `7-window_functions.sql` : script SQL contenant toutes les requêtes avec ROW_NUMBER(), RANK() et DENSE_RANK() pour analyser les commandes et ventes.
- `3-dataset.orders_window.csv` : dataset.
  
⚠️ Le dataset complet (~50 Mo) n’est pas versionné pour des raisons de taille. Cet échantillon (2 000 lignes) est fourni pour la démonstration, mais toutes les requêtes du script SQL sont applicables à l’intégralité du jeu de données.
