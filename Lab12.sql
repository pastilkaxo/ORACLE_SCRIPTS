 --  alter pluggable database pdb_lvo open;

 
--1. �������� � ������� TEACHERS ��� ������� BIRTHDAY � SALARY, ��������� �� ����������.

 alter table TEACHER add BIRTHDAY date;
 ALTER TABLE TEACHER ADD SALARY DECIMAL(10,2);
 
 UPDATE TEACHER SET 
    BIRTHDAY = TO_DATE('2004/04/25','YYYY/MM/DD'),
    SALARY = 1250.99
    WHERE 
    PULPIT LIKE '��%';
 
 UPDATE TEACHER SET 
    BIRTHDAY = TO_DATE('2024/04/22','YYYY/MM/DD'),
    SALARY = 1550.99
    WHERE 
    PULPIT LIKE '��%';

 UPDATE TEACHER SET 
    BIRTHDAY = TO_DATE('2004/05/25','YYYY/MM/DD'),
    SALARY = 1350.99
    WHERE 
    PULPIT LIKE '�%';
    
 UPDATE TEACHER SET 
    BIRTHDAY = TO_DATE('1991/07/12','YYYY/MM/DD'),
    SALARY = 2250.99
    WHERE 
    PULPIT LIKE '�%';
 
  UPDATE TEACHER SET 
    BIRTHDAY = TO_DATE('2000/11/23','YYYY/MM/DD'),
    SALARY = 1850.99
    WHERE 
    PULPIT LIKE '�%';
 
  UPDATE TEACHER SET 
    BIRTHDAY = TO_DATE('1991/07/12','YYYY/MM/DD'),
    SALARY = 1145.99
    WHERE 
    PULPIT LIKE '�%' OR PULPIT LIKE '�%';
    
  UPDATE TEACHER SET 
    BIRTHDAY = TO_DATE('1950/04/01','YYYY/MM/DD'),
    SALARY = 1145.99
    WHERE 
    PULPIT LIKE '�%';
    
 SELECT * FROM TEACHER;
 



--2. �������� ������ �������������� � ���� ������� �.�. ��� ��������������, ���������� � �����������.

DECLARE
    CURSOR TEACHER_CURS IS SELECT 
    REGEXP_SUBSTR(TEACHER_NAME,'[^ ]+',1,1) SURNAME,
    REGEXP_SUBSTR(TEACHER_NAME,'[^ ]+',1,2) NAME,
    REGEXP_SUBSTR(TEACHER_NAME,'[^ ]+',1,3) FATHERNAME,
    BIRTHDAY FROM TEACHER WHERE  TO_CHAR(BIRTHDAY,'D') = 1;
    
    NAME TEACHER.TEACHER_NAME%TYPE;
    SURNAME TEACHER.TEACHER_NAME%TYPE;
    FATHERNAME TEACHER.TEACHER_NAME%TYPE;
    BRTH TEACHER.BIRTHDAY%TYPE;
BEGIN
    OPEN TEACHER_CURS;
        FETCH TEACHER_CURS INTO SURNAME,NAME,FATHERNAME,BRTH;
        WHILE TEACHER_CURS%FOUND
        LOOP
            DBMS_OUTPUT.PUT_LINE(SURNAME || ' ' || SUBSTR(NAME,1,1)
            || '.' || SUBSTR(FATHERNAME,1,1) || '.' || ' : ' || BRTH);
            FETCH TEACHER_CURS INTO NAME,SURNAME,FATHERNAME,BRTH;
        END LOOP;
    CLOSE TEACHER_CURS;
END;

--3. �������� �������������, � ������� ��������� ������ ��������������, 
--   ������� �������� � ��������� ������ � �������� �� ���� �������� � ������� �DD/MM/YYYY�.

    CREATE VIEW NEXT_MONTH_TEACHER AS
    SELECT TO_CHAR(BIRTHDAY,'DD/MM/YYYY') AS BIRTH FROM TEACHER  WHERE  EXTRACT(MONTH FROM SYSDATE) + 1 = EXTRACT(MONTH FROM BIRTHDAY) ;

    SELECT * FROM NEXT_MONTH_TEACHER;

--4. �������� �������������, � ������� ��������� ���������� ��������������,
--   ������� �������� � ������ ������, �������� ������ ������� ������.

  CREATE VIEW EVERY_BIRTH AS
  SELECT TO_CHAR(BIRTHDAY,'Month')  AS BIRTH, COUNT(TEACHER) AS COUNT FROM TEACHER GROUP BY TO_CHAR(BIRTHDAY,'Month') ;

    SELECT * FROM EVERY_BIRTH;


--5. ������� ������ � ������� ������ ��������������, 
-- � ������� � ��������� ���� ������ � ���������, ������� ��� �����������.

DECLARE 
    CURSOR AGE_CURS IS SELECT TEACHER_NAME , BIRTHDAY FROM TEACHER 
    WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM BIRTHDAY) = 24 OR EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM BIRTHDAY) = 49 OR EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM BIRTHDAY) = 74  ;
    AGE TEACHER.BIRTHDAY%TYPE;
    NAME TEACHER.TEACHER_NAME%TYPE;
BEGIN
OPEN AGE_CURS;
    FETCH AGE_CURS INTO NAME,AGE;
    WHILE AGE_CURS%FOUND
    LOOP
            DBMS_OUTPUT.PUT_LINE( '���: '|| NAME || '; ' || '����������: ' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM AGE) + 1) );
            FETCH AGE_CURS INTO NAME,AGE;
    END LOOP;
