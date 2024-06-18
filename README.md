# Task List Project

A tasks project created in Flutter using Firebase, where users can sign up, log in, reset their password, create, and view a list of tasks.

## How to Use

**Step 1:**

Download or clone this repo by using the link below:

```
git@github.com:Vyzion-Innovation/FlutterFirebaseIntegration.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies:

```
flutter pub get
```

**Step 3:**

This project uses `inject` library that works with code generation, execute the following command to generate files:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

or watch command in order to keep the source code synced automatically:

```
flutter packages pub run build_runner watch
```

## Hide Generated Files

In-order to hide generated files, navigate to `Android Studio` -> `Preferences` -> `Editor` -> `File Types` and paste the below lines under `ignore files and folders` section:

```
*.inject.summary;*.inject.dart;*.g.dart;
```

In Visual Studio Code, navigate to `Preferences` -> `Settings` and search for `Files:Exclude`. Add the following patterns:

```
**/*.inject.summary
**/*.inject.dart
**/*.g.dart
```

## Task List Features:

- Splash
- Login
- Signup using email, password and Image
- Forgot
- Tasks List
- Create Task using Media
- Update Task using Media
