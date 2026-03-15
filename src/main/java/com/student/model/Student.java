package com.student.model;

public class Student {
    private int id;
    private int userId;
    private String fullName;
    private String email;
    private String phone;
    private String division;
    private String marks;
    private String profilePic; // new field

    public Student() {}

    public Student(int id, int userId, String fullName, String email, String phone, String division, String marks) {
        this.id = id;
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.division = division;
        this.marks = marks;
        this.profilePic = null;
    }

    public Student(int id, int userId, String fullName, String email, String phone, String division, String marks, String profilePic) {
        this.id = id;
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.division = division;
        this.marks = marks;
        this.profilePic = profilePic;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getDivision() { return division; }
    public void setDivision(String division) { this.division = division; }

    public String getMarks() { return marks; }
    public void setMarks(String marks) { this.marks = marks; }

    public String getProfilePic() { return profilePic; }
    public void setProfilePic(String profilePic) { this.profilePic = profilePic; }
}
