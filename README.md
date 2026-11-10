# Flutter + Firebase Integration Guide (FlutterFire CLI)

A beginner-friendly, A--Z practical guide to connecting a Flutter
Android application to Firebase using **Firebase CLI** and **FlutterFire
CLI**, with **Android Studio** as the development environment.

This tutorial builds a Student Registration and Login application using:

-   Flutter and Dart
-   Firebase Core
-   Firebase Authentication (Email/Password)
-   Firebase Realtime Database
-   Android Studio and an Android emulator/device

> **Important:** This project uses Firebase client SDKs directly. You do
> not need to build a separate REST API server for this basic
> registration and login workflow.

------------------------------------------------------------------------

## Table of Contents

1.  [What We Will Build](#1-what-we-will-build)
2.  [Prerequisites](#2-prerequisites)
3.  [Check Flutter and Android
    Studio](#3-check-flutter-and-android-studio)
4.  [Create the Flutter Project](#4-create-the-flutter-project)
5.  [Create a Firebase Project](#5-create-a-firebase-project)
6.  [Install Node.js and Firebase
    CLI](#6-install-nodejs-and-firebase-cli)
7.  [Install FlutterFire CLI](#7-install-flutterfire-cli)
8.  [Connect Flutter to Firebase](#8-connect-flutter-to-firebase)
9.  [Initialize Firebase in Flutter](#9-initialize-firebase-in-flutter)
10. [Enable Firebase Authentication](#10-enable-firebase-authentication)
11. [Create Firebase Realtime
    Database](#11-create-firebase-realtime-database)
12. [Configure Database Security
    Rules](#12-configure-database-security-rules)
13. [Understand the Database
    Structure](#13-understand-the-database-structure)
14. [Build the Flutter Application](#14-build-the-flutter-application)
15. [Run and Test the Application](#15-run-and-test-the-application)
16. [Understand the Application
    Architecture](#16-understand-the-application-architecture)
17. [Firebase SDK vs. Custom REST
    API](#17-firebase-sdk-vs-custom-rest-api)
18. [Common Errors and Solutions](#18-common-errors-and-solutions)
19. [Final Checklist](#19-final-checklist)
20. [Official Documentation](#20-official-documentation)

------------------------------------------------------------------------

## 1. What We Will Build

We will create a Student Registration and Login application with these
features:

1.  Student registration.
2.  Student login.
3.  Firebase Email/Password Authentication.
4.  Save student details in Firebase Realtime Database.
5.  Retrieve the logged-in student's details.
6.  Display a student dashboard.
7.  Logout functionality.
8.  Authentication state management.

### Application workflow

``` text
Flutter Application
       |
       v
Firebase Initialization
       |
       v
Firebase Services
   /          \
  v            v
Authentication  Realtime Database
  |                 |
Register/Login   Save/Retrieve Profile
  |                 |
  +--------+--------+
           |
           v
    Student Dashboard
```

------------------------------------------------------------------------

## 2. Prerequisites

Install the following software before starting:

  Software          Purpose
  ----------------- ----------------------------------------------
  Android Studio    Flutter development IDE
  Flutter SDK       Flutter framework
  Dart SDK          Programming language (included with Flutter)
  Node.js and npm   Required to install Firebase CLI
  Firebase CLI      Firebase project management
  FlutterFire CLI   Configures Firebase for Flutter
  Google account    Access to Firebase Console

Useful links:

-   [Android Studio](https://developer.android.com/studio)
-   [Flutter installation](https://docs.flutter.dev/get-started/install)
-   [Node.js](https://nodejs.org/)
-   [Firebase Console](https://console.firebase.google.com/)

------------------------------------------------------------------------

## 3. Check Flutter and Android Studio

1.  Open Android Studio.
2.  Open the Flutter project or prepare to create one.
3.  Open the **Terminal** tab at the bottom.
4.  Run:

``` bash
flutter doctor
```

This checks Flutter, Dart, Android SDK and Android Studio configuration.

Check the versions:

``` bash
flutter --version
dart --version
```

Resolve any Flutter or Android toolchain errors reported by
`flutter doctor` before continuing.

------------------------------------------------------------------------

## 4. Create the Flutter Project

### Option A: Create through Android Studio

1.  Open Android Studio.
2.  Select **New Flutter Project**.
3.  Select Flutter.
4.  Set the Flutter SDK path.
5.  Enter the project name:

``` text
student_firebase_app
```

6.  Select the project location.
7.  Select Android as a target platform.
8.  Click **Create**.

### Option B: Create through Terminal

``` bash
flutter create student_firebase_app
cd student_firebase_app
```

The initial project structure will look similar to:

``` text
student_firebase_app/
├── android/
├── ios/
├── lib/
│   └── main.dart
├── test/
├── web/
├── pubspec.yaml
└── README.md
```

For this practical, Android is the target platform.

------------------------------------------------------------------------

## 5. Create a Firebase Project

1.  Open [Firebase Console](https://console.firebase.google.com/).
2.  Sign in with your Google account.
3.  Click **Create a project** or **Add project**.
4.  Enter a project name, for example:

``` text
StudentFirebaseApp
```

5.  Continue through the setup.
6.  Google Analytics is optional for this practical.
7.  Click **Create project** and wait for completion.

The Firebase project will provide the backend services used by the
Flutter application.

------------------------------------------------------------------------

## 6. Install Node.js and Firebase CLI

Firebase CLI is installed using npm, which is included with Node.js.

### Step 6.1: Install Node.js

Download and install the LTS version from
[nodejs.org](https://nodejs.org/).

Open a new Android Studio Terminal or Windows Command Prompt and check:

``` bash
node --version
npm --version
```

Both commands should display version numbers.

### Step 6.2: Install Firebase CLI

``` bash
npm install -g firebase-tools
```

Verify the installation:

``` bash
firebase --version
```

### Step 6.3: Login to Firebase

``` bash
firebase login
```

A browser window will open. Sign in using the Google account that owns
or has access to the Firebase project, and grant the requested
permissions.

List accessible Firebase projects:

``` bash
firebase projects:list
```

You should see the Firebase projects associated with your account.

Documentation: [Firebase CLI
Reference](https://firebase.google.com/docs/cli)

------------------------------------------------------------------------

## 7. Install FlutterFire CLI

FlutterFire CLI configures Firebase for Flutter applications.

Run:

``` bash
dart pub global activate flutterfire_cli
```

Verify:

``` bash
flutterfire --version
```

### Windows PATH troubleshooting

If Windows reports:

``` text
'flutterfire' is not recognized as an internal or external command
```

Add the Dart Pub Cache `bin` folder to your Windows user PATH. A common
location is:

``` text
%LOCALAPPDATA%\Pub\Cache\bin
```

Steps:

1.  Search Windows for **Environment Variables**.
2.  Open **Edit the system environment variables**.
3.  Click **Environment Variables**.
4.  Under User variables, select **Path**.
5.  Click **Edit**, then **New**.
6.  Add the path shown above.
7.  Save the changes.
8.  Restart Android Studio or open a new terminal.
9.  Run `flutterfire --version` again.

Documentation: [FlutterFire
setup](https://firebase.google.com/docs/flutter/setup)

------------------------------------------------------------------------

## 8. Connect Flutter to Firebase

Make sure the terminal is inside the Flutter project directory.

For example:

``` text
C:\Users\YourName\AndroidStudioProjects\student_firebase_app
```

### Step 8.1: Add Firebase Core

``` bash
flutter pub add firebase_core
```

`firebase_core` is the core Flutter plugin required to initialize
Firebase.

### Step 8.2: Check the Android application ID

Open the Android Gradle configuration. Depending on the project
template, it is commonly:

``` text
android/app/build.gradle.kts
```

Find the application ID:

``` kotlin
applicationId = "com.example.student_firebase_app"
```

Your actual application ID may be different. Use the real value from
your project when configuring Firebase.

### Step 8.3: Run FlutterFire configuration

``` bash
flutterfire configure
```

Follow the interactive prompts:

1.  Select the Firebase project you created, such as
    `StudentFirebaseApp`.
2.  Select the Android platform.
3.  Select or confirm the Android application.
4.  Confirm the application ID.
5.  Allow the CLI to complete configuration.

The CLI generates:

``` text
lib/firebase_options.dart
```

This file contains generated Firebase configuration for the selected
platforms. Do not create it manually or edit it unnecessarily.

After configuration, the project will contain:

``` text
lib/
├── main.dart
└── firebase_options.dart
```

> **Important:** Keep `firebase_options.dart` in your project. Do not
> publish private service-account credentials or Admin SDK keys in a
> Flutter application. The generated client configuration is not a
> replacement for Firebase security rules.

------------------------------------------------------------------------

## 9. Initialize Firebase in Flutter

Open:

``` text
lib/main.dart
```

Use this temporary connection test before implementing the full
application:

``` dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Firebase App',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Firebase Connected Successfully!',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
```

### Understand the important code

  ---------------------------------------------------------------------------------
  Code                                          Explanation
  --------------------------------------------- -----------------------------------
  `WidgetsFlutterBinding.ensureInitialized()`   Initializes Flutter bindings before
                                                asynchronous setup

  `Firebase.initializeApp()`                    Initializes Firebase

  `firebase_options.dart`                       Contains generated Firebase
                                                configuration

  `currentPlatform`                             Selects configuration for the
                                                running platform

  `runApp()`                                    Starts the Flutter application
  ---------------------------------------------------------------------------------

Run:

``` bash
flutter run
```

If the application opens and displays **Firebase Connected
Successfully!**, Firebase initialization has completed.

------------------------------------------------------------------------

## 10. Enable Firebase Authentication

### Step 10.1: Enable Email/Password

1.  Open Firebase Console.
2.  Select your Firebase project.
3.  Open **Authentication** under Build.
4.  Click **Get started** if prompted.
5.  Open the **Sign-in method** or **Sign-in providers** section.
6.  Select **Email/Password**.
7.  Enable Email/Password.
8.  Save the changes.

### Step 10.2: Install Firebase Authentication

In Android Studio Terminal:

``` bash
flutter pub add firebase_auth
```

Important methods:

  Method                               Purpose
  ------------------------------------ --------------------------------------
  `createUserWithEmailAndPassword()`   Register a user
  `signInWithEmailAndPassword()`       Login
  `signOut()`                          Logout
  `currentUser`                        Get the currently authenticated user
  `authStateChanges()`                 Listen for authentication changes

Documentation:

-   [Firebase Authentication for
    Flutter](https://firebase.google.com/docs/auth/flutter/start)
-   [Email and Password
    Authentication](https://firebase.google.com/docs/auth/flutter/password-auth)

------------------------------------------------------------------------

## 11. Create Firebase Realtime Database

### Step 11.1: Create the database

1.  Open Firebase Console.
2.  Select your project.
3.  Open **Realtime Database** under Build.
4.  Click **Create Database**.
5.  Select an appropriate database location.
6.  Select the starting security configuration.
7.  Click **Enable**.

Use authenticated-user security rules as described in Section 12. Do not
leave a production database publicly readable or writable.

### Step 11.2: Understand the database URL

Firebase displays a database URL after the database is created. It may
look similar to:

``` text
https://your-project-default-rtdb.firebaseio.com/
```

Depending on the database region, it may instead look like:

``` text
https://your-project-default-rtdb.asia-southeast1.firebasedatabase.app/
```

When using the default database associated with the configured Firebase
project, the FlutterFire setup normally configures the connection. If
you use a different or additional database instance, configure its URL
explicitly in your application.

### Step 11.3: Install Realtime Database package

``` bash
flutter pub add firebase_database
```

The application now uses these Firebase packages:

``` text
firebase_core
firebase_auth
firebase_database
```

### Step 11.4: Run FlutterFire configuration again

After adding the Firebase products and packages, run:

``` bash
flutterfire configure
```

Select the same Firebase project and Android platform. Then run:

``` bash
flutter pub get
```

Documentation:

-   [Realtime Database for
    Flutter](https://firebase.google.com/docs/database/flutter/start)
-   [Read and Write
    Data](https://firebase.google.com/docs/database/flutter/read-and-write)

------------------------------------------------------------------------

## 12. Configure Database Security Rules

Open:

**Firebase Console → Realtime Database → Rules**

Use the following rules for this example:

``` json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "auth != null && auth.uid == $uid",
        ".write": "auth != null && auth.uid == $uid"
      }
    }
  }
}
```

Click **Publish**.

### Explanation

-   `auth != null` means the user must be authenticated.
-   `auth.uid == $uid` means the authenticated user's UID must match the
    database path.
-   A user can read and write their own profile.
-   A user cannot read or write another user's profile through these
    rules.

These rules protect the example `users` node. If the application later
adds other database nodes, define appropriate rules for each one.

------------------------------------------------------------------------

## 13. Understand the Database Structure

Each Firebase Authentication user receives a unique UID.

Example database structure:

``` json
{
  "users": {
    "FIREBASE_USER_UID_001": {
      "fullName": "John Silva",
      "studentId": "ICBT001",
      "email": "john@gmail.com",
      "createdAt": "2026-11-10T09:00:00.000"
    },
    "FIREBASE_USER_UID_002": {
      "fullName": "Kamal Perera",
      "studentId": "ICBT002",
      "email": "kamal@gmail.com",
      "createdAt": "2026-11-10T09:05:00.000"
    }
  }
}
```

The structure is:

``` text
users/
   └── USER_UID/
         ├── fullName
         ├── studentId
         ├── email
         └── createdAt
```

Get the currently logged-in user's UID:

``` dart
final user = FirebaseAuth.instance.currentUser;

print(user?.uid);
```

Use this UID as the database key. This lets the application retrieve the
correct student's profile.

------------------------------------------------------------------------

## 14. Build the Flutter Application

### Step 14.1: Create folders

Inside `lib`, create the following structure:

``` text
lib/
├── main.dart
├── firebase_options.dart
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   └── dashboard_screen.dart
└── services/
    ├── auth_service.dart
    └── database_service.dart
```

The `screens` folder contains the user interface. The `services` folder
contains Firebase operations.

### Step 14.2: Authentication service

Create:

``` text
lib/services/auth_service.dart
```

Code:

``` dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register user
  Future<UserCredential> registerUser({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Login user
  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Logout user
  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Listen to authentication changes
  Stream<User?> get authStateChanges =>
      _auth.authStateChanges();
}
```

**Explanation:**

-   `FirebaseAuth.instance` accesses Firebase Authentication.
-   `registerUser()` creates an account.
-   `loginUser()` authenticates an existing account.
-   `logoutUser()` signs out.
-   `currentUser` returns the authenticated user.
-   `authStateChanges` provides a stream of authentication changes.

### Step 14.3: Database service

Create:

``` text
lib/services/database_service.dart
```

Code:

``` dart
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseDatabase _database =
      FirebaseDatabase.instance;

  // Save student details
  Future<void> saveStudentDetails({
    required String uid,
    required String fullName,
    required String studentId,
    required String email,
  }) async {
    await _database.ref('users/$uid').set({
      'fullName': fullName,
      'studentId': studentId,
      'email': email,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  // Retrieve student details
  Future<Map<String, dynamic>?> getStudentDetails(
      String uid) async {
    final snapshot =
        await _database.ref('users/$uid').get();

    if (snapshot.exists && snapshot.value != null) {
      return Map<String, dynamic>.from(
        snapshot.value as Map,
      );
    }

    return null;
  }
}
```

**Explanation:**

The `DatabaseService` manages database operations.

The following code saves the profile:

``` dart
await _database.ref('users/$uid').set({
  'fullName': fullName,
  'studentId': studentId,
  'email': email,
});
```

The `getStudentDetails()` method retrieves the saved profile using the
UID.

### Step 14.4: Registration screen

Create:

``` text
lib/screens/register_screen.dart
```

Code:

``` dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final studentIdController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = AuthService();
  final DatabaseService databaseService = DatabaseService();

  bool isLoading = false;

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // 1. Create Firebase Authentication account
      final credential = await authService.registerUser(
        email: emailController.text,
        password: passwordController.text,
      );

      final uid = credential.user!.uid;

      // 2. Save student details in Realtime Database
      await databaseService.saveStudentDetails(
        uid: uid,
        fullName: nameController.text.trim(),
        studentId: studentIdController.text.trim(),
        email: emailController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
        ),
      );

      // AuthWrapper listens for authentication changes
      // and displays the dashboard.
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    studentIdController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter your name'
                        : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: studentIdController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter your student ID'
                        : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null ||
                    !RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                        .hasMatch(value.trim())
                        ? 'Enter a valid email'
                        : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.length < 6
                        ? 'Password must have at least 6 characters'
                        : null,
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : register,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Register'),
                ),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Already have an account? Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Registration workflow:**

1.  Validate the form.
2.  Create the Firebase Authentication account.
3.  Get the new user's UID.
4.  Save the student's profile under `users/UID`.
5.  The authentication stream detects the signed-in user and opens the
    dashboard.

**Important production consideration:** Authentication account creation
and database writing are separate operations. If the database write
fails after account creation, the authentication account may still
exist. Provide a way for the signed-in user to retry profile creation
rather than trying to register the same email again.

### Step 14.5: Login screen

Create:

``` text
lib/screens/login_screen.dart
```

Code:

``` dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = AuthService();

  bool isLoading = false;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await authService.loginUser(
        email: emailController.text,
        password: passwordController.text,
      );

      // AuthWrapper listens for the authentication change.
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 80,
              color: Colors.blue,
            ),

            const SizedBox(height: 25),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text(
                "Don't have an account? Register",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Step 14.6: Dashboard screen

Create:

``` text
lib/screens/dashboard_screen.dart
```

Code:

``` dart
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/database_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final databaseService = DatabaseService();

    final user = authService.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              await authService.logoutUser();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),

      body: FutureBuilder<Map<String, dynamic>?>(
        future: databaseService.getStudentDetails(user.uid),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to load student details'),
            );
          }

          final student = snapshot.data;

          if (student == null) {
            return const Center(
              child: Text('Student profile not found'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 45),
                ),

                const SizedBox(height: 20),

                Text(
                  'Welcome, ${student['fullName']}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(Icons.badge),
                  title: const Text('Student ID'),
                  subtitle: Text('${student['studentId']}'),
                ),

                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  subtitle: Text('${student['email']}'),
                ),

                ListTile(
                  leading: const Icon(Icons.fingerprint),
                  title: const Text('Firebase UID'),
                  subtitle: Text(user.uid),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### Step 14.7: Update main.dart

Replace the temporary Firebase connection test with the final
application code:

``` dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Firebase App',

      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),

      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          return const DashboardScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
```

### Why use AuthWrapper?

This listens to Firebase Authentication status:

``` dart
FirebaseAuth.instance.authStateChanges()
```

  Situation                                        Expected screen
  ------------------------------------------------ -----------------
  User is not logged in                            Login screen
  User successfully registers                      Dashboard
  User successfully logs in                        Dashboard
  User logs out                                    Login screen
  User reopens the app while still authenticated   Dashboard

The authentication stream automatically updates the screen. You do not
need to manually navigate to the dashboard after login.

------------------------------------------------------------------------

## 15. Run and Test the Application

### Step 15.1: Get dependencies

``` bash
flutter pub get
```

### Step 15.2: Analyze the project

``` bash
flutter analyze
```

Resolve any errors before testing.

### Step 15.3: Run the application

Connect an Android device or start an Android emulator.

``` bash
flutter run
```

### Step 15.4: Test registration

Use sample details:

  Field        Sample value
  ------------ ---------------------
  Full Name    Navod Perera
  Student ID   ICBT001
  Email        navodtest@gmail.com
  Password     Navod123

Click **Register**.

Expected workflow:

1.  Firebase creates the authentication account.
2.  Firebase generates a unique UID.
3.  Flutter saves student details in Realtime Database.
4.  Authentication state changes.
5.  The dashboard appears.

### Step 15.5: Verify Authentication

Open:

**Firebase Console → Authentication → Users**

Confirm that the registered email address appears.

### Step 15.6: Verify Realtime Database

Open:

**Firebase Console → Realtime Database → Data**

You should see a structure similar to:

``` json
{
  "users": {
    "generated_firebase_uid": {
      "fullName": "Navod Perera",
      "studentId": "ICBT001",
      "email": "navodtest@gmail.com",
      "createdAt": "2026-11-10T09:00:00.000"
    }
  }
}
```

### Step 15.7: Test login and logout

1.  Click Logout on the dashboard.
2.  Confirm that the login screen appears.
3.  Enter the registered email and password.
4.  Click Login.
5.  Confirm that the dashboard displays the correct student information.
6.  Close and reopen the application to test persistent authentication.

------------------------------------------------------------------------

## 16. Understand the Application Architecture

``` text
Flutter UI
  |
  ├── Login Screen
  ├── Registration Screen
  └── Dashboard Screen
          |
          v
     Service Layer
          |
          ├── AuthService
          |     ├── Register
          |     ├── Login
          |     └── Logout
          |
          └── DatabaseService
                ├── Save details
                └── Retrieve details
                      |
                      v
                 Firebase
                  /    \
                 v      v
          Authentication  Realtime Database
```

### Responsibility of each file

  File                      Responsibility
  ------------------------- -------------------------------------------------------
  `main.dart`               Initializes Firebase and manages authentication state
  `firebase_options.dart`   Generated Firebase configuration
  `auth_service.dart`       Registration, login and logout
  `database_service.dart`   Save and retrieve student information
  `register_screen.dart`    Registration user interface
  `login_screen.dart`       Login user interface
  `dashboard_screen.dart`   Displays the student's profile

------------------------------------------------------------------------

## 17. Firebase SDK vs. Custom REST API

There are two different approaches.

### Approach 1: Firebase SDK (used in this project)

Example Authentication call:

``` dart
FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email,
  password: password,
);
```

Example Realtime Database call:

``` dart
FirebaseDatabase.instance
    .ref('users/$uid')
    .set({
  'fullName': 'Navod Perera',
});
```

These are Firebase SDK methods. They communicate directly with Firebase
services.

You do not need to develop a separate REST API server for this basic
application.

### Approach 2: Custom REST API

You can develop your own backend using:

-   Node.js + Express
-   Laravel + PHP
-   ASP.NET Core Web API
-   Python + Flask

A custom backend is useful when the application needs additional
business logic, server-side processing, integrations or more complex
authorization.

For this student registration application, the Firebase SDK approach is
sufficient.

------------------------------------------------------------------------

## 18. Common Errors and Solutions

  -----------------------------------------------------------------------
  Error                               Possible solution
  ----------------------------------- -----------------------------------
  `flutterfire` not recognized        Add Dart Pub Cache `bin` to PATH

  `firebase` not recognized           Check Firebase CLI installation and
                                      Node.js PATH

  `No Firebase App '[DEFAULT]'`       Initialize Firebase before
                                      `runApp()`

  `firebase_options.dart` not found   Run `flutterfire configure`

  Permission denied                   Check Realtime Database security
                                      rules and authentication

  `operation-not-allowed`             Enable Email/Password
                                      Authentication

  `email-already-in-use`              Login to the existing account or
                                      use another email

  `weak-password`                     Use a password of at least 6
                                      characters

  `network-request-failed`            Check the internet connection

  Database URL not configured         Check database creation and
                                      generated configuration
  -----------------------------------------------------------------------

### Useful troubleshooting commands

``` bash
flutter clean
flutter pub get
flutterfire configure
flutter run
```

Do not change Gradle versions or delete configuration files without
first checking the actual build error.

------------------------------------------------------------------------

## 19. Final Checklist

Use this checklist to confirm that you completed the practical:

-   [ ] Install Flutter SDK and Android Studio.
-   [ ] Install Node.js and Firebase CLI.
-   [ ] Login using `firebase login`.
-   [ ] Install FlutterFire CLI.
-   [ ] Create a Firebase project.
-   [ ] Add `firebase_core`.
-   [ ] Run `flutterfire configure`.
-   [ ] Initialize Firebase in `main.dart`.
-   [ ] Enable Email/Password Authentication.
-   [ ] Add `firebase_auth`.
-   [ ] Create Realtime Database.
-   [ ] Add `firebase_database`.
-   [ ] Configure database security rules.
-   [ ] Create `AuthService`.
-   [ ] Create `DatabaseService`.
-   [ ] Create Registration Screen.
-   [ ] Create Login Screen.
-   [ ] Create Dashboard Screen.
-   [ ] Test registration and database saving.
-   [ ] Test login and logout.

------------------------------------------------------------------------

## 20. Official Documentation

Use these official resources for further learning:

1.  [Firebase setup with
    Flutter](https://firebase.google.com/docs/flutter/setup)
2.  [Firebase Authentication for
    Flutter](https://firebase.google.com/docs/auth/flutter/start)
3.  [Email and Password
    Authentication](https://firebase.google.com/docs/auth/flutter/password-auth)
4.  [Realtime Database setup for
    Flutter](https://firebase.google.com/docs/database/flutter/start)
5.  [Read and Write Realtime
    Database](https://firebase.google.com/docs/database/flutter/read-and-write)
6.  [Realtime Database Security
    Rules](https://firebase.google.com/docs/database/security)
7.  [Firebase CLI documentation](https://firebase.google.com/docs/cli)
8.  [Flutter documentation](https://docs.flutter.dev/)

------------------------------------------------------------------------

## Learning Outcome

After completing this practical, you should be able to:

-   Create a Flutter project using Android Studio.
-   Create and configure a Firebase project.
-   Connect Flutter to Firebase using Firebase CLI and FlutterFire CLI.
-   Implement Email/Password registration and login.
-   Generate and use Firebase UIDs.
-   Save student details in Realtime Database.
-   Retrieve user information from Firebase.
-   Manage authentication state.
-   Apply basic database security rules.

**Recommended learning sequence:** Complete Sections 1--12 first. Then
implement each Dart file in Section 14 individually. Test registration
before moving on to login and dashboard development.

------------------------------------------------------------------------

**Project:** Student Firebase Application\
**Platform:** Android\
**IDE:** Android Studio\
**Framework:** Flutter\
**Backend:** Firebase\
**Authentication:** Firebase Authentication\
**Database:** Firebase Realtime Database\
**Configuration:** Firebase CLI + FlutterFire CLI
