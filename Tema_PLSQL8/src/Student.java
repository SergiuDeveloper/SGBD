import java.util.Date;
import java.util.Objects;

public class Student {
    public int ID;
    public String Numar_Matricol;
    public String Nume;
    public String Prenume;
    public int An;
    public String Grupa;
    public int Bursa;
    public Date Data_Nastere;
    public String Email;
    public Date Created_At;
    public Date Updated_At;

    @Override
    public String toString() {
        return "Student{" +
                "ID=" + ID +
                ", Numar_Matricol='" + Numar_Matricol + '\'' +
                ", Nume='" + Nume + '\'' +
                ", Prenume='" + Prenume + '\'' +
                ", An=" + An +
                ", Grupa='" + Grupa + '\'' +
                ", Bursa=" + Bursa +
                ", Data_Nastere=" + Data_Nastere +
                ", Email='" + Email + '\'' +
                ", Created_At=" + Created_At +
                ", Updated_At=" + Updated_At +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Student)) return false;
        Student student = (Student) o;
        return ID == student.ID &&
                An == student.An &&
                Bursa == student.Bursa &&
                Objects.equals(Numar_Matricol, student.Numar_Matricol) &&
                Objects.equals(Nume, student.Nume) &&
                Objects.equals(Prenume, student.Prenume) &&
                Objects.equals(Grupa, student.Grupa) &&
                Objects.equals(Data_Nastere, student.Data_Nastere) &&
                Objects.equals(Email, student.Email) &&
                Objects.equals(Created_At, student.Created_At) &&
                Objects.equals(Updated_At, student.Updated_At);
    }

    @Override
    public int hashCode() {
        return Objects.hash(ID, Numar_Matricol, Nume, Prenume, An, Grupa, Bursa, Data_Nastere, Email, Created_At, Updated_At);
    }
}
