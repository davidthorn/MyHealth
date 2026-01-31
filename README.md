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
- Activity Rings summary and history
- Resting heart rate summary, history, and daily samples
- Workouts list screen
- Current workout screen (active session)
- Workout selection flow (start a workout)
- Workout detail screen with delete confirmation
- Insights screen
- Settings screen

## HealthKit adapter (planned)
HealthKit access is abstracted behind a single `HealthKitAdapter` facade so the app never talks to HealthKit APIs directly. The adapter is intentionally thin: it does not implement business logic. It only bridges HealthKit query/delegate plumbing into simple async/stream APIs that services consume.

Planned access pattern:
- `HealthKitAdapter` is the entry point. It owns internal sub-adapters and returns `AsyncStream` updates.
- Feature-specific sub-adapters wrap HealthKit query/delegate APIs.
- The rest of the app depends only on service protocols and model types.

Planned feature mapping:
- Workouts → `WorkoutsService` uses a `WorkoutDataSourceProtocol` implementation backed by `HealthKitAdapter`.
- Metrics (e.g., heart rate, calories) → `MetricsService` consumes `HealthKitAdapter` metric streams.
- Activity/rings summary → `DashboardService` consumes `HealthKitAdapter` summaries.
- Insights → `InsightsService` consumes aggregated streams from the adapter.

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
