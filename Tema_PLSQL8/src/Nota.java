import java.util.Date;
import java.util.Objects;

public class Nota {
    public int ID;
    public float Valoare;
    public Date Data_Notare;
    public Date Created_At;
    public Date Updated_At;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Nota)) return false;
        Nota nota = (Nota) o;
        return ID == nota.ID &&
                Float.compare(nota.Valoare, Valoare) == 0 &&
                Objects.equals(Data_Notare, nota.Data_Notare) &&
                Objects.equals(Created_At, nota.Created_At) &&
                Objects.equals(Updated_At, nota.Updated_At);
    }

    @Override
    public String toString() {
        return "Nota{" +
                "ID=" + ID +
                ", Valoare=" + Valoare +
                ", Data_Notare=" + Data_Notare +
                ", Created_At=" + Created_At +
                ", Updated_At=" + Updated_At +
                '}';
    }

    @Override
    public int hashCode() {
        return Objects.hash(ID, Valoare, Data_Notare, Created_At, Updated_At);
    }
}
