-- 1) Ajouter un numéro de ligne pour chaque commande client
SELECT
    date_date,
    customers_id,
    ### Key ###
    orders_id
    ###########
    ,ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rn
FROM `dataset.orders_window`
ORDER BY
    customers_id,
    date_date,
    orders_id,
    rn;


-- 2) Ajouter également le RANK
SELECT
    date_date,
    customers_id,
    ### Key ###
    orders_id
    ###########
    ,ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rn
    ,RANK() OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rk
FROM `dataset.orders_window`
ORDER BY
    customers_id,
    date_date,
    orders_id,
    rn;


-- 3) Comparaison rn vs rk pour quelques clients
SELECT
    date_date,
    customers_id,
    ### Key ###
    orders_id
    ###########
    ,ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rn
    ,RANK() OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rk
FROM `dataset.orders_window`
WHERE customers_id IN (33690,205343,212497)
ORDER BY
    customers_id,
    date_date,
    orders_id,
    rn;


-- 4) Ajouter une colonne is_new pour flagger la 1ère commande
WITH orders_rn AS (
    SELECT
        date_date,
        customers_id,
        ### Key ###
        orders_id
        ###########
        ,ROW_NUMBER() OVER (PARTITION BY customers_id ORDER BY date_date, orders_id) AS rn
    FROM `dataset.orders_window`
)
SELECT
    date_date,
    customers_id,
    ### Key ###
    orders_id
    ###########
    ,rn
    ,IF(rn = 1, 1, 0) AS is_new
FROM orders_rn
ORDER BY
    customers_id,
    date_date,
    rn;
