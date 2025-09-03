-- 1) Compute order-level turnover and each product's share (percent_turnover)
WITH sales_orders_turnover AS (
  SELECT
    date_date,
    -- ### Key ###
    orders_id,
    products_id,
    -- ###########
    category_1,
    turnover,
    -- If your CSV has purchase_cost, margin = turnover - purchase_cost. Otherwise keep NULL.
    IFNULL(turnover - purchase_cost, NULL) AS margin,
    SUM(turnover) OVER (PARTITION BY orders_id) AS orders_turnover
  FROM `course17.orders_window`
),

sales_with_share AS (
  SELECT
    date_date,
    -- ### Key ###
    orders_id,
    products_id,
    -- ###########
    category_1,
    turnover,
    margin,
    ROUND(orders_turnover, 2) AS orders_turnover,
    SAFE_DIVIDE(turnover, orders_turnover) AS percent_turnover
  FROM sales_orders_turnover
)

-- 2) Distribute order-level operational costs (from order_ship) down to product rows
sales_operational AS (
  SELECT
    s.date_date,
    -- ### Key ###
    s.orders_id,
    s.products_id,
    -- ###########
    s.category_1,
    s.turnover,
    s.margin,
    s.percent_turnover,
    -- Répartition des coûts opérationnels par produit
    ROUND(sh.shipping_fee * s.percent_turnover, 2) AS shipping_fee,
    ROUND(sh.log_cost     * s.percent_turnover, 2) AS log_cost,
    ROUND(sh.ship_cost    * s.percent_turnover, 2) AS ship_cost
  FROM sales_with_share AS s
  INNER JOIN `course17.order_ship` AS sh
    USING (orders_id)
)

-- 3) Final analysis: KPIs aggregated by category_1
SELECT
  -- ### Key ###
  category_1
  -- ###########
  ,ROUND(SUM(turnover))                                     AS turnover
  ,ROUND(SUM(margin))                                       AS margin
  ,ROUND(SAFE_DIVIDE(SUM(margin), SUM(turnover)) * 100, 1)  AS margin_percent
  ,ROUND(SUM(margin + shipping_fee - ship_cost - log_cost)) AS operational_margin
  ,ROUND(
      SAFE_DIVIDE(SUM(margin + shipping_fee - ship_cost - log_cost), SUM(turnover)) * 100
    ,1)                                                     AS operational_margin_percent
FROM sales_operational
GROUP BY category_1
ORDER BY category_1;
