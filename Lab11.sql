 --  Неявные курсоры:
 
--1. Разработайте АБ, демонстрирующий работу оператора SELECT с точной выборкой. 

declare 
    faculty_rec FACULTY%rowtype;
begin
    select * into faculty_rec from FACULTY  where faculty = 'ИДиП';
    dbms_output.put_line(faculty_rec.faculty ||' '||    faculty_rec.faculty_name);
end;

--2. Разработайте АБ, демонстрирующий работу оператора SELECT с неточной точной выборкой. Используйте конструкцию WHEN OTHERS секции исключений и встроенную функции SQLERRM, 
--SQLCODE для диагностирования неточной выборки. 

declare 
    faculty_rec FACULTY%rowtype;
    ex exception;
    pragma EXCEPTION_INIT(ex,100);
begin
    select * into faculty_rec from FACULTY where faculty = 'LVO' ;
    dbms_output.put_line(faculty_rec.faculty ||' '||    faculty_rec.faculty_name);
    exception
        when ex
        then 
            dbms_output.put_line('Данные не найдеты ORA:'||sqlcode||'');
            dbms_output.put_line(sqlerrm);
            when others 
            then dbms_output.put_line(sqlerrm);
end;


--3. Разработайте АБ, демонстрирующий работу конструкции WHEN TO_MANY_ROWS секции исключений для диагностирования неточной выборки. 

declare 
    faculty_rec FACULTY%rowtype;
    ex exception;
    pragma EXCEPTION_INIT(ex,100);
begin
    select * into faculty_rec from FACULTY;
    dbms_output.put_line(faculty_rec.faculty ||' '||    faculty_rec.faculty_name);
    exception
        when ex
        then 
            dbms_output.put_line('Данные не найдеты ORA:'||sqlcode||'');
            dbms_output.put_line(sqlerrm);
            when too_many_rows 
            then dbms_output.put_line('ERROR: '|| sqlerrm);
end;

--4. Разработайте АБ, демонстрирующий возникновение и обработку исключения NO_DATA_FOUND. 
--   Разработайте АБ, демонстрирующий применение атрибутов неявного курсора.

-- 4.1:
declare 
    faculty_rec FACULTY%rowtype;
    ex exception;
    pragma EXCEPTION_INIT(ex,100);
begin
    select * into faculty_rec from FACULTY where faculty = 'LVO';
    dbms_output.put_line(faculty_rec.faculty ||' '||    faculty_rec.faculty_name);
    exception
        when no_data_found
        then 
            dbms_output.put_line('Данные не найдеты ORA:'||sqlcode||'');
            dbms_output.put_line(sqlerrm);
end;

-- 4.2:

declare
    faculty_rec FACULTY%rowtype;
    b1 boolean;
    b2 boolean;
    b3 boolean;
    n pls_integer;
begin
    select * into faculty_rec from FACULTY where faculty = 'ИДиП';
    b1:= sql%found;
    b2:= sql%isopen;
    b3:= sql%notfound;
    n:= sql%rowcount;
    dbms_output.put_line(faculty_rec.faculty ||' '||    faculty_rec.faculty_name);
        if b1 then dbms_output.put_line('1 - true');
    else  dbms_output.put_line('1 - false');
    end if;
        if b2 then dbms_output.put_line('2 - true');
    else  dbms_output.put_line('2 - false');
    end if;
        if b3 then dbms_output.put_line('3 - true');
    else  dbms_output.put_line('3 - false');
    end if;
      dbms_output.put_line('ROWCOUNT:' || n);
end;


--5. Разработайте АБ, демонстрирующий применение операторов INSERT, UPDATE, DELETE, вызывающие нарушение целостности в базе данных. Обработайте исключения.

-- insert
declare 
    a_aud AUDITORIUM.AUDITORIUM%TYPE;
    a_type AUDITORIUM.AUDITORIUM_TYPE%TYPE;
begin
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
                       values  ('314-4',   '314-4', 'ЛК',  90)
returning AUDITORIUM, AUDITORIUM_TYPE into a_aud , a_type;
DBMS_OUTPUT.PUT_LINE('AUD:' ||a_aud|| ' TYPE:'|| a_type  );
exception
    when others
    then dbms_output.put_line(sqlerrm);
end;
-- update
declare 
    a_type AUDITORIUM_TYPE.AUDITORIUM_TYPE%TYPE;
    a_name AUDITORIUM_TYPE.AUDITORIUM_TYPENAME%TYPE;
