import java.sql.*;

public class UserAuthentication {
    static boolean validateCredentials(String username, String password) throws SQLException {
        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "STUDENT", "STUDENT");

        Statement getUserPasswordStatement = connection.createStatement();
        ResultSet userRows = getUserPasswordStatement.executeQuery("SELECT * FROM Users WHERE Username = '" + username + "' AND Password = '" + password + "'");

        boolean success = (userRows.next());

        userRows.close();
        getUserPasswordStatement.close();
        connection.close();

        return success;
    }
}
