CREATE OR REPLACE VIEW Catalog AS (
    SELECT Studenti.Nume AS Nume, Studenti.Prenume AS Prenume, Cursuri.Titlu_Curs AS Materie, Note.Valoare AS Nota FROM Note
        FULL OUTER JOIN Studenti ON Studenti.ID = Note.ID_Student
        FULL OUTER JOIN Cursuri ON Cursuri.ID = Note.ID_Curs
);
/
CREATE OR REPLACE TRIGGER t_Catalog_Insert INSTEAD OF INSERT ON Catalog
DECLARE
    students_count  NUMBER;
    student_exists  BOOLEAN;
    course_year     Cursuri.An%TYPE;
    min_student_ID  Studenti.ID%TYPE;
    max_student_ID  Studenti.ID%TYPE;
    student_group   Studenti.Grupa%TYPE;
    course_ID       Cursuri.ID%TYPE;
    student_ID      Studenti.ID%TYPE;
    max_grades_ID   Note.ID%TYPE;
BEGIN
    SELECT COUNT(*) INTO students_count FROM Studenti WHERE Studenti.Nume = :NEW.Nume AND Studenti.Prenume = :NEW.Prenume;
    IF students_count > 0 THEN
        student_exists := TRUE;
    ELSE
        student_exists := FALSE;
    END IF;

    IF student_exists = FALSE THEN
        SELECT Cursuri.ID, Cursuri.An INTO course_ID, course_year FROM Cursuri WHERE Cursuri.Titlu_Curs = :NEW.Materie;
        SELECT MIN(Studenti.ID), MAX(Studenti.ID) INTO min_student_ID, max_student_ID FROM Studenti;
        SELECT Studenti.Grupa INTO student_group FROM Studenti WHERE Studenti.ID = ROUND(DBMS_RANDOM.VALUE(min_student_ID, max_student_ID));

        DBMS_OUTPUT.PUT_LINE(student_group);

        INSERT INTO Studenti(
            ID,
            Nr_Matricol,
            Nume,
            Prenume,
            An,
            Grupa,
            Email,
            Created_At,
            Updated_At
        )
        VALUES(
            max_student_ID + 1,
            CONCAT(CONCAT(TRIM(TO_CHAR(ROUND(DBMS_RANDOM.VALUE(100, 999)))), TRIM(DBMS_RANDOM.STRING('U', 2))), TRIM(TO_CHAR(ROUND(DBMS_RANDOM.VALUE(0, 9))))),
            :NEW.Nume,
            :NEW.Prenume,
            course_year,
            student_group,
            TRIM(CONCAT(CONCAT(CONCAT(:NEW.Nume, '.'), :NEW.Prenume), '@info.uaic.ro')),
            CURRENT_DATE,
            CURRENT_DATE
        );
    END IF;

    student_ID := max_student_ID + 1;

    SELECT MAX(Note.ID) INTO max_grades_ID FROM Note;

    INSERT INTO Note(
        ID,
        ID_Student,
        ID_Curs,
        Valoare,
        Data_Notare,
        Created_At,
        Updated_At
    )
    VALUES(
        max_grades_ID + 1,
        student_ID,
        course_ID,
        :NEW.Nota,
        CURRENT_DATE,
        CURRENT_DATE,
        CURRENT_DATE
    );
END;
/
CREATE OR REPLACE TRIGGER t_Catalog_Update INSTEAD OF UPDATE ON Catalog
DECLARE
    student_ID      Studenti.ID%TYPE;
    course_ID       Cursuri.ID%TYPE;
    new_course_ID   Cursuri.ID%TYPE;
BEGIN
    SELECT Studenti.ID INTO student_ID FROM Studenti WHERE Studenti.Nume = :OLD.Nume AND Studenti.Prenume = :OLD.Prenume;

    IF :OLD.Nume != :NEW.Nume OR :OLD.Prenume != :NEW.Prenume THEN
        UPDATE Studenti SET Studenti.Nume = :NEW.Nume, Studenti.Prenume = :NEW.Prenume WHERE Studenti.ID = student_ID;
    END IF;
    
    IF :OLD.Materie != :NEW.Materie OR :OLD.Nota != :NEW.Nota THEN
        SELECT Cursuri.ID INTO course_ID FROM Cursuri WHERE Cursuri.Titlu_Curs = :OLD.Materie;
        SELECT Cursuri.ID INTO new_course_ID FROM Cursuri WHERE Cursuri.Titlu_Curs = :NEW.Materie;
    
        UPDATE Note SET Note.ID_Curs = new_course_ID, Note.Valoare = :NEW.Nota WHERE Note.ID_Student = student_ID AND Note.ID_Curs = course_ID AND Note.Valoare = :OLD.Nota;
    END IF;
END;
/
CREATE OR REPLACE TRIGGER t_Catalog_Delete INSTEAD OF DELETE ON Catalog
DECLARE
    student_ID  Studenti.ID%TYPE;
    course_ID   Cursuri.ID%TYPE;
BEGIN
    SELECT Studenti.ID INTO student_ID FROM Studenti WHERE Studenti.Nume = :OLD.Nume AND Studenti.Prenume = :OLD.Prenume;
    SELECT Cursuri.ID INTO course_ID FROM Cursuri WHERE Cursuri.Titlu_Curs = :OLD.Materie;
    
    DELETE FROM Note WHERE Note.ID_Student = student_ID AND Note.ID_Curs = course_ID AND Note.Valoare = :OLD.Nota;
END;