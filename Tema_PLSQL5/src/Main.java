import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Main {
    public static void main(String[] args) throws SQLException {
        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "STUDENT", "STUDENT");

        /* Incercam sa incalcam constraint-ul de nota unica */
        PreparedStatement statement = null;
        try {
            statement = connection.prepareStatement("INSERT INTO Note(id, id_student, id_curs, valoare) VALUES(10000, 23, 4, 6)");
            statement.execute();
            statement = connection.prepareStatement("INSERT INTO Note(id, id_student, id_curs, valoare) VALUES(10000, 23, 4, 9)");
            statement.execute();
        }
        catch (Exception exception) {
            System.out.println("Exceptie! Constraint nota unica!");
        }

        if (statement != null)
            statement.close();
        connection.close();
    }
}
