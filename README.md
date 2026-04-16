# Jellycat Collection Tracker

A mobile application for tracking your Jellycat plushie collection, built with Flutter following Clean Architecture principles.

## Project Structure

This repository contains:

- `/jellycat_app/` - The Flutter mobile application
- `/jellycat_app_plan.md` - Comprehensive architecture and implementation plan

## Features

✨ **Comprehensive Catalog** - Browse 900+ Jellycat releases across collections
🎯 **Collection Tracking** - Mark owned items, track progress and value
❤️ **Wishlist Management** - Create and manage wishlist of desired Jellycats
💰 **Value Estimation** - Calculate total worth of collection and wishlist
🎨 **Jellycat Branding** - Beautiful UI with authentic Jellycat colors
📱 **Offline-First** - Full functionality without internet connection
🔍 **Smart Filtering** - Filter by collection (Bashful, Amuseables, etc.)

## Architecture

Built using:
- **Clean Architecture** - Separation of concerns across layers
- **SOLID Principles** - Maintainable and testable code
- **Riverpod** - Type-safe state management
- **SQLite** - Offline-first local storage
- **Freezed** - Immutable data models
- **Material Design 3** - Modern UI components

### Layers

```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│  (UI, Widgets, State Management)    │
├─────────────────────────────────────┤
│         Domain Layer                │
│  (Entities, Use Cases, Interfaces)  │
├─────────────────────────────────────┤
│          Data Layer                 │
│  (Repositories, Data Sources)       │
├─────────────────────────────────────┤
│        Infrastructure               │
│  (Database, Platform APIs)          │
└─────────────────────────────────────┘
```

## Quick Start

### Prerequisites

- Flutter SDK 3.4.0+
- Dart SDK 3.4.0+
- Android Studio / Xcode

### Installation

```bash
cd jellycat_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

See `/jellycat_app/README.md` for detailed setup instructions.

## Sample Data

The app includes 8 sample Jellycats:
- Bashful Bunny
- Bashful Black & Cream Puppy
- Amuseable Avocado
- Amuseable Strawberry
- Cordy Roy Lion
- Bashful Dino
- Fuddlewuddle Bear
- Bashful Lamb

## Development

The project follows a feature-based folder structure:

```
lib/
├── core/              # Constants, theme, utilities
├── features/          # Feature modules
│   ├── catalog/      # Browse Jellycats
│   ├── collection/   # Track owned items
│   └── wishlist/     # Wishlist management
├── services/          # Platform services
├── shared/            # Shared widgets & providers
└── main.dart         # App entry point
```

## Future Enhancements

- Cloud sync with Firebase
- Social sharing features
- Real-time market pricing
- OCR for Jellycat identification
- Restock notifications
- Duplicate detection

## Contributing

Contributions welcome! Please read the architecture plan before submitting PRs.

## License

MIT License

## Disclaimer

Jellycat® is a registered trademark of Jellycat Ltd. This is an unofficial fan-made application. All Jellycat designs and characters are property of Jellycat Ltd.

---

Made with ❤️ by Jellycat collectors, for Jellycat collectors
