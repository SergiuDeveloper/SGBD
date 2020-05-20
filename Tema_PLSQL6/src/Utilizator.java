import java.sql.*;

public class Utilizator {
    public int ID;
    public String Pseudonim;
    public String HashParola;
    public String Nume;
    public String Prenume;

    public Utilizator() {
        this.ID = 0;
        this.Pseudonim = null;
        this.HashParola = null;
        this.Nume = null;
        this.Prenume = null;
    }

    public Utilizator(int id) throws SQLException {
        this.ID = id;
        this.Deserializare();
    }

    public void Serializare() throws SQLException {
        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "STUDENT", "STUDENT");

        PreparedStatement statement = connection.prepareStatement("SELECT Entitate FROM Utilizatori WHERE ID = ?");
        statement.setInt(1, this.ID);
        ResultSet resultSet = statement.executeQuery();

        if (resultSet.next()) {
            statement = connection.prepareStatement("UPDATE Utilizatori SET Entitate = Utilizator(?, ?, ?, ?) WHERE ID = ?");
            statement.setString(1, this.Pseudonim);
            statement.setString(2, this.HashParola);
            statement.setString(3, this.Nume);
            statement.setString(4, this.Prenume);
            statement.setInt(5, this.ID);
            statement.executeUpdate();
        }
        else {
            statement = connection.prepareStatement("INSERT INTO Utilizatori(Entitate) VALUES(Utilizator(?, ?, ?, ?))");
            statement.setString(1, this.Pseudonim);
            statement.setString(2, this.HashParola);
            statement.setString(3, this.Nume);
            statement.setString(4, this.Prenume);
            statement.executeUpdate();
        }

        resultSet.close();
        statement.close();
        connection.close();
    }

    public void Deserializare() throws SQLException {
        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "STUDENT", "STUDENT");

        PreparedStatement statement = connection.prepareStatement("SELECT Entitate FROM Utilizatori WHERE ID = ?");
        statement.setInt(1, this.ID);
        ResultSet resultSet = statement.executeQuery();

        if (resultSet.next()) {
            Object[] utilizatorReturnat = ((Struct)resultSet.getObject(1)).getAttributes();
            this.Pseudonim = (String)utilizatorReturnat[0];
            this.HashParola = (String)utilizatorReturnat[1];
            this.Nume = (String)utilizatorReturnat[2];
            this.Prenume = (String)utilizatorReturnat[3];
        }

        resultSet.close();
        statement.close();
        connection.close();
    }

    @Override
    public String toString() {
        return "Utilizator{" +
                "ID=" + ID +
                ", Pseudonim='" + Pseudonim + '\'' +
                ", HashParola='" + HashParola + '\'' +
                ", Nume='" + Nume + '\'' +
                ", Prenume='" + Prenume + '\'' +
                '}';
    }
}
