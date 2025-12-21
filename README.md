# 📋 CopyClip

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

  <br />

**The All-in-One Productivity Powerhouse** *Notes • Todos • Finance • Journal • Clipboard Manager*

[Report Bug](https://github.com/yourusername/copyclip/issues) · [Request Feature](https://github.com/yourusername/copyclip/issues)

</div>

---

## 📱 Screenshots

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Dashboard</b></td>
      <td align="center"><b>Notes</b></td>
      <td align="center"><b>Finance</b></td>
    </tr>
    <tr>
      <td><img src="assets/screenshots/dashboard.png" width="200" alt="Dashboard" /></td>
      <td><img src="assets/screenshots/notes.png" width="200" alt="Notes" /></td>
      <td><img src="assets/screenshots/finance.png" width="200" alt="Finance" /></td>
    </tr>
    <tr>
      <td align="center"><b>To-Dos</b></td>
      <td align="center"><b>Journal</b></td>
      <td align="center"><b>Clipboard</b></td>
    </tr>
    <tr>
      <td><img src="assets/screenshots/todos.png" width="200" alt="To-Dos" /></td>
      <td><img src="assets/screenshots/journal.png" width="200" alt="Journal" /></td>
      <td><img src="assets/screenshots/clipboard.png" width="200" alt="Clipboard" /></td>
    </tr>
  </table>
</div>

---

## ✨ Key Features

CopyClip isn't just another note-taking app. It's a privacy-focused, offline-first ecosystem for your digital life.

### 📝 Notes & Writing
- **Rich Text Editing:** Create beautiful notes with full markdown support.
- **Smart Organization:** Tag, categorize, and search your notes instantly.

### ✅ Productivity & Tasks
- **To-Do Lists:** Manage tasks with priorities, deadlines, and reminders.
- **Drag & Drop:** Reorder your daily tasks with satisfying animations.

### 💰 Finance Tracker
- **Expense Logging:** Track daily spending and income in seconds.
- **Visual Analytics:** View spending habits with intuitive charts and summaries.

### 📔 Personal Journal
- **Daily Reflections:** Capture your thoughts, moods, and memories.
- **Mood Tracking:** Visualize your emotional well-being over time.

### 📋 Clipboard Manager
- **History:** Never lose a copied link or text snippet again.
- **Auto-Save:** Automatically archives your system clipboard for easy retrieval.

---

## 🛠️ Tech Stack

This project is built with a focus on performance, clean architecture, and modern Flutter practices.

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **Local Database:** [Hive](https://docs.hivedb.dev/) (NoSQL, fast & secure)
* **State Management:** `setState` & `ValueNotifier` (Clean & Reactive)
* **Navigation:** [GoRouter](https://pub.dev/packages/go_router)
* **UI Components:** Custom Glassmorphism Widgets, Hero Animations, Bouncing Scroll Physics.

---

## 🚀 Getting Started

Follow these steps to get a local copy up and running.

### Prerequisites

* [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
* An IDE (VS Code or Android Studio).

### Installation

1.  **Clone the repository**
    ```bash
    git clone [https://github.com/technopradyumn/CopyClip.git](https://github.com/technopradyumn/CopyClip.git)
    ```
2.  **Navigate to the project directory**
    ```bash
    cd copyclip
    ```
3.  **Install dependencies**
    ```bash
    flutter pub get
    ```
4.  **Run the app**
    ```bash
    flutter run
    ```

---

## 📂 Project Structure

A quick look at the top-level directory structure.

```text
lib/
├── src/
│   ├── core/            # Shared widgets, utilities, and theme data
│   ├── features/        # Feature-based folders (Notes, Todos, etc.)
│   │   ├── notes/
│   │   ├── todos/
│   │   ├── expenses/
│   │   ├── journal/
│   │   └── clipboard/
│   └── app.dart         # Main app entry point
└── main.dart            # Application root