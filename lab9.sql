 -- alter pluggable database pdb_lvo open;
 -- alter user LVO QUOTA UNLIMITED ON USERS;
 
-- 1.	Прочитайте задание полностью и выдайте своему пользователю необходимые права.
create user LVO identified by 2025;
GRANT CONNECT ,CREATE DATABASE LINK, CREATE SEQUENCE, CREATE TABLE, 
CREATE CLUSTER, CREATE SYNONYM, CREATE PUBLIC SYNONYM, CREATE VIEW , CREATE MATERIALIZED VIEW TO LVO;

-- 2.	Создайте временную таблицу, добавьте в нее данные и продемонстрируйте, как долго они хранятся. Поясните особенности работы с временными таблицами.

CREATE GLOBAL TEMPORARY TABLE LVO_TB ( ID NUMBER(5) PRIMARY KEY);

BEGIN
    FOR i IN 1..10 LOOP
    INSERT INTO LVO_TB(ID)VALUES(i);
    END LOOP;
END;

SELECT * FROM LVO_TB;


-- 3.	Создайте последовательность S1 (SEQUENCE), со следующими характеристиками: начальное значение 1000; приращение 10; нет минимального значения; нет максимального значения;
--      не циклическая; значения не кэшируются в памяти; хронология значений не гарантируется. 
 --     Получите несколько значений последовательности. Получите текущее значение последовательности.
 
 CREATE SEQUENCE S1 
    INCREMENT BY 10
    START WITH 1000
    NOMINVALUE
    NOMAXVALUE
    NOCYCLE
    NOCACHE
    NOORDER;
    
    SELECT S1.NEXTVAL, S1.NEXTVAL FROM DUAL;
    
    SELECT S1.CURRVAL FROM DUAL;
    
    SELECT * FROM SYS.USER_SEQUENCES;
 
-- 4.	Создайте последовательность S2 (SEQUENCE), со следующими характеристиками: начальное значение 10; приращение 10; максимальное значение 100; не циклическую.
 --      Получите все значения последовательности. Попытайтесь получить значение, выходящее за максимальное значение.
        CREATE SEQUENCE S2
            INCREMENT BY 10 
            START WITH 10
            MAXVALUE 100
            NOCYCLE;
        
        SELECT S2.NEXTVAL FROM DUAL;
        SELECT S2.CURRVAL FROM DUAL;   
    
 --5.	Создайте последовательность S3 (SEQUENCE), со следующими характеристиками: начальное значение 10; приращение -10; минимальное значение -100;
 -- не циклическую; гарантирующую хронологию значений. 
 -- Получите все значения последовательности. Попытайтесь получить значение, меньше минимального значения.
 
    CREATE SEQUENCE S3
        INCREMENT BY -10
        START WITH 10
        MAXVALUE 10
        MINVALUE -100
        NOCYCLE
        ORDER;
    
    SELECT S3.NEXTVAL FROM DUAL;
 
-- 6.	Создайте последовательность S4 (SEQUENCE), со следующими характеристиками: начальное значение 1; приращение 1; минимальное значение 10; 
--      циклическая; кэшируется в памяти 5 значений; хронология значений не гарантируется. 
--      Продемонстрируйте цикличность генерации значений последовательностью S4.

    CREATE SEQUENCE S4
        INCREMENT BY 1
        START WITH 1
        MAXVALUE 6
        MINVALUE 1
        CYCLE
        CACHE 5
        NOORDER;
    
    SELECT S4.NEXTVAL FROM DUAL;
        

-- 7.	Получите список всех последовательностей в словаре базы данных, владельцем которых является пользователь XXX.

   SELECT * FROM USER_SEQUENCES;
        

-- 8.	Создайте таблицу T1, имеющую столбцы N1, N2, N3, N4, типа NUMBER (20), кэшируемую и расположенную в буферном пуле KEEP.
--      С помощью оператора INSERT добавьте 7 строк, вводимое значение для столбцов 
--      должно формироваться с помощью последовательностей S1, S2, S3, S4.

        CREATE TABLE T1( 
        N1 NUMBER(20), 
        N2 NUMBER(20),
        N3 NUMBER(20),
        N4 NUMBER(20)) CACHE STORAGE(BUFFER_POOL KEEP);
        
        BEGIN
            FOR i IN 1..7 LOOP
                INSERT INTO T1(N1,N2,N3,N4)VALUES(S1.NEXTVAL,S2.CURRVAL,S3.NEXTVAL,S4.NEXTVAL);
            END LOOP;
        END;
            
        SELECT * FROM T1;

-- 9.	Создайте кластер ABC, имеющий hash-тип (размер 200) и содержащий 2 поля: X (NUMBER (10)), V (VARCHAR2(12)).
        CREATE CLUSTER ABC(
        X NUMBER(10),
        V VARCHAR(12)
        )
        HASHKEYS 200;
