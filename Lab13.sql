
-- ALTER PLUGGABLE DATABASE PDB_LVO OPEN;


-- 1. ������������ ��������� ��������� GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE). ��������� ������ �������� ������ �������������� �� ������� TEACHER
--(� ����������� ��������� �����), ���������� �� ������� �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.

DECLARE
    PROCEDURE GET_TEACHERS 
    (
    PCODE IN TEACHER.PULPIT%TYPE
    )
    IS
        CURSOR TCHR_CURS IS SELECT * FROM TEACHER WHERE TEACHER.PULPIT = PCODE;
    BEGIN
        FOR TCHR_REC IN TCHR_CURS
        LOOP
            DBMS_OUTPUT.PUT_LINE(' NAME: ' ||  TCHR_REC.TEACHER_NAME || ' PULPIT: ' || TCHR_REC.PULPIT);
        END LOOP;
    END;
BEGIN
    GET_TEACHERS('����');
END;


-- 2. ������������ ��������� ������� GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) RETURN NUMBER. 
--������� ������ �������� ���������� �������������� �� ������� TEACHER, ���������� �� ������� �������� ����� � ���������. 
--������������ ��������� ���� � ����������������� ���������� ���������.

DECLARE
    FUNCTION GET_NUM_TEACHERS
    (
    PCODE IN TEACHER.PULPIT%TYPE
    )
    RETURN NUMBER
    IS
        CURSOR TCHR_CURS IS SELECT COUNT(*) AS CNT FROM TEACHER WHERE TEACHER.PULPIT = PCODE;
        CNT NUMBER;
    BEGIN
        FOR TCHR_REC IN TCHR_CURS
        LOOP
            RETURN TCHR_REC.CNT;
        END LOOP;
    END;
BEGIN
    DBMS_OUTPUT.PUT_LINE('COUNT: ' || GET_NUM_TEACHERS('����'));
END;


-- 3. ������������ ���������:
--GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), ���������� �� ����������, 
--�������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
--GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
--��������� ������ �������� ������ ��������� �� ������� SUBJECT, ������������ �� ��������,
--�������� ����� ������� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.


-- 1):
CREATE OR REPLACE PROCEDURE GET_TEACHERS
(
    FCODE FACULTY.FACULTY%TYPE
)
IS
    CURSOR TCHR_CURS IS SELECT T.TEACHER_NAME , P.PULPIT , F.FACULTY FROM TEACHER T
    INNER JOIN  PULPIT P ON P.PULPIT = T.PULPIT
    INNER JOIN FACULTY F ON F.FACULTY  = P.FACULTY
    WHERE F.FACULTY = FCODE
    ;
BEGIN
    FOR TCHR_REC IN TCHR_CURS 
    LOOP
        DBMS_OUTPUT.PUT_LINE('TEACHER: ' || TCHR_REC.TEACHER_NAME || ' PULPIT: ' || RTRIM(TCHR_REC.PULPIT) || ' FACULTY: ' || TCHR_REC.FACULTY);
    END LOOP;
END;

BEGIN
    GET_TEACHERS('����');
END;

-- 2):

CREATE OR REPLACE PROCEDURE GET_SUBJECTS
(
PCODE SUBJECT.PULPIT%TYPE
)
IS
    CURSOR SUB_CURS IS SELECT S.SUBJECT_NAME , P.PULPIT FROM SUBJECT S
    INNER JOIN PULPIT P ON P.PULPIT = S.PULPIT
    WHERE P.PULPIT = PCODE;
BEGIN
    FOR SUB_REC IN SUB_CURS
    LOOP
            DBMS_OUTPUT.PUT_LINE('NAME: ' || SUB_REC.SUBJECT_NAME  || ' PULPIT: ' || SUB_REC.PULPIT);
    END LOOP;
END;

BEGIN
    GET_SUBJECTS('����');
END;


-- 4. ������������ �������: 
--GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--RETURN NUMBER
--������� ������ �������� ���������� �������������� �� ������� TEACHER, ���������� �� ����������, �������� ����� � ���������. 
--������������ ��������� ���� � ����������������� ���������� ���������.
--GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER ������� ������ �������� ���������� ��������� �� ������� SUBJECT, ������������ �� ��������, �������� ����� ������� ���������.
--������������ ��������� ���� � ����������������� ���������� ���������. 


CREATE OR REPLACE FUNCTION GET_NUM_TEACHERS
(
FCODE FACULTY.FACULTY%TYPE
)
RETURN NUMBER
IS
    CURSOR TCHR_CURS IS SELECT COUNT(T.TEACHER) AS CNT FROM TEACHER T
                        INNER JOIN PULPIT P ON P.PULPIT = T.PULPIT
                        INNER JOIN FACULTY F ON F.FACULTY = P.FACULTY
                        WHERE F.FACULTY = FCODE;
BEGIN
    FOR TCHR_REC IN TCHR_CURS
    LOOP
        RETURN TCHR_REC.CNT;
    END LOOP;
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('COUNT: ' || GET_NUM_TEACHERS('����'));
END;

