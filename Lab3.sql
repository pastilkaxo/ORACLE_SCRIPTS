-- 1:
select * from v$pdbs;
select * from dictionary;

-- 4:
ALTER SESSION SET "_oracle_script" = true;

create tablespace TS_PDB
datafile 'C:\Tablecpaces\Lab3\ts_pdb2.dbf'
size 7M
autoextend on next 5M
maxsize 30M
extent management local;

create TEMPORARY tablespace TS_PDB_TEMP
tempfile 'C:\Tablecpaces\Lab3\ts_pdb_temp2.dbf'
size 5M
autoextend on next 3M
maxsize 20M
extent management local;

drop tablespace TS_PDB_TEMP; 
---------------------
CREATE ROLE RL_LVOPDB;
GRANT 
CREATE TABLE,
CREATE SESSION,
CREATE PROCEDURE,
CREATE VIEW
TO RL_LVOPDB;

----------------------

CREATE PROFILE PF_LVOPDB LIMIT
    PASSWORD_LIFE_TIME 180
    SESSIONS_PER_USER 3
    FAILED_LOGIN_ATTEMPTS 7
    PASSWORD_LOCK_TIME 1
    PASSWORD_REUSE_TIME 10
    PASSWORD_GRACE_TIME DEFAULT
    CONNECT_TIME 180
    IDLE_TIME 30;
-----------------------
CREATE USER U1_LVO_PDB IDENTIFIED BY Obobad12345
    DEFAULT TABLESPACE TS_PDB
    TEMPORARY TABLESPACE TS_PDB_TEMP
    PROFILE PF_LVOPDB
    ACCOUNT UNLOCK;
GRANT RL_LVOPDB TO U1_LVO_PDB;
ALTER USER U1_LVO_PDB  QUOTA 2M ON TS_PDB;
----------------------------------------------
DROP USER U1_LVO_PDB CASCADE;
DROP PROFILE PF_LVOPDB CASCADE;
DROP ROLE RL_LVOPDB;
DROP TABLESPACE TS_PDB;
DROP TABLESPACE TS_PDB_TEMP;
-------------------------------------
-- 5:
create table LVO_table(
ID number(5) primary key
);

INSERT INTO LVO_table(ID)
VALUES(1);
INSERT INTO LVO_table(ID)
VALUES(2);

SELECT * FROM LVO_table;

-- 6:

SELECT * FROM DICTIONARY;
--TABLESPACES:
SELECT TABLESPACE_NAME , STATUS , CONTENTS LOGGING FROM SYS.DBA_TABLESPACES;
--FILES:
SELECT FILE_NAME FROM SYS.DBA_DATA_FILES
UNION
SELECT FILE_NAME FROM SYS.DBA_TEMP_FILES;
--ROLES AND PRIVS
SELECT * FROM SYS.DBA_SYS_PRIVS WHERE GRANTEE = 'RL_LVOPDB';
--PROFILES
SELECT * FROM SYS.DBA_PROFILES 
WHERE PROFILE = 'PF_LVOPDB';
--USERS
select RTRIM(GRANTED_ROLE) ROLE ,GRANTEE from DBA_ROLE_PRIVS 
where GRANTEE = 'U1_LVO_PDB';

-- 7:
ALTER SESSION SET CONTAINER = CDB$ROOT;
CREATE USER C##LVO IDENTIFIED BY Obobad12345;
GRANT CONNECT, CREATE SESSION,CREATE TABLE,SYSDBA TO C##LVO CONTAINER=ALL;

-- 8:
GRANT CREATE TABLE TO C##LVO CONTAINER=ALL;
ALTER USER  C##LVO QUOTA UNLIMITED ON USERS;
DROP USER C##LVO;

-- 10:

create table CDB_TEST(ID number(5) primary key);
INSERT INTO CDB_TEST(ID)
VALUES(2);
select * from CDB_TEST;

drop table CDB_TEST;

-- 11:
select object_name from user_objects;

-- 12:
show con_name;
ALTER SESSION SET CONTAINER = pdb_lvo;
create user C##TNA identified by 2025;
grant  create session,CREATE TABLE to C##TNA ;
ALTER USER  C##TNA QUOTA UNLIMITED ON USERS;

create user C##ZSS identified by 2025;
grant  create session,CREATE TABLE to C##ZSS ;
ALTER USER  C##ZSS QUOTA UNLIMITED ON USERS;

DROP USER C##TNA;
DROP USER C##ZSS;
-- Роботоспособность YYY

CREATE TABLE YYY_TABLE(ID NUMBER (3));
insert into YYY_TABLE(ID) values(3);
select * from YYY_TABLE;

drop table YYY_TABLE;
----13:
-- U1:
select username,  machine,   schemaname ,  program ,  osuser , status  
from v$session 
WHERE username IS NOT NULL


