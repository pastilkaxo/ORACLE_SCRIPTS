alter pluggable database pdb_lvo open;




create tablespace data01
    datafile 'C:\Tablecpaces\Lab15\data01.dbf'
    size 50M
;

create tablespace data02
    datafile 'C:\Tablecpaces\Lab15\data02.dbf'
    size 50M
;

create tablespace data03
    datafile 'C:\Tablecpaces\Lab15\data03.dbf'
    size 50M
;



--1.	Создайте таблицу T_RANGE c диапазонным секционированием. Используйте ключ секционирования типа NUMBER. 

    create table T_RANGE (
    item_id number,
    price number
    )
    partition by range(price)
    (
        partition T_RANGE_q1 values less than (10),
        partition T_RANGE_q2 values less than (20),
        partition T_RANGE_q3 values less than (30),
        partition T_RANGE_max values less than (maxvalue)
    );


-- drop table T_RANGE;

--2.	Создайте таблицу T_INTERVAL c интервальным секционированием. Используйте ключ секционирования типа DATE.


        
  create table T_INTERVAL
  ( 
  ts    date,
  data varchar2(250)
  )
  partition by range(ts)
  interval (numtodsinterval(1,'day'))
  store in (users)
   (
   partition p0 values less than ('22-04-2004')
   );
   

   
 
 select * from user_tab_partitions where table_name = 'T_HASH';

--3.	Создайте таблицу T_HASH c хэш-секционированием. Используйте ключ секционирования типа VARCHAR2.

    create table T_HASH 
    (
    id number,
    name varchar2(255)
    )
    partition by hash (name)
    partitions 3
    store in (data01 , data02 , data03);


--4.	Создайте таблицу T_LIST со списочным секционированием. Используйте ключ секционирования типа CHAR.

    create table T_LIST
    (
    id number,
    type char(250)
    )
    partition by list (type) (
        partition T_LIST_q1 values ('BIG'),
        partition T_LIST_q2 values ('MEDIUM'),
        partition T_LIST_q3 values ('SMALL')
    );


--5.	Введите с помощью операторов INSERT данные в таблицы T_RANGE, T_INTERVAL, T_HASH, T_LIST. 
--      Данные должны быть такими, чтобы они разместились по всем секциям. Продемонстрируйте это с помощью SELECT запроса. 
    
        INSERT ALL 
            INTO T_RANGE(item_id , price) values(1,5)
            INTO T_RANGE(item_id , price) values(2,15)
            INTO T_RANGE(item_id , price) values(3,25)
            INTO T_RANGE(item_id , price) values(4,35)
        SELECT * FROM DUAL;

select * from T_RANGE  partition(T_RANGE_q3);

        INSERT ALL
            INTO T_INTERVAL(ts) values('23-04-2004')
            INTO T_INTERVAL(ts) values('21-04-2004')
            INTO T_INTERVAL(ts) values('22-04-2004')
            into T_INTERVAL(ts) values('20-04-2004')
        SELECT * FROM DUAL;
        
        
select * from T_INTERVAL partition (P0);

        INSERT ALL
            INTO T_HASH(id,name) values(1 , 'V')
            INTO T_HASH(id,name) values(2 , 'L')
            INTO T_HASH(id,name) values(3 , 'A')
            INTO T_HASH(id,name) values(4 , 'D')
        SELECT * FROM DUAL;

select * from T_HASH  partition(SYS_P468);

        INSERT ALL
            INTO T_LIST(id,type) VALUES(1,'BIG')
            INTO T_LIST(id,type) VALUES(2,'BIG')
            INTO T_LIST(id,type) VALUES(3,'SMALL')
        SELECT * FROM DUAL;

select * from T_LIST partition (T_LIST_q1);

 select * from user_tab_partitions where table_name = 'T_HASH';

--6.	Продемонстрируйте для всех таблиц процесс перемещения строк между секциями, при изменении (оператор UPDATE) ключа секционирования.

        alter table T_RANGE ENABLE ROW MOVEMENT;
        alter table T_INTERVAL ENABLE ROW MOVEMENT;
        alter table T_HASH ENABLE ROW MOVEMENT;
        alter table T_LIST ENABLE ROW MOVEMENT;
      
      -- 1:  
        update T_RANGE partition(T_RANGE_q1) set PRICE = PRICE+ 10;
        select * from T_RANGE  partition(T_RANGE_q2);
      -- 2:
        update T_INTERVAL partition(P0) set ts = '22-04-2004' where ts = '20-04-2004';
        select * from T_INTERVAL partition(SYS_P472);
      -- 3:
        update T_HASH partition(SYS_P470) set NAME = 'V' WHERE ID = 3;
        select * from T_HASH  partition(SYS_P468);
     -- 4:
        update T_LIST partition(T_LIST_q1) set type = 'MEDIUM' where id = 2;
        select * from T_LIST partition(T_LIST_q2);
       

--7.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE MERGE.
        
        alter table T_LIST MERGE PARTITIONS 
        T_LIST_q2 , T_LIST_q3 INTO PARTITION T_LIST_q4;
        
        SELECT * FROM T_LIST PARTITION(T_LIST_q2);
        
--8.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE SPLIT.

        alter table T_LIST SPLIT PARTITION T_LIST_q4  VALUES ('SMALL') into (PARTITION T_LIST_q2, PARTITION T_LIST_q3);

--9.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE EXCHANGE.

create table T_RANGE_EXCHANGED 
(
    item_id number,
    price number
);

alter table T_RANGE EXCHANGE PARTITION T_RANGE_Q2
WITH TABLE T_RANGE_EXCHANGED with validation ;

select * from T_RANGE_EXCHANGED;

insert into T_RANGE(item_id,price) values(6,14);
-- DROP TABLE T_RANGE_EXCHANGED;


--10.	Выведите при помощи SELECT запросов:
-- •	список всех секционированных таблиц;
    SELECT * FROM USER_TABLES WHERE PARTITIONED = 'YES';
-- •	список всех секций какой-либо таблицы;
    select * from user_tab_partitions where table_name = 'T_RANGE';
-- •	список всех значений из какой-либо секции по имени секции;W
    select * from T_RANGE  partition(T_RANGE_q2);
-- •	список всех значений из какой-либо секции по ссылке.
    select * from T_RANGE  partition for (30); 
    
    
-- drop table T_RANGE
-- drop table T_LIST
-- drop table T_INTERVAL
-- drop table T_HASH
