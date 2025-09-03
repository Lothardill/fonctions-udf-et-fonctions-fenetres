-- 1) ORDERS – WINDOW FUNCS

-- 1.1 ROW_NUMBER : numéro de ligne par client (1 = plus ancienne commande)
SELECT
  date_date,
  customers_id,
  -- ### Key ###
  orders_id,
  -- ###########
  ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date) AS rn
FROM `ops17.orders_17`
ORDER BY customers_id, date_date, rn;

-- 1.2 Ajouter aussi RANK pour comparer
SELECT
  date_date,
  customers_id,
  -- ### Key ###
  orders_id,
  -- ###########
  ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date) AS rn,
  RANK()       OVER (PARTITION BY customers_id ORDER BY date_date) AS rk
FROM `ops17.orders_17`
ORDER BY customers_id, date_date, rn;

-- 1.3 Comparaison rn vs rk pour des clients donnés
-- (Rmq : ROW_NUMBER différencie deux commandes le même jour, RANK leur donne le même rang.)
SELECT
  date_date,
  customers_id,
  -- ### Key ###
  orders_id,
  -- ###########
  ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date) AS rn,
  RANK()       OVER (PARTITION BY customers_id ORDER BY date_date) AS rk
FROM `ops17.orders_17`
WHERE customers_id IN (33690,205343,212497)
ORDER BY customers_id, date_date, rn;

-- 1.4 Astuce : si plusieurs commandes le même jour, on peut départager par orders_id
SELECT
  date_date,
  customers_id,
  -- ### Key ###
  orders_id,
  -- ###########
  ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rn,
  RANK()       OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rk
FROM `ops17.orders_17`
WHERE customers_id IN (33690,205343,212497)
ORDER BY customers_id, date_date, rn;

-- 1.5 Marquer la toute première commande par client (is_new = 1)
WITH orders_rn AS (
  SELECT
    date_date,
    customers_id,
    -- ### Key ###
    orders_id,
    -- ###########
    ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rn
  FROM `ops17.orders_17`
)
SELECT
  date_date,
  customers_id,
  -- ### Key ###
  orders_id,
  -- ###########
  rn,
  IF(rn = 1, 1, 0) AS is_new
FROM orders_rn
ORDER BY customers_id, date_date, rn;

-- 2) SALES – WINDOW FUNCS

-- 2.1 ROW_NUMBER / RANK sur les ventes
SELECT
  date_date,
  customers_id,
  -- ### Key ###
  orders_id,
  products_id,
  -- ###########
  ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rn
FROM `ops17.sales_17`
ORDER BY customers_id, date_date, orders_id, rn;

SELECT
  date_date,
  customers_id,
  -- ### Key ###
  orders_id,
  products_id,
  -- ###########
  ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rn,
  RANK()       OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rk
FROM `ops17.sales_17`
ORDER BY customers_id, date_date, orders_id, rn;

-- 2.2.b Ajouter DENSE_RANK pour comparer avec RANK
SELECT
  date_date,
  customers_id,
  -- ### Key ###
  orders_id,
  products_id,
  -- ###########
  ROW_NUMBER()  OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rn,
  RANK()        OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rk,
  DENSE_RANK()  OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS ds_rk
FROM `ops17.sales_17`
ORDER BY customers_id, date_date, orders_id, rn;

-- 2.2 Comparaison rk vs ds_rk pour quelques clients
SELECT
  date_date,
  customers_id,
  -- ### Key ###
  orders_id,
  products_id,
  -- ###########
  ROW_NUMBER()  OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rn,
  RANK()        OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rk,
  DENSE_RANK()  OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS ds_rk
FROM `ops17.sales_17`
WHERE customers_id IN (98869,217071,268263)
ORDER BY customers_id, date_date, orders_id, rn;

-- 2.3 Marquer les lignes de la première commande (is_new = 1) via DENSE_RANK
WITH sales_ds_rk AS (
  SELECT
    date_date,
    customers_id,
    -- ### Key ###
    orders_id,
    products_id,
    -- ###########
    DENSE_RANK() OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS ds_rk
  FROM `ops17.sales_17`
)
SELECT
  date_date,
  customers_id,
  -- ### Key ###
  orders_id,
  products_id,
  -- ###########
  ds_rk,
  IF(ds_rk = 1, 1, 0) AS is_new
FROM sales_ds_rk
ORDER BY customers_id, date_date, orders_id;
