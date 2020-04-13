SET SERVEROUTPUT ON;

/* Reprezinta un entry intr-o tabela de tip LISTA_MEDII_TYPE */
CREATE OR REPLACE TYPE LISTA_MEDII_RECORD AS OBJECT (
    An NUMBER,
    Semestru NUMBER,
    Medie FLOAT
);
/
/* Tabela tip LISTA_MEDII_TYPE */
CREATE OR REPLACE TYPE LISTA_MEDII_TYPE AS TABLE OF LISTA_MEDII_RECORD;
/
ALTER TABLE studenti ADD (
    Lista_Medii LISTA_MEDII_TYPE
)
NESTED TABLE Lista_Medii STORE AS Lista_Medii_Tab;
/
/* Adaugam pentru fiecare student datele pe coloana "lista_medii" */
DECLARE
    lista_medii_row LISTA_MEDII_RECORD;
    lista_medii_new LISTA_MEDII_TYPE;
    nrNote NUMBER;
    medie FLOAT;
    minAn NUMBER;
    maxAn NUMBER;
    minSemestru NUMBER;
    maxSemestru NUMBER;
BEGIN
    /* Calculare valoarea minima si maxima a field-ului "an" din tabela cursuri */
    SELECT MIN(an) INTO minAn FROM cursuri;
    SELECT MAX(an) INTO maxAn FROM cursuri;

    FOR student IN (SELECT * FROM studenti)
    LOOP
        lista_medii_new := LISTA_MEDII_TYPE();
    
        FOR an_curs IN minAn..maxAn
        LOOP
            /* Calculare valoarea minima si maxima a field-ului "semestru" din tabela cursuri */
            SELECT MIN(semestru) INTO minSemestru FROM cursuri WHERE cursuri.an = an_curs;
            SELECT MAX(semestru) INTO maxSemestru FROM cursuri WHERE cursuri.an = an_curs;
        
            FOR semestru_curs IN minSemestru..maxSemestru
            LOOP
                /* Calculam media per an, per semestru */
                SELECT AVG(note.valoare), COUNT(*) INTO medie, nrNote FROM note
                    JOIN cursuri ON cursuri.id = note.id_curs
                    WHERE cursuri.an = an_curs AND cursuri.semestru = semestru_curs AND note.id_student = student.id;
                    
                /* Daca are note, adaugam un entry in lista_medii_row */
                IF nrNote > 0 THEN
                    lista_medii_row := LISTA_MEDII_RECORD(an_curs, semestru_curs, medie);
                    
                    lista_medii_new.EXTEND();
                    lista_medii_new(lista_medii_new.COUNT) := lista_medii_row;
                END IF;
            END LOOP;
        END LOOP;
        
        /* Populam nested table-ul lista_medii */
        UPDATE studenti SET lista_medii = lista_medii_new WHERE id = student.id;
    END LOOP;
END;
/
/* Functia care determina cate medii are un student */
CREATE OR REPLACE FUNCTION f_Get_Lista_Medii_Count_For_Student(student_id NUMBER)
RETURN NUMBER
IS
    counter NUMBER;
    lista_medii_entry LISTA_MEDII_TYPE;
BEGIN
    counter := 0;
    /* Obtinem lista de medii a studentului */
    SELECT lista_medii INTO lista_medii_entry FROM studenti WHERE id = student_id;
    /* Iteram prin lista si incrementam counter-ul */
    FOR medie IN lista_medii_entry.FIRST..lista_medii_entry.LAST
    LOOP
        counter := counter + 1;
    END LOOP;
    
    RETURN counter;
END f_Get_Lista_Medii_Count_For_Student;
/
/* Student cu note */
BEGIN
    DBMS_OUTPUT.PUT_LINE(f_Get_Lista_Medii_Count_For_Student(3));
END;
/
/* Student fara note */
BEGIN
    DBMS_OUTPUT.PUT_LINE(f_Get_Lista_Medii_Count_For_Student(1020));
END;