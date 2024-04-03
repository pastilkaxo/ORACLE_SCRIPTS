-- 1.	Найдите на компьютере-сервере конфигурационные файлы SQLNET.ORA и TNSNAMES.ORA и ознакомьтесь с их содержимым.

-- C:\Oracle\network\admin

-- 2.	Настройте соединение при помощи SQL Developer с сервером Oracle с компьютера-клиента. Убедитесь, что соединение работает.

-- 3.	Настройте соединение при помощи SQLPLUS с сервером Oracle с помощью стандартной строки соединения с компьютера-клиента. Убедитесь, что соединение работает.

-- connect system/Foo12345678@/hostname:1521/orcl;

-- connect system/Foo12345678@(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))(CONNECT_DATA =(SERVICE_NAME = orcl)))


-- 4 - 5:
--Подключитесь при помощи SQL Developer и SQLPLUS компьютером-клиентом к серверу с использованием TNS соединения.
--      Убедитесь, что оба соединения работают.

-- Net Manager
-- Test
-- connect system/Foo12345678@Test

