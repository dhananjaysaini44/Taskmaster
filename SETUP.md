# Life Manager Setup Guide

"Let us manage your Life"

Follow these steps to synchronize this project with your Firebase account.

## Firebase Console Steps

1.  **Authentication**:
    *   Navigate to **Build > Authentication > Sign-in method**.
    *   Enable **Email/Password**.
    *   Enable **Google** (configure the support email).

2.  **Cloud Firestore**:
    *   Navigate to **Build > Firestore Database**.
    *   Create a new database.
    *   Start in **Test Mode** (or Production, then update rules immediately).

3.  **Firestore Security Rules**:
    *   Go to the **Rules** tab in Firestore.
    *   Paste the following scoped rules:
    ```javascript
    rules_version = '2';
    service cloud.firestore {
      match /databases/{database}/documents {
        match /users/{userId}/tasks/{taskId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      }
    }
    ```

4.  **Android Configuration**:
    *   Go to **Project Settings > General**.
    *   Under **Your apps**, select the Android app.
    *   Add your **SHA-1 fingerprint**.
    *   *To get fingerprint, run:* `keytool -list -v -keystore ~/.android/debug.keystore`
    *   Download `google-services.json` and replace the one in `android/app/`.

5.  **iOS Configuration**:
    *   Download `GoogleService-Info.plist`.
    *   Open `ios/Runner.xcworkspace` in Xcode.
    *   Right-click `Runner` folder and select **Add files to "Runner"...**.
    *   Select the downloaded `GoogleService-Info.plist` and ensure "Copy items if needed" is checked.

## Development Setup

After configuring the console, run the following command in your terminal:

```bash
flutterfire configure
```

This will regenerate `lib/firebase_options.dart` with your specific project settings.

## Project Analysis

To ensure everything is correct, run:

```bash
dart analyze .
```
