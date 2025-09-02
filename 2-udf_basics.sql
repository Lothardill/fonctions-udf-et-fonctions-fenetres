--1) Margin Percent

-- Query initiale enrichie avec la marge %
SELECT
    date_date,
    orders_id,
    products_id,
    promo_name,
    turnover_before_promo,
    turnover,
    purchase_cost,
    ROUND(SAFE_DIVIDE(turnover - purchase_cost, turnover) * 100, 1) AS margin_percent
FROM `course17.gwz_sales_17`;

-- UDF : margin_percent
CREATE OR REPLACE FUNCTION `course17.margin_percent`(
    turnover FLOAT64,
    purchase_cost FLOAT64
) AS (
    ROUND(SAFE_DIVIDE(turnover - purchase_cost, turnover) * 100, 1)
);

-- Requête avec UDF
SELECT
    date_date,
    orders_id,
    products_id,
    promo_name,
    turnover_before_promo,
    turnover,
    purchase_cost,
    course17.margin_percent(turnover, purchase_cost) AS margin_percent
FROM `course17.gwz_sales_17`;


-- 2) Promotion Percent

-- 2.1 Query enrichie avec promo_percent
SELECT
    date_date,
    orders_id,
    products_id,
    promo_name,
    turnover_before_promo,
    turnover,
    purchase_cost,
    course17.margin_percent(turnover, purchase_cost) AS margin_percent,
    ROUND(SAFE_DIVIDE(turnover_before_promo - turnover, turnover_before_promo) * 100, 0) AS promo_percent
FROM `course17.gwz_sales_17`;

-- UDF : promo_percent
CREATE OR REPLACE FUNCTION `course17.promo_percent`(
    turnover FLOAT64,
    turnover_before_promo FLOAT64
) AS (
    ROUND(SAFE_DIVIDE(turnover_before_promo - turnover, turnover_before_promo) * 100, 0)
);

-- 2.2 Requête finale avec les 2 UDF
SELECT
    date_date,
    orders_id,
    products_id,
    promo_name,
    turnover_before_promo,
    turnover,
    purchase_cost,
    course17.margin_percent(turnover, purchase_cost) AS margin_percent,
    course17.promo_percent(turnover, turnover_before_promo) AS promo_percent
FROM `course17.gwz_sales_17`;
