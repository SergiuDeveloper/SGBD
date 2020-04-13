import java.sql.*;

public class Main {
    public static void main(String[] args) throws SQLException {
        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl","STUDENT","STUDENT");

        Statement statement = connection.createStatement();

        System.out.println("Nr_Matricol    Nume    Prenume");
        System.out.println("______________________________");
        ResultSet resultSet = statement.executeQuery("SELECT NR_MATRICOL, NUME, PRENUME FROM studenti");
        while(resultSet.next())
            System.out.println(resultSet.getString(1) + "  " + resultSet.getString(2) + "  " + resultSet.getString(3));

        connection.close();
    }
}
