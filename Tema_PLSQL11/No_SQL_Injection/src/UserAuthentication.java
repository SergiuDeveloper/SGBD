import java.sql.*;

public class UserAuthentication {
    static boolean validateCredentials(String username, String password) throws SQLException {
        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "STUDENT", "STUDENT");

        PreparedStatement getUserPasswordStatement = connection.prepareStatement("SELECT * FROM Users WHERE Username = ? AND Password = ?");
        getUserPasswordStatement.setString(1, username);
        getUserPasswordStatement.setString(2, password);
        ResultSet userRows = getUserPasswordStatement.executeQuery();

        boolean success = (userRows.next());

        userRows.close();
        getUserPasswordStatement.close();
        connection.close();

        return success;
    }
}
