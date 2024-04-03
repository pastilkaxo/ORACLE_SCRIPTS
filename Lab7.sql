--  1.	���������� ����� ������ ������� SGA.
select * from v$sga;
select SUM(VALUE) TOTAL  from v$sga; 

-- 2.	���������� ������� ������� �������� ����� SGA.

select COMPONENT , CURRENT_SIZE , MAX_SIZE from v$sga_dynamic_components where COMPONENT like '%pool';

-- 3.	���������� ������� ������� ��� ������� ����.
SELECT COMPONENT , GRANULE_SIZE from v$sga_dynamic_components where COMPONENT like '%pool'; 

-- 4.	���������� ����� ��������� ��������� ������ � SGA.

SELECT * FROM v$sga_dynamic_free_memory;

-- 5.	���������� ������������ � ������� ������ ������� SGA.

SHOW PARAMETER SGA;

SELECT SUM(MAX_SIZE),SUM(MIN_SIZE),SUM(CURRENT_SIZE)  FROM gv$sga_dynamic_components WHERE CURRENT_SIZE > 0;

-- 6.	���������� ������� ����� ���P, DEFAULT � RECYCLE ��������� ����.

SELECT COMPONENT,CURRENT_SIZE  FROM gv$sga_dynamic_components WHERE COMPONENT  LIKE 'DEFAULT%' 
UNION
SELECT COMPONENT,CURRENT_SIZE  FROM gv$sga_dynamic_components WHERE COMPONENT LIKE 'RECYCLE%'
UNION
SELECT COMPONENT,CURRENT_SIZE  FROM gv$sga_dynamic_components WHERE COMPONENT LIKE 'KEEP%';

-- select * from v$buffer_pool;

-- 7.	�������� �������, ������� ����� ���������� � ��� ���P. 
--      ����������������� ������� �������.

CREATE TABLE LVO(ID NUMBER(5) PRIMARY KEY) STORAGE(BUFFER_POOL KEEP) TABLESPACE USERS;

SELECT SEGMENT_NAME , SEGMENT_TYPE , TABLESPACE_NAME ,
buffer_pool FROM USER_SEGMENTS WHERE SEGMENT_NAME = 'LVO';

DROP TABLE LVO;

-- 8.	�������� �������, ������� ����� ������������ � ���� DEFAULT. 
--      ����������������� ������� �������. 

CREATE TABLE LVO_2(ID NUMBER(5) PRIMARY KEY) CACHE TABLESPACE USERS;

SELECT SEGMENT_NAME , SEGMENT_TYPE , TABLESPACE_NAME ,
buffer_pool FROM USER_SEGMENTS WHERE SEGMENT_NAME = 'LVO_2';

DROP TABLE LVO_2;

-- 9.	������� ������ ������ �������� �������.
SHOW PARAMETER LOG_BUFFER;
-- 10.	������� ������ ��������� ������ � ������� ����.

select * from v$sgastat where pool = 'large pool' and name = 'free memory';

-- 11.	���������� ������ ������� ���������� � ��������� (dedicated, shared).
select  SID, STATUS, SERVER ,username ,service_name  from v$session where username is not null;

-- 12.	�������� ������ ������ ���������� � ��������� ����� ������� ���������.
select * from v$bgprocess where PADDR != '00' order by 1;

-- 13.	�������� ������ ���������� � ��������� ����� ��������� ���������.

select * from v$process;

-- 14.	����������, ������� ��������� DBWn �������� � ��������� ������.

select count(*) DBWS from v$process where PNAME like 'DBW%';

-- 15.	���������� ������� (����� ����������� ����������).

select * from v$services order by 3;

-- 16.	�������� ��������� ��� ��������� �����������.
show parameter dispatcher;
select * from v$shared_server;

-- 17.	������� � ������ Windows-�������� ������, ����������� ������� LISTENER.
-- ��������� ����� -> ������

-- 18.	����������������� � �������� ���������� ����� LISTENER.ORA. 
-- C:\Oracle\network\admin

-- 19.	��������� ������� lsnrctl � �������� �� �������� �������. 
-- C:\Oracle\bin

-- 20.	�������� ������ ����� ��������, ������������� ��������� LISTENER. 
select * from v$bgprocess where NAME = 'LREG';
select * from v$process where PNAME = 'LREG';
select * from v$services;
