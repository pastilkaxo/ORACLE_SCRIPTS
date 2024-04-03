--  1.	Определите общий размер области SGA.
select * from v$sga;
select SUM(VALUE) TOTAL  from v$sga; 

-- 2.	Определите текущие размеры основных пулов SGA.

select COMPONENT , CURRENT_SIZE , MAX_SIZE from v$sga_dynamic_components where COMPONENT like '%pool';

-- 3.	Определите размеры гранулы для каждого пула.
SELECT COMPONENT , GRANULE_SIZE from v$sga_dynamic_components where COMPONENT like '%pool'; 

-- 4.	Определите объем доступной свободной памяти в SGA.

SELECT * FROM v$sga_dynamic_free_memory;

-- 5.	Определите максимальный и целевой размер области SGA.

SHOW PARAMETER SGA;

SELECT SUM(MAX_SIZE),SUM(MIN_SIZE),SUM(CURRENT_SIZE)  FROM gv$sga_dynamic_components WHERE CURRENT_SIZE > 0;

-- 6.	Определите размеры пулов КЕЕP, DEFAULT и RECYCLE буферного кэша.

SELECT COMPONENT,CURRENT_SIZE  FROM gv$sga_dynamic_components WHERE COMPONENT  LIKE 'DEFAULT%' 
UNION
SELECT COMPONENT,CURRENT_SIZE  FROM gv$sga_dynamic_components WHERE COMPONENT LIKE 'RECYCLE%'
UNION
SELECT COMPONENT,CURRENT_SIZE  FROM gv$sga_dynamic_components WHERE COMPONENT LIKE 'KEEP%';

-- select * from v$buffer_pool;

-- 7.	Создайте таблицу, которая будет помещаться в пул КЕЕP. 
--      Продемонстрируйте сегмент таблицы.

CREATE TABLE LVO(ID NUMBER(5) PRIMARY KEY) STORAGE(BUFFER_POOL KEEP) TABLESPACE USERS;

SELECT SEGMENT_NAME , SEGMENT_TYPE , TABLESPACE_NAME ,
buffer_pool FROM USER_SEGMENTS WHERE SEGMENT_NAME = 'LVO';

DROP TABLE LVO;

-- 8.	Создайте таблицу, которая будет кэшироваться в пуле DEFAULT. 
--      Продемонстрируйте сегмент таблицы. 

CREATE TABLE LVO_2(ID NUMBER(5) PRIMARY KEY) CACHE TABLESPACE USERS;

SELECT SEGMENT_NAME , SEGMENT_TYPE , TABLESPACE_NAME ,
buffer_pool FROM USER_SEGMENTS WHERE SEGMENT_NAME = 'LVO_2';

DROP TABLE LVO_2;

-- 9.	Найдите размер буфера журналов повтора.
SHOW PARAMETER LOG_BUFFER;
-- 10.	Найдите размер свободной памяти в большом пуле.

select * from v$sgastat where pool = 'large pool' and name = 'free memory';

-- 11.	Определите режимы текущих соединений с инстансом (dedicated, shared).
select  SID, STATUS, SERVER ,username ,service_name  from v$session where username is not null;

-- 12.	Получите полный список работающих в настоящее время фоновых процессов.
select * from v$bgprocess where PADDR != '00' order by 1;

-- 13.	Получите список работающих в настоящее время серверных процессов.

select * from v$process;

-- 14.	Определите, сколько процессов DBWn работает в настоящий момент.

select count(*) DBWS from v$process where PNAME like 'DBW%';

-- 15.	Определите сервисы (точки подключения экземпляра).

select * from v$services order by 3;

-- 16.	Получите известные вам параметры диспетчеров.
show parameter dispatcher;
select * from v$shared_server;

-- 17.	Укажите в списке Windows-сервисов сервис, реализующий процесс LISTENER.
-- Диспетчер задач -> Службы

-- 18.	Продемонстрируйте и поясните содержимое файла LISTENER.ORA. 
-- C:\Oracle\network\admin

-- 19.	Запустите утилиту lsnrctl и поясните ее основные команды. 
-- C:\Oracle\bin

-- 20.	Получите список служб инстанса, обслуживаемых процессом LISTENER. 
select * from v$bgprocess where NAME = 'LREG';
select * from v$process where PNAME = 'LREG';
select * from v$services;
