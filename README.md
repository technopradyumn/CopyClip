# 📋 CopyClip

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.8.1-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.8.1-%230175C2.svg?style=for-the-badge&logo=Dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-14+-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-17+-000000?style=for-the-badge&logo=ios&logoColor=white)
![Hive](https://img.shields.io/badge/Hive-2.2.3-FF5722?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDJDOC42NzMgMiAyIDYuNjczIDIgMTJzNi42NzMgMTAgMTIgMTBzMTAtNi42NzMgMTAtMTJTMTEuMzI3IDIgMTIgMnptMCAxOWMtNC44MzcgMC05LjE2My00LjMyNi05LjE2My05LjE2M3MyLjMyNi05LjE2MyA5LjE2My05LjE2M3M5LjE2MyAyLjMyNiA5LjE2MyA5LjE2M3MtNC4zMjYgOS4xNjMgOS4xNjMgOS4xNjN6IiBmaWxsPSIjRkY1NzIyIi8+Cjwvc3ZnPgo=&logoColor=white)

<br/>

**🚀 The Ultimate All-in-One Productivity Ecosystem**

*Notes • Todos • Expenses • Journal • Clipboard • Canvas • Calendar • Social • Gamification*

[![GitHub stars](https://img.shields.io/github/stars/technopradyumn/CopyClip?style=social)](https://github.com/technopradyumn/CopyClip)
[![GitHub forks](https://img.shields.io/github/forks/technopradyumn/CopyClip?style=social)](https://github.com/technopradyumn/CopyClip)

[🌟 Report Bug](https://github.com/technopradyumn/CopyClip/issues/new?template=bug_report.md) · 
[💡 Request Feature](https://github.com/technopradyumn/CopyClip/issues/new?template=feature_request.md) · 
[📖 Documentation](https://github.com/technopradyumn/CopyClip/tree/main/docs)

</div>

---

## ✨ Features Overview

<div align="center">

| 🎯 **Dashboard** | 📝 **Notes** | ✅ **Todos** |
|---|---|---|
| Global search across all content | Rich Markdown editing (Quill) | Priority tasks & deadlines |
| Quick stats & navigation | Tags & organization | Drag & drop reordering |
| Home widgets support | Search & filter | Smart notifications |

| 💰 **Expenses** | 📔 **Journal** | 📋 **Clipboard** |
|---|---|---|
| Income/expense tracking | Mood tracking & analytics | Auto-save clipboard history |
| Beautiful charts (fl_chart) | Custom page designs | Rich text support |
| Category analysis | Daily reflection templates | Quick paste access |

| 🎨 **Canvas** | 📅 **Calendar** | 📱 **Social** |
|---|---|---|
| Freehand drawing & sketching | Event management | Social post composer |
| Folder organization | Recurring events | Multi-platform sharing |
| Export as image/PDF | Detailed views | Preview & scheduling |

| 🏆 **Gamification** | ⚙️ **Premium** | 🎨 **UI/UX** |
|---|---|---|
| XP system & medals | Ad-free experience | Glassmorphism design |
| Achievement badges | Advanced features | 60fps animations |
| Progress tracking | Cloud sync (future) | Dark/Light themes |

</div>

---

## 📱 Screenshots & Demos

<div align="center">
<img src="https://github.com/technopradyumn/CopyClip/assets/12345678/abc123" alt="Dashboard" width="200"/>
<img src="https://github.com/technopradyumn/CopyClip/assets/12345678/def456" alt="Notes" width="200"/>
<img src="https://github.com/technopradyumn/CopyClip/assets/12345678/ghi789" alt="Clipboard" width="200"/>
<!-- Add real screenshots from GitHub assets or create assets/screenshots/ folder -->
</div>

**Live Demo**: [Google Play](https://play.google.com/store/apps/details?id=com.technopradyumn.copyclip) | [TestFlight](https://testflight.apple.com/join/XXXXX)

---

## 🛠️ Tech Stack

```
🔥 Framework: Flutter 3.8.1 (Dart 3.8.1)
💾 Database: Hive 2.2.3 (Offline-first NoSQL)
📊 Charts: fl_chart 0.69.0
📝 RichText: Flutter Quill 11.5.0
🧭 Navigation: GoRouter
🎭 State: Bloc + Provider + ValueNotifier
🔔 Notifications: flutter_local_notifications 17.0.0
📱 Widgets: home_widget 0.7.0
🎨 Animations: flutter_animate 4.5.2 + rive 0.14.2
💎 UI: Glassmorphism 3.0.0 + ScreenUtil
🌍 i18n: flutter_localizations + Custom ARB generator
📄 Export: PDF 3.10.8 + printing 5.12.0
```

**Full dependencies**: [pubspec.yaml](pubspec.yaml)

---

## 🚀 Quick Start (2 minutes)

```bash
# Clone & Install
git clone https://github.com/technopradyumn/CopyClip.git
cd CopyClip
flutter pub get

# Run (Android/iOS/Web/Desktop)
flutter run

# Build Release
flutter build apk --release  # Android
flutter build ios --release  # iOS
flutter build web --release  # Web
```

**💡 Pro Tip**: First run generates Hive schema automatically!

---

## 🏗️ Project Architecture

```
lib/
├── src/
│   ├── core/          # Shared services, theme, router
│   │   ├── services/  # Clipboard, notifications, gamification
│   │   └── widgets/   # Reusable glassmorphism components
│   ├── features/      # 10+ Feature modules
│   │   ├── dashboard/ ├── notes/ ├── todos/
│   │   ├── expenses/  ├── journal/ ├── clipboard/
│   │   ├── canvas/    ├── calendar/ ├── social_post/
│   │   └── premium/
│   └── theme/         # Dynamic theming (Bloc)
└── main.dart          # Background clipboard + Widgets
```

**Clean Architecture** • **Feature-first** • **Hive-first** • **Widget-ready**

---

## 🔧 Development Setup

### 1. **Prerequisites**
```bash
Flutter 3.8.1+ (stable channel)
VS Code + Flutter/Dart extensions
Android Studio (for emulators)
```

### 2. **Code Generation** (Hive + Localization)
```bash
# Generate Hive adapters
flutter packages pub run build_runner build --delete-conflicting-outputs

# Generate localization (if needed)
dart run tool/generate_l10n.py
dart run tool/sync_localization.dart
```

### 3. **Environment**
```bash
cp .env.example .env  # Add your API keys
flutter pub get
```

### 4. **Widgets & Background**
- iOS: Enable App Groups (`group.com.technopradyumn.copyclip`)
- Android: Add widget providers in `AndroidManifest.xml`

**Docs**: [CI/CD](docs/CI_CD_SETUP.md) | [Signing](docs/SIGNING_SETUP.md) | [Env Vars](docs/ENVIRONMENT_VARIABLES.md)

---

## 📊 Home Screen Widgets

**Supported**: iOS/Android Home Widgets for quick access!

```
• 📝 Quick Notes
• ✅ Today's Todos  
• 💰 Expense Summary
• 📋 Recent Clipboard
• 📅 Upcoming Events
```

**Deep Linking**: `copyclip://app/todos`, `copyclip://clipboard` etc.

---

## 🤝 Contributing

1. Fork the repo
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'feat: add amazing feature'`)
4. Push & PR to `development` branch

**We love**:
- 🐛 Bug reports with reproduction
- 🚀 Performance improvements  
- 🎨 New customizations
- 🌍 Localization contributions

**Code Style**: Follow `analysis_options.yaml` | Use conventional commits

---

## 📄 License

```
MIT License - Use freely for personal & commercial projects!

See [LICENSE](LICENSE) for details.
```

---

## 🙏 Acknowledgments

- **Flutter Team** - Amazing framework!
- **Hive** - Lightning-fast offline storage
- **All Contributors** - ❤️ [Contributors](https://github.com/technopradyumn/CopyClip/graphs/contributors)

---

<div align="center">

**⭐ Star us on GitHub if you found this useful!**
**📱 Try CopyClip - Productivity, Redefined 🚀**

</div>


