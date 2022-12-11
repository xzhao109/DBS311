-- *********************** 
-- Student1 Name: Yu Hsin Fang    Student1 ID: 159633213
-- Student2 Name: Truong An Huynh Student2 ID: 123194219 
-- Student3 Name: Xiaoyue Zhao    Student3 ID: 124899212 
-- Date: 2022/12/07
-- Purpose: Assignment 2 - DBS311 
-- *********************** 

SET SERVEROUTPUT ON
/
--Q1: This procedure has an input parameter to receive the customer ID and an output parameter named found.
--This procedure looks for the given customer ID in the database. If the customer exists, it sets the variable found to 1. Otherwise, the found variable is set to 0.--

CREATE OR REPLACE PROCEDURE find_customer(c_id IN NUMBER, found OUT NUMBER) AS    
BEGIN   
    SELECT customer_id
    INTO found
    FROM customers c
    WHERE customer_id=c_id;
    --DBMS_OUTPUT.PUT_LINE ('ID: ' || found);
    IF found IS NOT NULL THEN
    found := 1;
    END  IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN    
    found := 0;
    DBMS_OUTPUT.PUT_LINE ('The customer does not exist.'||found);
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('Error!');
END;

/
DECLARE
   found NUMBER;
BEGIN
    find_customer(44,found);
    DBMS_OUTPUT.PUT_LINE ('found: '||found);
END;
/

--Q2:This procedure has an input parameter to receive the product ID and an output parameter named price.--
CREATE OR REPLACE PROCEDURE find_product (productID   IN NUMBER,
                                          price       OUT products.list_price%TYPE,
                                          productName OUT products.PRODUCT_NAME%TYPE)
AS
BEGIN
    SELECT list_price, product_name
    INTO   price, productName
    FROM   products
    WHERE  product_id = productID;
--DBMS_OUTPUT.PUT_LINE ('price: ' || price);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
             price := 0;
  --DBMS_OUTPUT.PUT_LINE ('The product does not exist.'||price);
  WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE ('Error!');
END;
/
DECLARE
    price NUMBER(9, 2) := 0;
    name  VARCHAR2(255 BYTE);
BEGIN
    find_product(115, price, name);
    DBMS_OUTPUT.PUT_LINE ('price: '||price);
    DBMS_OUTPUT.PUT_LINE ('name: '||name);
END;
/

--Q3: This procedure has an input parameter to receive the customer ID and an output parameter named new_order_id.--
CREATE OR REPLACE PROCEDURE add_order(c_id IN NUMBER, new_order_id OUT NUMBER) AS
    max_id orders.order_id%TYPE;
BEGIN
    SELECT MAX(order_id)
    INTO max_id
    FROM orders;
    new_order_id := max_id+1;
    INSERT INTO orders
    (order_id, customer_id, status, salesman_id, order_date)
    VALUES
    (new_order_id,c_id,'Shipped',56,SYSDATE);
EXCEPTION    
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('Error!');
END;

/
DECLARE
   new_order_id NUMBER := 0;
BEGIN
    add_order(44, new_order_id);    
END;
/

--Q4: This is an Oracle function with no parameters. It finds the maximum order ID in the orders table and increase it by 1 as new order ID. The function returns the new order ID to the caller.--
create or replace function generate_order_id 
return number
as
  new_order_id number;
begin
  select max(order_id) into new_order_id from orders;
  new_order_id := new_order_id + 1;
  return new_order_id;
end;
/


-- PROCEDURE 5
-- This procedure has five IN parameters. It stores the values of these parameters to the table order_items. 
CREATE OR REPLACE PROCEDURE add_order_item (orderId IN order_items.order_id % type, 
                                            itemId IN order_items.item_id % type, 
                                            productId IN order_items.product_id % type, 
                                            quantity IN order_items.quantity % type, 
                                            price IN order_items.unit_price % type) 
AS 
BEGIN
   INSERT INTO order_items(order_id, item_id, product_id, quantity, unit_price) 
   VALUES ( orderId, itemId, productId, quantity, price );