CREATE OR REPLACE FUNCTION GET_NUM_SUBJECTS
(
PCODE SUBJECT.PULPIT%TYPE
)
RETURN NUMBER
IS 
    CURSOR SUB_CURS IS SELECT COUNT(S.SUBJECT) AS CNT FROM SUBJECT S
                       INNER JOIN PULPIT P ON P.PULPIT = S.PULPIT
                       WHERE P.PULPIT = PCODE;
BEGIN
    FOR SUB_REC IN SUB_CURS
    LOOP
        RETURN SUB_REC.CNT;
    END LOOP;
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('COUNT: ' || GET_NUM_SUBJECTS('����'));
END;



-- 5. ������������ ����� TEACHERS, ���������� ��������� � �������:
--GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
--GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER 
--GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 

CREATE OR REPLACE PACKAGE TEACHERS IS
   PROCEDURE GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE);
   PROCEDURE GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE);
   FUNCTION GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER ;
   FUNCTION GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER;
END TEACHERS;





CREATE OR REPLACE PACKAGE BODY TEACHERS IS

-- PROCS:

PROCEDURE GET_TEACHERS
(
    FCODE FACULTY.FACULTY%TYPE
)
IS
    CURSOR TCHR_CURS IS SELECT T.TEACHER_NAME , P.PULPIT , F.FACULTY FROM TEACHER T
    INNER JOIN  PULPIT P ON P.PULPIT = T.PULPIT
    INNER JOIN FACULTY F ON F.FACULTY  = P.FACULTY
    WHERE F.FACULTY = FCODE
    ;
BEGIN
    FOR TCHR_REC IN TCHR_CURS 
    LOOP
        DBMS_OUTPUT.PUT_LINE('TEACHER: ' || TCHR_REC.TEACHER_NAME || ' PULPIT: ' || RTRIM(TCHR_REC.PULPIT) || ' FACULTY: ' || TCHR_REC.FACULTY);
    END LOOP;
END;

 PROCEDURE GET_SUBJECTS
(
PCODE SUBJECT.PULPIT%TYPE
)
IS
    CURSOR SUB_CURS IS SELECT S.SUBJECT_NAME , P.PULPIT FROM SUBJECT S
    INNER JOIN PULPIT P ON P.PULPIT = S.PULPIT
    WHERE P.PULPIT = PCODE;
BEGIN
    FOR SUB_REC IN SUB_CURS
    LOOP
            DBMS_OUTPUT.PUT_LINE('NAME: ' || SUB_REC.SUBJECT_NAME  || ' PULPIT: ' || SUB_REC.PULPIT);
    END LOOP;
END;

-- FUNCS: 


FUNCTION GET_NUM_TEACHERS
(
FCODE FACULTY.FACULTY%TYPE
)
RETURN NUMBER
IS
    CURSOR TCHR_CURS IS SELECT COUNT(T.TEACHER) AS CNT FROM TEACHER T
                        INNER JOIN PULPIT P ON P.PULPIT = T.PULPIT
                        INNER JOIN FACULTY F ON F.FACULTY = P.FACULTY
                        WHERE F.FACULTY = FCODE;
BEGIN
    FOR TCHR_REC IN TCHR_CURS
    LOOP
        RETURN TCHR_REC.CNT;
    END LOOP;
END;

 FUNCTION GET_NUM_SUBJECTS
(
PCODE SUBJECT.PULPIT%TYPE
)
RETURN NUMBER
IS 
    CURSOR SUB_CURS IS SELECT COUNT(S.SUBJECT) AS CNT FROM SUBJECT S
                       INNER JOIN PULPIT P ON P.PULPIT = S.PULPIT
                       WHERE P.PULPIT = PCODE;
BEGIN
    FOR SUB_REC IN SUB_CURS
    LOOP
        RETURN SUB_REC.CNT;
    END LOOP;
END;

END TEACHERS; 


-- 6. ������������ ��������� ���� � ����������������� ���������� �������� � ������� ������ TEACHERS.

BEGIN
    DBMS_OUTPUT.PUT_LINE('------------GET_TEACHERS-------------');
    TEACHERS.GET_TEACHERS(FCODE => '����');
    DBMS_OUTPUT.PUT_LINE('------------GET_SUBJECTS-------------');
    TEACHERS.GET_SUBJECTS(PCODE => '����');
    DBMS_OUTPUT.PUT_LINE('------------GET_NUM_TEACHERS-------------');
    DBMS_OUTPUT.PUT_LINE(TEACHERS.GET_NUM_TEACHERS('����'));
    DBMS_OUTPUT.PUT_LINE('------------GET_NUM_SUBJECTS-------------');
    DBMS_OUTPUT.PUT_LINE(TEACHERS.GET_NUM_SUBJECTS('����'));
END;

DROP PROCEDURE GET_TEACHERS;
DROP PROCEDURE GET_SUBJECTS;
DROP FUNCTION GET_NUM_TEACHERS;
DROP FUNCTION GET_NUM_SUBJECTS;
DROP PACKAGE TEACHERS;
