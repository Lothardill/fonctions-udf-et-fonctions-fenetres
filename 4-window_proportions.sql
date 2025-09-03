1) Nombre de produits par commande

-- 1.1 Compter le nb de produits distincts par commande
SELECT
  date_date,
  ### Key ###
  orders_id,
  products_id
  ###########
  ,COUNT(DISTINCT products_id) OVER (PARTITION BY orders_id) AS nb_products
FROM `analytics.sales_window`
ORDER BY
  customers_id, orders_id, products_id;

-- 1.2 Typologie de commande (single / multi)
CREATE OR REPLACE VIEW `analytics.sales_window_orders_type_v` AS
WITH sales_orders_type AS (
  SELECT
    date_date,
    ### Key ###
    orders_id,
    products_id
    ###########
    ,COUNT(DISTINCT products_id) OVER (PARTITION BY orders_id) AS nb_products
  FROM `analytics.sales_window`
)
SELECT
  date_date,
  ### Key ###
  orders_id,
  products_id
  ###########
  ,nb_products
  ,IF(nb_products = 1, 'single_product', 'multi_product') AS orders_type
FROM sales_orders_type
ORDER BY
  date_date, orders_id;

   2) Part d’un produit dans le CA de la commande

-- 2.1 CA total de la commande via fenêtre
SELECT
  date_date,
  ### Key ###
  orders_id,
  products_id
  ###########
  ,SUM(turnover) OVER (PARTITION BY orders_id) AS orders_turnover
FROM `analytics.sales_window`
ORDER BY
  customers_id, orders_id, products_id;

-- 2.2 Pourcentage du CA par produit dans la commande
CREATE OR REPLACE VIEW `analytics.sales_window_turnover_percent_v` AS
WITH sales_orders_turnover AS (
  SELECT
    date_date,
    ### Key ###
    orders_id,
    products_id
    ###########
    ,category_1
    ,turnover
    ,turnover - purchase_cost AS margin
    ,SUM(turnover) OVER (PARTITION BY orders_id) AS orders_turnover
  FROM `analytics.sales_window`
)
SELECT
  date_date,
  ### Key ###
  orders_id,
  products_id
  ###########
  ,category_1
  ,turnover
  ,margin
  ,ROUND(orders_turnover, 2) AS orders_turnover
  ,ROUND(SAFE_DIVIDE(turnover, orders_turnover) * 100, 2) AS percent_turnover
FROM sales_orders_turnover
ORDER BY
  date_date, orders_id;

   3) Nb de catégories_1 distinctes par commande

WITH orders_cat AS (
  SELECT
    ### Key ###
    orders_id
    ###########
    ,COUNT(DISTINCT category_1) AS nb_cat_1
  FROM `analytics.sales_window`
  GROUP BY orders_id
)
SELECT
  s.date_date,
  ### Key ###
  s.orders_id,
  s.products_id
  ###########
  ,o.nb_cat_1
FROM `analytics.sales_window` AS s
LEFT JOIN orders_cat AS o USING (orders_id)
ORDER BY
  s.customers_id, s.orders_id, s.products_id;

4) Décomposition Fenêtre = GROUP BY + JOIN
   (équivalents pédagogiques)


-- 4.1 CA total par commande (GROUP BY + JOIN)
WITH orders AS (
  SELECT
    ### Key ###
    orders_id
    ###########
    ,SUM(turnover) AS orders_turnover
  FROM `analytics.sales_window`
  GROUP BY orders_id
)
SELECT
  s.date_date,
  ### Key ###
  s.orders_id,
  s.products_id
  ###########
  ,o.orders_turnover
FROM `analytics.sales_window` AS s
LEFT JOIN orders AS o USING (orders_id)
ORDER BY
  s.customers_id, s.orders_id, s.products_id;

-- 4.2. Nb catégories_1 distinctes par commande (GROUP BY + JOIN)
WITH orders_nb_cat AS (
  SELECT
    ### Key ###
    orders_id
    ###########
    ,COUNT(DISTINCT category_1) AS nb_cat_1
  FROM `analytics.sales_window`
  GROUP BY orders_id
)
SELECT
  s.date_date,
  ### Key ###
  s.orders_id,
  s.products_id
  ###########
  ,o.nb_cat_1
FROM `analytics.sales_window` AS s
LEFT JOIN orders_nb_cat AS o USING (orders_id)
ORDER BY
  s.customers_id, s.orders_id, s.products_id;
