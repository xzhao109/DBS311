-- *********************** 
-- Student1 Name: Yu Hsin Fang    Student1 ID: 159633213
-- Student2 Name: Truong An Huynh Student2 ID: 123194219 
-- Student3 Name: Xiaoyue Zhao    Student3 ID: 124899212 
-- Date: The date of assignment completion 
-- Purpose: Assignment 1 - DBS311 
-- *********************** 

-- Question 1 - Write a query to display employee ID, first name, last name, 
-- and hire date for employees who have been hired after the last employee 
-- hired in August 2016 but two months before the first employee hired in 
-- December 2016. Sort the result by hire date and employee ID.
-- Q1 SOLUTION �
SELECT employee_id, first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '2016-08-31' AND '2016-10-01'
ORDER BY hire_date, employee_id;

EMPLOYEE_ID FIRST_NAME LAST_NAME HIRE_DATE 
----------- ---------- --------- ---------
        101 Annabelle  Dunn       16-09-17                                                                                                                                                                                                                                                                                                                                                                                                                                                            
          2 Jude       Rivera     16-09-21
         11 Tyler      Ramirez    16-09-28                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
         27 Kai        Long       16-09-28                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
         12 Elliott    James      16-09-30                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
         46 Ava        Sullivan   16-10-01


-- Question 2 - Display manager ID for managers with more than one employee. 
-- Answer this question without using the COUNT()function. Sort the result by 
-- manager ID.
-- Q2 SOLUTION �
SELECT DISTINCT manager_id AS "Manager ID"
FROM employees
HAVING SUM(1) > 1
GROUP BY manager_id
ORDER BY manager_id;

Manager ID
----------
         1
         2
         4
         9
        15
        21
        22
        23
        24
        25
        46
        47
        48
        49
        50


-- Question 3 - Use the previous query and SET Operator(s) to display manager 
-- ID for managers who have only one employee. Sort the result by manager ID.
-- Q3 SOLUTION �
SELECT DISTINCT manager_id AS "Manager ID"
FROM employees
WHERE manager_id NOT IN
   (SELECT DISTINCT manager_id
    FROM employees
    GROUP BY manager_id
    HAVING SUM(1) > 1)
ORDER BY manager_id;


Manager ID
----------
         3
       102
       106


-- Question 4 - Write a SQL query to display products that have been ordered 
-- multiple times in one day in 2016. Display product ID, order date, and the 
-- number of times the product has been ordered on that day. Sort the result by 
-- order date and product ID.
-- Q4 SOLUTION --
SELECT DISTINCT oi.product_id AS "Product ID", o.order_date AS "Order Date", COUNT(oi.quantity) AS "Number of orders"
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE order_date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY o.order_date, oi.product_id
HAVING COUNT(*)>1
ORDER BY o.order_date, oi.product_id;

Product ID     Order Date     Number of orders
----------     ----------     ----------------
       163       16-06-13                    2
        71       16-08-16                    2
        93       16-08-16                    2
        62       16-08-24                    2
         1       16-11-29                    2
        96       16-11-29                    2


-- Question 5 � Write a query to display customer ID and customer name for 
-- customers who have purchased all these three products: Products with ID 7, 
-- 40, 94. Sort the result by customer ID.
-- Q5 SOLUTION --
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

CUSTOMER_ID NAME                                                                                                                                                                                                                                                           
----------- -------------------------
          6 Community Health Systems


-- Question 6 � Write a query to display employee ID and the number of orders 
-- for employees with the maximum number of orders (sales). Sort the result by 
-- employee ID.
-- Q6 SOLUTION --
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

EMPLOYEE_ID Number of Orders
----------- ----------------
         62               13


-- Question 7 � Write a query to display the month number, month name, year, 
-- total number of orders, and total sales amount for each month in 2017. Sort 
-- the result according to month number.
-- Q7 SOLUTION --
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

Mo Month     Year Total Number of Orders Sales Amount
-- --------- ---- ---------------------- ------------
01 January   2017                     31     23938.79
02 February  2017                     85     84355.55
03 March     2017                     25     27279.53
04 April     2017                     13      7512.22
05 May       2017                     26     14345.55
06 June      2017                      7      8225.95
08 August    2017                     38     28881.85
09 September 2017                     25     18693.24
10 October   2017                     22     19245.91
11 November  2017                      2       2693.1


-- Question 8 � Write a query to display month number, month name, and average 
-- sales amount for months with the average sales amount greater than average 
-- sales amount in 2017. Round the average amount to two decimal places. Sort 
-- the result by the month number.
-- Q8 SOLUTION --
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

Mo Month     Year Average Sales Amount
-- --------- ---- --------------------
02 February  2017               992.42
03 March     2017              1091.18
06 June      2017              1175.14
10 October   2017               874.81
11 November  2017              1346.55


-- Question 9 � Write a query to display first names in EMPLOYEES that start 
-- with letter B but do not exist in CONTACTS. Sort the result by first name.
-- Q9 SOLUTION --
SELECT first_name
FROM employees WHERE first_name like 'B%'
MINUS
SELECT first_name
FROM contacts WHERE first_name like 'B%'
ORDER BY first_name;

FIRST_NAME                                                                                                                                                                                                                                                     
-----------
Bella
Blake


-- Question 10 � Write a query to calculate the values corresponding to each 
-- line and generate the following output including the calculated values.
-- Q10 SOLUTION --
SELECT 'The number of employees with total order amount over average order amount: ' ||
COUNT(COUNT(salesman_id)) AS "REPORT"
FROM
      (SELECT orders.salesman_id, order_items.order_id, order_items.quantity, order_items.unit_price, ( order_items.quantity * order_items.unit_price) AS total
      FROM orders
      INNER JOIN order_items ON orders.order_id = order_items.order_id)
WHERE salesman_id IS NOT NULL
GROUP BY salesman_id
HAVING SUM(total) > AVG(total)
      
UNION ALL
SELECT 'The number of employees with total number of orders greater than 10: ' ||
COUNT(COUNT(salesman_id)) AS "REPORT"
FROM orders 
WHERE salesman_id IS NOT NULL
GROUP BY salesman_id 
HAVING COUNT(order_id) > 10

UNION ALL
SELECT 'The number of employees with no order: ' || 
      ((SELECT COUNT(DISTINCT employee_id) FROM employees)
      - (SELECT COUNT(DISTINCT salesman_id) FROM orders))
      AS "REPORT"
FROM dual

UNION ALL
SELECT 'The number of employees with orders: ' || COUNT(DISTINCT SALESMAN_ID) AS "REPORT"
FROM orders;

The number of employees with total order amount over average order amount: 9
The number of employees with total number of orders greater than 10: 2
The number of employees with no order: 98
The number of employees with orders: 9

