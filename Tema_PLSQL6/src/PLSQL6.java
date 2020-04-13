import java.sql.SQLException;

public class PLSQL6 {
    public static void main(String[] args) throws SQLException {
        Utilizator utilizator = new Utilizator(1);
        System.out.println(utilizator);

        utilizator.Nume = "Nistor";
        utilizator.Prenume = "Sergiu";
        utilizator.Serializare();
        utilizator.Deserializare();
        System.out.println(utilizator);
    }
}