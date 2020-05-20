import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Main {
    public static void main(String[] args) throws SQLException {
        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "STUDENT", "STUDENT");

        PreparedStatement statement = null;
        try {
            statement = connection.prepareStatement("INSERT INTO Cursuri VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL)");
            statement.execute();
            System.out.println("Curs adaugat!");
        }
        catch (Exception exception) {
            System.out.println(exception.getMessage());
        }

        if (statement != null)
            statement.close();
        connection.close();
    }
}