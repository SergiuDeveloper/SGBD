package com.friendSuggestions;

import java.sql.*;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

public class FriendSuggestion {
    public FriendSuggestion(int appearances, Student student) {
        this.appearances = appearances;
        this.student = student;
    }

    private int appearances;
    public int getAppearances() {
        return this.appearances;
    }
    private void setAppearances(int appearances) {
        this.appearances = appearances;
    }

    private Student student;
    public Student getStudent() {
        return this.student;
    }
    private void setStudent(Student student) {
        this.student = student;
    }

    public static List<FriendSuggestion> get(int studentID, int numberOfCommonFriendsRequired) throws SQLException {
        Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "STUDENT", "STUDENT");

        PreparedStatement statement = connection.prepareStatement("SELECT id_student2 FROM prieteni WHERE id_student1 = ?");
        statement.setInt(1, studentID);
        ResultSet resultSet = statement.executeQuery();

        List<Integer> friendsIDsList = new ArrayList<Integer>();
        while (resultSet.next())
            friendsIDsList.add(resultSet.getInt(1));

        String statement2String = "SELECT s.id, s.nume, s.prenume FROM studenti s JOIN prieteni p ON s.id = p.id_student2 WHERE p.id_student2 != ? AND p.id_student1 IN (";
        for (int friendIDIterator = 0; friendIDIterator < friendsIDsList.size(); ++friendIDIterator) {
            statement2String += "?";
            if (friendIDIterator < friendsIDsList.size() - 1)
                statement2String += ", ";
        }
        statement2String += ")";
        PreparedStatement statement2 = connection.prepareStatement(statement2String);
        statement2.setInt(1, studentID);
        int friendIDIterator = 2;
        for (var friendID : friendsIDsList) {
            statement2.setInt(friendIDIterator, friendID);
            ++friendIDIterator;
        }

        ResultSet resultSet2 = statement2.executeQuery();
        Map<Integer, Integer> friendsSuggestionsDictionary = new Hashtable<>();
        Map<Integer, Student> friendsSuggestionStudentsDictionary = new Hashtable<>();
        int friendSuggestionID;
        int friendSuggestionAppearances;
        while (resultSet2.next()) {
            friendSuggestionID = resultSet2.getInt(1);
            try {
                friendSuggestionAppearances = friendsSuggestionsDictionary.get(friendSuggestionID);
            }
            catch (Exception exception) {
                friendSuggestionAppearances = 0;
            }
            friendsSuggestionsDictionary.put(friendSuggestionID, friendSuggestionAppearances + 1);
            friendsSuggestionStudentsDictionary.put(friendSuggestionID, new Student(resultSet2.getInt(1), resultSet2.getString(2), resultSet2.getString(3)));
        }

        List<FriendSuggestion> friendSuggestions = new ArrayList<FriendSuggestion>();

        AtomicInteger currentNumberOfFriendSuggestions = new AtomicInteger(0);
        AtomicReference<Student> currentStudent = new AtomicReference<Student>();
        friendsSuggestionsDictionary.forEach((k, v) -> {
            if (v >= numberOfCommonFriendsRequired) {
                currentStudent.set(friendsSuggestionStudentsDictionary.get(k));
                friendSuggestions.add(new FriendSuggestion(v, currentStudent.get()));
            }
        });

        connection.close();

        return friendSuggestions;
    }

    @Override
    public String toString() {
        return "\t\t{\n" +
                "\t\t\t\"appearances\": " + appearances + ",\n" +
                "\t\t\t\"student\": " + student + "\n" +
                "\t\t}";
    }
}