begin
update AUDITORIUM_TYPE set AUDITORIUM_TYPE = 'LK-K' where AUDITORIUM_TYPENAME = 'Лекционная' 
returning AUDITORIUM_TYPE , AUDITORIUM_TYPENAME into a_type , a_name;
DBMS_OUTPUT.PUT_LINE('AUD:' ||a_type|| ' NAME:'|| a_name  );
exception
    when others
    then dbms_output.put_line(sqlerrm);
end;

-- delete
declare 
    a_type AUDITORIUM_TYPE.AUDITORIUM_TYPE%TYPE;
    a_name AUDITORIUM_TYPE.AUDITORIUM_TYPENAME%TYPE;
begin
delete from AUDITORIUM_TYPE where AUDITORIUM_TYPENAME = 'Лекционная'
returning AUDITORIUM_TYPE , AUDITORIUM_TYPENAME into a_type , a_name;
DBMS_OUTPUT.PUT_LINE('AUD:' ||a_type|| ' NAME:'|| a_name  );
exception
    when others
    then dbms_output.put_line(sqlerrm);
end;

--                                          ЯВНЫЕ КУРСОРЫ:

--6. Создайте анонимный блок, распечатывающий таблицу TEACHER с применением явного курсора LOOP-цикла.
--   Считанные данные должны быть записаны в переменные, объявленные с применением опции %TYPE.

DECLARE 
    CURSOR TEACHER_CURS IS SELECT TEACHER , TEACHER_NAME , PULPIT 
    FROM TEACHER;
    teach TEACHER.TEACHER%TYPE;
    tname TEACHER.TEACHER_NAME%TYPE;
    tpupl TEACHER.PULPIT%TYPE;
BEGIN
    OPEN TEACHER_CURS;
    loop
        fetch TEACHER_CURS INTO teach,tname,tpupl;
        EXIT WHEN TEACHER_CURS%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(RTRIM(teach) || ' : ' 
        || tname || ' : '|| 
        tpupl);
    end loop;
    CLOSE TEACHER_CURS;
END;




--7. Создайте АБ, распечатывающий таблицу SUBJECT с применением явного курсора иWHILE-цикла. 
--  Считанные данные должны быть записаны в запись (RECORD), объявленную с применением опции %ROWTYPE.

DECLARE
    CURSOR SUBJECT_CURS IS SELECT SUBJECT,SUBJECT_NAME,PULPIT FROM SUBJECT;
    subject_rec SUBJECT%ROWTYPE;
BEGIN
OPEN SUBJECT_CURS;
FETCH SUBJECT_CURS INTO subject_rec;
WHILE SUBJECT_CURS%FOUND
LOOP
DBMS_OUTPUT.PUT_LINE(
' ' || RTRIM(subject_rec.SUBJECT) || ' : ' ||
subject_rec.SUBJECT_NAME || ' : ' ||
subject_rec.PULPIT
);
FETCH SUBJECT_CURS INTO subject_rec;
END LOOP;
CLOSE SUBJECT_CURS;
END;

--8. Создайте АБ, распечатывающий следующие списки аудиторий: все аудитории (таблица AUDITORIUM) с вместимостью меньше 20, от 21-30, от 31-60, от 61 до 80, от 81 и выше. 
--  Примените курсор с параметрами и три способа организации цикла по строкам курсора.

DECLARE
    CURSOR AUD_CURS(CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE , CAPACITY1 AUDITORIUM.AUDITORIUM_CAPACITY%TYPE) 
    IS SELECT AUDITORIUM , AUDITORIUM_CAPACITY,AUDITORIUM_TYPE
    FROM AUDITORIUM WHERE AUDITORIUM_CAPACITY <= CAPACITY1 AND AUDITORIUM_CAPACITY >= CAPACITY;
    AUD AUDITORIUM.AUDITORIUM%TYPE;
BEGIN
DBMS_OUTPUT.PUT_LINE('---------------0:20------------------');
    FOR AUD IN AUD_CURS(0,20)
    LOOP
            DBMS_OUTPUT.PUT_LINE( AUD.AUDITORIUM || ' : ' || AUD.AUDITORIUM_CAPACITY);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('---------------21:30------------------');
        FOR AUD IN AUD_CURS(21,30)
    LOOP
            DBMS_OUTPUT.PUT_LINE( AUD.AUDITORIUM || ' : ' || AUD.AUDITORIUM_CAPACITY);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('---------------31:60------------------');
        FOR AUD IN AUD_CURS(31,60)
    LOOP
            DBMS_OUTPUT.PUT_LINE( AUD.AUDITORIUM || ' : ' || AUD.AUDITORIUM_CAPACITY);
    END LOOP;
