-- 10

create table LVO_t (
ID NUMBER(5) primary key ,
Text varchar2(50)
);


-- 12

INSERT ALL
  INTO LVO_T(ID,Text) VALUES(1,'First')
  INTO LVO_T(ID,Text) VALUES(2,'Second')
  INTO LVO_T(ID,Text) VALUES(3,'Third')
SELECT * FROM dual;
commit;
    
select * from lvo_t;

-- 13

update lvo_t  set  Text = 'SecondCHANGED' where ID = 2;
update lvo_t  set Text = 'ThirdCHANGED' where ID = 3;
commit;

-- 14

select sum(ID) , avg(ID), count(ID), max(ID) ,min(ID) from LVO_T;

-- 15
delete LVO_T where ID = 2;
rollback;

-- 16
create table LVO_t_child (
cNum number(5) primary key,
refID number(3),
studentName varchar2(50),
constraint fk_lvo
    foreign key (refID)
    references lvo_t(ID)
);

insert all
    into LVO_t_child(cNum,refID,studentName) values(1,2,'Vladislav')
    into LVO_t_child(cNum,refID,studentName) values(2,3,'Dima')
    into LVO_t_child(cNum,refID,studentName) values(3,null,'Fin')
select * from dual;
commit;

select * from LVO_t_child;

-- 17

select LVO_T.ID  , LVO_T.Text , LVO_t_child.studentName 
from LVO_t 
inner join LVO_t_child on LVO_t_child.refID = LVO_t.ID

select  LVO_t_child.cNum , LVO_t_child.refID, 
LVO_t_child.studentName , LVO_T.Text 
from LVO_t_child 
left outer join LVO_T on  LVO_t.ID = LVO_t_child.refID

-- 18

drop table LVO_t_child;
drop table LVO_t;


