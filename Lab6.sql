-- 1. Определите местоположение файла параметров инстанса. 
-- C:\Oracle\database

-- 2. Убедитесь в наличии этого файла в операционной системе. 
-- реестр
select * from v$parameter;
show parameter spfile;

-- 3. Сформируйте PFILE с именем XXX_PFILE.ORA. Исследуйте его содержимое. 
--    Поясните известные вам параметры в файле.

create pfile='C:\Pfiles\LVO_PFILE.ORA' from spfile;

-- 4. Измените какой-либо параметр в файле PFILE.

-- Меняем значение OPEN_CURSORS 300 -> 350
select * from v$parameter where name = 'open_cursors';
show parameter spfile;

alter system set OPEN_CURSORS = 350 SCOPE=SPFILE;

/*
sqlplus / as sysdba;
shutdown immediate;
startup open;
*/


-- 5. Создайте новый SPFILE.

create spfile = 'SPFILEORCL1.ora' from pfile = 'C:\Pfiles\LVO_PFILE.ORA';

select * from v$parameter where name = 'open_cursors';

-- 6. Запустите инстанс с новыми параметрами.
/*
sqlplus / as sysdba;
shutdown immediate;
startup open;
*/

-- 7. Вернитесь к прежним значениям параметров другим способом.

-- 350 -> 300 вручную
/*
sqlplus / as sysdba;
shutdown immediate;
create spfile from pfile = 'C:\Pfiles\LVO_PFILE.ORA';
startup open;
*/

select * from v$parameter where name = 'open_cursors';

-- 8. Получите список управляющих файлов.
show parameter control;
select * from v$controlfile;

-- 9. Создайте скрипт для изменения управляющего файла.
alter database backup controlfile to trace as 'C:\BackUp\ControlBack.txt';

CREATE CONTROLFILE REUSE DATABASE "ORCL" NORESETLOGS  NOARCHIVELOG
    MAXLOGFILES 16
    MAXLOGMEMBERS 3
    MAXDATAFILES 1024
    MAXINSTANCES 8
    MAXLOGHISTORY 292
LOGFILE
  GROUP 1 'C:\ORACLEDB\ORADATA\ORCL\REDO01.LOG'  SIZE 200M BLOCKSIZE 512,
  GROUP 2 'C:\ORACLEDB\ORADATA\ORCL\REDO02.LOG'  SIZE 200M BLOCKSIZE 512,
  GROUP 3 'C:\ORACLEDB\ORADATA\ORCL\REDO03.LOG'  SIZE 200M BLOCKSIZE 512
-- STANDBY LOGFILE
DATAFILE
  'C:\ORACLEDB\ORADATA\ORCL\SYSTEM01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\SYSAUX01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\UNDOTBS01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\PDBSEED\SYSTEM01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\PDBSEED\SYSAUX01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\USERS01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\PDBSEED\UNDOTBS01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\ORCLPDB\SYSTEM01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\ORCLPDB\SYSAUX01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\ORCLPDB\UNDOTBS01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\ORCLPDB\USERS01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\PDB_LVO\SYSTEM01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\PDB_LVO\SYSAUX01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\PDB_LVO\UNDOTBS01.DBF',
  'C:\ORACLEDB\ORADATA\ORCL\PDB_LVO\USERS01.DBF',
  'C:\TABLECPACES\LAB3\TS_PDB.DBF'
CHARACTER SET AL32UTF8
;

-- 10. Определите местоположение файла паролей инстанса

-- C:\Oracle\database
show parameter ;
select * from v$passwordfile_info;

-- 11. Убедитесь в наличии этого файла в операционной системе. 

-- Реестр(файл паролей)
select * from v$pwfile_users;


-- 12. Получите перечень директориев для файлов сообщений и диагностики. 

select * from v$diag_info;


-- 13. Найдите и исследуйте содержимое протокола работы инстанса (LOG.XML),
--     найдите в нем команды переключения журналов которые вы выполняли.

-- C:\OracleDB\diag\rdbms\orcl\orcl\alert
-- current log

-- 14. Найдите и исследуйте содержимое трейса, 
--     в который вы сбросили управляющий файл.

alter database backup controlfile to trace;
-- C:\Oracle\database
-- C:\OracleDB\diag\rdbms\orcl\orcl\trace
--orcl_ora_11832
