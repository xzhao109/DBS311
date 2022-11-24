SET SERVEROUTPUT ON;

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



