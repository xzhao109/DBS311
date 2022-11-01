------------------------------------------------------------------
--//
--//
------------------------------------------------------------------
--  QUESTION 1 --
SELECT o.order_id                       AS "ORDER ID",
       SUM(oi.quantity)                 AS "Total Quantity",
       SUM(oi.quantity * oi.unit_price) AS "Total Amount"
FROM   orders o
       inner join order_items oi
               ON o.order_id = oi.order_id
GROUP  BY o.order_id
HAVING SUM(oi.quantity) > 1000
ORDER  BY o.order_id;

--  QUESTION 2 --
SELECT c.customer_id,
       c.name,
       COUNT(o.customer_id) AS "Number of Orders"
FROM   customers c
       left join orders o
              ON c.customer_id = o.customer_id
WHERE  c.name LIKE 'W%'
       AND c.name LIKE '%oo%'
GROUP  BY c.customer_id,
          c.name
ORDER  BY COUNT(*),
          c.customer_id;

--  QUESTION 3 --
SELECT pc.category_id,
       pc.category_name,
       ROUND(AVG(COALESCE(p.list_price, 0)), 2) AS "Average  Price",
       COUNT(p.category_id)                     AS "Number of Products"
FROM   product_categories pc
       left join products p
              ON pc.category_id = p.category_id
GROUP  BY pc.category_id,
          pc.category_name
ORDER  BY pc.category_id;

--  QUESTION 4 --
SELECT warehouse_id,
       COUNT(DISTINCT product_id) AS "Number of Different Products",
       SUM(quantity)              AS "Quantity of All Products"
FROM   inventories
GROUP  BY warehouse_id
ORDER  BY "quantity of all products";

--  QUESTION 5 --
SELECT c.country_name        AS "Country",
       COUNT(w.warehouse_id) AS "Number of Warehouses"
FROM   ( countries c
         inner join locations l
                 ON c.country_id = l.country_id )
       inner join warehouses w
               ON l.location_id = w.location_id
GROUP  BY c.country_name
ORDER  BY c.country_name; 