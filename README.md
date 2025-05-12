# 📱 Q\&A Hub

[⬇️ Download APK](https://github.com/Vanshpanchal/Flutter/blob/f7c41ee14122eb20d1cbd8628713e5bb1b6e11a5/Q-A%20Hub.apk)

**Q\&A Hub** is a community-driven mobile application built with **Flutter** and powered by **Firebase**, designed to help users prepare for interviews by posting, exploring, and sharing interview questions. The app also features moderation tools, user profiles, and a robust backend for real-time data handling.

---
## 🖼️ Application Previews


![1](https://github.com/Vanshpanchal/Flutter/blob/a78c9ff9bba8678c95176be13de267e1b6c962bc/previews/Q-A%20Hub-1.png)
![2](https://github.com/Vanshpanchal/Flutter/blob/a78c9ff9bba8678c95176be13de267e1b6c962bc/previews/Q-A%20Hub-2.png)

---

## 🚀 Key Features

### 🔐 User Authentication

* Secure login and sign-up via **Firebase Authentication** (Email & Password).
* Password reset and session management support.

### 📖 Explore Questions

* Browse a wide range of categorized and tagged interview questions.
* View posts in real-time with automatic updates via Firestore.

### ✍️ Post Your Questions

* Contribute questions with formatted text and optional image uploads.
* Media files are stored securely in **Firebase Storage**.

### 💾 Save & 🔗 Share

* Save favorite questions for easy access later.
* Share questions as plain text via messaging apps and email.

### 🚩 Report Inappropriate Content

* Users can report questions that are irrelevant or poorly framed.
* Admins receive and manage flagged content via a dedicated review panel.

### 👤 User Profile

* Users can view and edit their profile information including name, contact info, and profile picture.
* Personalized content and question history available.

### 🛠️ Admin Panel

* Admins can moderate reported posts, approve or reject questions, and assign categories.
* Helps maintain a high-quality content standard across the platform.

### 🔍 Search & Filter

* Perform keyword-based searches across all questions.
* Filter questions by difficulty, topic, or programming language.

---

## 🔧 Technologies Used

| Technology                          | Purpose                                           |
| ----------------------------------- | ------------------------------------------------- |
| **Flutter**                         | Cross-platform mobile development                 |
| **Firebase Authentication**         | User login, registration, and session management  |
| **Cloud Firestore**                 | Real-time NoSQL database for storing all app data |
| **Firebase Storage**                | Upload and serve images/files                     |
| **Firebase Functions** *(optional)* | Handle server-side logic for automation           |

---

## 📦 Setup Instructions

### ✅ Prerequisites

Ensure the following are installed:

* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* [Firebase CLI](https://firebase.google.com/docs/cli)
* A configured Firebase project in the [Firebase Console](https://console.firebase.google.com)

---

### 📁 Clone the Repository

```bash
git clone https://github.com/yourusername/qa-hub.git
cd qa-hub
```

---

### 📦 Install Dependencies

```bash
flutter pub get
```

---

### 🔗 Connect Firebase

#### Android Setup

1. Open the [Firebase Console](https://console.firebase.google.com).
2. Add an Android app to your project.
3. Download `google-services.json` and place it in `android/app/`.

#### iOS Setup

1. Add an iOS app in the Firebase Console.
2. Download `GoogleService-Info.plist` and place it in `ios/Runner/`.

#### Firebase Authentication

* Enable **Email/Password** under Authentication → Sign-in methods.

#### Firestore

* Set up a Firestore database and start in **test mode** or define custom security rules.

#### Firebase Storage

* Configure rules for file uploads (e.g., allow authenticated users to upload media).

---

### ▶️ Run the App

Make sure your device or emulator is running, then execute:

```bash
flutter run
```

---

## 🤝 Contribution Guidelines

We welcome contributions to improve the platform! You can help by:

* 🐛 Reporting bugs
* 💡 Suggesting new features
* 🔧 Submitting pull requests

### To contribute:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m 'Add feature'`)
4. Push to your branch (`git push origin feature/my-feature`)
5. Open a Pull Request