DBMS_OUTPUT.PUT_LINE('---------------61:80------------------');
        FOR AUD IN AUD_CURS(61,80)
    LOOP
            DBMS_OUTPUT.PUT_LINE( AUD.AUDITORIUM || ' : ' || AUD.AUDITORIUM_CAPACITY);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('---------------81:100------------------');
        FOR AUD IN AUD_CURS(81,100)
    LOOP
            DBMS_OUTPUT.PUT_LINE( AUD.AUDITORIUM || ' : ' || AUD.AUDITORIUM_CAPACITY);
    END LOOP;
EXCEPTION 
    WHEN OTHERS 
    THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;


--9. Создайте AБ. Объявите курсорную переменную с помощью системного типа refcursor. 
--  Продемонстрируйте ее применение для курсора c параметрами. 
DECLARE
    TYPE tteachers IS REF CURSOR RETURN TEACHER%ROWTYPE;
    xcurs tteachers;
    rec_teach TEACHER%ROWTYPE;
BEGIN
OPEN XCURS FOR SELECT TEACHER , TEACHER_NAME , PULPIT FROM TEACHER where PULPIT = 'ПОиСОИ';
FETCH xcurs INTO rec_teach;
LOOP
DBMS_OUTPUT.PUT_LINE(RTRIM(rec_teach.TEACHER) || ' : ' || rec_teach.TEACHER_NAME || ' : ' || rec_teach.PULPIT );
FETCH xcurs INTO rec_teach;
EXIT WHEN xcurs%NOTFOUND;
END LOOP;
CLOSE XCURS;
END;


--10. Создайте AБ. Уменьшите вместимость всех аудиторий (таблица AUDITORIUM) вместимостью от 40 до 80 на 10%. 
--      Используйте явный курсор с параметрами, цикл FOR, конструкцию UPDATE CURRENT OF. 

-- TYPE 1:
 
DECLARE
    CURSOR AUD_CURS(CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE , CAPACITY1 AUDITORIUM.AUDITORIUM_CAPACITY%TYPE) 
    IS SELECT AUDITORIUM , AUDITORIUM_CAPACITY,AUDITORIUM_TYPE
    FROM AUDITORIUM WHERE AUDITORIUM_CAPACITY <= CAPACITY1 AND AUDITORIUM_CAPACITY >= CAPACITY FOR UPDATE;
    AUD AUDITORIUM.AUDITORIUM%TYPE;
    CAP AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
    FOR AUD IN AUD_CURS(40,80)
    LOOP
            CAP := AUD.AUDITORIUM_CAPACITY * 0.9;
            UPDATE AUDITORIUM SET AUDITORIUM_CAPACITY = CAP 
            WHERE CURRENT OF AUD_CURS;
    END LOOP;
    FOR AUD IN AUD_CURS(40,80)
    LOOP
    DBMS_OUTPUT.PUT_LINE( RTRIM(AUD.AUDITORIUM) || ' : ' || AUD.AUDITORIUM_CAPACITY);
    END LOOP;
END;

rollback;

SELECT * FROM AUDITORIUM WHERE AUDITORIUM_CAPACITY >= 40 AND AUDITORIUM_CAPACITY <= 80;


-- TYPE 2:

DECLARE
    CURSOR AUD_CURS(CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE , CAPACITY1 AUDITORIUM.AUDITORIUM_CAPACITY%TYPE) 
    IS SELECT AUDITORIUM , AUDITORIUM_CAPACITY
    FROM AUDITORIUM WHERE AUDITORIUM_CAPACITY <= CAPACITY1 AND AUDITORIUM_CAPACITY >= CAPACITY FOR UPDATE;
    AUD AUDITORIUM.AUDITORIUM%TYPE;
    CAP AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
    OPEN AUD_CURS(40,80);
    FETCH AUD_CURS INTO AUD , CAP;
    WHILE (AUD_CURS%FOUND)
    LOOP
        CAP := CAP * 0.9;
        UPDATE AUDITORIUM
        SET AUDITORIUM_CAPACITY = CAP
        WHERE CURRENT OF AUD_CURS;
        DBMS_OUTPUT.PUT_LINE(RTRIM(AUD) || ' : ' || CAP);
        FETCH AUD_CURS INTO AUD , CAP;
    END LOOP;
    CLOSE AUD_CURS;
    ROLLBACK;
END;