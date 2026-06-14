--Comments on this non-moving inventory analysis
--1.Looking at products that have matching begin and end count
--2.Matching values does not mean non-moving, must verify with sales data
--3. Once inventory and sales data is verified, analyze the products, price point, location, never purchased

--First, find the products whose begin and end match
WITH unchanged_inventory AS (
  SELECT 
    first_inv.inventory_id,
    last_inv.brand,
    last_inv.description,
    first_inv.store,
    first_inv.city,
    last_inv.price::numeric AS retail_price,
    first_inv.on_hand::numeric AS begin_count,
    last_inv.on_hand::numeric AS end_count
  FROM  
    inventory_start_snapshot AS first_inv
  INNER JOIN inventory_end_snapshot AS last_inv ON first_inv.inventory_id = last_inv.inventory_id
  AND first_inv.store = last_inv.store AND first_inv.city = last_inv.city 
  WHERE 
    first_inv.on_hand = last_inv.on_hand
),
--Get sales data, remember that most items are text, cast as ::numeric
sales_summary AS ( 
  SELECT 
    sa.inventory_id,
    sa.store,
    SUM(sa.sales_quantity::numeric) AS total_sales_qty
  FROM 
    sales_activity AS sa 
  GROUP BY 
   sa.inventory_id,
   sa.store
)
--Now with unchanged inventory AND lack of sales verified, what price points are not moving
SELECT 
  ui.inventory_id,
  ui.brand,
  ui.store,
  ui.city,
  ui.retail_price,
  ui.end_count,
  COALESCE(ss.total_sales_qty, 0) AS total_units
FROM
  unchanged_inventory AS ui 
LEFT JOIN sales_summary AS ss ON ui.inventory_id = ss.inventory_id 
AND ui.store = ss.store
WHERE 
  COALESCE(ss.total_sales_qty, 0) = 0
ORDER BY 
  ui.retail_price DESC 