-- 10.	Создайте таблицу A, имеющую столбцы XA (NUMBER (10)) и VA (VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный столбец.

            CREATE TABLE A(
            XA NUMBER(10),
            VA VARCHAR2(12),
            XV CHAR(5)
            ) CLUSTER ABC(XA,VA);

-- 11.	Создайте таблицу B, имеющую столбцы XB (NUMBER (10)) и VB (VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный столбец.

        CREATE TABLE B(
        XB NUMBER(10),
        VB VARCHAR2(12),
        XV2 CHAR(5)
        ) CLUSTER ABC(XB,VB);
        

-- 12.	Создайте таблицу С, имеющую столбцы XС (NUMBER (10)) и VС (VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный столбец. 

        CREATE TABLE C (
        XC NUMBER(10),
        VC VARCHAR2(12),
        XV3 CHAR(5)
        ) CLUSTER ABC(XC,VC);
        
-- 13.	Найдите созданные таблицы и кластер в представлениях словаря Oracle.

        SELECT * FROM USER_TABLES;
        SELECT * FROM USER_CLUSTERS;
        SELECT * FROM USER_SEGMENTS;
        
-- 14.	Создайте частный синоним для таблицы XXX.С и продемонстрируйте его применение.

        CREATE SYNONYM T12 FOR LVO.C;
        SELECT * FROM T12;

-- 15.	Создайте публичный синоним для таблицы XXX.B и продемонстрируйте его применение.

        CREATE PUBLIC SYNONYM T11 FOR LVO.B;
        SELECT * FROM T11;

        


-- 16.	Создайте две произвольные таблицы A и B (с первичным и внешним ключами),'
--      заполните их данными, создайте представление V1, основанное на SELECT... FOR A inner join B. 
--      Продемонстрируйте его работоспособность.

        CREATE TABLE A(
        ID NUMBER(5) PRIMARY KEY,
        NAME VARCHAR(20) 
        )
        
        CREATE TABLE B(
        ID NUMBER(5) PRIMARY KEY,
        JOB VARCHAR(20) ,
        WID NUMBER(5),
        WNAME VARCHAR(20),
        CONSTRAINT FK_B
            FOREIGN KEY(WID)
            REFERENCES A(ID)
        );
        
        INSERT ALL 
            INTO A(ID,NAME) VALUES(1,'VLAD')
            INTO A(ID,NAME) VALUES(2,'DIMA')
            INTO A(ID,NAME) VALUES(3,'NIKITA')
            INTO A(ID,NAME) VALUES(4,'MASHA')
        SELECT * FROM DUAL;
        
        INSERT ALL
            INTO B(ID,JOB,WID,WNAME)VALUES(1,'TEACHER',2,'DIMA')
            INTO B(ID,JOB,WID,WNAME)VALUES(2,'FRONTEND DEV',1,'VLAD')
            INTO B(ID,JOB,WID,WNAME)VALUES(3,'BACKEND DEV',4,'MASHA')
        SELECT * FROM DUAL;
        
        SELECT * FROM A;
        SELECT * FROM B;
        
        
        CREATE VIEW V1
        AS 
        SELECT A.ID , B.WNAME , B.JOB FROM A
        INNER JOIN B ON A.ID = B.WID;
        
        SELECT * FROM V1;


-- 17.	На основе таблиц A и B создайте материализованное представление MV_XXX, которое имеет периодичность обновления 2 минуты. Продемонстрируйте его работоспособность.

        CREATE MATERIALIZED VIEW MV_LVO 
        REFRESH FORCE 
        START WITH SYSDATE 
        NEXT SYSDATE + INTERVAL '2' MINUTE
        ENABLE QUERY REWRITE
        AS
        SELECT A.ID , B.WNAME , B.JOB FROM A
        INNER JOIN B ON A.ID = B.WID;

        EXECUTE DBMS_MVIEW.REFRESH('MV_LVO');
        SELECT * FROM MV_LVO;
        

        insert INTO B(ID,JOB,WID,WNAME)VALUES(4,'BACKEND DEV',3,'NIKITA')
        COMMIT;
        DELETE FROM B WHERE ID = 4;
        

-- 18.	Создайте DBlink по схеме USER1-USER2 для подключения к другой базе данных (если ваша БД находится на сервере ORA12W, то надо подключаться к БД на сервере ORA12D, если вы работаете на своем сервере, то договоритесь с кем-то из группы). 
        CREATE DATABASE LINK LABPDB
        CONNECT TO TNA
        IDENTIFIED BY LabPDBUser
        USING '192.168.0.120:1521/labpdb';

-- 19.	Продемонстрируйте выполнение операторов SELECT, INSERT, UPDATE, DELETE, вызов процедур и функций с объектами удаленного сервера.
    
        select * from TEMP_T@LABPDB;
        
        INSERT INTO TEMP_T@LABPDB(ID,DATA)VALUES(1,'HELLO WORLD!');
        
        UPDATE TEMP_T@LABPDB SET DATA = 'BYE WORLD!' WHERE ID = 1;
        
        DELETE FROM TEMP_T@LABPDB WHERE ID = 1; 

drop sequence S1;
drop sequence S2;
drop sequence S3;
drop sequence S4;
DROP TABLE A;
DROP TABLE B;
DROP TABLE C;
DROP TABLE T1;
DROP SYNONYM T12;
DROP SYNONYM T11;
DROP VIEW V1;
DROP MATERIALIZED VIEW MV_LVO;
DROP DATABASE LINK LABPDB;





