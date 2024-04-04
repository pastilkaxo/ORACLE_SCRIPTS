-- 1:
BEGIN
NULL;
END;

--2
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;

-- 3:спецсимволы 

SELECT  KEYWORD FROM V$RESERVED_WORDS WHERE LENGTH = 1 AND KEYWORD != 'A';

-- 4:ключевые слова 

SELECT  KEYWORD FROM V$RESERVED_WORDS WHERE LENGTH > 1 AND KEYWORD != 'A' ORDER BY KEYWORD;

--5.1 •	объявление и инициализацию целых number-переменных;
--    •	арифметические действия над двумя целыми number-переменных, включая деление с остатком;


DECLARE  X NUMBER(5) := 3;
  Y NUMBER(10) := 10;
  Z NUMBER(10);
BEGIN
DBMS_OUTPUT.PUT_LINE('X = ' || x);
DBMS_OUTPUT.PUT_LINE('Y = ' || Y);
Z:= X + Y;
DBMS_OUTPUT.PUT_LINE('X+Y =  '|| Z ||'');
Z:= X - Y;
DBMS_OUTPUT.PUT_LINE('X-Y =  '|| Z ||'');
Z:= Y / X;
DBMS_OUTPUT.PUT_LINE('Y / X =  '|| Z ||'');
Z := TRUNC(Y/X);
DBMS_OUTPUT.PUT_LINE('ОСТАТОК:'||Z||'');
Z:= MOD(Y,X);
DBMS_OUTPUT.PUT_LINE('МОДУЛЬ:'||Z||'');
END;


-- 5.2
/*
•	объявление и инициализацию number-переменных с фиксированной точкой;
•	объявление и инициализацию number-переменных с фиксированной точкой и отрицательным масштабом (округление);
•	объявление number-переменных с точкой и применением символа E (степень 10) при инициализации/присвоении;
•	объявление и инициализацию переменных типа даты;
•	объявление и инициализацию символьных переменных различной семантики;
•	объявление и инициализацию BOOLEAN-переменных. 
*/

DECLARE 
    N1 NUMBER(10,2) := 8.3;
    N2 NUMBER(10,-2) := 123456789;
    N3 NUMBER := 5.23E-10;
    D1 DATE := SYSDATE;
    D2 TIMESTAMP := SYSTIMESTAMP;
    C1 CHAR(5) := 'VLAD';
    C2 NCHAR(10) := 'NIKITA';
    C3 VARCHAR2(10) := 'ORACLE';
    B1 BOOLEAN := TRUE;
BEGIN
DBMS_OUTPUT.PUT_LINE('N1:'||N1||'');
DBMS_OUTPUT.PUT_LINE('N2:'||N2||'');
DBMS_OUTPUT.PUT_LINE('N3:'||N3||'');
DBMS_OUTPUT.PUT_LINE('D1:'||TO_CHAR(D1)||'');
DBMS_OUTPUT.PUT_LINE('D2:'||TO_CHAR(D2)||'');
DBMS_OUTPUT.PUT_LINE('C1:'||C1||'');
DBMS_OUTPUT.PUT_LINE('C2:'||C2||'');
DBMS_OUTPUT.PUT_LINE('C3:'||C3||'');
DBMS_OUTPUT.PUT_LINE('C1:'||C1||'');
IF B1 THEN DBMS_OUTPUT.PUT_LINE('B1 : '||'true'); END IF;
END;

--      6. Разработайте анонимный блок PL/SQL содержащий объявление констант (VARCHAR2, CHAR, NUMBER).
--       Продемонстрируйте  возможные операции с константами.

DECLARE
    DEF1 CONSTANT VARCHAR2(10) := 'VLAD';
    DEF2 CONSTANT CHAR := 'O';
    DEF3 CONSTANT NUMBER := 10;
    N0 CHAR;
