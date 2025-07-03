# 📅 Event Planner App

A sleek, full-featured event planner mobile app built using **Flutter** and **Firebase**.  
This app allows users to create, manage, and attend social events — with RSVP tracking, real-time comments, and a clean personalized UI.

---

## 🚀 **Features**

- 🔐 Email/password authentication with email verification  
- 🗓️ Create and manage events (title, description, date, location)  
- 👥 RSVP tracking – users can mark themselves as attending  
- 💬 Comment section for each event  
- 📋 View past and upcoming events  
- 🖼️ Full-screen UI with background image  
- 🔄 Edit and delete events  
- 🔔 Personalized welcome and motivational quote on home screen  

---

## 🧑‍💻 **Technologies Used**

| Tech                         | Purpose                                |
|------------------------------|----------------------------------------|
| **Flutter**                  | Frontend UI framework                   |
| **Firebase Auth**            | User authentication                    |
| **Cloud Firestore**          | Realtime database (events, comments)   |
| **Dart**                     | Programming language                   |
| **Google Fonts**, **Provider** | UI & state management               |

---

## 📸 **Screenshots**

<p><strong> Login Screen</strong><br/>
<img src="screenshots/Screenshot_2025-07-02-12-15-21-227_com.example.event_planner_app - Copy - Copy.jpg" width="400"/>
</p>


<p><strong> Home Screen</strong><br/>
<img src="screenshots/Screenshot_2025-07-02-12-15-39-294_com.example.event_planner_app.jpg" width="400"/>
</p>

<p><strong> Create Event Screen</strong><br/>
<img src="screenshots/Screenshot_2025-07-02-12-18-18-374_com.example.event_planner_app.jpg" width="400"/>
</p>

<p><strong> Event Info screen </strong><br/>
<img src="screenshots/Screenshot_2025-07-02-12-20-04-137_com.example.event_planner_app - Copy.jpg" width="400"/>
</p>

<p><strong> All Event</strong><br/>
<img src="screenshots/Screenshot_2025-07-02-12-51-10-365_com.example.event_planner_app.jpg" width="400"/>
</p>

---

## 📂 **Project Structure**

```plaintext
lib/
├── main.dart
├── login_screen.dart
├── signup_screen.dart
├── home_screen.dart
├── create_event_screen.dart
├── event_list_screen.dart
├── event_details_screen.dart
└── styles.dart
