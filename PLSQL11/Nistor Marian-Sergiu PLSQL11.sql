SET SERVEROUTPUT ON;
/
DECLARE
    user_table_entries      NUMBER;
    procedure_lines_count   NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('User tables:');
    FOR user_table IN (SELECT * FROM USER_TABLES)
    LOOP
        DBMS_OUTPUT.PUT_LINE(CHR(9) || 'Table ' || user_table.TABLE_NAME || 
            CASE
                WHEN user_table.NESTED = 'NO' THEN ''
                ELSE '(Nested)'
            END
        || ':');
        
        DBMS_OUTPUT.PUT_LINE(CHR(9) || CHR(9) || 'Entries: ' ||
            CASE 
                WHEN user_table.NUM_ROWS IS NOT NULL THEN user_table.NUM_ROWS
                ELSE 0
            END
        );
        
        DBMS_OUTPUT.PUT_LINE(CHR(9) || CHR(9) || 'Constraints: ');
        FOR user_constraint IN (SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = user_table.TABLE_NAME)
        LOOP
            DBMS_OUTPUT.PUT(CHR(9) || CHR(9) || CHR(9) || 'Constraint ' || user_constraint.TABLE_NAME || '.' || user_constraint.CONSTRAINT_NAME || ' ');
            DBMS_OUTPUT.PUT_LINE(
                CASE user_constraint.CONSTRAINT_TYPE
                    WHEN 'C' THEN 'CHECK'
                    WHEN 'P' THEN 'PRIMARY KEY'
                    WHEN 'U' THEN 'UNIQUE KEY'
                    WHEN 'R' THEN 'FOREIGN KEY'
                    WHEN 'V' THEN 'CHECK OPTION ON A VIEW'
                    WHEN 'O' THEN 'READ ONLY ON A VIEW'
                END
                ||
                CASE
                    WHEN user_constraint.SEARCH_CONDITION IS NOT NULL THEN (', ' || user_constraint.SEARCH_CONDITION)
                    ELSE ''
                END
            );
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE(CHR(9) || CHR(9) || 'Indexes: ');
        FOR user_index IN (SELECT * FROM USER_INDEXES WHERE TABLE_NAME = user_table.TABLE_NAME)
        LOOP
            DBMS_OUTPUT.PUT(CHR(9) || CHR(9) || CHR(9) || 'Index ' || user_index.TABLE_NAME || '.' || user_index.INDEX_NAME || ' ');
            DBMS_OUTPUT.PUT_LINE(user_index.UNIQUENESS || ', ' || user_index.INDEX_TYPE);
        END LOOP;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('User procedures:');
    FOR user_procedure IN (SELECT * FROM USER_PROCEDURES WHERE OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION'))
    LOOP
        DBMS_OUTPUT.PUT_LINE(CHR(9) || 'Procedure ' || user_procedure.OBJECT_NAME || '(' || 
            CASE user_procedure.DETERMINISTIC
                WHEN 'NO' THEN 'Nondeterministic'
                WHEN 'YES' THEN 'Deterministic'
            END
        || '):');
        
        SELECT COUNT(*) INTO procedure_lines_count FROM USER_SOURCE WHERE NAME = user_procedure.OBJECT_NAME AND TYPE IN ('PROCEDURE', 'FUNCTION'); 
        DBMS_OUTPUT.PUT_LINE(CHR(9) || CHR(9) || 'Number of lines: ' || procedure_lines_count);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
END;