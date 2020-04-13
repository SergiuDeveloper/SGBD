/*
    intr-un bloc anonim, facem un insert, un student, cu informatiile id, nr_matricol, nume, prenume, an, grupa, data_nasterii
    din toate informatiile, vom genera aleator id, nr_matricol, an
        DBMS_RANDOM.VALUE(1, 10)
        DBMS_RANDOM.STRING('U'/ 'A', lungime)
        
    afisati id->datele studentului
    
    si apelam 2 proceduri
    1. prima insereaza note in functie de an(la cursuri din anul respectiv si anii anteriori)
    2. afisare varsta studentului in ani, luni, zile
*/

/*
SET SERVEROUTPUT ON;
*/

/*
DECLARE 
    maxID studenti.id%TYPE;
    minAn studenti.an%type;
    maxAn studenti.an%TYPE;
BEGIN
    SELECT MAX(id), MIN(an), MAX(an) INTO maxID, minAn, maxAn FROM studenti;
    
    INSERT INTO studenti(id, nr_matricol, nume, prenume, an, grupa, data_nastere)
    VALUES(DBMS_RANDOM.VALUE(maxID + 1, maxID + 1), TRIM(TRIM(TO_CHAR(DBMS_RANDOM.VALUE(100, 999), '999')) || TRIM(DBMS_RANDOM.STRING('U', 2)) || TRIM(TO_CHAR(DBMS_RANDOM.VALUE(0, 9), '9'))), 'Nistor', 'Sergiu', DBMS_RANDOM.VALUE(1, maxAn), 'B6', '15-AUG-1998');
END;
*/

/*
SELECT * FROM studenti WHERE nume = 'Nistor' AND prenume = 'Sergiu';
*/

/*
CREATE OR REPLACE PROCEDURE sp_InserareNota(
    numeStudent studenti.nume%TYPE,
    prenumeStudent studenti.prenume%TYPE,
    notaStudent note.valoare%TYPE,
    materie cursuri.titlu_curs%TYPE
)
AS
    anStudent studenti.an%TYPE;
    anMaterie cursuri.an%TYPE;
    idStudent studenti.id%TYPE;
    idCurs cursuri.id%TYPE;
    idNota note.id%TYPE;
BEGIN
    SELECT an, id INTO anStudent, idStudent FROM studenti WHERE nume = numeStudent AND prenume = prenumeStudent;
    
    SELECT an, id INTO anMaterie, idCurs FROM cursuri WHERE titlu_curs = materie;
    
    SELECT MAX(ID) INTO idNota FROM note;
    idNota := idNota + 1;
    
    IF anStudent < anMaterie THEN
        DBMS_OUTPUT.PUT_LINE('Studentul este in anul ' || anStudent || ' in timp ce materia este de anul ' || anMaterie);
        RETURN;
    END IF;
    
    INSERT INTO note(id, id_student, id_curs, valoare, data_notare)
    VALUES (idNota, idStudent, idCurs, notaStudent, CURRENT_DATE);
END sp_InserareNota;
*/

/*
BEGIN
    sp_InserareNota('Nistor', 'Sergiu', 10, 'Practicã SGBD');
END;
*/

/*
CREATE OR REPLACE PROCEDURE sp_VarstaStudent(
    numeStudent studenti.nume%TYPE,
    prenumeStudent studenti.prenume%TYPE
)
AS
    dataNastereStudent studenti.data_nastere%TYPE;
BEGIN
    SELECT data_nastere INTO dataNastereStudent FROM studenti WHERE nume = numeStudent AND prenume = prenumeStudent;
    
    DBMS_OUTPUT.PUT_LINE(trunc(months_between(CURRENT_DATE, dataNastereStudent) / 12) || ' Ani, ' ||
        trunc(months_between(CURRENT_DATE, dataNastereStudent) -
        (trunc(months_between(CURRENT_DATE, dataNastereStudent) / 12) * 12)) || ' Luni ' ||
        trunc(CURRENT_DATE) - add_months(dataNastereStudent, trunc(months_between(CURRENT_DATE, dataNastereStudent))) || ' Zile');
END sp_VarstaStudent;
*/

/*
BEGIN
    sp_VarstaStudent('Nistor', 'Sergiu');
END;
*/