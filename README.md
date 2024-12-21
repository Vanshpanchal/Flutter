# Q&A Hub - Flutter & Firebase
[Download APK](Q&Ahub.apk)

**Q&A Hub** is a community-driven app where users can post interview questions, explore existing questions, save their favorites, report irrelevant or poorly constructed questions, and share questions as text. The app is built using **Flutter** for cross-platform mobile development and integrates with **Firebase** for backend services such as Authentication, Firestore (NoSQL database), and Firebase Storage.

This app allows users to interact with the content, while also providing an admin panel to manage reported questions and ensure quality content. Users can filter and search questions by topics, and admins can approve/reject posts based on relevance.

## Features

### **User Authentication (Firebase Authentication)**
- Users can securely log in and sign up using their email and password (Firebase Authentication).
- Secure user management, including the ability to reset passwords and manage sessions.

### **Explore Page**
- Users can explore a variety of posted interview questions.
- Questions are categorized and tagged for easy navigation and discovery.

### **Post Questions**
- Users can contribute by posting their own interview questions, making the app an active Q&A hub for interview preparation.
- Questions can include text content, and images or files can be uploaded to Firebase Storage.

### **Save & Share**
- Users can save questions to their favorite list for later reference.
- Questions can be shared via text to others, fostering collaboration and knowledge-sharing.

### **Report Functionality**
- If a user encounters a poorly constructed or irrelevant question, they can report it.
- Reported questions are flagged and sent to the admin for review.

### **User Profile**
- Users can manage their profile information, including updating their name, profile picture, and contact details.
- The app offers personalized functionality based on the logged-in user’s profile.

### **Admin Panel**
- Admins have special access to manage the platform.
- They can approve or reject reported questions, ensuring the quality and relevance of the content.
- Admins can categorize posts, ensuring that they are sorted by topics for better organization.

### **Search & Filter**
- A robust search functionality allows users to search for questions by keywords, topics, or tags.
- Filter options help users narrow down the questions they are interested in, such as filtering by difficulty, topic, or language.

### **Firebase Firestore**
- **Firestore** is used to store user data (like profiles), questions, favorites, and reports.
- The Firestore database supports real-time synchronization, ensuring users can view new posts and updates instantly.

### **Firebase Storage**
- **Firebase Storage** handles the upload of media, such as images or files associated with questions.
- Users can attach images (e.g., screenshots) to their posted questions, stored securely in Firebase Storage.

---

## Technologies Used

- **Flutter:** 
  - Cross-platform mobile framework used to build both Android and iOS applications from a single codebase.
  
- **Firebase Authentication:** 
  - Provides an easy-to-implement authentication system for user login, sign-up, and session management.

- **Firebase Firestore:** 
  - Real-time NoSQL database for storing questions, user data, reports, and other app-related data.
  
- **Firebase Storage:** 
  - Cloud storage service for uploading and serving media (images, documents) related to questions.
  
- **Firebase Functions (Optional):** 
  - Serverless backend for handling administrative tasks like notifying users or processing reported questions.

---

## Setup Instructions

### **Prerequisites**

Before you begin, make sure you have the following installed on your machine:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- A Firebase project set up in the [Firebase Console](https://console.firebase.google.com/).

### **Clone the Repository**

```bash
git clone https://github.com/yourusername/qa-hub.git
cd qa-hub
```

### **Install Dependencies**

After cloning the repository, navigate to the project folder and install the required dependencies:

```bash
flutter pub get
```

### **Configure Firebase**

Follow the setup instructions for both **Android** and **iOS**:

1. **Add Firebase to your Android Project:**
   - Go to the [Firebase Console](https://console.firebase.google.com/).
   - Add a new project (if you haven't already) and configure Firebase for Android by following the [Android setup guide](https://firebase.google.com/docs/android/setup).
   - Download the `google-services.json` file and add it to the `android/app` directory in your project.

2. **Add Firebase to your iOS Project:**
   - Follow the [iOS setup guide](https://firebase.google.com/docs/ios/setup).
   - Download the `GoogleService-Info.plist` file and add it to the `ios/Runner` directory in your project.

3. **Configure Firebase Authentication:**
   - In the Firebase Console, go to the Authentication section and enable Email/Password authentication or other methods as required.

4. **Configure Firestore:**
   - Set up a Firestore database in the Firebase Console.
   - Define security rules for Firestore. You may start with rules that only allow authenticated users to read/write their own data.

5. **Configure Firebase Storage:**
   - Go to Firebase Storage in the Firebase Console and set up storage rules.
   - You can define rules to restrict access to certain files or users if needed.

### **Run the App**

To run the app on an emulator or a physical device, execute the following command:

```bash
flutter run
```

Make sure your Android or iOS device/emulator is running.

---

## Contribution

Feel free to fork this repository and contribute by submitting issues or pull requests. We encourage contributions to improve the app, fix bugs, or add new features. You can contribute by:

- Reporting bugs
- Suggesting new features
- Fixing issues and submitting pull requests

All contributions are welcome!
