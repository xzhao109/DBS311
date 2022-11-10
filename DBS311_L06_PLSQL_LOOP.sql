SET SERVEROUTPUT ON;

-- QUESTION 1 --
CREATE OR replace PROCEDURE calculate_factorial(n IN NUMBER)
AS
  factorial NUMBER := 1;
BEGIN
    FOR i IN 1..n LOOP
        factorial := factorial * i;
    END LOOP;

    IF n < 2 THEN
      dbms_output.PUT_LINE (n || '! = ' || factorial);
    END IF;
EXCEPTION
  WHEN OTHERS THEN
             dbms_output.PUT_LINE ('Error!');
END;
/
BEGIN
    calculate_factorial(1);
END; 


-- QUESTION 2 --
DECLARE
    employeeId NUMBER := 99;
    counter    NUMBER := 0;
    salary     NUMBER(9,2) := 10000;
    fname      VARCHAR2(255 byte);
    lname      VARCHAR2(255 byte);
    years      NUMBER := 0;
BEGIN
    SELECT first_name,
           last_name,
           FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date) / 12)
    INTO   fname, lname, years
    FROM   employees
    WHERE  employee_id = employeeId;

    LOOP
        counter := counter + 1;
        salary := salary * 1.05;
        EXIT WHEN counter > years;
    END LOOP;

    dbms_output.PUT_LINE ('First Name: ' || fname);
    dbms_output.PUT_LINE ('Last Name: ' || lname);
    dbms_output.PUT_LINE ('Salary: $' || salary);
EXCEPTION
  WHEN too_many_rows THEN
             dbms_output.PUT_LINE ('Too Many Rows Returned!');
END;
-- Approach 2 can not work --
CREATE OR replace PROCEDURE calculate_salary (employeeId IN NUMBER)
AS
  counter    NUMBER := 0;
  salary     NUMBER(9,2) := 10000;
  fname      VARCHAR2(255 byte);
  lname      VARCHAR2(255 byte);
  years      NUMBER := 0;
BEGIN
    SELECT first_name,
           last_name,
           FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date) / 12)
    INTO   fname, lname, years
    FROM   employees
    WHERE  employee_id = employeeId;

    LOOP
        counter := counter + 1;
        salary := salary * 1.05;
        EXIT WHEN counter > years;
    END LOOP;

    dbms_output.PUT_LINE ('First Name: ' || fname);
    dbms_output.PUT_LINE ('Last Name: ' || lname);
    dbms_output.PUT_LINE ('Salary: $' || salary);
EXCEPTION
  WHEN too_many_rows THEN
             dbms_output.PUT_LINE ('Too Many Rows Returned!');
END;
/
BEGIN
    calculate_salary(12);
END;


-- QUESTION 3 --
DECLARE
    id      NUMBER;
    name    VARCHAR2(255 byte);
    city    VARCHAR2(255 byte);
    state   VARCHAR2(255 byte);
BEGIN
    FOR i IN (SELECT warehouse_id
              FROM   warehouses) LOOP

        SELECT W.warehouse_id,
               W.warehouse_name,
               L.city,
               NVL(L.state, 'no state')
        INTO   id, name, city, state
        FROM   warehouses w
               JOIN locations l
                 ON w.location_id = L.location_id
        WHERE  w.warehouse_id = i.warehouse_id;

        dbms_output.Put_line ('Warehouse ID: '|| id);
        dbms_output.Put_line ('Warehouse Name: '|| name);
        dbms_output.Put_line ('City: '|| city);
        dbms_output.Put_line ('State: '|| state);
        dbms_output.Put_line ('');
    END LOOP;
EXCEPTION
  WHEN too_many_rows THEN
             dbms_output.PUT_LINE ('Too Many Rows Returned!');
END;
----
CREATE OR replace PROCEDURE warehouses_report
AS
  id    NUMBER;
  name  VARCHAR2(255 byte);
  city  VARCHAR2(255 byte);
  state VARCHAR2(255 byte);
BEGIN
    FOR i IN (SELECT warehouse_id
              FROM   warehouses) LOOP
        SELECT W.warehouse_id,
               W.warehouse_name,
               L.city,
               NVL(L.state, 'no state')
        INTO   id, name, city, state
        FROM   warehouses w
               join locations l
                 ON w.location_id = L.location_id
        WHERE  w.warehouse_id = i.warehouse_id;

        dbms_output.PUT_LINE ('Warehouse ID: ' || id);
        dbms_output.PUT_LINE ('Warehouse Name: ' || name);
        dbms_output.PUT_LINE ('City: ' || city);
        dbms_output.PUT_LINE ('State: ' || state);
        dbms_output.PUT_LINE ('');
    END LOOP;
EXCEPTION
  WHEN too_many_rows THEN
             dbms_output.PUT_LINE ('Too Many Rows Returned!');
END;
/
BEGIN
    warehouses_report();
END;  


