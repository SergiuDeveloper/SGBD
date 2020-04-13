SET SERVEROUTPUT ON;
/
/* Pastram doar prima nota a studentilor de la toate materiile */
DECLARE
    prima_nota_id Note.id%TYPE;
BEGIN
    FOR student IN (SELECT * FROM studenti)
    LOOP
        SELECT id INTO prima_nota_id FROM note WHERE id_student = student.id AND ROWNUM < 2;
        IF prima_nota_id = NULL THEN
            DELETE FROM note WHERE id_student = student.id AND id != prima_nota_id;
        END IF;
    END LOOP;
END;
/
/* Adaugam cheia unica in tabla note, daca aceasta nu exista; Fiecare student va avea doar o nota / materie */
DECLARE
    constraint_appearances_count NUMBER;
BEGIN
    /* Verificam de cate ori apare constraint-ul in tabela ALL_CONSTRAINTS */
    SELECT COUNT(*) INTO constraint_appearances_count FROM ALL_CONSTRAINTS WHERE TABLE_NAME = 'NOTE' AND CONSTRAINT_NAME = 'NOTA_UNICA';

    IF constraint_appearances_count = 0 THEN
        EXECUTE IMMEDIATE '
            ALTER TABLE Note ADD CONSTRAINT nota_unica UNIQUE (id_student, id_curs)
        ';
    END IF;
END;
/
/* Stored procedure care introduce pentru studentul X, la materia Y, nota Z, daca nu are nota la materia respectiva */
CREATE OR REPLACE PROCEDURE sp_InsertGradeIfNotExists(
    student_id Studenti.id%TYPE,
    course_title Cursuri.titlu_curs%TYPE,
    grade Note.valoare%TYPE
)
AS
    course_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT(course_not_found, -20001);
    course_id Cursuri.id%TYPE;
    grade_count NUMBER;
    latest_grade_id Note.id%TYPE;
BEGIN
    /* Cautam ID-ul cursului specificat ca parametru */
    SELECT id INTO course_id FROM Cursuri WHERE titlu_curs = course_title;
    IF course_id = NULL THEN
        RAISE course_not_found;
    END IF;
    
    /* Daca studentul nu are nota la cursul respectiv, o adaugam */
    SELECT COUNT(*) INTO grade_count FROM Note WHERE id_student = student_id AND id_curs = course_id;
    IF grade_count = 0 THEN
        /* Luam cel mai mare id din tabela Note */
        SELECT MAX(id) INTO latest_grade_id FROM Note;
        
        /* Adaugam noul entry */
        INSERT INTO
            Note(id, id_student, id_curs, valoare, data_notare, created_at, updated_at)
            VALUES(latest_grade_id + 1, student_id, course_id, grade, SYSDATE, SYSDATE, SYSDATE);
    END IF;
    
    /* Bloc de capturare a exceptiilor */
    EXCEPTION
        /* Exceptia course_not_found, declarata anterior */
        WHEN course_not_found THEN
            DBMS_OUTPUT.PUT_LINE('The course ' || course_title || ' could not be found in the Cursuri table.');
            RAISE;
END;
/
/* Stored procedure care introduce pentru studentul X, la materia Y, nota Z, chiar daca are nota la materia respectiva, caz in care prinde exceptia */
CREATE OR REPLACE PROCEDURE sp_InsertGrade(
    student_id Studenti.id%TYPE,
    course_title Cursuri.titlu_curs%TYPE,
    grade Note.valoare%TYPE
)
AS
    course_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT(course_not_found, -20001);
    course_id Cursuri.id%TYPE;
    latest_grade_id Note.id%TYPE;
BEGIN
    /* Cautam ID-ul cursului specificat ca parametru */
    SELECT id INTO course_id FROM Cursuri WHERE titlu_curs = course_title;
    IF course_id = NULL THEN
        RAISE course_not_found;
    END IF;
    
    /* Luam cel mai mare id din tabela Note */
    SELECT MAX(id) INTO latest_grade_id FROM Note;
        
    /* Adaugam noul entry */
    INSERT INTO
        Note(id, id_student, id_curs, valoare, data_notare, created_at, updated_at)
        VALUES(latest_grade_id + 1, student_id, course_id, grade, SYSDATE, SYSDATE, SYSDATE);
        
    /* Bloc de capturare a exceptiilor */
    EXCEPTION
        /* Exceptia de nota unica */
        WHEN DUP_VAL_ON_INDEX THEN
            /* Commented due to buffer overflow */
            /*DBMS_OUTPUT.PUT_LINE('The student with id ' || student_id || ' already has a grade in the ' || course_title || ' course.');*/
            NULL;
        /* Exceptia course_not_found, declarata anterior */
        WHEN course_not_found THEN
            DBMS_OUTPUT.PUT_LINE('The course ' || course_title || ' could not be found in the Cursuri table.');
            RAISE;
