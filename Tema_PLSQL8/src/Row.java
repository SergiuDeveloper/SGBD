import java.util.Objects;

public class Row {
    public Row(Curs curs, Student student, Nota nota) {
        this.curs = curs;
        this.student = student;
        this.nota = nota;
    }

    public Curs curs;
    public Student student;
    public Nota nota;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Row)) return false;
        Row row = (Row) o;
        return Objects.equals(curs, row.curs) &&
                Objects.equals(student, row.student) &&
                Objects.equals(nota, row.nota);
    }

    @Override
    public String toString() {
        return "Row{" +
                "curs=" + curs +
                ", student=" + student +
                ", nota=" + nota +
                '}';
    }

    @Override
    public int hashCode() {
        return Objects.hash(curs, student, nota);
    }
}
