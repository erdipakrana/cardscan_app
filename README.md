# 📇 CardScan — Visiting Card Scanner

A **Flutter** app that scans physical visiting (business) cards with your camera, extracts contact details using **on-device OCR**, and stores them locally for fast, offline access. Built with a clean, feature-first architecture using Riverpod and Drift.

> ⚡ **100% offline** — no accounts, no servers, no data leaves the device.

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Screenshots](#-screenshots)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Architecture](#-architecture)
- [Getting Started](#-getting-started)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [Available Scripts](#-available-scripts)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🔍 Overview

CardScan turns a photo of a business card into saved, browsable contact details. It captures an image with the camera, runs **Google ML Kit Text Recognition** on-device to extract the text, and persists each card in a local **SQLite** database (via Drift). The saved-cards list updates reactively as data changes.

**Who it's for:** anyone who collects business cards — sales reps, founders, recruiters, event-goers — and wants a private, offline way to digitize them.

---

## ✨ Key Features

- 📷 **Camera capture** — scan a business card with the device camera
- 🔍 **On-device OCR** — extract text automatically via Google ML Kit (works offline)
- 🧠 **Intelligent Parsing** — auto-detect name, job title, company, email, phone, and website from the extracted raw OCR text using regex and heuristics
- ✍️ **Interactive Review & Edit** — verify and correct parsed contact fields in an edit form before saving
- 💾 **Local persistence** — save structured contacts to an on-device SQLite database (Drift)
- 📋 **Structured Cards list** — browse and expand stored cards to view clean, grouped contact details
- 📋 **One-tap Copy** — quickly copy individual contact fields (email, phone, website) to your clipboard
- 🗑️ **Delete cards** — remove entries you no longer need
- ⚡ **Reactive UI** — the list updates live via a database stream

---

## 📸 Screenshots

> _Add screenshots or a screen recording here to help contributors and users._
>
> | Saved Cards | Scan Screen | Extracted Text |
> | :---------: | :---------: | :------------: |
> |  _(add)_    |  _(add)_    |    _(add)_     |

---

## 🛠️ Tech Stack

| Concern | Package / Tool |
| --- | --- |
| Framework | [Flutter](https://flutter.dev) (Dart SDK `^3.11.5`) |
| State management | [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod) |
| Text recognition (OCR) | [`google_mlkit_text_recognition`](https://pub.dev/packages/google_mlkit_text_recognition) |
| Local database | [`drift`](https://pub.dev/packages/drift) + `sqlite3_flutter_libs` |
| Camera / image capture | [`image_picker`](https://pub.dev/packages/image_picker) |
| File paths | `path_provider`, `path` |
| Codegen | `drift_dev`, `build_runner` |
| Linting | `flutter_lints` |

**Supported platforms:** Android, iOS, Web¹

> ¹ OCR and camera capture depend on device support; ML Kit is intended for mobile.

---

## 📂 Project Structure

```
cardscan_app/
├── lib/
│   ├── main.dart                    # App entry point (ProviderScope + MaterialApp)
│   ├── core/
│   │   └── database/                # Drift database definition + generated code
│   │       ├── app_database.dart
│   │       └── app_database.g.dart  # generated (build_runner)
│   └── features/
│       └── cards/
│           ├── data/
│           │   ├── datasources/     # CardsLocalDatasource (Drift queries)
│           │   ├── models/          # CardModel (data <-> entity mapping)
│           │   └── repositories/    # CardsRepositoryImpl
│           ├── domain/
│           │   ├── entities/        # VisitingCard
│           │   └── repositories/    # CardsRepository (abstract contract)
│           └── presentation/
│               ├── controllers/     # Riverpod providers + CardScannerController
│               └── pages/           # SavedCardsPage, CardScannerPage
├── test/                            # Widget/unit tests
├── android/ ios/ web/               # Platform projects
└── pubspec.yaml
```

---

## 🏗️ Architecture

The project follows **feature-first clean architecture** with three layers:

- **Domain** — framework-agnostic business rules: the `VisitingCard` entity (now housing structured fields: `name`, `jobTitle`, `company`, `email`, `phone`, `website`, and raw `details`) and the `CardsRepository` contract.
- **Data** — implements the domain contract: `CardsLocalDatasource` runs Drift queries, `CardModel` maps DB rows to entities, and `CardsRepositoryImpl` ties them together.
- **Presentation** — UI + state: Riverpod providers expose a `cardsStreamProvider` (live list) and a `CardScannerController` (`StateNotifier`) managing the scan → extract → parse → save flow.

Dependencies point **inward** (presentation → domain ← data), keeping the domain pure and testable.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) with Dart `^3.11.5`
- A configured Android/iOS emulator or a physical device (camera required for scanning)
- Run `flutter doctor` and resolve any reported issues

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/visiting_card_scanner.git
cd visiting_card_scanner/cardscan_app

# 2. Install dependencies
flutter pub get

# 3. Generate the Drift database code (required)
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

> 💡 Step 3 is required — the app won't compile without the generated
> `app_database.g.dart`. Re-run it whenever you change files in `core/database/`.

---

## ⚙️ Configuration

The app works out of the box with **no environment variables or API keys** (ML Kit runs on-device).

### Camera permissions

`image_picker` uses the platform camera. If scanning fails on a real device, ensure permissions are declared:

**Android** — `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

**iOS** — `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan visiting cards.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo access to import card images.</string>
```

> ⚠️ These entries are **not currently present** in the repo — adding them is a
> great first contribution (see the [Roadmap](#-roadmap)).

### Database

The SQLite database (`cards.db`) is created automatically in the app's documents directory on first launch. Schema version is `1`. The database stores the following fields per card:
- `id` (Primary key, auto-increment)
- `name` (Contact person's name)
- `jobTitle` (Title/Designation, nullable)
- `company` (Organization, nullable)
- `email` (Email address, nullable)
- `phone` (Phone number, nullable)
- `website` (Website link, nullable)
- `details` (Raw extracted OCR text block)

To upgrade the database schema, bump `schemaVersion` in `app_database.dart` and add a migration when changing tables.

---

## 📖 Usage

1. **Launch the app** — you land on the **Saved Cards** screen (empty on first run).
2. **Tap the camera FAB** to open the scanner.
3. **Tap "Scan Card"** — capture the business card with your camera.
4. The parsed details are extracted; review them (text is selectable/copyable).
5. **Tap "Save Card"** — an interactive form displays pre-filled parsed details (Name, Title, Company, Email, Phone, Website). Edit any fields to correct OCR mistakes.
6. Back on the list, **tap a card to expand** its details and perform quick actions (copying emails/phones/websites).

---

## 📜 Available Scripts

| Command | Description |
| --- | --- |
| `flutter pub get` | Install dependencies |
| `dart run build_runner build --delete-conflicting-outputs` | Generate Drift code (one-off) |
| `dart run build_runner watch --delete-conflicting-outputs` | Regenerate code on file changes |
| `flutter run` | Run the app on a connected device/emulator |
| `flutter analyze` | Static analysis / lints |
| `flutter test` | Run unit & widget tests |
| `dart format .` | Format the codebase |
| `flutter build apk --release` | Build a release Android APK |
| `flutter build appbundle --release` | Build an Android App Bundle (Play Store) |
| `flutter build ios --release` | Build a release iOS app |
| `flutter build web` | Build the web app |

---

## 🧪 Testing

The project uses `flutter_test`. A smoke test in `test/widget_test.dart` verifies the app boots and renders the home title.

```bash
flutter test                       # run all tests
flutter test --coverage            # generate coverage/lcov.info
```

**Contributions welcome:** the test suite is currently minimal. High-value additions include unit tests for `CardsRepositoryImpl`, the `CardScannerController` state transitions, and widget tests for the saved-cards and scanner pages.

---

## 🚢 Deployment

**Android (Play Store):**
```bash
flutter build appbundle --release
```
Sign the bundle with your keystore (configure `android/key.properties` and `build.gradle`), then upload the `.aab` to the Play Console.

**iOS (App Store):**
```bash
flutter build ios --release
```
Open `ios/Runner.xcworkspace` in Xcode, set your signing team, then archive and distribute via App Store Connect.

**Web:**
```bash
flutter build web
```
Deploy the contents of `build/web/` to any static host (Firebase Hosting, Netlify, GitHub Pages, etc.).

---

## 🗺️ Roadmap

High-impact, modern feature ideas for contributors. Pick one, open an issue to claim it, and send a PR!

### 🔥 High Impact
- [x] **Structured field parsing** — auto-detect name, phone, email, company, and website from raw OCR text instead of storing one blob (regex/NLP based).
- [ ] **Save to device contacts** — one-tap export of a scanned card to the phone's address book.
- [ ] **Search & filter** — full-text search across saved cards by name, company, or keyword.
- [ ] **Edit saved cards** — let users correct OCR mistakes after saving (now partially implemented as edit-before-saving).
- [ ] **Camera permission setup** — declare Android/iOS permissions so scanning works reliably on all devices.

### 📱 Modern UX
- [ ] **Live camera scanning** — real-time card detection with an overlay guide instead of the picker flow.
- [ ] **Material 3 + dark mode** — migrate the theme to Material 3 with dynamic color and a dark theme.
- [ ] **Card thumbnails** — persist the captured image alongside details and show it in the list.
- [ ] **Gallery import** — scan an existing photo of a card from the gallery.
- [ ] **Swipe-to-delete & undo** — faster list management with an undo snackbar.

### 🌐 Integrations & Sync
- [ ] **QR / vCard export** — generate a shareable QR code or `.vcf` file per card.
- [ ] **Cloud backup & sync** — optional sync via Firebase / Supabase across devices.
- [ ] **Multi-language OCR** — support Latin, Chinese, Japanese, Korean, and Devanagari scripts.
- [ ] **CSV / Excel export** — bulk-export all cards for use in a CRM.

### 🧰 Quality & Tooling
- [ ] **Expand test coverage** — repository, controller, and widget tests.
- [ ] **CI pipeline** — GitHub Actions for `flutter analyze`, `flutter test`, and build checks.
- [ ] **Accessibility pass** — semantic labels, larger-text support, and contrast tuning.
- [ ] **Database migrations** — versioned schema migrations as the model grows.

---

## 🤝 Contributing

Contributions are welcome and appreciated! Please read **[CONTRIBUTING.md](CONTRIBUTING.md)** for full setup, architecture guidelines, and the PR workflow.

**Quick start for contributors:**

1. **Find something to work on** — pick an item from the [Roadmap](#-roadmap) or open an issue.
2. **Claim it** — comment on / open an issue so others know it's taken.
3. **Fork & branch** — `git checkout -b feature/your-feature`
4. **Build & verify** — run `flutter analyze`, `flutter test`, and `dart format .`
5. **Open a PR** — describe what changed and why, link the issue, and add screenshots for UI changes.

Please keep PRs focused and follow the existing clean-architecture layering (domain → data → presentation).

---

## 📄 License

Released under the [MIT License](LICENSE).
