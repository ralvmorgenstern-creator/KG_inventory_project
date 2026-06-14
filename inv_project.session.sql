WITH unchanged_inv AS (
  SELECT
      l.inventory_id,
      l.store,
      l.city,
      l.brand,
      l.price,
      s.on_hand:numeric AS begin_count,
      l.on_hand:numeric AS year_end_audit
  FROM inventory_end_snapshot AS l
  JOIN inventory_start_snapshot AS s
      ON l.inventory_id = s.inventory_id
     AND l.store = s.store
     AND l.city = s.city
  WHERE l.on_hand::numeric = s.on_hand::numeric      -- compare first
    AND l.on_hand::numeric > 0              -- optional: exclude zero inventory
)

SELECT
    inventory_id,
    store,
    city,
    begin_count,
    year_end_audit
FROM unchanged_inv;