CLOSE AGE_CURS;
END;


--6. ������� ������ � ������� ������� ���������� ����� �� �������� � ����������� ���� �� �����, 
--   ������� ������� �������� �������� ��� ������� ���������� � ��� ���� ����������� � �����.

DECLARE 
    CURSOR AVG_CURS IS SELECT FACULTY.FACULTY, FLOOR(AVG(TEACHER.SALARY))  , PULPIT.PULPIT FROM TEACHER 
    INNER JOIN PULPIT ON PULPIT.PULPIT = TEACHER.PULPIT
    INNER JOIN FACULTY ON FACULTY.FACULTY = PULPIT.FACULTY
    GROUP BY ROLLUP(FACULTY.FACULTY ,PULPIT.PULPIT);
    AVEG TEACHER.SALARY%TYPE;
    FAC FACULTY.FACULTY%TYPE;
    PULP PULPIT.PULPIT%TYPE;
BEGIN
    OPEN AVG_CURS;
        FETCH AVG_CURS INTO  FAC , AVEG ,PULP;
        WHILE AVG_CURS%FOUND 
        LOOP
            DBMS_OUTPUT.PUT_LINE(NVL(RTRIM(FAC),'� �����') || ' ' ||  RTRIM(PULP) || ' : ' || AVEG);
            FETCH AVG_CURS INTO  FAC , AVEG ,PULP;
        END LOOP;
    CLOSE AVG_CURS;
END;


--7. ������� ������������� ���� ��� ������� ���������� ������� ���� ����������. 
--�������� ��������� �������� � �������� �� 0 ����� ���������� ZERO_DIVIDE. 
--������������� ���������������� ������ ��� �������� �������� 0.

DECLARE
    my_exception EXCEPTION;
    NUM1 NUMBER;
    NUM2 NUMBER;
    RESULT NUMBER;
BEGIN
    NUM1 := 10;
    NUM2 := 0;
    if num2 = 0 then raise my_exception;
    end if;
    RESULT := NUM1 / NUM2;
    DBMS_OUTPUT.PUT_LINE('RESULT: ' || RESULT);
    EXCEPTION
        when my_exception then
        dbms_output.put_line('NUM2 is 0');
        WHEN zero_divide THEN 
        dbms_output.put_line('ZERO_DIVIDE: '||sqlerrm);
END;

--8. ������� ������������� ���� � �������� SELECT�INTO ��� ������ ������������ ������������� �� ��������� ����.
-- �������� ��������� ���������� NO_DATA_FOUND � ������� ���������� '������������� �� ������!'.
-- ���������, ��� ���������� ��� ��������������� ����������.

DECLARE
    CODE TEACHER.TEACHER%TYPE;
    T TEACHER%ROWTYPE;
    NO_DATA_FOUND EXCEPTION;
BEGIN
    CODE := '������WEFW';
    SELECT * INTO T FROM TEACHER WHERE TEACHER = CODE;
     dbms_output.put_line('TEACHER_NAME: ' || T.TEACHER_NAME);
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
             dbms_output.put_line('������������� �� ������!');
        WHEN OTHERS THEN
             dbms_output.put_line('NO_DATA_FOUND!');
END;

--9. ������� �������� � ��������� ����.
--�������� � ��� ���������� � ������� �������, ������� � ����� ������ -20 001 � ������� PRAGMA
--EXCEPTION_INIT. ������������� ���������� �� ��������� �����,
--���������� ��� � ��������. ��������� ��������, ����� ���������� �� ������� � �����
--������ � ����� ���������� ������������.

-- 1:
DECLARE
    EX1 EXCEPTION;
    PRAGMA EXCEPTION_INIT(EX1,-20001);
    EX2 EXCEPTION;
    PRAGMA EXCEPTION_INIT(EX2 , -20001);
BEGIN
    BEGIN
    DBMS_OUTPUT.PUT_LINE('BLOCK-2');
    RAISE EX2;
    END;
    DBMS_OUTPUT.PUT_LINE('BLOCK-1');
    EXCEPTION
        WHEN EX2 THEN
          DBMS_OUTPUT.PUT_LINE('BLOCK-1 ---> EX2');
END;


-- 2:
DECLARE
    EX1 EXCEPTION;
BEGIN
    DECLARE 
        EX1 EXCEPTION;
    BEGIN
    DBMS_OUTPUT.PUT_LINE('BLOCK-2');
    RAISE EX1;
        EXCEPTION
        WHEN EX1 THEN
          DBMS_OUTPUT.PUT_LINE('BLOCK-2 ---> EX1');
    END;
    DBMS_OUTPUT.PUT_LINE('BLOCK-1');
    RAISE EX1;
    EXCEPTION
        WHEN EX1 THEN
          DBMS_OUTPUT.PUT_LINE('BLOCK-1 ---> EX2');
END;



--10. ���������, ������������ �� ���������� NO_DATA_FOUND � ������� SELECT�INTO � PL/SQL 
--     ����� � �������������� ��������� �������, �������� MAX.

DECLARE 
    S TEACHER.SALARY%TYPE;
BEGIN
    SELECT MAX(SALARY) INTO S FROM TEACHER WHERE TEACHER = '$$$$$$';
    dbms_output.put_line('MAX: ' || S);
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('NO MAX VALUE');
END;
 