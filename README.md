# CricAI

An AI-Powered Cricket Coach

CricAI is an Industrial project for an emerging startup named enGenAIr, funded by HEC for my Final Year Project.

A complete mobile based solution for cricket training, aiming to minimize errors by providing AI-driven feedback and analysis to coaches and players which will save valuable time and efforts.

## Features:

1. **User Authentication**

- Login
- Register
- Forgot Password
- Verify Email
- New Password

2. **Upload Video**
3. **Record Video**
4. **Generate analysis**
5. **View Result**
6. **Session Management**

- Create Session
- Update Session
- Remove Session
- View All Sessions

7. **Player Management**

- Add Player
- Remove Player
- View All players

8. **User Management**

- Remove User

9. **Backend Management**

- Add Ideal Player Data
- Remove Ideal Player Data

## Tech Stack

- **Flutter** - for mobile development of CricAI application having coach and player as users
- **Firebase** - for integration of _Firebase Authentication_, _Firestore_ for sessions collection and players collection, and _Firebase Storage_ for storing videos
- **Python** - for the development of core features, Pose Estimation and Shot Comparison, and Shot Classification Classifier
- **Mediapipe Library** - for extracting landmarks of the body of a player
- **FastAPI** - for the development of Pose Estimation, Shot Comparison, and Shot Classification APIs and integrating them in the mobile application to generate analysis.

## Design

### Use Case Diagram :

![Use Case Diagram](https://github.com/HibbanHaroon/CricAI/blob/assets/Diagrams/Use%20Case%20Diagram.png)

### Architecture Diagram:

![Architecture Diagram](https://github.com/HibbanHaroon/CricAI/blob/assets/Diagrams/Architecture%20Diagram.jpg)

### Work Breakdown Structure:

![Work Breakdown Structure](https://github.com/HibbanHaroon/CricAI/blob/assets/Diagrams/Work%20Breakdown%20Structure.jpg)

### Figma Prototype

[Figma Link](https://www.figma.com/file/wqdUByLf3qINwzOxqnFv3D/CricAI-Prototype?type=design&node-id=0%3A1&mode=design&t=eIUN5muog8xDmiIw-1)

1. **Splash Screen**
   ![Splash Screen](https://github.com/HibbanHaroon/CricAI/blob/assets/Figma%20Prototype/Splash%20Screen.png)

2. **Login Screen**
   ![Login Screen](https://github.com/HibbanHaroon/CricAI/blob/assets/Figma%20Prototype/Login.png)

3. **Register Screen**
   ![Register Screen](https://github.com/HibbanHaroon/CricAI/blob/assets/Figma%20Prototype/Register.png)

4. **Forgot Password Screen**
   ![Forgot Password Screen](https://github.com/HibbanHaroon/CricAI/blob/assets/Figma%20Prototype/Forgot%20Password.png)

5. **Verify Email Screen**
   ![Verify Email Screen](https://github.com/HibbanHaroon/CricAI/blob/assets/Figma%20Prototype/Verify%20Account.png)

6. **New Password Screen**
   ![New Password Screen](https://github.com/HibbanHaroon/CricAI/blob/assets/Figma%20Prototype/New%20Password.png)

7. **Home Screen**
   ![Home Screen](https://github.com/HibbanHaroon/CricAI/blob/assets/Figma%20Prototype/Home%20Screen.png)

8. **Create Session Screen**
   ![Create Session Screen](https://github.com/HibbanHaroon/CricAI/blob/assets/Figma%20Prototype/Create%20Session.png)

9. **View All Sessions Screen**
   ![View All Sessions Screen](https://github.com/HibbanHaroon/CricAI/blob/assets/Figma%20Prototype/View%20All%20Sessions.png)

10. **Session Screen**
    ![Session Screen](https://github.com/HibbanHaroon/CricAI/blob/assets/Figma%20Prototype/Session%20Page.png)

11. **Generate Analysis Screen**
    ![Generate Analysis Screen](https://github.com/HibbanHaroon/CricAI/blob/assets/Figma%20Prototype/Generate%20Analysis.png)

12. **View Result Screen**
    ![View Result Screen](https://github.com/HibbanHaroon/CricAI/blob/assets/Figma%20Prototype/View%20Result.png)