BEGIN
DBMS_OUTPUT.PUT_LINE('КОНКАТЕНАЦИЯ:' || DEF1 ||' ');
DBMS_OUTPUT.PUT_LINE('АРИФМЕТИКА:' || TO_CHAR(DEF3 +2)||' ');
N0 := DEF2;
DBMS_OUTPUT.PUT_LINE('ПРИСВОЕНИЕ:' || N0 ||' ');
END;


--  7. Разработайте АБ, содержащий объявления переменной с опцией %TYPE. Продемонстрируйте действие опции.

-- DROP TABLE TEST_10
CREATE TABLE TEST_10(
NAME CHAR(5),
AGE NUMBER(2)
);
INSERT INTO TEST_10(NAME,AGE)VALUES('ORCL',2);


DECLARE 
    NAME TEST_10.NAME%TYPE;
    ID TEST_10.AGE%TYPE;
BEGIN
NAME := 'VLAD';
DBMS_OUTPUT.PUT_LINE('ИМЯ:'||NAME||'');
ID := 1231313;
DBMS_OUTPUT.PUT_LINE('ID:'||ID||'');
EXCEPTION
    WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE('ERROR:'|| SQLERRM);
END;

-- 8. Разработайте АБ, содержащий объявления переменной с опцией %ROWTYPE. Продемонстрируйте действие опции.

DECLARE
    TEST TEST_10%ROWTYPE;
BEGIN
SELECT * INTO TEST FROM TEST_10 where TEST_10.AGE = 2;
DBMS_OUTPUT.PUT_LINE(TEST.NAME || ':' || TEST.AGE);
END;


-- 9. Разработайте АБ, демонстрирующий все возможные конструкции оператора IF .
declare 
    p1 pls_integer := 10;
    p2 pls_integer := 20;
    p3 pls_integer := 5;
BEGIN
    IF P2 > P1
    THEN
        DBMS_OUTPUT.PUT_LINE('P2 > P1');
    END IF;
    -------
    IF P1 < P3
    THEN
        DBMS_OUTPUT.PUT_LINE('P1 < P3');
    ELSE
        DBMS_OUTPUT.PUT_LINE('P1 > P3');
    END IF;
    ---------
    IF P1 + P3 >= P2
    THEN
        DBMS_OUTPUT.PUT_LINE('P1+P3 > P2');
    ELSIF P1 + P3 <= P2
    THEN
        DBMS_OUTPUT.PUT_LINE('P1 + P3 < P2');
    ELSE
        DBMS_OUTPUT.PUT_LINE('P1 + P3 = P3');
    END IF;
END;


-- 10. Разработайте АБ, демонстрирующий работу оператора CASE.

DECLARE 
    CASEP PLS_INTEGER := 10;
BEGIN
CASE 
    WHEN 1 > CASEP THEN DBMS_OUTPUT.PUT_LINE('1 >' || TO_CHAR(CASEP));
    WHEN 1 < CASEP THEN DBMS_OUTPUT.PUT_LINE('1 <' || TO_CHAR(CASEP)); 
END CASE;
----
CASE CASEP
  WHEN 1  THEN DBMS_OUTPUT.PUT_LINE(TO_CHAR(CASEP));
  WHEN 5  THEN DBMS_OUTPUT.PUT_LINE(TO_CHAR(CASEP));
  WHEN 10  THEN DBMS_OUTPUT.PUT_LINE(TO_CHAR(CASEP) || ' CURRENT');
END CASE;
END;

-- 11. Разработайте АБ, демонстрирующий работу оператора LOOP.

DECLARE 
    NUM INTEGER := 10;
BEGIN
LOOP
    NUM := NUM + 10;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(NUM));
EXIT WHEN NUM = 100;
END LOOP;
END;

-- 12. Разработайте АБ, демонстрирующий работу оператора WHILE.

DECLARE 
    NUM INTEGER := 10;
BEGIN
WHILE (NUM < 100)
LOOP
    NUM := NUM + 10;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(NUM));
END LOOP;
END;

-- 13. Разработайте АБ, демонстрирующий работу оператора FOR.

DECLARE 
    NUM INTEGER := 10;
BEGIN
FOR i in 1 .. NUM
LOOP
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(i));
END LOOP;
END;



