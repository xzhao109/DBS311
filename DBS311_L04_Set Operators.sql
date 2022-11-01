 ------------------------------------------------------------------
--//
--//
------------------------------------------------------------------


--  QUESTION 1 --
SELECT COUNT(*) AS "Report"
FROM   (SELECT DISTINCT employee_id
        FROM   employees
        UNION ALL
        SELECT DISTINCT customer_id
        FROM   customers) A;
        
   
      
--  QUESTION 2 --
SELECT COUNT(*) AS "Number of Customers"
FROM   (SELECT DISTINCT customer_id
        FROM   customers
        MINUS
        SELECT DISTINCT customer_id
        FROM   orders) A; 
 

        
--  QUESTION 3 -- 
SELECT COUNT(*) AS "Report"
FROM   (SELECT DISTINCT customer_id
        FROM   customers
        INTERSECT
        SELECT DISTINCT customer_id
        FROM   orders)
UNION ALL
SELECT COUNT(*)
FROM   (SELECT DISTINCT employee_id
        FROM   employees
        INTERSECT
        SELECT DISTINCT salesman_id
        FROM   orders); 
        
        
        
--  QUESTION 4 --
SELECT first_name,
       SUBSTR (last_name, 1, 1) AS "First Letter of Last Name"
FROM   contacts
INTERSECT
SELECT first_name,
       SUBSTR (last_name, 1, 1)
FROM   employees;



--  QUESTION 5 --
-- Approach 1 (32 rows/ can not display 'NULL')
SELECT location_id,
       warehouse_id
FROM   warehouses
UNION
SELECT location_id,
       TO_NUMBER(NULL) AS warehouse_id
FROM   locations;



-- Approach 2 (23 rows/ use JOINs)
SELECT l.location_id,
       COALESCE(TO_CHAR(w.warehouse_id), 'NULL') AS warehouse_id
FROM   locations l
       left join warehouses w
              ON l.location_id = w.location_id; 




