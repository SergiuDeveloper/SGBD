import org.xml.sax.SAXException;

import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Scanner;

public class PLSQL8 {
    public static void main(String[] args) throws SQLException, IOException, ParserConfigurationException, SAXException, ParseException {
        System.out.println("1. Export data");
        System.out.println("2. Import data");

        Scanner consoleScanner = new Scanner(System.in);
        switch (consoleScanner.nextInt()) {
            case 1: DBManager.exportData(); break;
            case 2: DBManager.importData().forEach(System.out::println); break;
            default: break;
        }
    }
}
