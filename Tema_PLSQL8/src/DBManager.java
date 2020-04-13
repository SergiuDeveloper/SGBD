import org.w3c.dom.*;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class DBManager {
    public static void exportData() throws SQLException {
        Connection connection = DriverManager.getConnection(DBManager.dbConnectionString, DBManager.dbUsername, DBManager.dbPassword);

        PreparedStatement initializeDirectoryStatement = connection.prepareStatement(DBManager.initializeDirectoryQuery);
        initializeDirectoryStatement.execute();
        initializeDirectoryStatement.close();

        CallableStatement exportDataStatement = connection.prepareCall(DBManager.exportDataQuery);
        exportDataStatement.execute();
        exportDataStatement.close();

        connection.close();
    }

    public static List<Row> importData() throws ParserConfigurationException, IOException, SAXException {
        List<Row> dbRows = new ArrayList<>();

        DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
        documentBuilderFactory.setIgnoringElementContentWhitespace(true);
        documentBuilderFactory.setIgnoringComments(true);
        DocumentBuilder documentBuilder = documentBuilderFactory.newDocumentBuilder();
        Document document = documentBuilder.parse(new File("db_output.xml"));
        NodeList rowNodes = document.getDocumentElement().getChildNodes();

        Node rowNode;
        NodeList objectNodes;
        NodeList properties;
        Curs curs = null;
        Student student = null;
        Nota nota = null;
        DateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
        /* i += 2 din cauza unei erori din library-ul de DOM - newline-urile cauzeaza citirea aceluiasi row de 2 ori */
        for (int i = 1; i < rowNodes.getLength(); i += 2) {
            rowNode = rowNodes.item(i);
            objectNodes = rowNode.getChildNodes();

            for (int j = 1; j < objectNodes.getLength(); ++j) {
                switch (objectNodes.item(j).getNodeName()) {
                    case "Curs":
                        curs = new Curs();

                        properties = objectNodes.item(j).getChildNodes();
                        for (int k = 1; k < properties.getLength(); ++k) {
                            if (properties.item(k).getTextContent() == null)
                                continue;

                            try {
                                switch (properties.item(k).getNodeName()) {
                                    case "ID":
                                        curs.ID = Integer.parseInt(properties.item(k).getTextContent());
                                        break;
                                    case "An":
                                        curs.An = Integer.parseInt(properties.item(k).getTextContent());
                                        break;
                                    case "Semestru":
                                        curs.Semestru = Integer.parseInt(properties.item(k).getTextContent());
                                        break;
                                    case "Credite":
                                        curs.Credite = Integer.parseInt(properties.item(k).getTextContent());
                                        break;
                                    case "Created_At":
                                        curs.Created_At = dateFormat.parse(properties.item(k).getTextContent());
                                        break;
                                    case "Updated_At":
                                        curs.Updated_At = dateFormat.parse(properties.item(k).getTextContent());
                                        break;
                                    default:
                                        break;
                                }
                            }
                            catch (Exception ignore) {
                            }
                        }
                        break;
                    case "Student":
                        student = new Student();

                        properties = objectNodes.item(j).getChildNodes();
                        for (int k = 1; k < properties.getLength(); ++k) {
                            if (properties.item(k).getTextContent() == null)
                                continue;

                            try {
                                switch (properties.item(k).getNodeName()) {
                                    case "ID":
                                        student.ID = Integer.parseInt(properties.item(k).getTextContent());
                                        break;
                                    case "Numar_Matricol":
                                        student.Numar_Matricol = properties.item(k).getTextContent();
                                        break;
                                    case "Nume":
                                        student.Nume = properties.item(k).getTextContent();
                                        break;
                                    case "Prenume":
                                        student.Prenume = properties.item(k).getTextContent();
                                        break;
                                    case "An":
                                        student.An = Integer.parseInt(properties.item(k).getTextContent());
                                        break;
                                    case "Grupa":
                                        student.Grupa = properties.item(k).getTextContent();
                                        break;
                                    case "Bursa":
                                        student.Bursa = Integer.parseInt(properties.item(k).getTextContent());
                                        break;
                                    case "Data_Nastere":
                                        student.Data_Nastere = dateFormat.parse(properties.item(k).getTextContent());
                                        break;
                                    case "Email":
                                        student.Email = properties.item(k).getTextContent();
                                        break;
                                    case "Created_At":
                                        student.Created_At = dateFormat.parse(properties.item(k).getTextContent());
                                        break;
                                    case "Updated_At":
                                        student.Updated_At = dateFormat.parse(properties.item(k).getTextContent());
                                        break;
                                    default:
                                        break;
                                }
                            }
                            catch (Exception ignore) {
                            }
                        }
                        break;
                    case "Nota":
                        nota = new Nota();

                        properties = objectNodes.item(j).getChildNodes();
                        for (int k = 1; k < properties.getLength(); ++k) {
                            if (properties.item(k).getTextContent() == null)
                                continue;

                            try {
                                switch (properties.item(k).getNodeName()) {
                                    case "ID":
                                        nota.ID = Integer.parseInt(properties.item(k).getTextContent());
                                        break;
                                    case "Valoare":
                                        nota.Valoare = Float.parseFloat(properties.item(k).getTextContent());
                                        break;
                                    case "Data_Notare":
                                        nota.Data_Notare = dateFormat.parse(properties.item(k).getTextContent());
                                        break;
                                    case "Created_At":
                                        nota.Created_At = dateFormat.parse(properties.item(k).getTextContent());
                                        break;
                                    case "Updated_At":
                                        nota.Updated_At = dateFormat.parse(properties.item(k).getTextContent());
                                        break;
                                    default:
                                        break;
                                }
                            }
                            catch (Exception ignore) {
                            }
                        }
                        break;
                    default:
                        break;
                }
            }
            dbRows.add(new Row(curs, student, nota));
        }
        return dbRows;
    }

    private static String dbConnectionString = "jdbc:oracle:thin:@localhost:1521:orcl";
    private static String dbUsername = "STUDENT";
    private static String dbPassword = "STUDENT";

    private static String initializeDirectoryQuery = "CREATE OR REPLACE DIRECTORY OUTPUT_DIR as 'C:\\Users\\Sergiu\\Desktop\\Facultate\\An 2\\SGBD\\Tema_PLSQL8'";
    private static String exportDataQuery = "" +
            "DECLARE  " +
            "    output_file         UTL_FILE.FILE_TYPE;  " +
            "BEGIN  " +
            "    output_file := UTL_FILE.FOPEN('OUTPUT_DIR', 'db_output.xml', 'w');  " +
            "      " +
            "    UTL_FILE.PUT_LINE(output_file, '<?xml version=\"1.0\" encoding=\"UTF-8\"?>');  " +
            "    UTL_FILE.PUT_LINE(output_file, '<QueryResults>');  " +
            "      " +
            "    FOR db_row IN (SELECT   " +
            "        Cursuri.ID AS Cursuri_ID,  " +
            "        Cursuri.An AS Cursuri_An,  " +
            "        Cursuri.Semestru AS Cursuri_Semestru,  " +
            "        Cursuri.Credite AS Cursuri_Credite,  " +
            "        Cursuri.Created_At AS Cursuri_Created_At,  " +
            "        Cursuri.Updated_At AS Cursuri_Updated_At,  " +
            "        Studenti.ID AS Studenti_ID,  " +
            "        Studenti.Nr_Matricol AS Studenti_Nr_Matricol,  " +
            "        Studenti.Nume AS Studenti_Nume,  " +
            "        Studenti.Prenume AS Studenti_Prenume,  " +
            "        Studenti.An AS Studenti_An,  " +
            "        Studenti.Grupa AS Studenti_Grupa,  " +
            "        Studenti.Bursa AS Studenti_Bursa,  " +
            "        Studenti.Data_Nastere AS Studenti_Data_Nastere,  " +
            "        Studenti.Email AS Studenti_Email,  " +
            "        Studenti.Created_At AS Studenti_Created_At,  " +
            "        Studenti.Updated_At AS Studenti_Updated_At,  " +
            "        Note.ID AS Note_ID,  " +
            "        Note.Valoare AS Note_Valoare,  " +
            "        Note.Data_Notare AS Note_Data_Notare,  " +
            "        Note.Created_At AS Note_Created_At,  " +
            "        Note.Updated_At AS Note_Updated_At   " +
            "        FROM Note FULL OUTER JOIN Cursuri ON Cursuri.ID = Note.ID_Curs FULL OUTER JOIN Studenti ON Studenti.ID = Note.ID_Student)  " +
            "    LOOP  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || '<Row>');  " +
            "          " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || '<Curs>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<ID>' || TO_CHAR(db_row.Cursuri_ID) || '</ID>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<An>' || TO_CHAR(db_row.Cursuri_An) || '</An>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Semestru>' || TO_CHAR(db_row.Cursuri_Semestru) || '</Semestru>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Credite>' || TO_CHAR(db_row.Cursuri_Credite) || '</Credite>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Created_At>' || TO_CHAR(db_row.Cursuri_Created_At) || '</Created_At>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Updated_At>' || TO_CHAR(db_row.Cursuri_Updated_At) || '</Updated_At>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || '</Curs>');  " +
            "          " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || '<Student>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<ID>' || TO_CHAR(db_row.Studenti_ID) || '</ID>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Nr_Matricol>' || TO_CHAR(db_row.Studenti_Nr_Matricol) || '</Nr_Matricol>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Nume>' || TO_CHAR(db_row.Studenti_Nume) || '</Nume>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Prenume>' || TO_CHAR(db_row.Studenti_Prenume) || '</Prenume>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<An>' || TO_CHAR(db_row.Studenti_An) || '</An>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Grupa>' || TO_CHAR(db_row.Studenti_Grupa) || '</Grupa>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Bursa>' || TO_CHAR(db_row.Studenti_Bursa) || '</Bursa>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Data_Nastere>' || TO_CHAR(db_row.Studenti_Data_Nastere) || '</Data_Nastere>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Email>' || TO_CHAR(db_row.Studenti_Email) || '</Email>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Created_At>' || TO_CHAR(db_row.Studenti_Created_At) || '</Created_At>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Updated_At>' || TO_CHAR(db_row.Studenti_Updated_At) || '</Updated_At>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || '</Student>');  " +
            "          " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || '<Nota>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<ID>' || TO_CHAR(db_row.Note_ID) || '</ID>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Valoare>' || TO_CHAR(db_row.Note_Valoare) || '</Valoare>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Data_Notare>' || TO_CHAR(db_row.Note_Data_Notare) || '</Data_Notare>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Created_At>' || TO_CHAR(db_row.Note_Created_At) || '</Created_At>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || CHR(9) || '<Updated_At>' || TO_CHAR(db_row.Note_Updated_At) || '</Updated_At>');  " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || CHR(9) || '</Nota>');  " +
            "          " +
            "        UTL_FILE.PUT_LINE(output_file, CHR(9) || '</Row>');  " +
            "    END LOOP;  " +
            "      " +
            "    UTL_FILE.PUT_LINE(output_file, '</QueryResults>');  " +
            "      " +
            "    UTL_FILE.FCLOSE(output_file);  " +
            "END;";
}
