package com.friendSuggestions;

public class Student {
    public Student(int id, String firstName, String lastName) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
    }

    private int id;
    public int getID() {
        return this.id;
    }
    private void setID(int id) {
        this.id = id;
    }
    private String firstName;
    public String getFirstName() {
        return this.firstName;
    }
    private void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    private String lastName;
    public String getLastName() {
        return this.lastName;
    }
    private void setLastName(String lastName) {
        this.lastName = lastName;
    }

    @Override
    public String toString() {
        return "Student{" +
                "id=" + id +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                '}';
    }
}
