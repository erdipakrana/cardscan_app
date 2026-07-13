# Contributing to CardScan

Thanks for your interest in improving CardScan! 🎉 This guide covers everything you need to get set up and land a great pull request.

## 🧭 Ways to Contribute

- 🐛 **Fix a bug** — check the issues tab for open bugs
- ✨ **Build a feature** — see the [Trending Features to Contribute](README.md#-trending-features-to-contribute) section in the README
- 📝 **Improve docs** — README, code comments, or this guide
- 🧪 **Add tests** — the codebase is currently light on tests

## 🚀 Development Setup

**Prerequisites:** Flutter SDK `^3.11.5` and a configured emulator or physical device.

```bash
# 1. Fork and clone the repo
git clone https://github.com/<your-username>/visiting_card_scanner.git
cd visiting_card_scanner/cardscan_app

# 2. Install dependencies
flutter pub get

# 3. Generate Drift database code (required)
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

> 💡 If you change anything in `lib/core/database/`, re-run the `build_runner`
> command above to regenerate `app_database.g.dart`.

## 🏗️ Architecture Guidelines

The app follows a **feature-first clean architecture**. Please keep new code in the correct layer:

```
lib/
├── core/                    # shared infrastructure (database, etc.)
└── features/<feature>/
    ├── data/                # datasources, models, repository implementations
    ├── domain/              # entities & repository contracts (no Flutter imports)
    └── presentation/        # pages & Riverpod controllers/providers
```

- **Domain** defines *what* the app does (entities, repository interfaces) and must stay framework-agnostic.
- **Data** implements the domain contracts (Drift, ML Kit, etc.).
- **Presentation** holds UI and state — use **Riverpod** providers, not ad-hoc state.

## 🔀 Pull Request Workflow

1. Create a branch from `main`:
   ```bash
   git checkout -b feature/short-description
   ```
2. Make your changes, keeping commits focused and descriptive.
3. Run the checks locally (see below) — they must pass.
4. Push and open a Pull Request that:
   - describes **what** changed and **why**
   - links any related issue (`Closes #123`)
   - includes screenshots or a short clip for UI changes

## ✅ Before You Submit

Run these and make sure they're clean:

```bash
flutter analyze     # static analysis / lints
flutter test        # unit & widget tests
dart format .       # consistent formatting
```

## 🎨 Code Style

- Follow the rules in `analysis_options.yaml` (based on `flutter_lints`).
- Prefer `const` constructors where possible.
- Keep widgets small and composable; extract private widgets for readability.
- Name things clearly — match the conventions in the surrounding code.

## 💬 Questions

Open a [GitHub issue](../../issues) with the `question` label if you're unsure
about anything before starting. Claiming an issue before you begin helps avoid
duplicate work.

Happy hacking! 🚀
