package com.student.model;

import java.time.LocalDateTime;

public class Announcement {
    private int id;
    private String title;
    private String content;
    private LocalDateTime datePosted;

    public Announcement() {}

    public Announcement(int id, String title, String content, LocalDateTime datePosted) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.datePosted = datePosted;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public LocalDateTime getDatePosted() { return datePosted; }
    public void setDatePosted(LocalDateTime datePosted) { this.datePosted = datePosted; }
}
