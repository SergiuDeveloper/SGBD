--ex1
/*DECLARE
    v_nume VARCHAR2(20);
    v_prenume VARCHAR2(20);
BEGIN
    SELECT nume, prenume INTO v_nume, v_prenume FROM studenti WHERE id = 254;
    DBMS_OUTPUT.PUT_LINE('Studentul se numeste ' || v_nume || ' ' || v_prenume || '.');
END;*/

--ex2 nume, prenume, medie, nr prietenii pt primii 3 studenti conform topului mediilor
DECLARE
    medie_max FLOAT;
    id_student_max NUMBER;
    nume_max VARCHAR(20);
    prenume_max VARCHAR(20);
    nr_prietenii_max NUMBER;
BEGIN
    FOR rownum_counter IN 1..3
    LOOP
        SELECT id_student, medie INTO id_student_max, medie_max FROM (
            SELECT id_student, medie FROM (
                SELECT id_student, AVG(valoare) AS medie FROM note
                GROUP BY id_student
                ORDER BY medie DESC
            )
            WHERE ROWNUM <= rownum_counter
            MINUS
            SELECT id_student, medie FROM (
                SELECT id_student, AVG(valoare) AS medie FROM note
                GROUP BY id_student
                ORDER BY medie DESC
            )
            WHERE ROWNUM <= rownum_counter - 1
        );
        
        SELECT nume, prenume INTO nume_max, prenume_max FROM studenti WHERE id = id_student_max;
        
        SELECT COUNT(*) INTO nr_prietenii_max FROM prieteni WHERE id_student1 = id_student_max
        GROUP BY id_student1;
        
        DBMS_OUTPUT.PUT_LINE(nume_max || ' ' || prenume_max || ', media ' || medie_max || ', nr prietenii ' || nr_prietenii_max);
    END LOOP;
END;
