-- QUESTION 5 --
SELECT c.customer_id,
       c.name
FROM   customers c
       join orders o
         ON c.customer_id = o.customer_id
       join order_items io
         ON io.order_id = o.order_id
WHERE  io.product_id IN ( 7, 40, 94 )
GROUP  BY c.customer_id,
          c.name
HAVING COUNT (c.customer_id) >= 3
ORDER  BY c.customer_id;

-- CUSTOMER_ID NAME                                                                                                                                                                                                                                                           
-- ----------- -------------------------
--           6 Community Health Systems

 
-- QUESTION 6 -- 
SELECT *
FROM   (SELECT e.employee_id,
               COUNT(*) AS "Number of Orders"
        FROM   employees e
               join orders o
                 ON e.employee_id = o.salesman_id
        GROUP  BY e.employee_id
        ORDER  BY 2 DESC)
WHERE  ROWNUM < 2
ORDER  BY employee_id;

-- EMPLOYEE_ID Number of Orders
-- ----------- ----------------
--          62               13



-- QUESTION 7 -- 
SELECT TO_CHAR(o.order_date, 'mm')         AS "Month Number",
       TO_CHAR(o.order_date, 'Month')      AS "Month",
       TO_CHAR(o.order_date, 'yyyy')       AS "Year",
       COUNT (TO_CHAR(o.order_date, 'mm')) AS "Total Number of Orders",
       SUM(oi.unit_price)                  AS "Sales Amount"
FROM   orders o
       join order_items oi
         ON o.order_id = oi.order_id
WHERE  TO_CHAR(o.order_date, 'yyyy') = 2017
GROUP  BY TO_CHAR(o.order_date, 'mm'),
          TO_CHAR(o.order_date, 'Month'),
          TO_CHAR(o.order_date, 'yyyy')
ORDER  BY "Month Number";

-- Mo Month     Year Total Number of Orders Sales Amount
-- -- --------- ---- ---------------------- ------------
-- 01 January   2017                     31     23938.79
-- 02 February  2017                     85     84355.55
-- 03 March     2017                     25     27279.53
-- 04 April     2017                     13      7512.22
-- 05 May       2017                     26     14345.55
-- 06 June      2017                      7      8225.95
-- 08 August    2017                     38     28881.85
-- 09 September 2017                     25     18693.24
-- 10 October   2017                     22     19245.91
-- 11 November  2017                      2       2693.1



-- QUESTION 8 -- 
SELECT TO_CHAR(o.order_date, 'mm')    AS "Month Number",
       TO_CHAR(o.order_date, 'Month') AS "Month",
       TO_CHAR(o.order_date, 'yyyy')  AS "Year",
       ROUND(AVG(oi.unit_price), 2)   AS "Average Sales Amount"
FROM   orders o
       join order_items oi
         ON o.order_id = oi.order_id
WHERE  TO_CHAR(o.order_date, 'yyyy') = 2017
GROUP  BY TO_CHAR(o.order_date, 'mm'),
          TO_CHAR(o.order_date, 'Month'),
          TO_CHAR(o.order_date, 'yyyy')
HAVING AVG(oi.unit_price) > (SELECT AVG(oi.unit_price)
                             FROM   orders o
                                    join order_items oi
                                      ON o.order_id = oi.order_id
                             WHERE  TO_CHAR(o.order_date, 'yyyy') = 2017)
ORDER  BY "Month Number"; 

-- Mo Month     Year Average Sales Amount
-- -- --------- ---- --------------------
-- 02 February  2017               992.42
-- 03 March     2017              1091.18
-- 06 June      2017              1175.14
-- 10 October   2017               874.81
-- 11 November  2017              1346.55