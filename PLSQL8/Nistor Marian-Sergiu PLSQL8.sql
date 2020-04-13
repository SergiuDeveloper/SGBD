CREATE OR REPLACE DIRECTORY GRADES_OUTPUT_DIR AS 'D:\STUDENT';
/
DECLARE
    output_grades_file  UTL_FILE.FILE_TYPE;
    grades_file_line    VARCHAR2(1024);
BEGIN
    output_grades_file := UTL_FILE.FOPEN('GRADES_OUTPUT_DIR', 'grades.csv', 'W');
    
    grades_file_line := '';
    FOR grades_column IN (SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'NOTE')
    LOOP
        grades_file_line := grades_file_line || grades_column.COLUMN_NAME || ', ';
    END LOOP;
    IF LENGTH(grades_file_line) > 2 THEN
        grades_file_line := SUBSTR(grades_file_line, 0, LENGTH(grades_file_line) - 2);
        UTL_FILE.PUT_LINE(output_grades_file, grades_file_line);
    END IF;
    
    FOR grades_row IN (SELECT * FROM Note)
    LOOP
        grades_file_line := TO_CHAR(grades_row.ID)          || ', ' ||
                            TO_CHAR(grades_row.ID_Student)  || ', ' ||
                            TO_CHAR(grades_row.ID_Curs)     || ', ' ||
                            TO_CHAR(grades_row.Valoare)     || ', ' ||
                            TO_CHAR(grades_row.Data_Notare) || ', ' ||
                            TO_CHAR(grades_row.Created_At)  || ', ' ||
                            TO_CHAR(grades_row.Updated_At);
        UTL_FILE.PUT_LINE(output_grades_file, grades_file_line);
    END LOOP;
    
    UTL_FILE.FCLOSE(output_grades_file);
END;
/
DELETE FROM Note;
/
DECLARE
    input_grades_file UTL_FILE.FILE_TYPE;
    grades_file_line    VARCHAR2(1024);
BEGIN
    input_grades_file := UTL_FILE.FOPEN('GRADES_OUTPUT_DIR', 'grades.csv', 'R');
    
    /* Prima linie contine numele coloanelor */
    UTL_FILE.GET_LINE(input_grades_file, grades_file_line);
    LOOP
        UTL_FILE.GET_LINE(input_grades_file, grades_file_line);
        
        INSERT INTO Note(
            ID,
            ID_Student,
            ID_Curs,
            Valoare,
            Data_Notare,
            Created_At,
            Updated_At
        )
        VALUES (
            TO_NUMBER(REGEXP_SUBSTR(grades_file_line, '[^,]+', 1, 1)),
            TO_NUMBER(REGEXP_SUBSTR(grades_file_line, '[^,]+', 1, 2)),
            TO_NUMBER(REGEXP_SUBSTR(grades_file_line, '[^,]+', 1, 3)),
            TO_NUMBER(REGEXP_SUBSTR(grades_file_line, '[^,]+', 1, 4)),
            TO_DATE(REGEXP_SUBSTR(grades_file_line, '[^,]+', 1, 5)),
            TO_DATE(REGEXP_SUBSTR(grades_file_line, '[^,]+', 1, 6)),
            TO_DATE(REGEXP_SUBSTR(grades_file_line, '[^,]+', 1, 7))
        );
    END LOOP;
    
    /* Loop-ul se opreste cand da exception */
    EXCEPTION
        WHEN OTHERS THEN
            UTL_FILE.FCLOSE(input_grades_file);
END;
/
SELECT * FROM Note;