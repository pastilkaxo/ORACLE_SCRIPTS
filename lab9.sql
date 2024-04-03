 -- alter pluggable database pdb_lvo open;
 -- alter user LVO QUOTA UNLIMITED ON USERS;
 
-- 1.	���������� ������� ��������� � ������� ������ ������������ ����������� �����.
create user LVO identified by 2025;
GRANT CONNECT ,CREATE DATABASE LINK, CREATE SEQUENCE, CREATE TABLE, 
CREATE CLUSTER, CREATE SYNONYM, CREATE PUBLIC SYNONYM, CREATE VIEW , CREATE MATERIALIZED VIEW TO LVO;

-- 2.	�������� ��������� �������, �������� � ��� ������ � �����������������, ��� ����� ��� ��������. �������� ����������� ������ � ���������� ���������.

CREATE GLOBAL TEMPORARY TABLE LVO_TB ( ID NUMBER(5) PRIMARY KEY);

BEGIN
    FOR i IN 1..10 LOOP
    INSERT INTO LVO_TB(ID)VALUES(i);
    END LOOP;
END;

SELECT * FROM LVO_TB;


-- 3.	�������� ������������������ S1 (SEQUENCE), �� ���������� ����������������: ��������� �������� 1000; ���������� 10; ��� ������������ ��������; ��� ������������� ��������;
--      �� �����������; �������� �� ���������� � ������; ���������� �������� �� �������������. 
 --     �������� ��������� �������� ������������������. �������� ������� �������� ������������������.
 
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
 
-- 4.	�������� ������������������ S2 (SEQUENCE), �� ���������� ����������������: ��������� �������� 10; ���������� 10; ������������ �������� 100; �� �����������.
 --      �������� ��� �������� ������������������. ����������� �������� ��������, ��������� �� ������������ ��������.
        CREATE SEQUENCE S2
            INCREMENT BY 10 
            START WITH 10
            MAXVALUE 100
            NOCYCLE;
        
        SELECT S2.NEXTVAL FROM DUAL;
        SELECT S2.CURRVAL FROM DUAL;   
    
 --5.	�������� ������������������ S3 (SEQUENCE), �� ���������� ����������������: ��������� �������� 10; ���������� -10; ����������� �������� -100;
 -- �� �����������; ������������� ���������� ��������. 
 -- �������� ��� �������� ������������������. ����������� �������� ��������, ������ ������������ ��������.
 
    CREATE SEQUENCE S3
        INCREMENT BY -10
        START WITH 10
        MAXVALUE 10
        MINVALUE -100
        NOCYCLE
        ORDER;
    
    SELECT S3.NEXTVAL FROM DUAL;
 
-- 6.	�������� ������������������ S4 (SEQUENCE), �� ���������� ����������������: ��������� �������� 1; ���������� 1; ����������� �������� 10; 
--      �����������; ���������� � ������ 5 ��������; ���������� �������� �� �������������. 
--      ����������������� ����������� ��������� �������� ������������������� S4.

    CREATE SEQUENCE S4
        INCREMENT BY 1
        START WITH 1
        MAXVALUE 6
        MINVALUE 1
        CYCLE
        CACHE 5
        NOORDER;
    
    SELECT S4.NEXTVAL FROM DUAL;
        

-- 7.	�������� ������ ���� ������������������� � ������� ���� ������, ���������� ������� �������� ������������ XXX.

   SELECT * FROM USER_SEQUENCES;
        

-- 8.	�������� ������� T1, ������� ������� N1, N2, N3, N4, ���� NUMBER (20), ���������� � ������������� � �������� ���� KEEP.
--      � ������� ��������� INSERT �������� 7 �����, �������� �������� ��� �������� 
--      ������ ������������� � ������� ������������������� S1, S2, S3, S4.

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

-- 9.	�������� ������� ABC, ������� hash-��� (������ 200) � ���������� 2 ����: X (NUMBER (10)), V (VARCHAR2(12)).
        CREATE CLUSTER ABC(
        X NUMBER(10),
        V VARCHAR(12)
        )
        HASHKEYS 200;
-- 10.	�������� ������� A, ������� ������� XA (NUMBER (10)) � VA (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.

            CREATE TABLE A(
            XA NUMBER(10),
            VA VARCHAR2(12),
            XV CHAR(5)
            ) CLUSTER ABC(XA,VA);

-- 11.	�������� ������� B, ������� ������� XB (NUMBER (10)) � VB (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.

        CREATE TABLE B(
        XB NUMBER(10),
        VB VARCHAR2(12),
        XV2 CHAR(5)
        ) CLUSTER ABC(XB,VB);
        

-- 12.	�������� ������� �, ������� ������� X� (NUMBER (10)) � V� (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������. 

        CREATE TABLE C (
        XC NUMBER(10),
        VC VARCHAR2(12),
        XV3 CHAR(5)
        ) CLUSTER ABC(XC,VC);
        
-- 13.	������� ��������� ������� � ������� � �������������� ������� Oracle.

        SELECT * FROM USER_TABLES;
        SELECT * FROM USER_CLUSTERS;
        SELECT * FROM USER_SEGMENTS;
        
-- 14.	�������� ������� ������� ��� ������� XXX.� � ����������������� ��� ����������.

        CREATE SYNONYM T12 FOR LVO.C;
        SELECT * FROM T12;

-- 15.	�������� ��������� ������� ��� ������� XXX.B � ����������������� ��� ����������.

        CREATE PUBLIC SYNONYM T11 FOR LVO.B;
        SELECT * FROM T11;

        


-- 16.	�������� ��� ������������ ������� A � B (� ��������� � ������� �������),'
--      ��������� �� �������, �������� ������������� V1, ���������� �� SELECT... FOR A inner join B. 
--      ����������������� ��� �����������������.

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


-- 17.	�� ������ ������ A � B �������� ����������������� ������������� MV_XXX, ������� ����� ������������� ���������� 2 ������. ����������������� ��� �����������������.

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
        

-- 18.	�������� DBlink �� ����� USER1-USER2 ��� ����������� � ������ ���� ������ (���� ���� �� ��������� �� ������� ORA12W, �� ���� ������������ � �� �� ������� ORA12D, ���� �� ��������� �� ����� �������, �� ������������ � ���-�� �� ������). 
        CREATE DATABASE LINK LABPDB
        CONNECT TO TNA
        IDENTIFIED BY LabPDBUser
        USING '192.168.0.120:1521/labpdb';

-- 19.	����������������� ���������� ���������� SELECT, INSERT, UPDATE, DELETE, ����� �������� � ������� � ��������� ���������� �������.
    
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





