SET SERVEROUTPUT ON;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Utilizatori';
    
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE Administrator';
    
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
END;
/
CREATE OR REPLACE TYPE Utilizator AS OBJECT(
    Pseudonim   VARCHAR(64) NULL,
    HashParola  VARCHAR(64) NULL,
    Nume        VARCHAR(64) NULL,
    Prenume     VARCHAR(64) NULL,
    
    CONSTRUCTOR FUNCTION Utilizator(pseudonim VARCHAR2, parola VARCHAR2) RETURN SELF AS RESULT,
    MEMBER FUNCTION f_HashuiesteParola(parola VARCHAR2) RETURN VARCHAR2,
    MEMBER PROCEDURE f_HashuiesteParolaProprie,
    MEMBER FUNCTION f_ComparaParolaCuHash(parola VARCHAR2, hashParola VARCHAR2) RETURN BOOLEAN,
    MAP MEMBER FUNCTION f_Map RETURN VARCHAR2
) NOT FINAL;
/
CREATE OR REPLACE TYPE BODY Utilizator
AS
    /* Constructor explicit */
    CONSTRUCTOR FUNCTION Utilizator(
        pseudonim   VARCHAR2,
        parola      VARCHAR2
    )
    RETURN SELF AS RESULT
    AS
    BEGIN
        SELF.Pseudonim  := pseudonim;
        SELF.HashParola := SELF.f_HashuiesteParola(parola);
        RETURN;
    END;
    /* Hashuieste o parola primita ca input */
    MEMBER FUNCTION f_HashuiesteParola(
        parola VARCHAR2
    )
    RETURN VARCHAR2
    AS
        hashParola VARCHAR2(64);
    BEGIN
        SELECT STANDARD_HASH(parola) INTO hashParola FROM DUAL;
        RETURN hashParola;
    END;
    /* Hashuieste parola obiectului curent */
    MEMBER PROCEDURE f_HashuiesteParolaProprie
    AS
    BEGIN
        SELECT STANDARD_HASH(SELF.HashParola) INTO SELF.HashParola FROM DUAL;
    END;
    
    MEMBER FUNCTION f_ComparaParolaCuHash(
        parola      VARCHAR2,
        hashParola  VARCHAR2
    ) 
    RETURN BOOLEAN
    AS
        hashParolaIntrodusa VARCHAR2(64);
    BEGIN
        hashParolaIntrodusa := SELF.f_HashuiesteParola(parola);
        IF hashParolaIntrodusa = hashParola
        THEN
            RETURN TRUE;
        END IF;
        RETURN FALSE;
    END;
    
    /* Mapare dupa pseudonimul utilizatorului */
    MAP MEMBER FUNCTION f_Map
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN SELF.Pseudonim;
    END;
END;
/
CREATE TABLE Utilizatori(
    ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Entitate Utilizator NOT NULL
);
/
DELETE FROM Utilizatori;
/
/* Introducere entry-uri in tabela nou creata, Utilizator*/
DECLARE
    utilizatorNou       Utilizator;
BEGIN
    utilizatorNou := Utilizator('sergiu', 'parolasergiu');
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
    utilizatorNou := Utilizator('sergiu2', 'parolasergiu2');
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
    utilizatorNou := Utilizator('sergiu3', 'parolasergiu3');
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
    utilizatorNou := Utilizator('sergiu4', 'parolasergiu4', 'Nistor', 'Sergiu');
    utilizatorNou.f_HashuiesteParolaProprie();
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
    utilizatorNou := Utilizator('sergiu5', 'parolasergiu5');
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
END;
/
/* Demonstratie ordonare */
SELECT * FROM Utilizatori ORDER BY Entitate;
/
/* Subclasa mostenitoare a clasei Utilizator */
CREATE OR REPLACE TYPE Administrator UNDER Utilizator(
    OVERRIDING MEMBER PROCEDURE f_HashuiesteParolaProprie
);
/
CREATE OR REPLACE TYPE BODY Administrator
AS
    OVERRIDING MEMBER PROCEDURE f_HashuiesteParolaProprie
    AS
    BEGIN
        /* Nu executa nicio operatie; administratorii au deja parola hashuita - s-a ocupat inginerul de sistem de chestiunea asta */
        NULL;
    END;
END;
/
/* Demonstrarea functionalitatilor */
DECLARE
    utilizatorNou       Utilizator;
BEGIN
    utilizatorNou := Utilizator('sergiu', 'parolasergiu');
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
    utilizatorNou := Utilizator('sergiu2', 'parolasergiu2');
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
    utilizatorNou := Utilizator('sergiu3', 'parolasergiu3');
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
    utilizatorNou := Utilizator('sergiu4', 'parolasergiu4', 'Nistor', 'Sergiu');
    utilizatorNou.f_HashuiesteParolaProprie();
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
    utilizatorNou := Utilizator('sergiu5', 'parolasergiu5');
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
    
    /* Administratorul nu mosteneste constructorul explicit al Utilizatorului */
    /* Fiind subclasa a Utilizatorului, o instanta a clasei Administrator poate fi introdusa in tabela de Utilizatori */
    utilizatorNou := Administrator('sergiu', 'parolasergiu', 'admin_nume', 'admin_prenume');
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
    utilizatorNou := Administrator('sergiu2', 'parolasergiu2', 'admin_nume', 'admin_prenume');
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
    utilizatorNou := Administrator('sergiu3', 'parolasergiu3', 'admin_nume', 'admin_prenume');
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
    utilizatorNou := Administrator('sergiu4', 'parolasergiu4', 'Nistor', 'Sergiu');
    /* Metoda suprascrisa */
    utilizatorNou.f_HashuiesteParolaProprie();
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
    utilizatorNou := Administrator('sergiu5', 'parolasergiu5', 'admin_nume', 'admin_prenume');
    INSERT INTO Utilizatori(Entitate) VALUES(utilizatorNou);
END;
/
SELECT * FROM Utilizatori ORDER BY Entitate;