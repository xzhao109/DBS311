 -- ***********************
-- Name: Xiaoyue Zhao
-- ID: 124899212
-- Date: Sep 18
-- Purpose: Lab 01 
-- Course Code: DBS311
-- Section Code: ZAA
-- ***********************


-- Q1 SOLUTION --
-- TO_CHAR ( value, format_mask, nls_language )
-- TO_CHAR(1340.64, '9999.9') => ' 1340.6'
SELECT TO_CHAR (( SYSDATE + 1 ), 'FMMonth DD"th of year" YYYY') AS "TOMORROW"
FROM   dual;
-- Advanced Option 
define tomorrow = SYSDATE + 1;
SELECT TO_CHAR ( & tomorrow, 'FMMonth DD"th of year" YYYY') AS "TOMORROW"
FROM   dual;
undefine tomorrow; 


-- Q2 SOLUTION --
-- TRUNC (number, decimal_places)
-- TRUNC (10.789) => 10
SELECT product_id,
       product_name,
       list_price,
       ROUND(list_price * 1.02) AS "NEW PRICE"
FROM   products
WHERE  list_price > 85
       AND list_price < 100
       AND category_id = 5
ORDER  BY product_id; 


-- Q3 SOLUTION --
SELECT first_name
       || ' '
       || last_name
       || ' with employee ID '
       || employee_id
       || ' works as '
       || job_title
       || '.' AS "EMPLOYEE INFO"
FROM   employees
WHERE  manager_id IS NULL
ORDER  BY employee_id; 


-- Q4 SOLUTION --
-- Round the number to 2 decimal places
-- SELECT ROUND(235.415, 2) AS RoundValue;
SELECT last_name,
       hire_date,
       ROUND(MONTHS_BETWEEN(current_date, hire_date))AS "MONTHS WORKED"
FROM   employees
WHERE  hire_date >= TO_DATE('16-DEC-01', 'YY-MON-DD')
ORDER  BY hire_date,
          employee_id; 
   

-- Q5 SOLUTION --
-- ADD_MONTHS ( date, number_months )
-- ADD_MONTHS ( ‘26-JUN-19’, 2) => ‘26-AUG-19’
-- NEXT_DAY ( date, weekday )
-- NEXT_DAY ( ‘26-JUN-19’, ‘SUNDAY’) => ‘30-AUG-19’
SELECT last_name,
       hire_date,
       TO_CHAR(( NEXT_DAY(ADD_MONTHS(hire_date, 3), 'Monday') ),
       'FMDAY"," Month" the" Ddsp "of year" YYYY') AS "REVIEW DAY"
FROM   employees
WHERE  hire_date < TO_DATE('16-JAN-25', 'YY-MON-DD')
ORDER  BY "REVIEW DAY",
          last_name; 
   
  
   
-- Q6 SOLUTION --
-- NVL() function achieves the same result
SELECT warehouse_id,
       warehouse_name,
       city,
       COALESCE(state, 'Unknown') AS "STATE"
FROM   warehouses s
       inner join locations l
               ON s.location_id = l.location_id
ORDER  BY warehouse_id; 

