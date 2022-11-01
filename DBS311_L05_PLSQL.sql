SET SERVEROUTPUT ON;

-- QUESTION 1 --
-- Approach 1 --
CREATE OR replace PROCEDURE test_string (string IN VARCHAR2)
AS
BEGIN
    dbms_output.PUT_LINE(UPPER(string)
                         ||' has '
                         || LENGTH(string)
                         ||' chracters.');
EXCEPTION
  WHEN OTHERS THEN
             dbms_output.PUT_LINE ('Error!');
END;
/   
BEGIN
    test_string('flower');
END; 


-- Approach 2 --
DECLARE
  string VARCHAR2(20) := 'flower';
BEGIN
  dbms_output.PUT_LINE(UPPER(string)
  ||' has '
  || LENGTH(string)
  ||' chracters.');
EXCEPTION
  WHEN OTHERS THEN
             dbms_output.PUT_LINE ('Error!');
END;



-- QUESTION 2 --
-- Approach 1 --
CREATE OR replace PROCEDURE info_employee (employeeId IN NUMBER)
AS
  workingYears NUMBER;
BEGIN
    SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date) / 12)
    INTO   workingYears
    FROM   employees
    WHERE  employee_id = employeeId;

    dbms_output.PUT_LINE ('The employee with ID '
                          || employeeId
                          || ' has worked '
                          || workingYears
                          || ' years.');
EXCEPTION
  WHEN no_data_found THEN
             dbms_output.PUT_LINE ('No Data Found!');
END;
/
BEGIN
    info_employee(1004);
END; 

-- Approach 2 --
DECLARE
    employeeId   NUMBER := 1004;
    workingYears NUMBER;
BEGIN
    SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date) / 12)
    INTO   workingYears
    FROM   employees
    WHERE  employee_id = employeeId;

    dbms_output.PUT_LINE ('The employee with ID '
                          || employeeId
                          || ' has worked '
                          || workingYears
                          || ' years.');
EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line ('No Data Found!');
END;



-- QUESTION 3 --
-- Approach 1 --
CREATE OR replace PROCEDURE find_product (productId IN NUMBER)
AS
  productName VARCHAR2(255 byte);
  price       NUMBER(9, 2);
  categoryName VARCHAR2(255 byte);
BEGIN
    SELECT p.product_name,
           p.list_price,
           pc.category_name
    INTO   productName, price, categoryName
    FROM   products p
           join product_categories pc
             ON p.category_id = pc.category_id
    WHERE  p.product_id = productId; 

    dbms_output.PUT_LINE ('Product Name: '
                          || productName);
                          
    dbms_output.PUT_LINE ('List Price: '
                          || price);   
                          
    dbms_output.PUT_LINE ('Category name: '
                          || categoryName);
EXCEPTION
  WHEN OTHERS THEN
             dbms_output.PUT_LINE ('Error!');
END;
/
BEGIN
    find_product(132);
END; 

-- Approach 2 --
DECLARE
    productId   NUMBER := 132;
    productName VARCHAR2(255 byte);
    price       NUMBER(9, 2);
    categoryName VARCHAR2(255 byte);
BEGIN
    SELECT p.product_name,
           p.list_price,
           pc.category_name
    INTO   productName, price, categoryName
    FROM   products p
           join product_categories pc
             ON p.category_id = pc.category_id
    WHERE  p.product_id = productId; 

    dbms_output.PUT_LINE ('Product Name: '
                          || productName);
                          
    dbms_output.PUT_LINE ('List Price: '
                          || price);   
                          
    dbms_output.PUT_LINE ('Category name: '
                          || categoryName);
EXCEPTION
  WHEN OTHERS THEN
             dbms_output.PUT_LINE ('Error!');
END;



-- QUESTION 4 --
CREATE TABLE new_products AS
SELECT *
FROM products;

-- Approach 1 --
CREATE OR replace PROCEDURE increase_price (category_id IN NUMBER, amount IN NUMBER)
AS
  price NUMBER(9, 2);
BEGIN
    SELECT AVG(list_price)
    INTO   price
    FROM   new_products
    WHERE  category_id = category_id;

    IF price < amount THEN
      UPDATE new_products
      SET    list_price = list_price * 1.02
      WHERE  category_id = category_id;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
      dbms_output.PUT_LINE ('Error!');
END;
/
BEGIN
    increase_price(2, 500.15);
END; 

-- Approach 2 --
DECLARE
    category_id NUMBER := 2;
    amount     NUMBER(9, 2) := 500.15;
    price      NUMBER(9, 2);
BEGIN
    SELECT AVG(list_price)
    INTO   price
    FROM   new_products
    WHERE  category_id = category_id;

    IF price < amount THEN
      UPDATE new_products
      SET    list_price = list_price * 1.02
      WHERE  category_id = category_id;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
      dbms_output.PUT_LINE ('Error!');
END; 



-- QUESTION 5 --
-- Approach 1 --
CREATE OR replace PROCEDURE category_status
AS
  avg_count  NUMBER := 0;
  high_count NUMBER := 0;
  low_count  NUMBER := 0;
  avg_credit NUMBER(8, 2);
  max_credit NUMBER(8, 2);
  min_credit NUMBER(8, 2);
BEGIN
    SELECT ROUND(AVG(credit_limit), 2),
           MAX(credit_limit),
           MIN(credit_limit)
    INTO   avg_credit, max_credit, min_credit
    FROM   customers;

    FOR c IN (SELECT credit_limit
              FROM   customers) LOOP
        IF c.credit_limit < ( ( avg_credit - min_credit ) / 2 ) THEN
          low_count := low_count + 1;
        ELSIF c.credit_limit > ( ( max_credit - avg_credit ) / 2 ) THEN
          high_count := high_count + 1;
        ELSE
          avg_count := avg_count + 1;
        END IF;
    END LOOP;

    dbms_output.PUT_LINE ('The number of customers with average credit limit: '
                          || avg_count);

    dbms_output.PUT_LINE ('The number of customers with high credit limit: '
                          || high_count);

    dbms_output.PUT_LINE ('The number of customers with low credit limit: '
                          || low_count);
END;
/
BEGIN
    category_status();
END; 

-- Approach 2 --
DECLARE
    avg_count  NUMBER := 0;
    high_count NUMBER := 0;
    low_count  NUMBER := 0;
    avg_credit NUMBER(8, 2);
    max_credit NUMBER(8, 2);
    min_credit NUMBER(8, 2);
BEGIN
    SELECT ROUND(AVG(credit_limit), 2),
           MAX(credit_limit),
           MIN(credit_limit)
    INTO   avg_credit, max_credit, min_credit
    FROM   customers;

    FOR c IN (SELECT credit_limit
              FROM   customers) LOOP
        IF c.credit_limit < ( ( avg_credit - min_credit ) / 2 ) THEN
          low_count := low_count + 1;
        ELSIF c.credit_limit > ( ( max_credit - avg_credit ) / 2 ) THEN
          high_count := high_count + 1;
        ELSE
          avg_count := avg_count + 1;
        END IF;
    END LOOP;

    dbms_output.PUT_LINE ('The number of customers with average credit limit: '
                          || avg_count);

    dbms_output.PUT_LINE ('The number of customers with high credit limit: '
                          || high_count);

    dbms_output.PUT_LINE ('The number of customers with low credit limit: '
                          || low_count);
END; 