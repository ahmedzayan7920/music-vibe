<!--
[SYNC IMPACT REPORT]
- Version change: [CONSTITUTION_VERSION] -> 1.0.0
- List of modified principles:
  * PRINCIPLE_1: [PRINCIPLE_1_NAME] -> I. Feature-First & Clean Architecture
  * PRINCIPLE_2: [PRINCIPLE_2_NAME] -> II. Cubit-First & Equatable States
  * PRINCIPLE_3: [PRINCIPLE_3_NAME] -> III. Strict UI & Widget Standards (NON-NEGOTIABLE)
  * PRINCIPLE_4: [PRINCIPLE_4_NAME] -> IV. Type-Safe Error Handling & Robust Data Layer
  * PRINCIPLE_5: [PRINCIPLE_5_NAME] -> V. Centralized Styling, Theming & Localization
- Added sections:
  * Tech Stack & Key Packages
  * Development Workflow & Code Quality
- Removed sections: None
- Templates requiring updates:
  * .specify/templates/plan-template.md (✅ updated/aligned)
  * .specify/templates/spec-template.md (✅ updated/aligned)
  * .specify/templates/tasks-template.md (✅ updated/aligned)
  * .specify/templates/checklist-template.md (✅ updated/aligned)
- Follow-up TODOs: None
-->

# Music Vibe Constitution

## Core Principles

### I. Feature-First & Clean Architecture
We strictly follow a feature-first structure for new feature development to ensure clear Separation of Concerns:
- `core/` contains shared logic, services, and configuration.
- `features/` contains self-contained folders for each feature (e.g. `features/home`).
- Inside each feature, we separate into `/data` (sources, models, repos) and `/presentation` (cubits, views, widgets).
- Business logic is strictly separated from UI. Cubits manage the state, and UI components are purely declarative (dumb widgets).

### II. Cubit-First & Equatable States
- State management is implemented using `flutter_bloc`. Always use `Cubit` for state management by default. Suggest `Bloc` only if the feature involves a complex stream of incoming events.
- All Bloc/Cubit states and data models MUST extend `Equatable` from the `equatable` package.
- All properties must be included in the `props` getter to guarantee proper value equality.

### III. Strict UI & Widget Standards (NON-NEGOTIABLE)
We maintain extremely clean, robust, and reusable UI code:
- **Widgets Must Be Classes**: Always create widgets as separate classes extending `StatelessWidget` or `StatefulWidget`. NEVER write functions that return a `Widget` (e.g., `Widget _buildRow()`).
- **Separate Widget Files**: Break down the UI into small, single-purpose widgets. Each new widget class must be in its own separate file.
- **Aggressive Const usage**: Be aggressive with using `const` constructors for widgets and constants.
- **Named & Required Parameters**: Constructor arguments must be named parameters `{}`, and required ones must use the `required` keyword.
- **Pass Full Objects**: Always pass complete data model objects (e.g., `User user`) instead of individual primitive attributes.

### IV. Type-Safe Error Handling & Robust Data Layer
- All data operations and repository methods that can fail MUST return `Future<Either<Failure, SuccessType>>` from the `dartz` package. This forces caller logic to handle success and failure cases explicitly.
- Dependencies must be registered and resolved using the `get_it` package.
- Navigation must use `auto_route`.
- Simple local storage uses `shared_preferences`, and complex database persistence uses `hive_ce`.

### V. Centralized Styling, Theming & Localization
- **Theming Workflow**: Centralize all custom colors in `AppPalette` as static const Color properties. Custom, theme-dependent properties must be defined in `ThemeExtension` classes (`AppColors` for semantic colors and `AppTextStyles` for text styles), defined inside the central `AppTheme` class.
- **Localization Workflow**: NEVER hardcode user-facing strings in widgets. All text must be defined in localization translation files (`en.json`, `ar.json`) and accessed type-safely via `AppStrings.keyName`.
- **Aesthetics & Animations**: Deliver beautiful, premium, and clean UI/UX designs. Use the `animate_do` package for subtle micro-animations (fades, slides) and Flutter's built-in `AnimationController` for custom animations.

## Tech Stack & Key Packages

Key framework details and dependency packages of the Music Vibe project:
- **Core Technology**: Flutter (Dart)
- **State Management**: `flutter_bloc`
- **Dependency Injection**: `get_it`
- **Navigation**: `auto_route`
- **Error Handling**: `dartz` (Either type)
- **Value Equality**: `equatable`
- **Localization**: `easy_localization`
- **Environment Variables**: `envied`
- **Local Storage (Simple)**: `shared_preferences`
- **Local Storage (Database)**: `hive_ce`
- **Responsiveness**: `responsive_framework`
- **Simple Animations**: `animate_do`
- **Private Networking**: `network_core` (if applicable)

## Development Workflow & Code Quality

Our software development workflow relies on strict compliance with modern engineering practices:
- **SOLID Principles**: Apply SOLID principles strictly, with a special emphasis on the Single Responsibility Principle (SRP) to keep classes focused and modular.
- **Clean Code & Self-Documentation**: Code must be readable, simple, and easy to maintain. Do not clutter files with excessive comments. Let clean, self-documenting code speak for itself.
- **Proactive Refactoring**: Whenever a chunk of UI or business logic can be reusable, proactively refactor it into dedicated widgets, helpers, or utilities.
- **Design Patterns**: Proactively leverage well-known design patterns (e.g., Repository, Singleton via GetIt, and Factory).
- **Localization Requirement**: Introducing any new user-facing text requires creating translation keys in `assets/translations/en.json`, `assets/translations/ar.json`, and exposing them in `lib/core/localization/app_strings.dart` before referencing.

## Governance

- **Constitution Supersedes**: The Core Principles and development constraints defined in this constitution supersede all other local practices or ad-hoc patterns.
- **Compliance Checks**: All implementation plans, feature specifications, and pull request reviews must be strictly validated against these guidelines.
- **Complexity & Exceptions**: Any complexity or architectural deviation must be justified in writing inside the respective feature implementation plan.
- **Versioning Policy**: We strictly version changes to this constitution according to semantic rules: MAJOR for removing/redefining principles, MINOR for adding or expanding guidelines, and PATCH for formatting, corrections, or wording clarifications.

**Version**: 1.0.0 | **Ratified**: 2026-05-31 | **Last Amended**: 2026-05-31
