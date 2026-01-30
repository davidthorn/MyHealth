# MyHealth

MyHealth is a SwiftUI HealthKit app focused on a clean MVVM architecture. The UI layer lives in this app target. HealthKit business logic will be provided later via a Swift package.

## Architecture (high level)
- View owns ViewModel (initialized in the View constructor).
- View talks only to ViewModel.
- ViewModel talks only to Service protocol.
- Services emit updates via `AsyncStream`.
- Models live in `Models` and are `public` with public initializers.
- Navigation uses `Hashable` route types.
- TabView top-level views are `*Scene` and declare navigation destinations.

See `ARCHITECTURE.md` for the full rules.

## Features (current)
- Dashboard summary screen
- Metrics exploration screen
- Workouts list screen
- Current workout screen (active session)
- Workout selection flow (start a workout)
- Workout detail screen with delete confirmation
- Insights screen
- Settings screen

## Structure
- `MyHealth/Scenes` — SwiftUI scenes used in the TabView
- `MyHealth/Views` — SwiftUI views used inside scenes
- `MyHealth/Components` — Reusable view components
- `MyHealth/ViewModels` — ViewModels for each scene and root content
- `MyHealth/Services` — Service implementations
- `MyHealth/Protocols` — Protocols (e.g., service protocols)
- `MyHealth/Models` — Public models and route enums
- `MyHealth/Stores` — Persistent document stores

## Build
Open `MyHealth.xcodeproj` and run the `MyHealth` target.
