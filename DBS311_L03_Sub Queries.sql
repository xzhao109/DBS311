 ------------------------------------------------------------------
--//
--//
------------------------------------------------------------------


--  QUESTION 1 --
SELECT employee_id,
       hire_date
FROM   employees
WHERE  hire_date BETWEEN (SELECT hire_date
                          FROM   employees
                          WHERE  employee_id = 57) AND
                         To_date('16-11-30', 'YY-MM-DD')
       AND employee_id IN (SELECT salesman_id
                           FROM   orders
                           WHERE  salesman_id IS NOT NULL)
       AND employee_id <> 57
ORDER  BY hire_date,
          employee_id; 



--  QUESTION 2 --
SELECT c.customer_id,
       c.name,
       o.order_date,
       Count(*) AS "Number of Orders"
FROM   customers c
       inner join orders o
               ON c.customer_id = o.customer_id
WHERE  o.order_date = ANY (SELECT order_date
                           FROM   orders
                           WHERE  customer_id = 2)
       AND c.customer_id <> 2
GROUP  BY c.customer_id,
          c.name,
          o.order_date
ORDER  BY o.order_date,
          c.customer_id; 
          
          
          
--  QUESTION 3 -- 
SELECT pc.category_id,
       pc.category_name
FROM   product_categories pc
       inner join products p
               ON pc.category_id = p.category_id
WHERE  p.list_price > (SELECT Max(DISTINCT list_price)
                       FROM   products
                       WHERE  category_id = 2)
GROUP  BY pc.category_id,
          pc.category_name;
          
          
  
--  QUESTION 4 --   
SELECT p.product_id,
       p.product_name,
       pc.category_name,
       p.list_price AS "Unit Price"
FROM   products p
       inner join product_categories pc
               ON p.category_id = pc.category_id
WHERE  p.list_price = (SELECT Max(list_price)
                       FROM   products)
        OR p.list_price = (SELECT Min(list_price)
                           FROM   products)
ORDER  BY pc.category_id,
          p.product_id;


--  QUESTION 5 -- 
SELECT c.customer_id,
       c.name,
       o.order_date
FROM   customers c
       inner join orders o
               ON c.customer_id = o.customer_id
WHERE  o.order_date = (SELECT Max(order_date)
                       FROM   orders)
        OR o.order_date = (SELECT Min(order_date)
                           FROM   orders)
ORDER  BY o.customer_id,
          o.order_date; 
  