END;
/
/* 1.000.000 de incercari de inserare cu prima metoda - 74 secunde */
DECLARE
    students_count NUMBER;
    executions_count NUMBER := 0;
    desired_executions_count NUMBER := 1000000;
BEGIN
    SELECT COUNT(*) INTO students_count FROM Studenti;

    WHILE executions_count < desired_executions_count
    LOOP
        FOR student IN (SELECT * FROM Studenti)
        LOOP
            IF executions_count < desired_executions_count THEN
                sp_InsertGradeIfNotExists(student.id, 'Logicã', ROUND(DBMS_RANDOM.VALUE(1, 10)));
                
                executions_count := executions_count + 1;
            END IF;
        END LOOP;
    END LOOP;
END;
/
/* 1.000.000 de incercari de inserare cu a doua metoda - mai mult de 74 secunde; da crash aplicatia la un punct */
DECLARE
    students_count NUMBER;
    executions_count NUMBER := 0;
    desired_executions_count NUMBER := 1000000;
BEGIN
    SELECT COUNT(*) INTO students_count FROM Studenti;

    WHILE executions_count < desired_executions_count
    LOOP
        FOR student IN (SELECT * FROM Studenti)
        LOOP
            IF executions_count < desired_executions_count THEN
                sp_InsertGrade(student.id, 'Logicã', ROUND(DBMS_RANDOM.VALUE(1, 10)));
                    
                executions_count := executions_count + 1;
            END IF;
        END LOOP;
    END LOOP;
END;
/
/* Functia returneaza media unui student, pe baza numelui si prenumelui sau */
CREATE OR REPLACE FUNCTION f_GetAverageGrade(
    first_name Studenti.prenume%TYPE,
    last_name Studenti.nume%TYPE
)
RETURN FLOAT AS
    student_not_found EXCEPTION;
    PRAGMA EXCEPTION_INIT(student_not_found, -20002);
    student_id NUMBER;
    student_average_grades_list LISTA_MEDII_TYPE;
BEGIN
    /* Obtinem id-ul studentului primit ca input */
    SELECT id, lista_medii INTO student_id, student_average_grades_list FROM Studenti WHERE nume = last_name AND prenume = first_name AND ROWNUM < 2;
    IF student_id = NULL OR student_average_grades_list.COUNT = 0 THEN
        RAISE student_not_found;
    END IF;

    /* Returnam ultima sa medie */
    RETURN student_average_grades_list(student_average_grades_list.LAST).Medie;

    EXCEPTION
        WHEN student_not_found THEN
            DBMS_OUTPUT.PUT_LINE(first_name || ' ' || last_name || ' could not be found in the Studenti table.');
            RAISE;
END;
/
DECLARE
    TYPE STUDENT_INPUT_TYPE IS RECORD(first_name studenti.prenume%TYPE, last_name studenti.nume%TYPE);
    TYPE STUDENT_INPUT_TABLE_TYPE IS TABLE OF STUDENT_INPUT_TYPE;
    student_input_table STUDENT_INPUT_TABLE_TYPE := STUDENT_INPUT_TABLE_TYPE();
    student_counter NUMBER;
BEGIN
    student_input_table.EXTEND(6);
    student_input_table(1).first_name := 'Matei';
    student_input_table(1).last_name := 'Bulai';
    student_input_table(2).first_name := 'Marian';
    student_input_table(2).last_name := 'Crucerescu';
    student_input_table(3).first_name := 'Studentul';
    student_input_table(3).last_name := 'Inexistent 1';
    student_input_table(4).first_name := 'Elena';
    student_input_table(4).last_name := 'Durnea';
    student_input_table(5).first_name := 'Studentul';
    student_input_table(5).last_name := 'Inexistent 2';
    student_input_table(6).first_name := 'Studentul';
    student_input_table(6).last_name := 'Inexistent 3';
    
    student_counter := 1;
    
    FOR student_input_table_iterator IN student_input_table.FIRST .. student_input_table.LAST
    LOOP
        BEGIN
            DBMS_OUTPUT.PUT('Student ' || student_input_table(student_input_table_iterator).first_name || ' ' || student_input_table(student_input_table_iterator).last_name || ': ');
            
            DBMS_OUTPUT.PUT_LINE(f_GetAverageGrade(student_input_table(student_input_table_iterator).first_name, student_input_table(student_input_table_iterator).last_name));
            
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Error');
                    NULL;
        END;
    END LOOP;
END;