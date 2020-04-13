import java.util.Date;
import java.util.Objects;

public class Curs {
    public Integer ID;
    public Integer An;
    public Integer Semestru;
    public Integer Credite;
    public Date Created_At;
    public Date Updated_At;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Curs)) return false;
        Curs curs = (Curs) o;
        return ID.equals(curs.ID) &&
                An.equals(curs.An) &&
                Semestru.equals(curs.Semestru) &&
                Credite.equals(curs.Credite) &&
                Objects.equals(Created_At, curs.Created_At) &&
                Objects.equals(Updated_At, curs.Updated_At);
    }

    @Override
    public String toString() {
        return "Curs{" +
                "ID=" + ID +
                ", An=" + An +
                ", Semestru=" + Semestru +
                ", Credite=" + Credite +
                ", Created_At=" + Created_At +
                ", Updated_At=" + Updated_At +
                '}';
    }

    @Override
    public int hashCode() {
        return Objects.hash(ID, An, Semestru, Credite, Created_At, Updated_At);
    }
}