EXCEPTION 
  WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE ('Error!');
END;
/ 
BEGIN
   add_order_item(99, 99, 99, 99, 99.99);
END;

-- remove test data
DELETE FROM order_items
WHERE  order_id = 99
       AND order_id = 99
       AND item_id = 99
       AND product_id = 99
       AND quantity = 99
       AND unit_price = 99.99; 
/

-- PROCEDURE 6
-- This procedure receives two values as customer ID and Order ID and confirms if there exists any order with this order ID for this customer in the orders table. 
-- If the order ID with this customer ID exists, the procedure passes the order ID to the caller. Otherwise, it passes 0 to the caller. 
CREATE OR REPLACE PROCEDURE customer_order (customerId IN NUMBER,
                                            orderId    IN OUT NUMBER)
AS
  counter NUMBER := 0;
BEGIN
    FOR i IN (SELECT order_id
              FROM   orders
              WHERE  customer_id = customerId) LOOP
        IF i.order_id = orderId THEN
          counter := counter + 1;
        END IF;
    END LOOP;
    IF counter = 0 THEN
      orderId := 0;
    END IF;
EXCEPTION
  WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE ('Error!');
END;
/
DECLARE
    customerId NUMBER := 9;
    orderId    NUMBER := 9;
BEGIN
    customer_order(customerId, orderId);
    DBMS_OUTPUT.PUT_LINE('Customer ID ' || customerId || ' with Order ID is ' || orderId);
END;
/


-- PROCEDURE 7
-- This procedure has an input parameter to receive an order ID and an output parameter to pass the status of the order to the caller. 
-- IF the receiving order ID exists, the procedure stores the order status in the status variable. If the order ID does not exists, store null in the status variable.
CREATE OR REPLACE PROCEDURE display_order_status (orderId IN NUMBER,
                                                  status  OUT orders.status%TYPE)
AS
BEGIN
    FOR i IN (SELECT status
              FROM   orders
              WHERE  order_id = orderId) LOOP
        IF i.status IS NOT NULL THEN
          status := i.status;
        END IF;
    END LOOP;
    IF status IS NULL THEN
      status := 'null';
    END IF;
EXCEPTION
  WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE ('Error!');
END;
/
DECLARE
    orderId NUMBER := 9;
    status  orders.status%TYPE;
BEGIN
    display_order_status(orderId, status);
    DBMS_OUTPUT.PUT_LINE('Status is ' || status);
END; 
/


-- PROCEDURE 8
-- This procedure has an input parameter to receive an order ID and an output parameter to pass a value to the caller. 
-- IF the receiving order ID exists, the procedure stores the value of the column status in a variable orderStatus. 
-- If orderStatus is ‘Canceled’, the procedure stores 1 in to the parameter cancelStatus. 
-- If the orderStatus is shipped, the procedure stores 2 in to the parameter cancelStatus. 
-- Otherwise, it stores 3 in to the parameter cancelStatus and updates the status of that order to “Canceled”. 
-- If the order ID does not exists, it stores 0 in the cancel variable.
CREATE OR REPLACE PROCEDURE cancel_order (orderId      IN NUMBER,
                                          cancelStatus OUT NUMBER)
AS
BEGIN
    FOR i IN (SELECT status
              FROM   orders
              WHERE  order_id = orderId) LOOP
        IF i.status = 'Canceled' THEN
          cancelStatus := 1;
        ELSIF i.status = 'Shipped' THEN
          cancelStatus := 2;
        ELSE
          cancelStatus := 3;
          i.status := 'Canceled';
        END IF;
    END LOOP;
    IF cancelstatus IS NULL THEN
      cancelStatus := 0;
    END IF;
EXCEPTION
  WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE ('Error!');
END;
/
DECLARE
    orderId      NUMBER := 100;
    cancelStatus NUMBER;
BEGIN
    CANCEL_ORDER(orderId, cancelStatus);
    -- DBMS_OUTPUT.PUT_LINE('cancelStatus is ' || cancelstatus);
END; 
/


