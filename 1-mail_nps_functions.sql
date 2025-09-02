-- 1) GREENWEEZ MAIL
-- 1.1 Exploration (ordre décroissant par volume envoyé)
SELECT
  -- ### Key ###
  journey_id,
  -- ############
  journey_name,
  sent_nb
FROM `course17.gwz_mail_17`
ORDER BY sent_nb DESC;

-- 1.2 Fonction is_mail_be : 1 si la campagne cible la Belgique, sinon 0
-- détection via "nlbe" dans le journey_name
CREATE OR REPLACE FUNCTION `course17.is_mail_be`(journey_name STRING)
AS (IF(journey_name LIKE "%nlbe%", 1, 0));

-- Requête d’exemple avec la fonction is_mail_be
SELECT
  -- ### Key ###
  journey_id,
  -- ############
  journey_name,
  course17.is_mail_be(journey_name) AS mail_be,
  sent_nb
FROM `course17.gwz_mail_17`
ORDER BY sent_nb DESC;

-- 1.3 Fonction mail_type : newsletter / abandoned_basket / back_in_stock
CREATE OR REPLACE FUNCTION `course17.mail_type`(journey_name STRING)
AS (
  CASE
    WHEN journey_name LIKE "%panier_abandonne%" OR journey_name LIKE "%abandoned_basket%" THEN "abandoned_basket"
    WHEN journey_name LIKE "%back_in_stock%" THEN "back_in_stock"
    WHEN journey_name LIKE "%nl%" OR journey_name LIKE "%nlbe%" THEN "newsletter"
    ELSE NULL
  END
);

-- Sélection enrichie (type + BE)
SELECT
  -- ### Key ###
  journey_id,
  -- ############
  journey_name,
  course17.is_mail_be(journey_name)   AS mail_be,
  course17.mail_type(journey_name)    AS mail_type,
  sent_nb
FROM `course17.gwz_mail_17`
ORDER BY sent_nb DESC;

-- 2) NPS & LIVRAISONS
-- 2.1 Exploration
SELECT
  date_date,
  orders_id,
  transporter,
  global_note
FROM `course17.gwz_nps_17`;

-- 2.2 Fonction nps : -1 (detractor), 0 (passive), 1 (promoter)
CREATE OR REPLACE FUNCTION `course17.nps`(global_note INT64)
AS (
  CASE
    WHEN global_note IN (9,10) THEN 1         -- Promoters
    WHEN global_note IN (7,8)  THEN 0         -- Passives
    WHEN global_note BETWEEN 0 AND 6 THEN -1  -- Detractors
    ELSE NULL
  END
);

-- Requête d’exemple avec la fonction nps
SELECT
  date_date,
  orders_id,
  transporter,
  global_note,
  course17.nps(global_note) AS nps
FROM `course17.gwz_nps_17`;

-- 2.3 Fonctions transporter_brand & delivery_mode
CREATE OR REPLACE FUNCTION `course17.transporter_brand`(transporter STRING)
AS (
  CASE
    WHEN transporter LIKE "%Chrono%" THEN "Chrono"
    WHEN transporter LIKE "%DPD%"    THEN "DPD"
    ELSE NULL
  END
);

CREATE OR REPLACE FUNCTION `course17.delivery_mode`(transporter STRING)
AS (
  CASE
    WHEN transporter LIKE "%Pickup%" THEN "Pickup"
    WHEN transporter LIKE "%Home%"   THEN "Home"
    ELSE NULL
  END
);

-- Sélection enrichie : nps + brand + mode
SELECT
  date_date,
  orders_id,
  course17.delivery_mode(transporter)  AS delivery_mode,
  course17.transporter_brand(transporter) AS transporter_brand,
  transporter,
  global_note,
  course17.nps(global_note)            AS nps
FROM `course17.gwz_nps_17`;
